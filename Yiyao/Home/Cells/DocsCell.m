//
//  DocsCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/17.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "DocsCell.h"
#import "NewPDFModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VideoViewController.h"
#import "DetailsViewController.h"
#import "Common.h"

#define VIEWWIDTH self.frame.size.width
#define VIEWHEIGHT self.frame.size.height
@interface DocsCell ()
{
    NSArray *_viewArray;
    NSArray *_labelArray;
    NSArray *_pageImageArray;
//    NSArray *_labelArray;
    UITapGestureRecognizer *_tapGestureRecognizer;
    
    UILabel *_pageLabel1;
    UILabel *_pageLabel2;
    UILabel *_pageLabel3;
    UILabel *_pageLabel4;
    
    UIImageView *_pageImageView1;
    UIImageView *_pageImageView3;
    UIImageView *_pageImageView4;
    UIImageView *_pageImageView2;
    
    UIImageView *_imageView1;
    UIImageView *_imageView2;
    UIImageView *_imageView3;
    UIImageView *_imageView4;
    UIImageView *_VedioImageView;
}
@end
@implementation DocsCell

- (void)awakeFromNib {
    // Initialization code
    _VedioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 30, self.frame.size.width-8, (self.frame.size.width)/1.5)];
    [self addSubview:_VedioImageView];
    _imageView1 = [[UIImageView alloc] init];
    _imageView2 = [[UIImageView alloc] init];
    _imageView3 = [[UIImageView alloc] init];
    _imageView4 = [[UIImageView alloc] init];
    
    _pageImageView1 = [[UIImageView alloc] init];
    _pageImageView2 = [[UIImageView alloc] init];
    _pageImageView3 = [[UIImageView alloc] init];
    _pageImageView4 = [[UIImageView alloc] init];
    
    _pageLabel1 = [[UILabel alloc] init];
    _pageLabel2 = [[UILabel alloc] init];
    _pageLabel3 = [[UILabel alloc] init];
    _pageLabel4 = [[UILabel alloc] init];
    _viewArray = @[_imageView1,_imageView2,_imageView3,_imageView4];
    _pageImageArray = @[_pageImageView1,_pageImageView2,_pageImageView3,_pageImageView4];
    _labelArray = @[_pageLabel1,_pageLabel2,_pageLabel3,_pageLabel4];
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = _viewArray[i];
        UIImageView *pageImageView = _pageImageArray[i];
        UILabel *label = _labelArray[i];
        imageView.tag = i;
        pageImageView.contentMode = UIViewContentModeScaleToFill;
        pageImageView.image = [UIImage imageNamed:@"引导条"];//framer 240 48;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:imageView];
        [imageView addSubview:pageImageView];
        [imageView addSubview:label];
    }
    
    
    [super awakeFromNib];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = 5;
    CGFloat pageImgeFrameWidth = 80;
    CGFloat pageImgeFrameHeight = 20;
    if ([[Common device] isEqualToString:@"pad"]) {
        pageImgeFrameHeight = 30;
        pageImgeFrameWidth = 150;
        _VedioImageView.frame = CGRectMake(space, 35, VIEWWIDTH - 2 * space, (VIEWWIDTH - 2 * space ) / 3);
    }else{
       _VedioImageView.frame = CGRectMake(space, 35, VIEWWIDTH - 2 * space, (VIEWWIDTH - 2 * space ) / 1.8);
    }
    
    
    
    CGFloat imageViewHeight = (VIEWHEIGHT - MaxY(_VedioImageView) -3 * space)/2;
    CGFloat imageViewWidth = (VIEWWIDTH - 3 * space)/2;
    
    for (NSInteger y = 0; y < 2; y++) {
        for (NSInteger x = 0; x < 2; x++) {
            UIImageView *imageView = _viewArray[y * 2 + x];
            UIImageView *pageImageView = _pageImageArray[y * 2 + x];
            UILabel *label = _labelArray[y * 2 + x];
            
            imageView.frame = CGRectMake(space + x * (space + imageViewWidth),
                                         MaxY(_VedioImageView)+ space + y * (space + imageViewHeight),
                                         imageViewWidth,
                                         imageViewHeight);
            pageImageView.frame = CGRectMake(imageViewWidth - pageImgeFrameWidth, 0, pageImgeFrameWidth, pageImgeFrameHeight);
    
            label.frame = pageImageView.frame;
        }
    }
}

- (void)setDataScource:(NSMutableArray *)dataScource{
    NSLog(@"setDataScource:%@" ,dataScource);
    
    _dataScource = dataScource;
    
    if (dataScource.count == 0) {
        return;
    }
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = _viewArray[i];
        UILabel *label = _labelArray[i];
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:_tapGestureRecognizer];
        

        NSLog(@"image===%@,laebl====%@",[_dataScource[i] folderName],[_dataScource[i] jpgNum]);
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_dataScource[i] coverUrl] ] placeholderImage:nil];
        label.text = [NSString stringWithFormat:@"%@页",[_dataScource[i] jpgNum]];
        
    }
}

-(void)setVedioData:(NSDictionary *)vedioData{
    _vedioData = vedioData;
    if (_vedioData ==nil) {
        return;
    }
    [_VedioImageView sd_setImageWithURL:[vedioData objectForKey:@"coverUrl"] placeholderImage:nil];
    _VedioImageView.tag = 30;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_VedioImageView addGestureRecognizer:_tapGestureRecognizer];
    _VedioImageView.userInteractionEnabled = YES;
        //灰色蒙板
    UIView *blackView = [UIView new];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [_VedioImageView addSubview:blackView];
    
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_VedioImageView);
        make.center.equalTo(_VedioImageView);
    }];

    
    
    //添加播放按钮
//    CGFloat x = (_VedioImageView.layer.frame.size.width / 2 ) ;
//    CGFloat y = (_VedioImageView.layer.frame.size.height / 2 );
    
    UIImageView * palyerBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player"]];
    [_VedioImageView addSubview:palyerBtn];
    
    [palyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_VedioImageView);
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tgr{
    if (tgr.view.tag == 30) {
        VideoViewController *view = [[VideoViewController alloc] init];
        view.videoUrl = [NSURL URLWithString:[_vedioData objectForKey:@"fileUrl"]];
        [[Common viewController:self] presentViewController:view animated:YES completion:NULL];
        
        return;
    }else{
        DetailsViewController *viewContorler = [[DetailsViewController alloc] init];
        NewPDFModel *mode =_dataScource[tgr.view.tag];
        viewContorler.Id = [mode Id];
        viewContorler.type = [mode type];
        viewContorler.title = @"详情";
        [[Common viewController:self].navigationController pushViewController:viewContorler animated:YES];
        [Common viewController:self].tabBarController.tabBar.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
