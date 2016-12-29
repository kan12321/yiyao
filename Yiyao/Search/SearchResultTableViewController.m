//
//  SearchResultTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "API.h"
#import "NSString+Common.h"
@interface SearchResultTableViewController ()
{
    NSMutableArray *_dataSource;
    NSInteger _pageNumber;
}
@end

@implementation SearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:@"搜索" Ctrl:self];
    [Common setNavBackBtn:self];
    _dataSource = [NSMutableArray array];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, self.view.layer.frame.size.width - 20, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = UIColorFromRGB(0xf2f2f2);
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    if ( self.preSearchWord != nil ) {
        self.searchBar.text = self.preSearchWord;
    }
    
    
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
    if ( self.preSearchWord != nil ) {
        [API post:[NSString stringWithFormat:@"medicines/search/%ld/20",_pageNumber] Params:@{@"searchContent":self.preSearchWord} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            self.isEmpty = (_dataSource.count > 0 ) ? YES :NO;
            [self.tableView reloadData];
        }];

    }

    
 
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing
{
    if( searchBar.text.length > 0 )
    {
        self.preSearchWord = searchBar.text;
        [self.tableView.header beginRefreshing];
//        [API post:@"medicines/search/1/10" Params:@{@"searchContent":searchBar.text} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] )
//            {
//                
//                self.sData = (NSDictionary * ) [responseObject objectForKey:@"data"];
//                self.list = [self.sData objectForKey:@"list"];
//                [self.tableView reloadData];
//            }
//        }];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    [searchBar resignFirstResponder];

}

-(void)activeCancelButton:(UISearchBar*)searchBar
{
    self.searchBar.showsCancelButton = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar{
    [self activeCancelButton:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * 点击浏览记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击后取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( self.isEmpty ) {
        return;
    }
    NSDictionary * row = (NSDictionary*) [_dataSource objectAtIndex:indexPath.row];
    
    if( [[Common getToken] isEqualToString:@""])
    {//未登录状态下直接显示说明书
        [API get:@"datum/detail"
            Params:@{@"id":[row objectForKey:@"instructionsId"],@"type":@"2"}
            Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject%@" , responseObject);
                if( [[responseObject objectForKey:@"status"] isEqualToString:@"ERROR"] )
                {
                    [self message:[responseObject objectForKey:@"message"]];
                } else {
                    //跳转
                    [self showDetail:[row objectForKey:@"instructionsId"] Type:@"2"];
                }
            }];
        
    } else {
        //enterpriseId 企业ID instructionsId说明书ID id＝药品ID
        self.selectIndexPath = indexPath;
        [self performSegueWithIdentifier:@"to_result_Segue" sender:self];
    }
}


-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchBar;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( _dataSource.count > 0) {
        self.isEmpty = NO;
        return  _dataSource.count;
    } else{
        self.isEmpty = YES;
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( self.isEmpty == NO )
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell_ID" forIndexPath:indexPath];
        
    NSDictionary * row = _dataSource[indexPath.row];
    cell.textLabel.text = [Common getStrFromJson:row Key:@"commonName"];
    cell.detailTextLabel.text = [Common getStrFromJson:row Key:@"enterpriseName"];
    return cell;
    }
    else {
        EmptyTableViewCell * cell = (EmptyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];

        return cell;
    }
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"to_result_Segue"] )
    {
        NSDictionary * row = (NSDictionary*) [_dataSource objectAtIndex:self.selectIndexPath.row];
        //enterpriseId 企业ID instructionsId说明书ID id＝药品ID
        ResultTableViewController * view = (ResultTableViewController *) [segue destinationViewController];
        view.cid = [row objectForKey:@"id"];
        //view.cid = @"21863"; //测试
        view.enterpriseId = [row objectForKey:@"enterpriseId"];
        view.instructionsId = [row objectForKey:@"instructionsId"];
    }
}


-(void)showDetail:(NSString *) fileId Type:(NSString *)type
{
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
