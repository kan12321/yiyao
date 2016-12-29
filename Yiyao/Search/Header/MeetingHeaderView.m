//
//  MeetingHeaderView.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MeetingHeaderView.h"

@implementation MeetingHeaderView


-(void)setIconImg:(UIImage *)iconImg Title:(NSString *)title{
    [self.iconImg setImage:iconImg];
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
