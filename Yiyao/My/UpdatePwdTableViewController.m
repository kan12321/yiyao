//
//  UpdatePwdTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "UpdatePwdTableViewController.h"

@interface UpdatePwdTableViewController ()

@end

@implementation UpdatePwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:self.title Ctrl:self];

    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightTextTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyInfoFooterTableView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MyInfoFooterTableView_ID"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updatePwd{
    if ( [self.oldpwdTextField.text isEqualToString:@""] ) {
        [self message:@"请输入原密码"];
    }
    else if( [self.newpwdTextField.text isEqualToString:@""] )
    {
        [self message:@"请输入新密码"];
    }
    else
    {
        [API post:@"member/info/modifypwd" Params:@{@"password":self.oldpwdTextField.text,@"newPwd":self.newpwdTextField.text} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"member/info/modifypwd resp:%@" , responseObject);
            self.status = [responseObject objectForKey:@"status"];
            
            if ( [self.status isEqualToString:@"OK"] ) {
                //操作成功，点击退出
                
                self.okAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
                self.okAlertView.tag = 101;
                
                [self.okAlertView show];
            }
            else {
                //提示,服务器错误信息
                [self message:[responseObject objectForKey:@"message"]];
            }
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 101 ) {
        //修改成功 退出登录
        [self performSegueWithIdentifier:@"to_logout" sender:self];
    }
}

#pragma mark - Table view Layout
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MyInfoFooterTableView * view = (MyInfoFooterTableView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MyInfoFooterTableView_ID"];
    
    UIButton * updateBtn = [view startUp];
    [updateBtn setTitle:@"修改" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updatePwd) forControlEvents:UIControlEventTouchDown];
    
    return view;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightTextTableViewCell *cell = (RightTextTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RightTextTableViewCell_ID" forIndexPath:indexPath];

    if (indexPath.row == 0 ) {
        cell.titleLeftLabel.text = @"原密码";
        cell.RighttextField.placeholder = @"输入原始密码";
        self.oldpwdTextField = cell.RighttextField;
        self.oldpwdTextField.delegate = self;
        self.oldpwdTextField.secureTextEntry = YES;
    } else {
        cell.titleLeftLabel.text = @"新密码";
        cell.RighttextField.placeholder = @"输入新密码";
        self.newpwdTextField = cell.RighttextField;
        self.newpwdTextField.delegate = self;
        self.newpwdTextField.secureTextEntry = YES;
    }
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}

@end
