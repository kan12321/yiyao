//
//  LoginActionViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//**登录页面与登录处理
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "API.h"

@interface LoginActionViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property UIAlertView * alertView;

@end
