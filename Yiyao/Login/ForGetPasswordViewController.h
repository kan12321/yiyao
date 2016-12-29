//
//  ForGetPasswordViewController.h
//  Yiyao
//
//  Created by tobo on 16/9/27.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightTextTableViewCell.h"
#import "RightBtnAndTextTableViewCell.h"
@interface ForGetPasswordViewController : UITableViewController

@property NSMutableArray * titleArray;
@property NSMutableArray * keyArray;
@property NSMutableArray * valArray;


@property UIAlertView * alertView;

//字段必填 手机号码 密码 验证码
@property NSString * phone;
@property NSString * password;
@property NSString * verifyCode;

//手机
@property UITextField * phoneTextField;
@end
