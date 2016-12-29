//
//  MyInfoTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyInfoTableViewCell.h"

@implementation MyInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setLeft:(NSString *)left Right:(NSString *)right{
    self.leftLabel.text = left;
    self.rightLabel.text = right;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
