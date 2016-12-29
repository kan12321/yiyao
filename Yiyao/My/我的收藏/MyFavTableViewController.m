//
//  MyFavTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyFavTableViewController.h"
#import "EmptyTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
@interface MyFavTableViewController ()
{
    NSMutableArray *_dataSource;
    NSInteger _pageNumber;
}
@end

@implementation MyFavTableViewController
@synthesize leftSwipeGestureRecognizer , rightSwipeGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:self.title Ctrl:self];
    //去掉隐藏tabbar留下的空白部分
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self cellRegister];
    
    //屏幕滑动
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downDataFormNet:NO];
    }];
    _dataSource = [[NSMutableArray alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self downDataFormNet:YES];
    }];
    [self.tableView.header beginRefreshing];
    
}

//滑动
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if ( self.tabsIndex < 5 ) {
            self.tabsIndex++;
            [self downDataFormNet:YES];
        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if ( self.tabsIndex > 0 ) {
            self.tabsIndex--;
            [self downDataFormNet:YES];
        }
    }
}



-(void)cellRegister
{
    [self.tableView registerNib:[UINib nibWithNibName:@"TabsManuTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TabsManuTableHeaderView_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FavPaperTableViewCell" bundle:nil] forCellReuseIdentifier:@"FavPaperTableViewCell_ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TabsManu
-(NSInteger)numsOfTabsManu
{
    return 5;
}

-(NSInteger)widthOfTabsManu
{
    return 50;
}

-(NSArray *)textOfTabsManu
{
    return [NSArray arrayWithObjects:@"资料",@"说明书",@"企业",@"表单",@"流程", nil];
}

- (void)tabsManu:(TabsManuTableHeaderView *) tabsManu didSelectRowAtIndex:(int)index;
{
    self.tabsIndex = index;
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
    NSLog(@"%@",[NSString stringWithFormat:@"member/collection/member/%ld/20?collectionType=%d",_pageNumber,_tabsIndex]);
    
    NSArray * type = @[@"3",@"2",@"1",@"4",@"5"];
    NSString * fileType = [type objectAtIndex:self.tabsIndex];
    [API get:[NSString stringWithFormat:@"member/collection/member/%ld/20",_pageNumber] Params:@{@"collectionType":fileType} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (isMore) {
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                for (NSDictionary *dict in  [responseObject objectForKey:@"data"]) {
                    [_dataSource addObject:dict];
                }
            }
            [self.tableView.footer endRefreshing];
            
        }else{
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                [_dataSource removeAllObjects];
                for (NSDictionary *dict in  [responseObject objectForKey:@"data"]) {
                    [_dataSource addObject:dict];
                }
            }
            [self.tableView.header endRefreshing];
            
            NSLog(@"上啦刷新");
        }
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view layout
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    self.tabsManu = (TabsManuTableHeaderView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TabsManuTableHeaderView_ID"];
    self.tabsManu.delegate = self;
    [self.tabsManu startUp:self.view.layer.frame.size.width At:self.tabsIndex];
    return self.tabsManu;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.count == 0) {
        EmptyTableViewCell *cell = (EmptyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
        return cell;
    }
    FavPaperTableViewCell *cell = (FavPaperTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"FavPaperTableViewCell_ID" forIndexPath:indexPath];
    
    NSDictionary * book = _dataSource[indexPath.row];
    
    if( [[NSString stringWithFormat:@"%@" , [book objectForKey:@"fileType"]] isEqualToString:@"1"]  )
    {
        [cell setBookId:[Common getStrFromJson:book Key:@"fileId"]
                  Intro:[Common getStrFromJson:book Key:@"fileName"]
                   time:[Common getSimpleDateStr:[Common getStrFromJson:book Key:@"createDate"]]
                  count:@"视频"
                  image:[book objectForKey:@"coverUrl"]
         ];
    } else {
        [cell isBooK];//目前没有视频数据
        
        [cell setBookId:[Common getStrFromJson:book Key:@"fileId"]
                  Intro:[Common getStrFromJson:book Key:@"fileName"]
                   time:[Common getSimpleDateStr:[Common getStrFromJson:book Key:@"createDate"]]
                  count:[Common getStrFromJson:book Key:@"jpgNum"]
                  image:[NSString stringWithFormat:@"%@/1.jpg" , [Common getStrFromJson:book Key:@"folderName"]]
         ];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * type = @[@"3",@"2",@"1",@"4",@"5"];
    NSString * fileType = [type objectAtIndex:self.tabsIndex];
    NSDictionary * book = [_dataSource objectAtIndex:indexPath.row];
    [self showDetail:[book objectForKey:@"fileId"] Type:fileType];
    
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
