//
//  HomeTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocsCell.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MJRefresh/MJRefresh.h>
#import <JSONModel/JSONModel.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SearchResultTableViewController.h"
#import "CreditTableViewController.h"
#import "EmptyTableViewCell.h"
#import "BrowsedTableViewController.h"

@interface HomeTableViewController : UITableViewController<UITextFieldDelegate,UISearchBarDelegate>

@property UIAlertView * alertView;

@property UISearchBar * searchBar;

@property NSString * searchWord;
@property NSDictionary * sData; //搜索结果数据

@property NSDictionary * tmpData;

@property int hcount; //浏览记录数据行数
@property BOOL isEmptyHistory; //是否有浏览记录

@property int apiGetCount;
@end
