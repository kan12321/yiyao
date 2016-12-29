//
//  BrowsedTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "BrowsedTableViewCell.h"

@implementation BrowsedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)isMovie
{
    self.blackView.hidden = NO;
    self.playerBtn.hidden = NO;
}

-(void)isBook
{
    self.blackView.hidden = YES;
    self.playerBtn.hidden = YES;
}
@end
