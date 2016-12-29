//
//  HistoryRowCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface HistoryRowCell : UITableViewCell

@property (nonatomic, strong)NSDictionary *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
