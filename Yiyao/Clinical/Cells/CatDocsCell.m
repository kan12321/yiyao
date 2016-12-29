//
//  CatDocsCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/18.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "CatDocsCell.h"

@implementation CatDocsCell

- (void)awakeFromNib {
    // Initialization code
    self.rightBtn.layer.cornerRadius = 12;
    self.leftBtn.layer.cornerRadius = 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
