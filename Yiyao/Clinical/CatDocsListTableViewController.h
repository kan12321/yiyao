//
//  CatDocsListTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/18.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "CatDocsCell.h"
#import "UIImageView+WebCache.h"
#import "DetailsViewController.h"

@interface CatDocsListTableViewController : UITableViewController

@property int page;
@property int row;
@property NSString * titleString;
@property UIAlertView * alertView;
@property NSString *cid;
@end
