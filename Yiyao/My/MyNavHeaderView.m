//
//  MyNavHeaderView.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/21.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyNavHeaderView.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation MyNavHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setUserName:(NSString*)userName AndTag:(NSString*)tag AndNo:(NSString *)noStr
{
    //设置 科室😊
    
    //根据title字长重新设置titleLable宽度
    CGSize size = [Common boundingRectWithString:userName withSize:CGSizeMake(MAXFLOAT, 21) withTextFont:[UIFont systemFontOfSize:16] withLineSpacing:0];
    
    
    CGRect userNameRect = self.userName.layer.frame;

    //重置姓名label位置
    [self.userName setFrame:CGRectMake(userNameRect.origin.x, userNameRect.origin.y, size.width + 10, userNameRect.size.height)];
    

    
    
    if ( tag.length > 1 ) {
        
    
    CGSize tagSize = [Common boundingRectWithString:tag withSize:CGSizeMake(MAXFLOAT, 16) withTextFont:[UIFont systemFontOfSize:11] withLineSpacing:0];

    
    UIButton * tagBtn = [[UIButton alloc] initWithFrame:CGRectMake(userNameRect.origin.x + size.width + 9 ,
         userNameRect.origin.y + 1, tagSize.width + 4 , tagSize.height + 4)];
    
    tagBtn.layer.borderWidth = 1;
    tagBtn.layer.cornerRadius = 3;
    tagBtn.layer.borderColor = [UIColorFromRGB(0x00b7ee) CGColor];
//    tagBtn.titleLabel.text = tag;
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    [tagBtn setTitleColor:UIColorFromRGB(0x00b7ee) forState:UIControlStateNormal];
    [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];

    [self.bgView addSubview:tagBtn];
    
    }
    
    self.userName.text = userName;
    self.workNo.text = noStr;
    
    //设置 签到按钮
    self.signBtn.layer.borderWidth = 0.5;
    self.signBtn.layer.borderColor = [UIColorFromRGB(0xfd5453) CGColor];
    [self.signBtn setTitleColor:UIColorFromRGB(0xfd5453) forState:UIControlStateNormal];
    self.signBtn.layer.cornerRadius = 3;
    
}

-(void)setAvatar:(NSString *)imageName
{
    [self.avatarImg setImage:[UIImage imageNamed:imageName]];
    self.avatarImg.layer.cornerRadius = 33;
    self.avatarImg.layer.masksToBounds = YES;
}

-(void)setAvatarFromUrl:(NSString *)url
{
    [self.avatarImg sd_setImageWithURL:[[NSURL alloc] initWithString:url]];
    self.avatarImg.layer.cornerRadius = 33;
    self.avatarImg.layer.masksToBounds = YES;
}

@end
