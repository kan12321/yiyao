//
//  MyInfoTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoTableViewCell.h"
#import "MyAreaTableViewCell.h"
#import "MyCardTableViewCell.h"
#import "MyInfoFooterTableView.h"
#import "Common.h"


@interface MyInfoTableViewController : UITableViewController


@property NSMutableArray * titleArray;
@property NSMutableArray * keyArray;
@property NSMutableArray * valArray;

@property NSDictionary * data;

@end
