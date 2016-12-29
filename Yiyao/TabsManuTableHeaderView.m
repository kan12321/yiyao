//
//  TabsManuTableHeaderView.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "TabsManuTableHeaderView.h"

@implementation TabsManuTableHeaderView

-(void) startUp:(CGFloat) screanWidth At:(int)index
{
    NSLog(@"screanWidth:%f" , screanWidth);
    NSInteger nums = [self.delegate numsOfTabsManu];
    _btnWidht = (int) [self.delegate widthOfTabsManu];
    //只支持>3
    NSMutableArray * xArray = [[NSMutableArray alloc] init];
    

    if ( nums == 4 ) {
        int btnWidht = _btnWidht;
        int space = (int) ( screanWidth - (4*btnWidht) )/(4+1);
        [xArray addObject:[NSNumber numberWithInt: space]];
        [xArray addObject:[NSNumber numberWithInt:( 2*space + btnWidht)]];
        [xArray addObject:[NSNumber numberWithInt:( 3*space + 2*btnWidht )]];
        [xArray addObject:[NSNumber numberWithInt:( 4*space + 3*btnWidht )]];
        
        NSLog(@"%@" , xArray);
    }
    
    if ( nums == 5 ) {
        int btnWidht = _btnWidht;
        int space = (int) ( screanWidth - (5*btnWidht) )/(5+1);
        [xArray addObject:[NSNumber numberWithInt:space]];
        [xArray addObject:[NSNumber numberWithInt:( 2*space + btnWidht)]];
        [xArray addObject:[NSNumber numberWithInt:( 3*space + 2*btnWidht )]];
        [xArray addObject:[NSNumber numberWithInt:( 4*space + 3*btnWidht )]];
        [xArray addObject:[NSNumber numberWithInt:( 5*space + 4*btnWidht) ]];
        
        NSLog(@"%@" , xArray);
    }
    
    
    NSArray * textArr = [self.delegate textOfTabsManu];
    self.borderArray = [[NSMutableArray alloc] init];
    self.btnsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < nums; i++) {
        UIButton * btn = [self addBtn:[textArr objectAtIndex:i] AtX:[[xArray objectAtIndex:i] intValue] ];
        //添加事件
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        //设置tag 为 index
        btn.tag = i;
        
        [self.btnsArray addObject:btn];
        [self.bgView addSubview:btn];
        
        if(i == index ){
            //默认首个元素选中
            [self btnSeleted:btn];
        }

    }
    
    
    NSLog(@"TabsBorder: %f:%f:%f:%f" ,self.TabsBorder.layer.frame.origin.x , self.TabsBorder.layer.frame.origin.y, self.TabsBorder.layer.frame.size.width, self.TabsBorder.layer.frame.size.height);
}


-(void)clickBtn:(UIButton *) btn{
    [self.delegate tabsManu:self didSelectRowAtIndex:(int)btn.tag];
    
    //点击加效果
    for (UIButton * btnEach in self.btnsArray) {
        [btnEach setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
    }
    
    for (UIView * borderView in self.borderArray) {
        [borderView setBackgroundColor:[UIColor whiteColor]];
    }
    
    [self btnSeleted:btn];
}

//按钮被选中
-(void)btnSeleted:(UIButton *) btn{
    //颜色高亮
    [btn setTitleColor:UIColorFromRGB(0x3786c7) forState:UIControlStateNormal];
    //移动边框到按钮下方
    int index = (int)btn.tag;
    UIView * borderView = [self.borderArray objectAtIndex:index];
    [borderView setBackgroundColor:UIColorFromRGB(0x3786c7)];
}

//添加按钮
-( UIButton *  )addBtn:(NSString *) title AtX:(CGFloat )x
{
    NSLog(@"self.bgView.layer.frame.size.width %f" , self.bgView.layer.frame.size.width);
    CGFloat width = self.btnWidht;
    CGFloat y = 10;
    CGFloat atX = x + (width / 2 ) - 20;
    CGFloat height = 20;
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(atX , y,  width, height)];
    [btn setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    //按钮文字居中对齐
    btn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentCenter;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    
    //添加边栏
    float borderX = atX;
    UIView * borderView = [[UIView alloc] initWithFrame:CGRectMake( borderX , 38.5, width , 1.5)];
    [borderView setBackgroundColor:[UIColor whiteColor]];
    [self.borderArray addObject:borderView];
    [self.bgView addSubview:borderView];
    
    return btn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
