//
//  LoginActionViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "LoginActionViewController.h"
#import "RegisterViewController.h"
#import "ForGetPasswordViewController.h"
#import "Common.h"
@interface LoginActionViewController ()

@end

@implementation LoginActionViewController

/**
 * 正确隐藏导航栏
 */
//- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillAppear:animated];
//}
- (void)viewDidLoad {
    [super viewDidLoad];

    [Common setBarTitle:@"返回" andUiViewController:self];
    [Common setNavBarTitle:@"登录" Ctrl:self];
    CGFloat cornerRadius = (self.usernameTextField.layer.frame.size.height /2.0) - 2;
    
    
    //修改用户名 与 密码文本框样式
    [self textFieldStyle:self.usernameTextField ImageNamed:@"用户名"];
    [self textFieldStyle:self.passwordTextField ImageNamed:@"密码"];
    if ([[Common device]isEqualToString:@"pad"]) {
        _iconImageView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/5);
        _iconImageView.transform = CGAffineTransformScale(_iconImageView.transform, 1.5, 1.5);
        _forgotBtn.transform = CGAffineTransformMakeTranslation(0, 10);
        _registerBtn.transform = CGAffineTransformMakeTranslation(0, 10);
    }
    
    //修改登录按钮样式
    self.loginBtn.layer.cornerRadius = cornerRadius;
    self.loginBtn.layer.masksToBounds = YES;
    
    //添加 忘记密码 与 注册新用户 动作
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.usernameTextField.keyboardType = UIKeyboardTypePhonePad;
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.secureTextEntry = YES;
    

    if ([[Common device] isEqualToString:@"pad"]) {
        
    }else if ([[Common device] isEqualToString:@"iphone6p"]||[[Common device] isEqualToString:@"iphone6"]){
        _usernameTextField.transform = CGAffineTransformMakeTranslation(0, -50);
        _passwordTextField.transform = CGAffineTransformMakeTranslation(0, -50);
        _loginBtn.transform = CGAffineTransformMakeTranslation(0, -50);
        _registerBtn.transform = CGAffineTransformMakeTranslation(0, -50);
        _forgotBtn.transform = CGAffineTransformMakeTranslation(0, -50);
    }
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [self.registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchDown];
    [self.forgotBtn addTarget:self action:@selector(forGotPassword) forControlEvents:UIControlEventTouchDown];
//    测试
//    _usernameTextField.text = @"15800000000";
//    _passwordTextField.text = @"123456";
    //13600000000
}
//登录
-(void)login{
    NSDictionary * params = @{@"phone":self.usernameTextField.text , @"password":self.passwordTextField.text} ;
    NSLog(@"%@" , params);
    [API post:@"member/info/login" Params:params Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@" , responseObject);
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"ERROR"]) {
            [self message:[responseObject objectForKey:@"message"]];
        } else {
            //写入token
            NSString * token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
            [Common setToken:token];
            NSLog(@"token:%@",token);
            
            //写入userinfo
            NSDictionary * userinfo = [responseObject objectForKey:@"data"];
            NSData * userdata = [NSJSONSerialization dataWithJSONObject:userinfo options:NSJSONWritingPrettyPrinted  error:nil];
            [Common setUserInfo:userdata];
            
            //跳转
            //to_homepage
            [self performSegueWithIdentifier:@"to_homepage" sender:self];
        }
    }];
    
}

- (void)registerUser{
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    viewController.title = @"注册";
    viewController._isLogin = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)forGotPassword{
    ForGetPasswordViewController *viewController = [[ForGetPasswordViewController alloc] init];
    viewController.title = @"重置密码";
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}

-(void)textFieldStyle:(UITextField *) usernameTextField ImageNamed:(NSString *)imageName{
 
    CGFloat cornerRadius = (self.usernameTextField.layer.frame.size.height /2.0) - 2;

    
    CGFloat rightViewWidth = self.usernameTextField.layer.frame.size.width * (120.0/650.0);
    CGFloat rightViewHeight = self.usernameTextField.layer.frame.size.height;
    
    CGFloat iconX = (45.0/650.0) * self.usernameTextField.layer.frame.size.width;
    CGFloat iconY = (self.usernameTextField.layer.frame.size.height  - 25)/2.0;
    
    UIImageView * usernameRightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    UIView * usernameTxtRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightViewWidth, rightViewHeight)];
    //  [usernameTxtRightView setBackgroundColor:[UIColor redColor]];
    
    [usernameRightImage setFrame:CGRectMake(iconX, iconY , 25, 25)];
    [usernameTxtRightView addSubview:usernameRightImage];
    
    usernameTextField.leftView = usernameTxtRightView;
    usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    usernameTextField.layer.cornerRadius = cornerRadius;
    usernameTextField.layer.masksToBounds = YES;
}


/**
 * 点击空白区域收缩键盘
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 键盘事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //检测帐号是否是手机号码
    //检测密码规则是否正确
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 屏幕上弹
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -SCREEN_HEIGHT/6, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}

#pragma mark -屏幕恢复
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}


@end
