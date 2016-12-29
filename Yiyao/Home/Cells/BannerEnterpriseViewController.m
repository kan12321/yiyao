//
//  BannerEnterpriseViewController.m
//  Yiyao
//
//  Created by tobo on 16/10/10.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "BannerEnterpriseViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "API.h"
#import "BannerEnterpriseViewCell.h"
#import "NSString+Common.h"
#import "ResultTableViewController.h"
@interface BannerEnterpriseViewController ()
{
    NSMutableArray *_dataSource;
    NSInteger _pageNumber;
    
}
@end

@implementation BannerEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dataSource = [[NSMutableArray alloc] init];
      [self.tableView registerNib:[UINib nibWithNibName:@"BannerEnterpriseViewCell" bundle:nil] forCellReuseIdentifier:@"BannerEnterpriseViewCell_ID"];
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
    
        [API get:[NSString stringWithFormat:@"/medicines/company/%ld/20?enterpriseId=%@",_pageNumber,_Id] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BannerEnterpriseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerEnterpriseViewCell_ID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[BannerEnterpriseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BannerEnterpriseViewCell_ID"];
    }
    // Configure the cell...
    cell.drugNameLabel.text = [_dataSource[indexPath.row] objectForKey:@"commonName"];
    cell.enterpriseLabel.text = [_dataSource[indexPath.row]objectForKey:@"enterpriseName"];
    return cell;
}
//这里看下传值对不对
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewController *view = [[ResultTableViewController alloc] init];
    NSLog(@"%@",_dataSource[indexPath.row]);
    view.enterpriseId = [_dataSource[indexPath.row] objectForKey:@"enterpriseId"];
    view.instructionsId = [_dataSource[indexPath.row]objectForKey:@"instructionsId"];
    view.cid = [_dataSource[indexPath.row]objectForKey:@"id"];
    [self.navigationController pushViewController:view animated:YES];
    
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
