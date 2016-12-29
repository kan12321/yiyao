//
//  FavPaperTableViewCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface FavPaperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *introImageView;

@property (weak, nonatomic) IBOutlet UIView *playerBg;
@property (weak, nonatomic) IBOutlet UIImageView *playerBtn;
@property (weak, nonatomic) IBOutlet UILabel *playerTime;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

-(void)isBooK;

-(void)setBookId:(NSString *)bookId Intro:(NSString *)intro
            time:(NSString *)time count:(NSString *)count
           image:(NSString *)url;

-(void)setMovieId:(NSString *)movieId Intro:(NSString *)intro
             time:(NSString *)time count:(NSString *)count
            image:(NSString *)imageName;

@end
