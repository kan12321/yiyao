//
//  BannerCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "BannerCell.h"
#import "SDCycleScrollView.h"
#import "Common.h"
#import "BannerHtmlViewController.h"
#import "BannerEnterpriseViewController.h"
@interface BannerCell ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    UIScrollView *_DIFeaturedScrollerView;
    SDCycleScrollView *_cycleScrollView;
}
@end
@implementation BannerCell

- (void)awakeFromNib {
    _DIFeaturedScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    _DIFeaturedScrollerView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    _DIFeaturedScrollerView.showsVerticalScrollIndicator = NO;
    _DIFeaturedScrollerView.contentSize = CGSizeMake(self.frame.size.width, 0);
    [self addSubview:_DIFeaturedScrollerView];
    // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [_DIFeaturedScrollerView addSubview:_cycleScrollView];
    
    //         --- 模拟加载延迟
    
    // Initialization code
}

-(void)setImageUrlStrings:(NSMutableArray *)ImageUrlStrings
{
    _ImageUrlStrings = ImageUrlStrings;
    _cycleScrollView.imageURLStringsGroup = _ImageUrlStrings;
}

- (void)setBannerArray:(NSArray *)bannerArray{
    _bannerArray = bannerArray;
    NSMutableArray *array = [NSMutableArray new];
    for (BannerModel *mode in _bannerArray) {
        [array addObject:mode.fileUrl];
    }
    self.ImageUrlStrings = [NSMutableArray arrayWithArray:array];
    _DIFeaturedScrollerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    _cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
}

#pragma maek -----------SDCycleScrollView 代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    NSString *url;
    if ( [[(BannerModel *)_bannerArray[index] type] isEqualToString:@"0"]) {
        url =  [_bannerArray[index] htmlUrl];
        BannerHtmlViewController *viewController = [[BannerHtmlViewController alloc] init];
        viewController.model = _bannerArray[index];
        [[Common viewController:self].navigationController pushViewController:viewController animated:YES];
        viewController.title = [_bannerArray[index] title];
        
    }else{
        BannerEnterpriseViewController *view = [[BannerEnterpriseViewController alloc] init];
        view.Id = [_bannerArray[index] companyID];
        [[Common viewController:self].navigationController pushViewController:view animated:YES];
        NSLog(@"%@",_bannerArray[index]);

    }
    [Common viewController:self].tabBarController.tabBar.hidden = YES;
    
}


#pragma mark ------代理方法

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
