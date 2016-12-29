//
//  MeetingTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MeetingTableViewController.h"

@interface MeetingTableViewController ()

@end

@implementation MeetingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = @[@"1",@"2",@"3",@"1",@"2"];
    self.tabs = @[@"列表",@"已约",@"待核",@"驳回",@"取消"];
    self.list = [[NSMutableArray alloc] init];
    //navi
    [Common setNavBarTitle:@"会议" Ctrl:self];
    //back btn
    [Common setNavBackBtn:self];
//    
//    UIBarButtonItem * rightBarItem =
//    [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:nil];
    
    UIButton * rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0 , 44, 20)];
    [rightBarButton setTitle:@"筛选" forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBarButton addTarget:self action:@selector(selectArea) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarItem , nil];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TabsManuTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TabsManuTableHeaderView_ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MeetingCell" bundle:nil] forCellReuseIdentifier:@"MeetingCell_ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];

    self.city = @"";//[Common getUserInfo:@"city"] ;
    self.province = @"";//[Common getUserInfo:@"province"];
    self.tabsIndex = 0;
    [self initAreapickerView];
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(API_RELOAD) forControlEvents:UIControlEventValueChanged];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    self.tableView.tableFooterView = nil;
    
    //上拉加载更多
    self.pageNo = 1;
    self.pageNums = 5;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self API_LOAD:YES];
    }];
    
    [self API_LOAD:NO];
    //UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - header style
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.tabsManu = (TabsManuTableHeaderView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TabsManuTableHeaderView_ID"];
    self.tabsManu.delegate = self;
    [self.tabsManu startUp:self.view.layer.frame.size.width At:self.tabsIndex];
    return self.tabsManu;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

#pragma mark - Table view delegate
/**
 * 点击浏览记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击后就取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectIndexPath = indexPath;
    [self performSegueWithIdentifier:@"show_meeting" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( self.list != nil ) {
        if ( [self.list count] > 0 ) {
            self.isEmpty = NO;
            return [self.list count];
        } else {
            self.isEmpty = YES;
            return 1;
        }
    } else {
        self.isEmpty = YES;
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( self.isEmpty ) {
        EmptyTableViewCell *cell = (EmptyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else
{
    MeetingCell *cell = (MeetingCell *) [tableView dequeueReusableCellWithIdentifier:@"MeetingCell_ID" forIndexPath:indexPath];
    NSDictionary * row = [self.list objectAtIndex:indexPath.row];
    cell.areaLabel.text = [NSString stringWithFormat:@"%@ %@" , [Common getStrFromJson:row Key:@"province"] , [Common getStrFromJson:row Key:@"city"]];
    cell.titleLabel.text = [Common getStrFromJson:row Key:@"title"];
    cell.contentLabel.text = [Common getStrFromJson:row Key:@"description"];
    cell.longLabel.text = [NSString stringWithFormat:@"时长:  %@小时" ,  [Common getStrFromJson:row Key:@"duration"]];
    cell.dateLabel.text = [Common getSimpleHMDateStr:[Common getStrFromJson:row Key:@"startTime"]];
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"show_meeting"] ) {
        MeetingViewController * view = (MeetingViewController*) [segue destinationViewController];
        NSDictionary * row = [self.list objectAtIndex:self.selectIndexPath.row];
        NSLog(@"data:%@" , row);
        
        if( self.tabsIndex == 0 || (self.tabsIndex == 4) )
        {
            view.isYuYue = NO;
        } else {
            view.isYuYue = YES;
        }
        view.mid = [Common getStrFromJson:row Key:@"id"];
        view.url = [Common getStrFromJson:row Key:@"htmlUrl"];
        view.type = [self.type objectAtIndex:self.tabsIndex];
    }
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
    return self.tabs;
}

- (void)tabsManu:(TabsManuTableHeaderView *) tabsManu didSelectRowAtIndex:(int)index;
{
    self.tabsIndex = index;
    self.province = @"";
    self.city = @"";
    self.pageNo = 1;
    [self API_LOAD:NO];
}

-(void)API_RELOAD
{
    self.pageNo = 1;
    [self API_LOAD:NO];
}


-(void)reloadFromApi:(id)responseObject isNext:(BOOL) nextPage
{
    if(([[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]] == NO )
       && ( [ [[responseObject objectForKey:@"data"] objectForKey:@"list"] isKindOfClass:[NSNull class]] == NO )
       )
    {
        if( nextPage == NO ){
            self.list = [[NSMutableArray alloc] init];
        } else {
            [self.tableView.footer endRefreshing];
        }
        
        int i = 0;
        for (NSDictionary * row in  [[responseObject objectForKey:@"data"] objectForKey:@"list"] ) {
            [self.list addObject:row];
            i++;
        }
        
        if( i < self.pageNums )
        {
            [self.tableView.footer setState:MJRefreshStateNoMoreData];
        } else {
            [self.tableView.footer endRefreshing];
        }
        
        
        
    } else {
        self.list = [[NSMutableArray alloc] init];
        [self.tableView.footer endRefreshing];
    }
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    
    
}

-(void)API_LOAD:(BOOL)nextPage
{
    NSString * status = [self.type objectAtIndex:self.tabsIndex ];

    if ( nextPage ) {
        self.pageNo++;
    }
    NSString * pageQuery = [NSString stringWithFormat:@"%ld/%ld",(long)self.pageNo,(long)self.pageNums];


    if ( (self.tabsIndex == 0) || (self.tabsIndex == 4) ) {
        
        [API post:[NSString stringWithFormat:@"meeting/applist/%@" , pageQuery]
          Params:@{@"status":status ,@"province":self.province,@"city":self.city}
            Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                    [self reloadFromApi:responseObject isNext:nextPage];
                }
            }];
    } else {
        [API post:[NSString stringWithFormat:@"meeting/meetingreservation/member/%@" , pageQuery]
          Params:@{@"status":status ,@"province":self.province,@"city":self.city}
            Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                    [self reloadFromApi:responseObject isNext:nextPage];
                }
            }];
    }
}


#pragma mark - 筛选省市
-(void)selectArea
{
    //地区选择控件
    NSString *cancelButtonTitle = NSLocalizedString(@"取消筛选", nil);
    NSString *destructiveButtonTitle = NSLocalizedString(@"确定", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([[Common device] isEqualToString:@"pad"] ) {
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT, 0, 0);;
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.city = @"" ;
        self.province = @"";
        [self API_RELOAD];
        NSLog(@"点击取消按钮");
    }];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //选载了省市，修改数据
        NSLog(@"%@ %@" , self.province , self.city);
        [self API_RELOAD];
        //修改省市显示
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:destructiveAction];
    [alertController.view addSubview:self.AreapickerView];
    
    self.province = [self.provinces objectAtIndex:0];
    self.city = [self.citiesDidSelected objectAtIndex:0];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - AreapickerView 地区选择控件

-(void)initAreapickerView{
    //地区选择控件
    self.AreapickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
    self.AreapickerView.delegate = self;
    self.AreapickerView.dataSource = self;
    self.AreapickerView.tag = 201;
    //省市
//    NSString * areaJsonStr = [[NSString alloc] initWithFormat:@"%s%@" , API_DOMAIN , @"/assets/admin/json/area.json"];
//    NSURL * areaJsonURL = [[NSURL alloc] initWithString: [areaJsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *name = [NSString stringWithFormat:@"area.json"];
    NSString *finalPath = [path stringByAppendingPathComponent:name];
    NSData* response = [NSData dataWithContentsOfFile:finalPath];
    
    NSError *error;
    self.areaJsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    self.provinces = [[NSMutableArray alloc] init];
    self.cities = [[NSMutableArray alloc] init];
    for (NSDictionary * row in self.areaJsonArray) {
        NSArray * cities = [row objectForKey:@"city"];
        NSMutableArray * citiesTmp = [[NSMutableArray alloc] init];
        if ( [cities count] == 1) {
            NSDictionary * tmpIcity = [cities objectAtIndex:0];
            NSArray * areaIcity = [tmpIcity objectForKey:@"area"];
            for (NSString * city in areaIcity ) {
                [citiesTmp addObject:city];
            }
            
        } else {
            for (NSDictionary * city in cities) {
                [citiesTmp addObject:[city objectForKey:@"name"]];
            }
        }
        
        [self.provinces addObject:[row objectForKey:@"name"]];
        [self.cities addObject:citiesTmp];
    }
    
    self.citiesDidSelected = [self.cities objectAtIndex:0];
}

//联动级别 省市2级
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25.0f;
}
//数据量
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? [self.provinces count] : [self.citiesDidSelected count];
}
//省市 显示
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return component == 0 ? [self.provinces objectAtIndex:row] : [self.citiesDidSelected objectAtIndex:row];
}
//二级联动选择了省市
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ( component == 0 ) {
        self.citiesDidSelected = [self.cities objectAtIndex:row];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadComponent:1];
        self.province = [self.provinces objectAtIndex:row];
        self.city = [self.citiesDidSelected objectAtIndex:0];
    } else {
        self.city = [self.citiesDidSelected objectAtIndex:row];
    }
}
@end
