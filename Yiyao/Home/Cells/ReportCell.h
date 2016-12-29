//
//  ReportCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell
//企业
@property (weak, nonatomic) IBOutlet UILabel *enterpriseLabel;
//会议
@property (weak, nonatomic) IBOutlet UILabel *conferenceLabel;
//学术资料
@property (weak, nonatomic) IBOutlet UILabel *academicLabel;


@property (nonatomic, strong)NSMutableArray *dataSource;
@end
