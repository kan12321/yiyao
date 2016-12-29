//
//  ReaderViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderViewController : UIViewController<UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *NavCollectionView;

@property(nonatomic,strong)NSArray *imgArr;
@property(nonatomic,assign)NSInteger currentImageIndex;
@property (weak, nonatomic) IBOutlet UIView *imgBgScrollView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
