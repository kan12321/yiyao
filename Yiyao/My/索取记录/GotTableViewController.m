//
//  GotTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "GotTableViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface GotTableViewController ()
{
    NSMutableArray *_dataSource;
    NSInteger _pageNumber;
}
@end

@implementation GotTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setNavBarTitle:self.title Ctrl:self];
    _dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"GotTableViewCell" bundle:nil] forCellReuseIdentifier:@"GotTableViewCell_ID"];
    //去掉隐藏tabbar留下的空白部分
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downDataFormNet:NO];
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self downDataFormNet:YES];
    }];
    [self.tableView.header beginRefreshing];
}
- (void)downDataFormNet:(BOOL)isMore{
    if (isMore) {
        if (_dataSource.count%20==0) {
            _pageNumber = _dataSource.count/20+1;
        }else{
            [self.tableView.footer endRefreshing];
            return;
        }
    }else{
        _pageNumber = 1;
    }
    [API get:[NSString stringWithFormat:@"data/infoapply/member/%ld/20?token=%@",(long)_pageNumber,[Common getToken]] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (isMore) {
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                for (NSDictionary *dict in  [[responseObject objectForKey:@"data"] objectForKey:@"list"]) {
                    [_dataSource addObject:dict];
                }
            }
            [self.tableView.footer endRefreshing];
            
        }else{
            [_dataSource removeAllObjects];
            for (NSDictionary *dict in  [[responseObject objectForKey:@"data"] objectForKey:@"list"]) {
                [_dataSource addObject:dict];
            }
            [self.tableView.header endRefreshing];
            
            NSLog(@"上啦刷新");
        }
        [self.tableView reloadData];
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma makr - Table view Layout
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 158;
}


/**
 * 不显示多余空行
 */

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
/***Up 不显示多余空行**/



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSource.count == 0) {
        return 1;
    }
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.count == 0) {
        EmptyTableViewCell *cell = (EmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
        return cell;
    }
    GotTableViewCell *cell = (GotTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GotTableViewCell_ID" forIndexPath:indexPath];
    NSDictionary * row = _dataSource[indexPath.row];
    
    cell.timeLabel.text = [Common getStrFromJson:row Key:@"applicationDate"];
    cell.emailLabel.text = [Common getStrFromJson:row Key:@"email"];
    cell.phoneLabel.text = [Common getStrFromJson:row Key:@"phone"];
    cell.statusLabel.text = [[Common getStrFromJson:row Key:@"status"] integerValue]>1?@"已发送":@"申请中";
    NSString * content = [Common getStrFromJson:row Key:@"details"];
    CGSize contentSize = [Common boundingRectWithString:content withSize:CGSizeMake(MAXFLOAT, 44) withTextFont:[UIFont systemFontOfSize:14] withLineSpacing:0];
    
    if ( contentSize.width > 200 ) {
        cell.contentLabel.text = content;
    } else {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@\n" , content];
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
