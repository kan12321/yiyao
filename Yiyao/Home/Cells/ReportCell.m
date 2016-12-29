//
//  ReportCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    if (_dataSource.count != 3) {
        return;
    }
    _enterpriseLabel.text = [NSString stringWithFormat:@"%@家",[dataSource[0] objectForKey:@"companyNum"]];
    _conferenceLabel.text = [NSString stringWithFormat:@"%@场",[dataSource[1] objectForKey:@"meetingNum"]];
    _academicLabel.text = [NSString stringWithFormat:@"%@篇",[dataSource[2] objectForKey:@"literatureNum"]];
    
   
}
@end
