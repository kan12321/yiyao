//
//  ResultTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "ResultTableViewController.h"

@interface ResultTableViewController ()
{
    //企业
    NSDictionary * _enterprise;
    //学术资料列表
    NSArray * _docs;
    //说明书
    NSDictionary * _intro;
    //会议
    NSArray * _meeting;
    
    UITapGestureRecognizer * _tapGestureRecognizer1;
    UITapGestureRecognizer * _tapGestureRecognizer2;
}
@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:@"药品详情" Ctrl:self];
    [Common setNavBackBtn:self];
    
    _enterprise = [[NSDictionary alloc] init];
    _meeting = [[NSArray alloc] init];
    _docs = [[NSArray alloc] init];
    _intro = [[NSDictionary alloc] init];
    
    [self registerNib];
    self.docsArray = [[NSArray alloc] init];
    self.meetingArray = [[NSArray alloc] init];
    
#pragma mark --- 企业
    [API get:@"data/enterprisedata/query" Params:@{@"companyUserId":self.enterpriseId} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"企业:%@" , responseObject);
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]
            &&([responseObject objectForKey:@"data"] != nil)
            &&( [[responseObject objectForKey:@"data"] objectForKey:@"id"] != nil)
            ) {
            _enterprise = [responseObject objectForKey:@"data"];
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];
    
#pragma mark --- 说明书
    [API get:@"data/instructions/medicines" Params:@{@"medicinesId":self.cid} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"说明书:%@" , responseObject);
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]
           &&([responseObject objectForKey:@"data"] != nil)
           &&( [[responseObject objectForKey:@"data"] objectForKey:@"id"] != nil)
        ) {
            _intro = [responseObject objectForKey:@"data"];
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];

#pragma mark --- 会议
    [API get:@"meeting/medicines/all" Params:@{@"medicinesId":self.cid} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"会议:%@" , responseObject);
        
        if ( [[Common getFromJson:responseObject Key:@"data"] isKindOfClass:[NSArray class]] )
        {
            _meeting = [responseObject objectForKey:@"data"];
            
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];
    
#pragma mark --- 学术资料
    [API get:@"data/literature/medicines/all" Params:@{@"medicinesId":self.cid} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [[Common getFromJson:responseObject Key:@"data"] isKindOfClass:[NSArray class]] )
        {
            _docs = [responseObject objectForKey:@"data"];
            
            NSLog(@"_docs:%@" , _docs);
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];
}

-(void)registerNib{
//#import "SMeetingTableViewCell"
//#import "SIntroTableViewCell"
//#import "CompanyAndIntroTableViewCell"
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SMeetingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMeetingTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SIntroTableViewCell" bundle:nil] forCellReuseIdentifier:@"SIntroTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanyAndIntroTableViewCell" bundle:nil] forCellReuseIdentifier:@"CompanyAndIntroTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MeetingHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MeetingHeaderView_ID"];
 
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EmptyTableViewCell_ID"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view layout
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    } else {
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        MeetingHeaderView * view = (MeetingHeaderView *) [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MeetingHeaderView_ID"];
        
        if ( section == 2 ) {
            [view setIconImg:[UIImage imageNamed:@"学术资料Icon"] Title:@"学术资料"];
        }
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.section == 0 ) {
        return 142;
    }
    else if(indexPath.section == 1 ){
        return 60;
    }
    else if(indexPath.section == 2 ){
        return 80;
    } else {
        return 0;
    }
}



/**
 *分割线
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row %li" , (long)indexPath.row);
    //如果是最后一条信息，则不显示分割线
    if ( (indexPath.section == 2) ) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 400, 0, 0)];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == 0 ) {
        return 1;
    } else if( section == 1){
        return [_meeting count] > 1 ? [_meeting count] : 1;
    } else {
        return [_docs count] > 1 ? [_docs count] : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        CompanyAndIntroTableViewCell *cell = (CompanyAndIntroTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"CompanyAndIntroTableViewCell_ID" forIndexPath:indexPath];
        
        if ( [[Common getStrFromJson:_enterprise Key:@"folderName"] isEqualToString:@""]) {
            //无企业,设置默认图片
        }
        else{
            NSURL * companyUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/1.jpg" , [Common getStrFromJson:_enterprise Key:@"folderName"]]];
            [cell.companyImageView sd_setImageWithURL:companyUrl];
            //设置企业说明查看跳转
            _tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCompany)];
            cell.companyImageView.userInteractionEnabled = YES;
            [cell.companyImageView addGestureRecognizer:_tapGestureRecognizer1];
        }
        
        //说明书
        if ( [[Common getStrFromJson:_intro Key:@"folderName"] isEqualToString:@""]) {
            //无说明书
        } else{
            NSURL * introUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/1.jpg" , [Common getStrFromJson:_intro Key:@"folderName"]]];
            [cell.introImageView sd_setImageWithURL:introUrl];
            
            //设置说明查看跳转
            _tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showIntro)];
            cell.introImageView.userInteractionEnabled = YES;
            [cell.introImageView addGestureRecognizer:_tapGestureRecognizer2];

        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if( indexPath.section == 1 ){
        if([_meeting count] == 0 ){
            //
            EmptyTableViewCell * cell = (EmptyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            return cell;
        } else {
            SMeetingTableViewCell *cell = (SMeetingTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"SMeetingTableViewCell_ID" forIndexPath:indexPath];
            NSDictionary * meeting = [_meeting objectAtIndex:indexPath.row];
            cell.area.text = [NSString stringWithFormat:@"%@ %@" , [Common getStrFromJson:meeting Key:@"province"] , [Common getStrFromJson:meeting Key:@"city"] ];
            
            cell.topTitle.text = [Common getStrFromJson:meeting Key:@"title"];
            cell.intro.text = [NSString stringWithFormat:@"别名:%@" ,[Common getStrFromJson:meeting Key:@"meetingName"]];
            cell.timeLong.text = [NSString stringWithFormat:@"时长:%@小时" ,[Common getStrFromJson:meeting Key:@"duration"]];
            cell.time.text = [Common getSimpleHMDateStr:[Common getStrFromJson:meeting Key:@"startTime"]];
            return cell;
        }
    } else if( indexPath.section == 2 ){
        if ([_docs count] == 0 ) {
            EmptyTableViewCell * cell = (EmptyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell_ID" forIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            return cell;
        } else {
            NSDictionary * doc = [_docs objectAtIndex:indexPath.row];
            SIntroTableViewCell *cell = (SIntroTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"SIntroTableViewCell_ID" forIndexPath:indexPath];
            if( [[Common getStrFromJson:doc Key:@"coverUrl"] isEqualToString:@""] ){
                //服务器没有返回图片
            } else {
                NSURL * imageUrl = [[NSURL alloc] initWithString:[doc objectForKey:@"coverUrl"]];
                [cell.leftImageView sd_setImageWithURL:imageUrl];
            }
            
            NSString * content = [Common getStrFromJson:doc Key:@"documentName"];
            CGSize contentSize = [Common boundingRectWithString:content withSize:CGSizeMake(MAXFLOAT, 44) withTextFont:[UIFont systemFontOfSize:14] withLineSpacing:0];
            
            if ( contentSize.width > 200 ) {
                cell.name.text = content;
            } else {
                cell.name.text = [NSString stringWithFormat:@"%@\n" , content];
            }
            
            cell.timeLabel.text = [Common getStrFromJson:doc Key:@"createDate"];
            cell.pageNo.text = @"";
            //            NSLog(@"%@" , doc);
//            if ( [[Common getStrFromJson:doc Key:@"jpgNum"] isEqualToString:@""]) {
//                cell.pageNo.text = @"视频";
//            } else {
//                cell.pageNo.text = [NSString stringWithFormat:@"共%@页" ,[Common getStrFromJson:doc Key:@"jpgNum"]];
//            }
            
            return cell;
        }
    }

    return nil;
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [segue.identifier isEqualToString:@"to_show_meeting"] ) {
        
        
//        NSLog(@"meeting:%@" , meeting);
//        NSArray *arry=[[Common getStrFromJson:meeting Key:@"htmlUrl"]componentsSeparatedByString:@"8090"];
        MeetingViewController * view = (MeetingViewController *) [segue destinationViewController];
        view.mid = [Common getStrFromJson:_selectedMeeting Key:@"id"];
        view.url = [Common getStrFromJson:_selectedMeeting Key:@"htmlUrl"];
        if ( [self.mIsReservate isEqualToString:@"0"] ) {
            view.isYuYue = NO;
            view.type = @"1";
        }
        else {
            view.isYuYue = YES;
            view.type = self.mStatus;
        }
    }
}
//查看企业文档
-(void)showCompany
{
    [self showDetail:[_enterprise objectForKey:@"id"] Type:@"1"];
}

//查看说明书文档
-(void)showIntro
{
    NSLog(@"click is showIntro ");
    [self showDetail:[_intro objectForKey:@"id"] Type:@"2"];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //学术资料展示
    if ( indexPath.section ==  2 ) {
        NSDictionary * doc = [_docs objectAtIndex:indexPath.row];
        [self showDetail:[doc objectForKey:@"id"] Type:@"3"];
    }
    //显示会议详情
    else if( indexPath.section == 1 )
    {
        self.selectedMeeting = [_meeting objectAtIndex:indexPath.row];
        NSLog(@"selectedMeeting:%@" , self.selectedMeeting  );
        [API get:@"meeting/meetingreservation/isreservate" Params:@{@"meetingId":[Common getStrFromJson:_selectedMeeting Key:@"id"]} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"isreservate:%@" , responseObject);
            NSDictionary * data = (NSDictionary *) [responseObject objectForKey:@"data"];
            
            if (
                [[Common getStrFromJson:data Key:@"isReservate"] isEqualToString:@"0"]
                ) {
                self.mIsReservate = @"0";
            }
            else {
                self.mIsReservate = @"1";
                self.mStatus = [Common getStrFromJson:data Key:@"status"];
            }
            
            [self performSegueWithIdentifier:@"to_show_meeting" sender:self];
        }];
        
    }
    //点击后取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
