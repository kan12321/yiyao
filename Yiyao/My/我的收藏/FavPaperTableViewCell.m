//
//  FavPaperTableViewCell.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "FavPaperTableViewCell.h"

@implementation FavPaperTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)isBooK{
    self.playerBg.hidden = YES;
    self.playerBtn.hidden = YES;
    self.playerTime.hidden = YES;
    //self.countLabel.text = @"12:00:00";
}

-(void)setBookId:(NSString *)bookId Intro:(NSString *)intro
            time:(NSString *)time count:(NSString *)count
           image:(NSString *)url
{
    self.introLabel.text = intro;
    self.timeLabel.text = time;
    if( [count isEqualToString:@"视频"]){
        self.countLabel.text = @"视频";
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"共%@页" , count];
    }
    [self.introImageView sd_setImageWithURL:[[NSURL alloc] initWithString:url] placeholderImage:[UIImage imageNamed:@"default"]];
}

-(void)setMovieId:(NSString *)movieId Intro:(NSString *)intro
             time:(NSString *)time count:(NSString *)count
            image:(NSString *)imageName
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
