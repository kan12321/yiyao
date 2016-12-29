//
//  SignCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "SignCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation SignCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (dataArray.count == 0) {
        return;
    }
    _signInDay.text = [NSString stringWithFormat:@"您已经连续签到%@天",[dataArray[0] objectForKey:@"countSignDay"] ];
    _Integral.text = [NSString stringWithFormat:@"当前积分%@分",[_dataArray[1] objectForKey:@"integral"]];
    [[SDImageCache sharedImageCache] clearDisk];
    //判断后台是否返回头像   无返回设置默认头像
    if ([[_dataArray[2] objectForKey:@"head_icon"] isEqualToString:@"test-avatar2"]) {
        _userImageView.image = [UIImage imageNamed:[_dataArray[2] objectForKey:@"head_icon"]];
    }else{
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[2] objectForKey:@"head_icon"]] placeholderImage:nil];
    }
    //头像圆角
    _userImageView.layer.borderWidth = 1;
    _userImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userImageView.layer.cornerRadius = _userImageView.layer.frame.size.width/2;
    _userImageView.layer.masksToBounds = YES;
    
    //设置签到按钮样式
    self.signIn.layer.borderWidth = 1;
    self.signIn.layer.cornerRadius = 3;
    self.signIn.layer.borderColor = [self.signIn.titleLabel.textColor CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
