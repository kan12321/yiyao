//
//  RightBtnAndTextTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "RightBtnAndTextTableViewCell.h"

@implementation RightBtnAndTextTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)startUp{
    self.authcodeBtn.layer.cornerRadius = self.authcodeBtn.frame.size.height/2;
    self.authcodeBtn.layer.masksToBounds = YES;
//    self.leftTextField.layer.cornerRadius = 6;
//    self.leftTextField.layer.borderColor = [UIColorFromRGB(0xe6e6e6) CGColor];
//    self.leftTextField.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
