//
//  ForGetPasswordViewController.m
//  Yiyao
//
//  Created by tobo on 16/9/27.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "ForGetPasswordViewController.h"
#import "NSString+Common.h"
#import "API.h"
#import "HomeTableViewController.h"
@interface ForGetPasswordViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
}
@end

@implementation ForGetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:@"忘记密码" Ctrl:self];
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"手机号码",@"验证码",@"密码",nil];
    
    self.keyArray = [[NSMutableArray alloc] initWithObjects:@"phone",@"verifyCode",@"password",nil];
    
    self.phone = @"";
    self.verifyCode = @"";
    self.password = @"";
    self.valArray = [[NSMutableArray alloc] initWithObjects:@"+86",@"",@"输入6位字符以上密码",nil];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    //去掉table多余的线
    _tableView.tableFooterView = [[UITableView alloc] init];
    [self regsiterNib];
    [self createButton];
    // Do any additional setup after loading the view.
    
    [self.tableView setScrollEnabled:NO];
}
- (void)createButton{
    //Add a container view as self.view and the superview of the tableview
    UITableView *tableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    tableView.frame = tableView.bounds;
    self.view = containerView;
    [containerView addSubview:tableView];
    
    
    CGFloat y = SCREEN_HEIGHT - 50;
    
    UIButton * regBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, self.view.layer.frame.size.width, 50)];
    [regBtn.titleLabel setText:@"设置新密码"];
    [regBtn setTitle:@"设置新密码" forState:UIControlStateNormal];
    
    [regBtn setBackgroundColor:UIColorFromRGB(0x3786c7)];
    [regBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [self.view addSubview:regBtn];
    
    [regBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)buttonAction:(UIButton *)button{
    if (![NSString checkTel:self.phone andViewController:self]) {
        return;
    }
    if (self.verifyCode.length != 6) {
        [self message:@"请输入6位数字验证码"];
        return;
    }
    if (self.password.length < 6 || self.password.length > 20) {
        [self message:@"请安要求输入正确的密码格式"];
        return;
    }
    
    
    NSDictionary * params = @{@"phone":self.phone ,
                              @"password":self.password ,
                              @"code":self.verifyCode ,
                              };
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    
    [manager
     POST:[Common getApiUrl:@"member/info/forgetpwd"]
     parameters:params
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         
     } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         if ( [[responseObject objectForKey:@"status"] isEqualToString:@"ERROR"]) {
             [self message:[responseObject objectForKey:@"message"]];
         } else {
//此处跳转登录界面
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
             }]];
             
             [self presentViewController:alert animated:YES completion:^{
                 
             }];
            
         }
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error %@" , error.description);
         
     }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)regsiterNib{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightTextTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightBtnAndTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightBtnAndTextTableViewCell_ID"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * key = [self.keyArray objectAtIndex:indexPath.row];
    //验证码
    if ( [key isEqualToString:@"verifyCode" ]) {
        
        RightBtnAndTextTableViewCell *cell = (RightBtnAndTextTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RightBtnAndTextTableViewCell_ID" forIndexPath:indexPath];
        [cell startUp];
        [cell.authcodeBtn addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchDown];
        cell.leftTextField.delegate = self;
        cell.leftTextField.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        RightTextTableViewCell *cell = ( RightTextTableViewCell * )[tableView dequeueReusableCellWithIdentifier:@"RightTextTableViewCell_ID" forIndexPath:indexPath];
        
        cell.titleLeftLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        
        cell.RighttextField.placeholder = [self.valArray objectAtIndex:indexPath.row];
        cell.RighttextField.delegate = self;
        cell.RighttextField.tag = indexPath.row;
        
        //        if ( [key isEqualToString:@"phone"] || [key isEqualToString:@"verifyCode"]) {
        //            //数字键盘
        //            cell.RighttextField.keyboardType = UIKeyboardTypePhonePad;
        //        }
        cell.RighttextField.returnKeyType = UIReturnKeyDone;
        if ( [key isEqualToString:@"password"] ) {
            cell.RighttextField.secureTextEntry = YES;
        }
        
        if ( [key isEqualToString:@"phone"]) {
            self.phoneTextField = cell.RighttextField;
            self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)getAuthCode{
    NSLog(@"is here getAuthCode");
    NSLog(@"self.phoneTextField.text :%@" , self.phoneTextField.text);
    if ([NSString checkTel:self.phoneTextField.text andViewController:self]) {
        
        
        [API post:@"verifycode/notokencode" Params:@{@"type":@"4",@"phone":self.phoneTextField.text} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@" , [responseObject objectForKey:@"message"]);
            [self message:[responseObject objectForKey:@"message"]];
        }];
    }
}

-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[Common device] isEqualToString:@"pad"]) {
        return 50;
    }
    return 40;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    NSLog(@"textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    //测试commit
    NSString * key = [self.keyArray objectAtIndex:textField.tag];
    if( [key isEqualToString:@"phone"] ){
        self.phone = textField.text;
    }
    else if( [key isEqualToString:@"password"] ){
        self.password = textField.text;
    }
    else if( [key isEqualToString:@"verifyCode"] ){
        self.verifyCode = textField.text;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// called when 'return' key pressed. return NO to ignore.
{
    return [textField resignFirstResponder];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
