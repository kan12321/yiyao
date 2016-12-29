//
//  MyAreaTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyAreaTableViewCell.h"

@implementation MyAreaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setProvince:(NSString *)province City:(NSString *)city
{
    self.pLabel.text = province;
    self.cityLabel.text = city;
//    CGPoint rightImgOrigin = self.rightDownImg.layer.frame.origin;
//    CGSize  rightImgSize = self.rightDownImg.layer.frame.size;
//    NSLog(@"rightImgOrigin.x :%f" , rightImgOrigin.x );
//    //添加市
//    CGSize citySize = [Common boundingRectWithString:city withSize:CGSizeMake(MAXFLOAT, 44) withTextFont:[UIFont systemFontOfSize:14] withLineSpacing:0];
//    
//    CGFloat cityX = rightImgOrigin.x - citySize.width - 5;
//    UILabel * cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(cityX , 0 , citySize.width + 5 , 44)];
//    [cityLabel setFont:[UIFont systemFontOfSize:14]];
//    cityLabel.text = city;
//    [cityLabel setTextColor:UIColorFromRGB(0xbfbfbf)];
//    
//    [self.contentView addSubview:cityLabel];
//    
//    //添加省
//    CGFloat leftDownImgX = cityX - 10 - 10;
//    UIImageView * leftDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(leftDownImgX , rightImgOrigin.y , rightImgSize.width, rightImgSize.height)];
//    [leftDownImg setImage:[UIImage imageNamed:@"down"]];
//    [self.contentView addSubview:leftDownImg];
//    
//    CGSize provinceSize = [Common boundingRectWithString:province withSize:CGSizeMake(MAXFLOAT, 44) withTextFont:[UIFont systemFontOfSize:14] withLineSpacing:0];
//    CGFloat provinceX = leftDownImgX - provinceSize.width - 5;
//    UILabel * provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(provinceX , 0 , provinceSize.width + 5 , 44)];
//    provinceLabel.text = province;
//    [provinceLabel setFont:[UIFont systemFontOfSize:14]];
//    [provinceLabel setTextColor:UIColorFromRGB(0xbfbfbf)];
//    //[self.contentView addSubview:provinceLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
