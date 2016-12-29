//
//  CreditTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditTableViewCell.h"
#import "CreditHeaderView.h"
#import "Common.h"
#import "API.h"
#import "GetCreditTableViewController.h"

@interface CreditTableViewController : UITableViewController


@property NSString * fen;

@property NSDictionary * gotCreditData;
@end
