//
//  MyNavTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/21.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyNavTableViewCell.h"

@implementation MyNavTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)resetTitle:(NSString *)title AndRight:(NSString *)right
{
    self.titleLabel.text = title;
    self.rightLabel.text = right;
    [self.iconImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"My%@" , title]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
