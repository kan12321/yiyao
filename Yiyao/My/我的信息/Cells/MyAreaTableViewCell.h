//
//  MyAreaTableViewCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface MyAreaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightDownImg;
@property (weak, nonatomic) IBOutlet UILabel *pLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
- (void)setProvince:(NSString *)province City:(NSString *)city;

@end
