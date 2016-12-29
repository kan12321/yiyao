//
//  SearchResultTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "EmptyTableViewCell.h"
#import "API.h"
#import "ResultTableViewController.h"

@interface SearchResultTableViewController : UITableViewController<UISearchBarDelegate,UITextFieldDelegate>


@property UISearchBar * searchBar;
@property NSDictionary * sData;
@property NSArray * list;
@property BOOL isEmpty;

@property UIAlertView * alertView;
@property NSIndexPath * selectIndexPath;
@property NSString * preSearchWord;

@end
