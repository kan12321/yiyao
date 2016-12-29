//
//  BrowsedTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "BrowsedTableViewController.h"
#import "EmptyTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
@interface BrowsedTableViewController ()
{
     NSInteger _pageNumber;
    
}
@end

@implementation BrowsedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:self.title Ctrl:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;EmptyTableViewCell
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //去掉隐藏tabbar留下的空白部分
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    _dataSource = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"BrowsedTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrowsedTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];
    
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
    [API get:[NSString stringWithFormat:@"record/file/member/%ld/20",_pageNumber] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (isMore) {
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                for (NSDictionary *dict in  [[responseObject objectForKey:@"data"] objectForKey:@"list"]) {
                    [_dataSource addObject:dict];
                }
            }
            [self.tableView.footer endRefreshing];
            
        }else{
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
            [_dataSource removeAllObjects];
            for (NSDictionary *dict in  [[responseObject objectForKey:@"data"] objectForKey:@"list"]) {
                [_dataSource addObject:dict];
            }
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
#pragma mark - Table view Layout
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( self.dataSource.count == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
       EmptyTableViewCell  *cell = (EmptyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
        
        return cell;
    }
    
    BrowsedTableViewCell *cell = (BrowsedTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"BrowsedTableViewCell_ID" forIndexPath:indexPath];
    NSDictionary * row = self.dataSource[indexPath.row];
    
    cell.timeLabel.text = [Common getStrFromJson:row Key:@"time"];
    [cell.introImageView sd_setImageWithURL:[NSURL URLWithString:[Common getStrFromJson:row Key:@"coverUrl"]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    NSLog(@"documentType:%@" , [Common getStrFromJson:row Key:@"documentType"]);
    if ( [[Common getStrFromJson:row Key:@"documentType"] isEqualToString:@"1"] )
    {
        [cell isMovie];
    } else
    {
        [cell isBook];
    }
    
    
    //    }
    
    
    cell.titleLabel.text = [Common getStrFromJson:row Key:@"fileName"];
    //    NSString * browseNumber = [[Common getStrFromJson:row Key:@"browseNumber"] isEqualToString:@""] ? @"1" : [Common getStrFromJson:row Key:@"browseNumber"];
    cell.cLabel.text = @"";
    
    return cell;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    /**跳转到文档详情**/
    NSDictionary * row = self.dataSource[indexPath.row];
    DetailsViewController *viewContorler = [[DetailsViewController alloc] init];
    viewContorler.Id = [row objectForKey:@"fileId"];
    viewContorler.type = [row objectForKey:@"fileType"];
    [Common setNavBackBtn:self];
    viewContorler.title = @"详情";
    [self.navigationController pushViewController:viewContorler animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    /***end***/
    
    //点击后取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
