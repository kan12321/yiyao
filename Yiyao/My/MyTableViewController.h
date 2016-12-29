//
//  MyTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/21.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "MyNavHeaderView.h"
#import "MyNavTableViewCell.h"
#import "API.h"
#import "MyInfoTableViewController.h"
#import "MyFavTableViewController.h"
#import "GotTableViewController.h"
#import "BrowsedTableViewController.h"
#import "CreditTableViewController.h"
#import "VPImageCropperViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface MyTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>


@property NSMutableArray * navConfigs;

@property NSString * department_name;
@property NSString * head_icon;
@property NSString * integral;
@property NSString * departmentID;
@property NSString * name;
@property NSString * jobNum;

@property NSDictionary * data; //返回的data

@property UIImageView * avatarImageView;

//图片选择
@property UIButton * certImageBtn;
@property NSString * filename;
@property NSString * imageType;
@property NSData * imageData;

@property UIAlertView * alertView;
@end
