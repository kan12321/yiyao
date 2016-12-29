//
//  MyNavTableViewCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/21.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface MyNavTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (void)resetTitle:(NSString *)title AndRight:(NSString *)right;

@end
