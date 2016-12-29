//
//  ReaderViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "ReaderViewController.h"

@interface ReaderViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollerView;
    UIImageView *imgView;
    CGFloat bigScale;
    BOOL flag;
    BOOL isHidden;
    
}

@end

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    fl.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    //fl.headerReferenceSize = CGSizeMake(0, 0);
    //fl.footerReferenceSize = CGSizeMake(0, 0);
    
    [self.NavCollectionView setCollectionViewLayout:fl];
    
    self.NavCollectionView.delegate = self;
    self.NavCollectionView.dataSource = self;
    
    //
    self.currentImageIndex = 0;
    self.imgArr = [[NSArray alloc] initWithObjects:@"testBook1",@"testBook2",@"testBook3",@"testBook4",@"testBook5",@"testBook6",@"testBook7", nil];
    
    //默认不显示 目录 与 标题
    self.titleBgView.layer.zPosition = 10;
    self.imgBgScrollView.layer.zPosition = 0;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupScrollView];
    [self viewDidLayoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Nav datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.imgArr count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,20,35,20);
}
//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//定义并返回每个headerView或footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(75, 89);
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCollectionCell_ID" forIndexPath:indexPath];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 89)];
    NSLog(@"objectAtIndex:%li" , (long)indexPath.row);
    [imageView setImage:[UIImage imageNamed:[self.imgArr objectAtIndex:indexPath.row]]];
    [cell addSubview:imageView];
    
    
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)setupScrollView
{
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.delegate = self;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.backgroundColor = [UIColor whiteColor];
    [self.imgBgScrollView addSubview:_scrollerView];
    
    for (int i = 0; i < [self.imgArr count]; i++) {
        imgView = [[UIImageView alloc] init];
        imgView.tag = i;
        //        NSString *str = [NSString stringWithFormat:@"%@upload/%@",WebService,[self.imgArr objectAtIndex:i]];
        //        [imgView setImageWithURL:[NSURL URLWithString:str]];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imgArr objectAtIndex:i]]]
         ];
        [imgView setUserInteractionEnabled:YES];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [_scrollerView addSubview:imgView];
        
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:singleTap];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwoAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [imgView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        // 捏合手势缩放图片
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [imgView addGestureRecognizer:pinch];
    }
}


-(void)viewDidLayoutSubviews{
    CGRect rect = self.imgBgScrollView.bounds;
    NSLog(@"viewDidLayoutSubviews rect %f , %f , %f , %f" , rect.origin.x , rect.origin.y , rect.size.width , rect.size.height);
    rect.size.width += 10 * 2;
    
    _scrollerView.bounds = rect;
    _scrollerView.center = self.imgBgScrollView.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollerView.frame.size.width - 10 * 2;
    CGFloat h = _scrollerView.frame.size.height;
    
    [_scrollerView.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = 10 + idx * (10 * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollerView.contentSize = CGSizeMake(_scrollerView.subviews.count * _scrollerView.frame.size.width, 0);
    _scrollerView.contentOffset = CGPointMake(self.currentImageIndex * _scrollerView.frame.size.width, 0);
}


#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int index = (scrollView.contentOffset.x + _scrollerView.bounds.size.width * 0.5) / _scrollerView.bounds.size.width;
    NSLog(@"scrollView.contentOffset.x  %f , _scrollerView.bounds.size.width %f " , scrollView.contentOffset.x , _scrollerView.bounds.size.width);
    CGFloat margin = 50;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.view.bounds.size.width) > margin || (x - index * self.view.bounds.size.width) < - margin) {
        imgView = _scrollerView.subviews[index];
        [UIView animateWithDuration:0.5 animations:^{
            imgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            bigScale = 1.0;
        }];
    }
}

-(void)oneTapAction:(UITapGestureRecognizer*)recognizer{
    //    NSInteger index= recognizer.view.tag;
    //    NSString *str = [NSString stringWithFormat:@"%@upload/%@",WebService,imgeArr[index]];
    //    [imgView setImageWithURL:[NSURL URLWithString:str]];
    if (isHidden == YES) {
        self.navigationController.navigationBar.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        isHidden = NO;
        _scrollerView.backgroundColor = [UIColor whiteColor];
    }else{
        self.navigationController.navigationBar.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _scrollerView.backgroundColor = [UIColor blackColor];
        isHidden = YES;
    }
}

-(void)tapTwoAction:(UITapGestureRecognizer *)tapGesture{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIGestureRecognizerState state = [tapGesture state];
    if (state == UIGestureRecognizerStateEnded)
    {
        if(!flag){
            [tapGesture.view setTransform:CGAffineTransformScale(tapGesture.view.transform, 2, 2)];
            flag = true;
        }else{
            [tapGesture.view setTransform:CGAffineTransformIdentity];
            flag = false;
        }
        
    }
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }
}

@end
