//
//  MyFavTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsManuTableHeaderView.h"
#import "FavPaperTableViewCell.h"
#import "Common.h"
#import "API.h"
#import "DetailsViewController.h"
@interface MyFavTableViewController : UITableViewController<TabsManuTableHeaderViewDelegate>


@property TabsManuTableHeaderView * tabsManu;

@property int tabsIndex;
@property NSMutableArray * papayArray;
@property NSMutableArray * introArray;
@property NSMutableArray * CompanyArray;
@property NSArray * data;

//滑动事件
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end
