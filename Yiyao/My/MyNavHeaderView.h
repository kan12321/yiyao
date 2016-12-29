//
//  MyNavHeaderView.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/21.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyNavHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *workNo;

-(void)setUserName:(NSString*)userName AndTag:(NSString*)tag AndNo:(NSString *)noStr;
-(void)setAvatar:(NSString *)imageName;
-(void)setAvatarFromUrl:(NSString *)url;
@end
