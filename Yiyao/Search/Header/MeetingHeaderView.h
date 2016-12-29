//
//  MeetingHeaderView.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setIconImg:(UIImage *)iconImg Title:(NSString *)title;
@end
