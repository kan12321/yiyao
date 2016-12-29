//
//  BannerCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
@interface BannerCell : UITableViewCell

@property (nonatomic, strong)NSMutableArray *ImageUrlStrings;

@property (nonatomic, strong)NSArray *bannerArray;
@property (nonatomic, assign)CGFloat heigthView;
@end
