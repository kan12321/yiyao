//
//  UpdatePwdTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightTextTableViewCell.h"
#import "MyInfoFooterTableView.h"
#import "Common.h"
#import "API.h"

@interface UpdatePwdTableViewController : UITableViewController<UITextFieldDelegate , UIAlertViewDelegate>

@property UITextField * oldpwdTextField;
@property UITextField * newpwdTextField;
@property UIAlertView * alertView;
@property NSString * status;

@property UIAlertView * okAlertView;
@end
