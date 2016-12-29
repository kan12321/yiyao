//
//  DetailsViewController.m
//  Yiyao
//
//  Created by tobo on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "DetailsViewController.h"
#import "API.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DetailsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClaimViewController.h"
@interface DetailsViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;//中间滑动视图
    NSInteger _index;//点击第N张图片
    NSInteger _images;//图片总数
    CGFloat _lastViewMaxY;
    UIScrollView *_subScrollView;//中间用于显示的View
    NSMutableArray *_imageViews;//用于存储imageView的数组
    UIScrollView *_downScrollView;//下面的scrollView
    DetailsModel *_model;
    UILabel *_pageLabel;
    UIView *_downView;
    UILabel *_titleLabel;
    NSInteger _scrollerY;
    //播放器
    AVPlayerViewController      *_playerController;
    AVPlayer                    *_player;
    AVAudioSession              *_session;
}
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //请求数据
    [self createTitleLabel];
    
    //返回back  设置成返回
    [Common setBarTitle:@"返回" andUiViewController:self];
    //判断登录是否
    NSLog(@"token ==%@",[Common getToken]);
    if ([Common getToken].length >= 5) {
        [self createNavigationItem];
    }
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [Common setNavBarTitle:@"详情" Ctrl:self];
}

- (void)createNavigationItem{
    UIButton * rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0 , 50, 20)];
    [rightBarButton setTitle:@"索取" forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBarButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarItem , nil];
}
//点击索取  获取界面
- (void)rightButtonAction{
    [_player pause];
    ClaimViewController *viewController = [[ClaimViewController alloc] init];
    viewController.title = @"索取资料";
    viewController.Id = [_model recordId];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)createTitleLabel{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
    
    _titleLabel.backgroundColor = [UIColor grayColor];
    
    NSString *url =[NSString stringWithFormat:@"datum/detail?id=%@&type=%@",_Id,_type];
    //1 企业资料 2 药品说明书 3 学术资料 4 临床表单 5 住院流程
    [API get:url Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"file responseObject:%@" , responseObject);
        _model = [[DetailsModel alloc] initWithDictionary:[responseObject objectForKey:@"data"] error:nil];
        _titleLabel.text = _model.fileName;
        _images = [_model.jpgNum intValue];
        [self setDataWithView];
    }];
    
    [self.view addSubview:_titleLabel];
    _lastViewMaxY = MaxY(_titleLabel);
}
//判断数据类型后  粘贴数据
- (void)setDataWithView{
    if([_model.fileType isEqualToString:@"0"]){
        [self createView];
        [self createDownView];
        if ([_model.jpgNum integerValue]< 3) {
            if (_model.jpgNum.integerValue == 1) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d.jpg",_model.folderName,1]] placeholderImage:nil];
                imageView.userInteractionEnabled=YES;
                imageView.tag = 180;
                UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick1:)];
                [imageView addGestureRecognizer:tgr];
                _scrollView.pagingEnabled = NO;
                _scrollView.bounces = YES;
                [_scrollView addSubview:imageView];
            }else{
               [self createImageView];
            }
        }else{
    
            self.view.backgroundColor = [UIColor whiteColor];
            [self createImageViews];
            
        }
    }else{
        [self createVedioView];
        self.view.backgroundColor = [UIColor blackColor];
        [self createDownView];
        [self.view addSubview:_downView];
        _pageLabel.text = @"";
    }
    
}

- (void)createImageView{
    for (NSInteger i = 0; i<_images; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%ld.jpg",_model.folderName,i+1]] placeholderImage:nil];
        imageView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick1:)];
        [imageView addGestureRecognizer:tgr];
        UITapGestureRecognizer *doubuletgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick1:)];
        doubuletgr.numberOfTapsRequired=2;
        [imageView addGestureRecognizer:doubuletgr];
        [tgr requireGestureRecognizerToFail:doubuletgr];
        if (i == 0) {
            _subScrollView.frame = imageView.frame;
            imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
            _subScrollView.maximumZoomScale=2.0;
            _subScrollView.minimumZoomScale=0.2;
            _subScrollView.delegate=self;
            _subScrollView.showsVerticalScrollIndicator = NO;
            _subScrollView.showsHorizontalScrollIndicator = NO;
           
            
            [_subScrollView addSubview:imageView];
            [_scrollView addSubview:_subScrollView];
 
        }else{
            [_scrollView addSubview:imageView];
        }
         imageView.tag = 200+i;
    }
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_images, 0);
}
- (void)createVedioView
{
    _session = [AVAudioSession sharedInstance];
    [_titleLabel removeFromSuperview];
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //视频url地址传输
    _player = [AVPlayer playerWithURL:[NSURL URLWithString:[_model fileUrl]]];
    _playerController = [[AVPlayerViewController alloc] init];
    _playerController.player = _player;
    _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
//    _playerController.allowsPictureInPicturePlayback = YES;    //画中画，iPad可用
    _playerController.showsPlaybackControls = YES;
    
    [self addChildViewController:_playerController];
    _playerController.view.translatesAutoresizingMaskIntoConstraints = YES;    //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
    //self.view.bounds
    _playerController.view.frame = CGRectMake(0, _lastViewMaxY+100, SCREEN_WIDTH, 300);
    [self.view addSubview:_playerController.view];
    //自动播放
}
//创建scrollView
- (void)createView{
    _scrollView  = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.maximumZoomScale=2.0;
    _scrollView.minimumZoomScale=0.2;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, _lastViewMaxY, SCREEN_WIDTH, SCREEN_HEIGHT-200);
    _scrollerY = _lastViewMaxY;
    [self.view addSubview:_scrollView];
    _downScrollView = [[UIScrollView alloc] init];
    _downScrollView.frame = CGRectMake(0,SCREEN_HEIGHT-80, SCREEN_WIDTH, 80);
    
    for (NSInteger i = 0; i < _images; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(5+(_downScrollView.frame.size.height - 10 +5 )*i, 5, _downScrollView.frame.size.height-10, _downScrollView.frame.size.height-10);
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick1:)];
        [imageView addGestureRecognizer:tgr];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%ld.jpg",_model.folderName,i+1]] placeholderImage:nil];
        [_downScrollView addSubview:imageView];
    }
    _downScrollView.showsVerticalScrollIndicator = YES;
    _downScrollView.contentSize = CGSizeMake((_downScrollView.frame.size.height - 10 +5 )*_images+5, 0);
    _downScrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_downScrollView];
    _subScrollView = [[UIScrollView alloc] init];
    _imageViews = [[NSMutableArray alloc] init];
    
    
}
//创建如偏视图
- (void)createImageViews{
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = (_images-1+i)%_images;
        NSLog(@"%ld",imageView.tag);
        [self setImageToView:imageView];
        imageView.userInteractionEnabled=YES;
        if (i!=1) {
            [_scrollView addSubview:imageView];
        }else{
            _subScrollView.frame = imageView.frame;
            imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
            _subScrollView.maximumZoomScale=2.0;
            _subScrollView.minimumZoomScale=0.2;
            _subScrollView.delegate=self;
            _subScrollView.showsVerticalScrollIndicator = NO;
            _subScrollView.showsHorizontalScrollIndicator = NO;
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick1:)];
            [imageView addGestureRecognizer:tgr];
            UITapGestureRecognizer *doubuletgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick1:)];
            doubuletgr.numberOfTapsRequired=2;
            [imageView addGestureRecognizer:doubuletgr];
            [tgr requireGestureRecognizerToFail:doubuletgr];
            [_subScrollView addSubview:imageView];
            
            [_scrollView addSubview:_subScrollView];
        }
        
        [_imageViews addObject:imageView];
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}
- (void)createDownView{
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    _downView.backgroundColor = [UIColor grayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 50);
    [button setTitle:[_model.isCollect isEqualToString:@"0"]?@"收藏":@"已收藏" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    if([Common getToken].length >= 5){
        [_downView addSubview:button];
    }
    _pageLabel = [[UILabel alloc] init];
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld页",_index+1,_images];
    _pageLabel.frame = CGRectMake(SCREEN_WIDTH-110, 0, 100, 50);
    _pageLabel.textAlignment = NSTextAlignmentRight;
    _pageLabel.textColor = [UIColor whiteColor];
    [_downView addSubview:_pageLabel];
}

- (void)buttonAction:(UIButton *)button{
    [API post:@"member/collection/add" Params:@{@"fileId":_Id,@"collectionType":_type} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self message:[responseObject objectForKey:@"message"]];
            [button setTitle:@"已收藏" forState:UIControlStateNormal];
        }
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_player play];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_model == nil) {
        return;
    }
    [_player pause];
    
    [API post:@"datum/updrecord" Params:@{@"recordId":[_model recordId],@"viewPage":[NSString stringWithFormat:@"%ld",_index+1],@"token":[Common getToken]} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
    }];
}

- (void) setImageToView:(UIImageView *)view{
    NSString *url = [NSString stringWithFormat:@"%@/%ld.jpg",_model.folderName,view.tag+1];
    [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

- (void)Onclick2:(UITapGestureRecognizer *)tgr{
    UIScrollView *sv= (UIScrollView *)tgr.view.superview;
    CGFloat maxmum = sv.maximumZoomScale;
    if (sv.zoomScale != 1.0) {
        [sv setZoomScale:1.0 animated:YES];
        
    }else{
        [sv setZoomScale:maxmum animated:YES];
    }
}

- (void)Onclick1:(UITapGestureRecognizer *)tgr
{
    if (_images>2) {
    if (tgr.view.tag < 100) {
        UIScrollView *sv= (UIScrollView *)tgr.view.superview;
        CGFloat maxmum = sv.maximumZoomScale;
        if(tgr.numberOfTapsRequired==2){
            if (sv.zoomScale != 1.0) {
                [sv setZoomScale:1.0 animated:YES];
            }else{
                [sv setZoomScale:maxmum animated:YES];
            }
        }else if (tgr.numberOfTapsRequired==1){
            static BOOL isDownScrollView = NO;
            if (!isDownScrollView) {
                [_downScrollView removeFromSuperview];
                [_titleLabel removeFromSuperview];
                isDownScrollView = YES;
                [self.view addSubview:_downView];
            }else{
                [_downView removeFromSuperview];
                [self.view addSubview:_downScrollView ];
                [self.view addSubview:_titleLabel];
                isDownScrollView = NO;
            }
            
        }else{
            return;
        }
    }else{
        _index = tgr.view.tag - 100;
        NSLog(@"%ld",_index);
        NSInteger i = 0;
        for (UIImageView *view in _imageViews) {
            
            view.tag = (_index+_images-1+i)%_images;
            NSLog(@"%ld",view.tag);
            [self setImageToView:view];
            i++;
        }
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld页",_index+1,_images];
        UIScrollView *sv = (UIScrollView *)[_imageViews[1] superview];
        sv.zoomScale=1.0;
    }
    }else if (_images == 2){
        if (tgr.view.tag > 150) {
        UIScrollView *sv= (UIScrollView *)tgr.view.superview;
        if(tgr.numberOfTapsRequired==2){
            if (sv.zoomScale != 1.0) {
                [sv setZoomScale:1.0 animated:YES];
            }else{
                [sv setZoomScale:2 animated:YES];
            }
        }else if (tgr.numberOfTapsRequired==1){
            static BOOL isDownScrollView = NO;
            if (!isDownScrollView) {
                [_downScrollView removeFromSuperview];
                [_titleLabel removeFromSuperview];
                isDownScrollView = YES;
                [self.view addSubview:_downView];
            }else{
                [_downView removeFromSuperview];
                [self.view addSubview:_downScrollView ];
                [self.view addSubview:_titleLabel];
                isDownScrollView = NO;
            }
        }
        }else{
            _scrollView.contentOffset = CGPointMake((tgr.view.tag-100)*SCREEN_WIDTH, 0);
        }
    }else{
        if (tgr.numberOfTapsRequired==1){
            static BOOL isDownScrollView = NO;
            if (!isDownScrollView) {
                [_downScrollView removeFromSuperview];
                [_titleLabel removeFromSuperview];
                isDownScrollView = YES;
                [self.view addSubview:_downView];
            }else{
                [_downView removeFromSuperview];
                [self.view addSubview:_downScrollView ];
                [self.view addSubview:_titleLabel];
                isDownScrollView = NO;
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提示框
-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}
#pragma mark ---滑动修改
-  (void)circulate
{
    NSInteger flag = 0;
    CGFloat offsetX =_scrollView.contentOffset.x;
    if (offsetX == 2*SCREEN_WIDTH) {
        flag=1;
    }else if(offsetX == 0)
    {
        flag=-1;
    }else{
        return;
    }
    for (UIImageView *view in _imageViews) {
        view.tag = (view.tag+flag+_images)%_images;
        NSLog(@"%ld",view.tag);
        [self setImageToView:view];
    }
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    UIImageView *view = _imageViews[1];
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld页",view.tag+1,_images];
    UIScrollView *sv = (UIScrollView *)[_imageViews[1] superview];
    sv.zoomScale=1.0;
}

- (void)updateFrame{
    [_subScrollView setBouncesZoom:YES];
    [_scrollView setBouncesZoom:YES];
    _scrollView.frame = CGRectMake(0, _scrollerY, SCREEN_WIDTH, SCREEN_HEIGHT-200);
   
    UIImageView *imageview0 = (UIImageView *)[self.view viewWithTag:200];
    UIImageView *imageview1 = (UIImageView *)[self.view viewWithTag:201];
    [imageview0 removeFromSuperview];
    [imageview1 removeFromSuperview];
    imageview0.transform = CGAffineTransformIdentity;
    imageview1.transform = CGAffineTransformIdentity;
    _subScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-200);
    if (_scrollView.contentOffset.x == 0) {
        imageview0.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        imageview1.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        _subScrollView.frame = imageview0.frame;
        [_subScrollView addSubview:imageview0];
        [_scrollView addSubview:imageview1];
    }else if (_scrollView.contentOffset.x == SCREEN_WIDTH){
         imageview0.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
         imageview1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        _subScrollView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        [_subScrollView addSubview:imageview1];
        [_scrollView addSubview:imageview0];
    }
     _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    if (_images >1) {
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld页",(long)(NSInteger)(_scrollView.contentOffset.x/SCREEN_WIDTH + 1),_images];
    }
}
#pragma mark - 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (_images<3) {
        [self updateFrame];
        return;
    }
    [self circulate];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_images >=3) {
        return _imageViews[1];
    }else{
        return scrollView.subviews[0];
    }
    return nil;
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (scale<0.5) {
        
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden=NO;
    }
}
- (void)dealloc{
    NSLog(@"结束");
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
