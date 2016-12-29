//
//  ClaimViewController.h
//  Yiyao
//
//  Created by tobo on 16/9/30.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightTextTableViewCell.h"
#import "TextAreaTableViewCell.h"

@interface ClaimViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, copy)NSString *Id;

@property UITextField * emailTextField;
@property UITextField * phoneTextField;

@end
