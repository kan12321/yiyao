//
//  MeetingCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MeetingCell.h"

@implementation MeetingCell

- (void)awakeFromNib {
    // Initialization code
    CGRect frame = self.sepLine.layer.frame;
    [self.sepLine setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1 / [[UIScreen mainScreen] scale] )];
    [self.sepLine setHidden:YES];
    
    UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH - 2 * frame.origin.x, 1 / [[UIScreen mainScreen] scale] )];
    NSLog(@"scale %f" , [[UIScreen mainScreen] scale] );
    [sepView setBackgroundColor:UIColorFromRGB(0x393939)];
    
    [self.contentView addSubview:sepView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
