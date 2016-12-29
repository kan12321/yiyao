//
//  GetCreditTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoTableViewCell.h"
#import "RightTextTableViewCell.h"
#import "Common.h"
#import "API.h"
@interface GetCreditTableViewController : UITableViewController<UITextFieldDelegate>

@property NSDictionary * data;
@property UITextField * textField;
@property UIAlertView * alertView;
@end
