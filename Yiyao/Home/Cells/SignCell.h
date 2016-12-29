//
//  SignCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignCell : UITableViewCell
//签到button
@property (weak, nonatomic) IBOutlet UIButton *signIn;
//签到多少天
@property (weak, nonatomic) IBOutlet UILabel *signInDay;
//签到积分
@property (weak, nonatomic) IBOutlet UILabel *Integral;
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *gotCreditBtn;
@end
