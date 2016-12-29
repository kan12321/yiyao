//
//  HistoryRowCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "HistoryRowCell.h"

@implementation HistoryRowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    NSLog(@"time %@" , [_dataSource objectForKey:@"time"]);
    _timeLabel.text = [Common getSimpleHMDateStr:[_dataSource objectForKey:@"time"]];
    _titleLabel.text =[_dataSource objectForKey:@"fileName"];
    
    
    
}

@end
