//
//  TabsManuTableHeaderView.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/25.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabsManuTableHeaderView;

@protocol TabsManuTableHeaderViewDelegate

@required
-(NSInteger)numsOfTabsManu; //按钮数量
-(NSInteger)widthOfTabsManu; //按钮数量
-(NSArray *)textOfTabsManu; //按钮的文字
//点击按钮后的事件
- (void)tabsManu:(TabsManuTableHeaderView *) tabsManu didSelectRowAtIndex:(int)index;

@end

@interface TabsManuTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<TabsManuTableHeaderViewDelegate> delegate;

//选中文字下的蓝边
@property (weak, nonatomic) IBOutlet UIView *TabsBorder;

@property (weak, nonatomic) IBOutlet UIView *bgView;

//绘画按钮
-(void) startUp:(CGFloat) screanWidth At:(int) index;

@property NSMutableArray * btnsArray;

@property NSMutableArray * borderArray;

@property int btnWidht;
@end
