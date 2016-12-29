//
//  CreditTableViewCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *log_content;
@property (weak, nonatomic) IBOutlet UILabel *log_time;

-(void)setStatus:(NSString *)status Content:(NSString*)content Time:(NSString *)time;

@end
