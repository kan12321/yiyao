//
//  MeetingTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsManuTableHeaderView.h"
#import "MeetingCell.h"
#import "Common.h"
#import "API.h"
#import "EmptyTableViewCell.h"
#import "MeetingViewController.h"
#import "MJRefresh.h"

@interface MeetingTableViewController : UITableViewController<TabsManuTableHeaderViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property TabsManuTableHeaderView * tabsManu;
@property NSArray * tabs;
@property int tabsIndex;

@property NSDictionary * data;
@property NSMutableArray * list;
@property BOOL isEmpty;
@property NSString * city;
@property NSString * province;

@property UIPickerView * AreapickerView;
@property NSMutableArray *provinces;
@property NSMutableArray *cities;
@property NSMutableArray *citiesDidSelected;
@property NSArray *areaJsonArray;


@property NSIndexPath * selectIndexPath;

//数据查询时type值
@property NSArray * type;

//分页
@property NSInteger pageNo; 
@property NSInteger pageNums;
@end
