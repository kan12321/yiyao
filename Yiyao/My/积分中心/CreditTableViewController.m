//
//  CreditTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "CreditTableViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface CreditTableViewController ()
{
    NSMutableArray *_dataSource;
    NSInteger _pageNumber;
    CreditHeaderView *_headerView;
}
@end

@implementation CreditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setNavBarTitle:@"积分中心" Ctrl:self];
    [Common setNavBackBtn:self];
    _dataSource = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreditTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreditTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CreditHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CreditHeaderView_ID"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downDataFormNet:NO];
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self downDataFormNet:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    [API get:[NSString stringWithFormat:@"integral/flow/member/%ld/20",_pageNumber] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [API get:@"member/info/integral" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.fen = [[responseObject objectForKey:@"data"] objectForKey:@"integral"];
        if (_headerView) {
            _headerView.fenLabel.text = [NSString stringWithFormat:@"%@ 分" , self.fen];
        }
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 样式 与 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView = (CreditHeaderView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CreditHeaderView_ID"];
    
    [_headerView.gotBtn addTarget:self action:@selector(gotCredit) forControlEvents:UIControlEventTouchDown];
    if (self.fen != nil) {
        _headerView.fenLabel.text = [NSString stringWithFormat:@"%@ 分" , self.fen];
    }
    UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 119, 1, 47)];
    [bView setBackgroundColor:UIColorFromRGB(0x2375B8)];
    [_headerView addSubview:bView];
    return _headerView;
}

-(void)gotCredit
{
    [API get:@"integral/putrule/rule" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@" , responseObject);
        if( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] )
        {
            self.gotCreditData = [responseObject objectForKey:@"data"];
            [self performSegueWithIdentifier:@"to_got_credit" sender:self];
        }
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

/**
 * 取消显示多余的分割线
 */
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditTableViewCell *cell = (CreditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CreditTableViewCell_ID" forIndexPath:indexPath];
    
    
    NSDictionary * rowData = [_dataSource objectAtIndex:indexPath.row];
    
    [cell setStatus:[Common getStrFromJson:rowData Key:@"status"] Content:[Common getStrFromJson:rowData Key:@"remarks"] Time: [Common getStrFromJson:rowData Key:@"createDate"]];
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"to_got_credit"] ) {
        GetCreditTableViewController * view = (GetCreditTableViewController *)[segue destinationViewController];
        view.data = self.gotCreditData;
    }
}

@end
