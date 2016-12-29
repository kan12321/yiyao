//
//  MyInfoFooterTableView.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyInfoFooterTableView.h"

@implementation MyInfoFooterTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIButton *)startUp{
    self.logoutBtn.layer.cornerRadius = 7.5;
    self.logoutBtn.layer.masksToBounds = YES;
    return self.logoutBtn;
}

@end
