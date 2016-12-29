//
//  ClinicalCatsViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/18.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordLayout.h"
#import "API.h"
#import "CatDocsListTableViewController.h"

@interface ClinicalCatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *btnsBgView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property NSMutableArray * wordsArray;
@property NSMutableArray * idsArray;

@property NSInteger buttonTag;
+ (void)storyBoradAutoLay:(UIView *)allView;
@property NSArray * nextList;

@end
