//
//  ResultTableViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingHeaderView.h"
#import "SMeetingTableViewCell.h"
#import "SIntroTableViewCell.h"
#import "CompanyAndIntroTableViewCell.h"
#import "API.h"
#import "EmptyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DetailsViewController.h"
#import "MeetingViewController.h"

@interface ResultTableViewController : UITableViewController

@property NSString * enterpriseId ;//企业ID
@property NSString * instructionsId ;//企业ID
@property NSString * cid ;//药品ID


@property NSArray * meetingArray;
@property NSArray * docsArray;

@property NSDictionary * selectedMeeting;
@property NSString * mIsReservate;
@property NSString * mStatus;
@end
