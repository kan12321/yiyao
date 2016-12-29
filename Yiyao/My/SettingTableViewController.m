//
//  SettingTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:self.title Ctrl:self];

    [Common setNavBackBtn:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyInfoFooterTableView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MyInfoFooterTableView_ID"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view Layout
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

/**
 * 不显示多余空行
 */

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 1 ? 70 : 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if( section == 1 )
    {
    MyInfoFooterTableView * view = (MyInfoFooterTableView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MyInfoFooterTableView_ID"];
    
    UIButton * logoutBtn = [view startUp];
    
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    
    return view;
    }
    return nil;
}
/***Up 不显示多余空行**/

-(void)logout
{
    [Common logout];
    [API post:@"member/info/loginout" Params:nil Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"我已经退出了");
    }];
}

/**
 * 点击浏览记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && ( indexPath.row == 0) ) {
        //关于我们
        [self performSegueWithIdentifier:@"to_about_me" sender:self];
    }
    else if( indexPath.section == 0 && ( indexPath.row == 1) )
    {
        //版本更新
    }
    else if( indexPath.section == 1 && (indexPath.row == 0) )
    {
        //修改密码
        [self performSegueWithIdentifier:@"to_updatePwd_Segue" sender:self];
    }
    
    //点击后就取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell_ID" forIndexPath:indexPath];
    cell.detailTextLabel.text = @"";
    
    if ( indexPath.section == 0) {
        cell.textLabel.text = @"关于我们";
        } else {
        cell.textLabel.text = @"修改密码";
    }

    [cell.textLabel setTextColor:UIColorFromRGB(0x222222)];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    
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
