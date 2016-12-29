//
//  HomeTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "HomeTableViewController.h"
#import "API.h"
#import "Common.h"
#import "BannerCell.h"
#import "SignCell.h"
#import "ReportCell.h"
#import "BannerModel.h"
#import "NewPDFModel.h"
#import "DocsCell.h"
#import "HistoryRowCell.h"
#import "HistoryHeaderCell.h"

@interface HomeTableViewController ()
{
    //轮播图数据
    NSMutableArray *_bannerArray;
    //用户签到数据
    NSMutableArray *_secondCellDataSource;
    //企业数据
    NSMutableArray *_thirdCellDataSource;
    //pdf格式的数据源
    NSMutableArray *_pdfDataSource;
    //最新视频数据源
    NSDictionary *_dataSource;
    
    //浏览记录数据
    NSArray *_browserSource;
    NSDictionary *_browserData;
    
    UINib * _tNib;
    NSString *_toDayIsSign;
}
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEmptyHistory = YES;
    self.hcount = 1;
    self.apiGetCount = 0;
    [self downLoadModelForNet:nil];
    //自定义的导航栏
    [self setTopSearchBar];
    //返回back  设置成返回
    [Common setBarTitle:@"返回" andUiViewController:self];
    //注册Cell
    [self registerNib];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(downLoadModelForNet:) forControlEvents:UIControlEventValueChanged];
    
    [Common setNavBackBtn:self];
}
#pragma mark ------请求数据
-(void)stopRefreshControl
{
    if (self.apiGetCount == 6 ) {
        self.apiGetCount = 0;
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - 异步获取数据，并刷新
- (void)downLoadModelForNet:(UIRefreshControl *) refreshControl{
    _bannerArray = [[NSMutableArray alloc] init];
    _secondCellDataSource = [[NSMutableArray alloc] init];
    _thirdCellDataSource = [[NSMutableArray alloc] init];
    _pdfDataSource = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"carouselfigure/all?token=%@",[Common getToken]];
    
#pragma mark ---------请求轮播图数据
    [API get:str Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
        for (NSDictionary *dict in array) {
            BannerModel *mode = [[BannerModel alloc] initWithDictionary:dict error:nil];
            [_bannerArray addObject:mode];
            
        }
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        self.apiGetCount++;
        [self stopRefreshControl];
    }];
#pragma mark --------获取签到连续天数
    [API get:[NSString stringWithFormat:@"integral/sign/signday?token=%@",[Common getToken]] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取连续签到天数
        [_secondCellDataSource addObject:@{@"countSignDay":[[responseObject objectForKey:@"data"] objectForKey:@"countSignDay"]}];
        
        [API get:[NSString stringWithFormat:@"member/info/integral?token=%@",[Common getToken]] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            //获取会员积分
            [_secondCellDataSource addObject:@{@"integral":[[responseObject objectForKey:@"data"] objectForKey:@"integral"]}];
            //获取会员头像
            if ([Common getUserInfo:@"head_icon"]) {
                [_secondCellDataSource addObject:@{@"head_icon":@"test-avatar2"}];
                
            }else{
                [_secondCellDataSource addObject:@{@"head_icon":[Common getUserInfo:@"head_icon"]}];
            }
            [API get:@"/integral/sign/todayissign" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                _toDayIsSign = [[responseObject objectForKey:@"data"] objectForKey:@"toDayIsSign"];
                [self.tableView beginUpdates];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                self.apiGetCount++;
                [self stopRefreshControl];
            }];
        }];
    }];
#pragma mark ------------企业
    [API get:[NSString stringWithFormat:@"data/homepage/count?token=%@",[Common getToken]] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_thirdCellDataSource addObject:@{@"companyNum":[[responseObject objectForKey:@"data"] objectForKey:@"companyNum"]}];
        [_thirdCellDataSource addObject:@{@"meetingNum":[[responseObject objectForKey:@"data"] objectForKey:@"meetingNum"]}];
        [_thirdCellDataSource addObject:@{@"literatureNum":[[responseObject objectForKey:@"data"] objectForKey:@"literatureNum"]}];
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        self.apiGetCount++;
        [self stopRefreshControl];
    }];
    
    
#pragma mark ----获取pdf图片
    [API get:[NSString stringWithFormat:@"data/homepage/newpdf?token=%@",[Common getToken]] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
        for (NSDictionary *dict in array) {
            NewPDFModel *model = [[NewPDFModel alloc] initWithDictionary:dict error:nil];
            [_pdfDataSource addObject:model];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        self.apiGetCount++;
        [self stopRefreshControl];
    }];
#pragma mark ------获取视频数据
    [API get:[NSString stringWithFormat:@"data/homepage/newvedio?token=%@",[Common getToken]] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataSource = @{@"id":[[responseObject objectForKey:@"data"]objectForKey:@"id"],
                        @"fileUrl":[[responseObject objectForKey:@"data"]objectForKey:@"fileUrl"],
                        @"coverUrl":[[responseObject objectForKey:@"data"]objectForKey:@"coverUrl"],};
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        self.apiGetCount++;
        [self stopRefreshControl];
    }];
#pragma mark ---------获取浏览记录
    [API get:@"record/file/member/1/10" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        _browserData = [responseObject objectForKey:@"data"];
        _browserSource = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        if ( [_browserSource count] > 0 ) {
            NSLog(@"_browserSource count:%lu" , (unsigned long)[_browserSource count]);
            self.hcount =  ([_browserSource count] < 6) ? (int) [_browserSource count] : 5 ; //最多显示5条
            self.isEmptyHistory = NO;
        } else {
            self.hcount = 1;
            self.isEmptyHistory = YES;
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        self.apiGetCount++;
        [self stopRefreshControl];
    }];
}








//提示框
-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}

//注册Cell的Nib
-(void) registerNib{
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SignCell" bundle:nil] forCellReuseIdentifier:@"SignCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReportCell" bundle:nil] forCellReuseIdentifier:@"ReportCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DocsCell" bundle:nil] forCellReuseIdentifier:@"DocsCell_ID"];
    
    _tNib = [UINib nibWithNibName:@"HistoryHeaderCell" bundle:nil];
    [self.tableView registerNib:_tNib forCellReuseIdentifier:@"HistoryHeaderCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryRowCell" bundle:nil] forCellReuseIdentifier:@"HistoryRowCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];
    
}

-(void) setTopSearchBar{
    CGFloat screenWidth = self.navigationController.navigationBar.layer.bounds.size.width;
    CGFloat screenHeight = self.navigationController.navigationBar.layer.bounds.size.height;
    
    //    int y = screenHeight - 25 - 8;
    NSLog(@"navigationController screenWidth:%f" , self.view.layer.bounds.size.width);
    
    //导航栏显示搜索框架，留边10
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth -20, screenHeight )];//allocate titleView
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, self.view.layer.frame.size.width - 20 -10 , 44)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = UIColorFromRGB(0xf2f2f2);
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    //    self.searchBar.placeholder = @"搜索";
    self.searchBar.tintColor = UIColorFromRGB(0xffffff);
    
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)}];
    searchField.textColor = UIColorFromRGB(0xffffff);
    searchField.layer.cornerRadius = 12;
    
    [searchField setBackgroundColor:UIColorFromRGB(0x6fa4ce)];
    
    
    //设置搜索框的icon
    UIImageView * searchTxtRightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页SB"]];
    UIView * searchTxtRightRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25 , 25)];
    [searchTxtRightImage setFrame:CGRectMake(8, 5, 15, 15)];
    [searchTxtRightRightView addSubview:searchTxtRightImage];
    
    searchField.leftView = searchTxtRightRightView;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    
    
    //添加搜索框
    [titleView addSubview:self.searchBar];
    
    
    //    UIColor *color = self.navigationController.navigationBar.tintColor;
    //    [titleView setBackgroundColor:color];
    
    /*
     UITextField * searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, y , screenWidth - 20 , 25 )];
     //placeholder
     searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)}];
     
     
     //设置搜索框的icon
     UIImageView * searchTxtRightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页SB"]];
     UIView * searchTxtRightRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25 , 25)];
     [searchTxtRightImage setFrame:CGRectMake(8, 5, 15, 15)];
     [searchTxtRightRightView addSubview:searchTxtRightImage];
     
     searchTextField.leftView = searchTxtRightRightView;
     searchTextField.leftViewMode = UITextFieldViewModeAlways;
     
     searchTextField.layer.borderWidth = 0;
     searchTextField.layer.cornerRadius = 12;
     
     
     [searchTextField setFont:[UIFont systemFontOfSize:12]];
     [searchTextField setTextColor:[UIColor whiteColor]];
     [searchTextField setBackgroundColor:UIColorFromRGB(0x6fa4ce)];
     
     //添加搜索框
     [titleView addSubview:searchTextField];
     
     // searchTextField.delegate = self;
     // searchTextField.returnKeyType = UIReturnKeySearch;
     
     */
    //Set to titleView
    self.navigationItem.titleView = titleView;
    
}

#pragma mark - 搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    //取消按钮
    UIButton *btn=[self.searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing
{
    if( searchBar.text.length > 0 )
    {
        [API post:@"medicines/search/1/10" Params:@{@"searchContent":searchBar.text} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            if( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] )
            {
                self.sData = (NSDictionary * ) [responseObject objectForKey:@"data"];
                self.searchWord = searchBar.text;
                [self performSegueWithIdentifier:@"to_search_Segue" sender:self];
                self.tabBarController.tabBar.hidden = YES;
                self.searchBar.showsCancelButton = NO;
                self.searchBar.text = @"";
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 表格样式，高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
           switch (indexPath.section) {
               case 0:{
                   if ([[Common device] isEqualToString:@"pad"]) {
                       return 300;
                   }
                return 150;
               }
                break;
            case 1:
                return 64;
                break;
            case 2:
                return 80;
                break;
               case 3:{
                   if ([[Common device] isEqualToString:@"pad"]) {
                       return 700;
                   }else if ([[Common device] isEqualToString:@"iphone5"]){
                       return 400;
                   }else if ([[Common device] isEqualToString:@"iphone6p"]){
                       return 550;
                   }
                return 480;
               }
                break;
            case 4:
                return 33;
                break;
            case 5:
                return 36;
                break;
            default:
                break;
        }
       
    return 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *分割线
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 5) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    } else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //除第五段，其他的每段1条
    NSLog(@"numberOfRowsInSection section:%li" , (long)section);
    if ( section == 5 ) {
        NSLog(@"self.hcount %i" , self.hcount);
        return self.hcount;
    } else {
        return 1;
    }
}

-(void)playNetMovie{
    
    [self performSegueWithIdentifier:@"to_player_Segue" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( indexPath.section == 3 ){
        DocsCell * cell = (DocsCell *) [tableView dequeueReusableCellWithIdentifier:@"DocsCell_ID" forIndexPath:indexPath];
        //        UIButton * playerBtn = [cell getBtn];
        //        [playerBtn addTarget:self action:@selector(playNetMovie) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"_pdfDataSource:%@" , _pdfDataSource);
        if (_pdfDataSource) {
            cell.dataScource = _pdfDataSource;
            cell.vedioData = _dataSource;
        }
        cell.selectionStyle = NO;
        return cell;
    }
    else
    {
        UITableViewCell *cell;
        switch (indexPath.section) {
            case 0:{
                BannerCell *cell;
                cell = [tableView dequeueReusableCellWithIdentifier:@"BannerCell_ID" forIndexPath:indexPath];
                if (_bannerArray) {
                    cell.bannerArray = _bannerArray;
                }
                
                return cell;
            }
                break;
            case 1:{
                SignCell *cell;
                cell = [tableView dequeueReusableCellWithIdentifier:@"SignCell_ID" forIndexPath:indexPath];
                if (_secondCellDataSource) {
                    cell.dataArray = _secondCellDataSource;
                }
               
                [cell.gotCreditBtn addTarget:self action:@selector(home_to_got_credit) forControlEvents:UIControlEventTouchDown];
                if ( _toDayIsSign.integerValue == 0 ) {
                    [cell.signIn setTitle:@"签到" forState:UIControlStateNormal];
                    [cell.signIn addTarget:self action:@selector(submitSign:) forControlEvents:UIControlEventTouchDown];
                } else {
                    [cell.signIn setTitle:@"已签到" forState:UIControlStateNormal];
                    [cell.signIn addTarget:self action:@selector(tipsSigned) forControlEvents:UIControlEventTouchDown];
                }
                
                
                if( [[Common getUserInfo:@"head_icon"] isEqualToString:@""] == NO){
                    [[SDImageCache sharedImageCache] clearDisk];
                    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[Common getUserInfo:@"head_icon"]]];
                }
                
                cell.selectionStyle = NO;
                return cell;
            }
                break;
            case 2:{
                ReportCell *cell;
                cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell_ID" forIndexPath:indexPath];
                if (_thirdCellDataSource) {
                    cell.dataSource = _thirdCellDataSource;
                }
                
                cell.selectionStyle = NO;
                return cell;
                break;
            }
            case 4:
            {
                HistoryHeaderCell *cell = ( HistoryHeaderCell * ) [tableView dequeueReusableCellWithIdentifier:@"HistoryHeaderCell_ID" forIndexPath:indexPath];
                [cell.moreBtn addTarget:self action:@selector(to_more_history) forControlEvents:UIControlEventTouchDown];
                cell.selectionStyle = NO;
                return cell;
                break;
            }
            case 5:
            {
                NSLog(@"is here HistoryRowCell isEmptyHistory:%@" , self.isEmptyHistory ? @"YES" : @"NO");
                if (self.isEmptyHistory ) {
                    EmptyTableViewCell * cell;
                    cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
                    cell.selectionStyle = NO;
                    return cell;
                }
                else
                {
                    HistoryRowCell *cell;
                    cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryRowCell_ID" forIndexPath:indexPath];
                    if (_browserSource) {
                        cell.dataSource = _browserSource[indexPath.row];
                    }
                    return cell;
                }
                break;
            }
            default:
                break;
        }
        
        return cell;
        
        
    }
}


#pragma mark - Table view delegate
/**
 * 点击浏览记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击后就取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //点击浏览记录
    if ( indexPath.section == 5) {
        
        /**跳转到文档详情**/
        NSDictionary * row = _browserSource[indexPath.row];
        DetailsViewController *viewContorler = [[DetailsViewController alloc] init];
        viewContorler.Id = [row objectForKey:@"fileId"];
        viewContorler.type = [row objectForKey:@"fileType"];
        [Common setNavBackBtn:self];
        viewContorler.title = @"详情";
        [self.navigationController pushViewController:viewContorler animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        /***end***/
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
    [Common setNavBackBtn:self];
    
    if( [segue.identifier isEqualToString:@"to_search_Segue"] )
    {
        SearchResultTableViewController * view = (SearchResultTableViewController *)[segue destinationViewController];
        view.sData = self.sData;
        view.preSearchWord = self.searchWord;
    }
    else if ( [segue.identifier isEqualToString:@"home_to_got_credit"]) {
        CreditTableViewController * view = (CreditTableViewController *) [segue destinationViewController];
        view.fen = [_secondCellDataSource[1] objectForKey:@"integral"];
    }
}

//花积分跳转
-(void)home_to_got_credit
{
    self.tabBarController.tabBar.hidden = YES;
    [self performSegueWithIdentifier:@"home_to_got_credit" sender:self];
    
    
}

//更多浏览记录
-(void)to_more_history
{
     self.tabBarController.tabBar.hidden = YES;
    [self performSegueWithIdentifier:@"to_more_history" sender:self];
}

//签到
-(void)submitSign:(UIButton *) btn
{
    if ( [btn.titleLabel.text isEqualToString:@"签到"] ) {
        [btn setTitle:@"已签到" forState:UIControlStateNormal];
        [API post:@"integral/sign/sign" Params:nil Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@" , responseObject);
            
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
                //签到成功
                [Common setSign];
            }
            else if( [[responseObject objectForKey:@"message"] isEqualToString:@"当日已签到"] )
            {
                [Common setSign];
            }
        }];
    }
}

-(void)tipsSigned
{
    [self message:@"今日已签到"];
}
@end
