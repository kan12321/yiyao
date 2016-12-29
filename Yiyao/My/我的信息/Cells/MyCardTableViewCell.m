//
//  MyCardTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyCardTableViewCell.h"

@implementation MyCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)startCartImage{
    self.cartImage.layer.borderColor = [UIColorFromRGB(0xc2c1c2) CGColor];
    self.cartImage.layer.borderWidth = 1;
    self.cartImage.layer.cornerRadius = 7;
    self.cartImage.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
