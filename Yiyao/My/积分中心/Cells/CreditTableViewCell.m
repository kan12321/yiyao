//
//  CreditTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "CreditTableViewCell.h"

@implementation CreditTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setStatus:(NSString *)status Content:(NSString*)content Time:(NSString *)time
{
    NSArray * s = @[@"失败",@"已完成",@"处理中",@"被驳回"];
    self.log_content.text = [NSString stringWithFormat:@"%@ [%@]" , content , [s objectAtIndex:[status integerValue]]];
    self.log_time.text = time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
