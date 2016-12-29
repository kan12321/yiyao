//
//  CatDocsListTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/18.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "CatDocsListTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "EmptyTableViewCell.h"
@interface CatDocsListTableViewController ()
{
    NSMutableArray *_dataSource;
    NSInteger _pageNumber;
}
@end

@implementation CatDocsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航
    [Common setNavBarTitle:self.titleString Ctrl:self];
    
    
    _dataSource = [NSMutableArray array];
    
    [self.tableView
     registerNib:[UINib nibWithNibName:@"CatDocsCell" bundle:nil] forCellReuseIdentifier:@"ClinicalCell"];
    [self.tableView
     registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    NSString * cid = [NSString stringWithFormat:@"%@" , self.cid];
    NSString * url = [NSString stringWithFormat:@"%@/%ld/%i",@"clinical/department" , _pageNumber , 20];
    
    [API get:url Params:@{@"departmentId":cid} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
            if (isMore) {
                for (NSDictionary *dict in  [responseObject objectForKey:@"data"]) {
                    [_dataSource addObject:dict];
                }
            }else{
                [_dataSource removeAllObjects];
                for (NSDictionary *dict in  [responseObject objectForKey:@"data"]) {
                    [_dataSource addObject:dict];
                }
                NSLog(@"上啦刷新");
            }
            [self.tableView reloadData];
        }
        if (isMore) {
            [self.tableView.footer endRefreshing];
        }else{
            [self.tableView.header endRefreshing];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.count == 0) {
         EmptyTableViewCell    *cell = (EmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
        return cell;
    }
    CatDocsCell *cell = (CatDocsCell *)[tableView dequeueReusableCellWithIdentifier:@"ClinicalCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * row = _dataSource[indexPath.row];
    cell.data = row;
    
    NSString * imageUrl = [NSString stringWithFormat:@"%@/1.jpg" , [row objectForKey:@"folder_name"] ];
    [cell.introImageView sd_setImageWithURL:[[NSURL alloc] initWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    NSLog(@"row %@" , row);
    
    NSString *name= [NSString stringWithFormat:@"%@", [row objectForKey:@"clinical_name"]];
    cell.intro.text = name;
    cell.dateLabel.text = [NSString stringWithFormat:@"更新时间:%@" ,[Common getSimpleDateStr:[row objectForKey:@"createDate"]]];
    cell.leftBtn.tag = indexPath.row;
    cell.rightBtn.tag = indexPath.row;
    [cell.leftBtn addTarget:self action:@selector(liucheng:) forControlEvents:UIControlEventTouchDown];
    [cell.rightBtn addTarget:self action:@selector(biaodan:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}


/**
 *分割线
 */
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"indexPath.row %li" , (long)indexPath.row);
//    //如果是最后一条信息，则不显示分割线
//    if (indexPath.row >= 1) {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsMake(0, 400, 0, 0)];
//        }
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsZero];
//        }
//    } else {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
//        }
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsZero];
//        }
//    }
//}
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

-(void)liucheng:(UIButton *) btn
{
    NSDictionary * row = [_dataSource objectAtIndex:btn.tag];
    [self showDetail:[row objectForKey:@"processId"] Type:@"5"];
}

-(void)biaodan:(UIButton *) btn
{
    NSDictionary * row = [_dataSource objectAtIndex:btn.tag];
    [self showDetail:[row objectForKey:@"formId"] Type:@"4"];
}
//提示框
-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}

-(void)showDetail:(NSString *) fileId Type:(NSString *)type
{
    if ([fileId isEqual:[NSNull null]]) {
        [self message:@"暂无数据"];
        return;
    }
    /**跳转到文档详情**/
    DetailsViewController *viewContorler = [[DetailsViewController alloc] init];
    viewContorler.Id = fileId;
    viewContorler.type = type;
    [Common setNavBackBtn:self];
    viewContorler.title = @"详情";
    [self.navigationController pushViewController:viewContorler animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    /***end***/
}


@end
