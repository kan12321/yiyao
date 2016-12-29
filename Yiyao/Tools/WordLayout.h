//
//  WordLayout.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/8.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface WordLayout : NSObject

//X原点
@property int startX;

//Y原点
@property int startY;

//每行的间距
@property int lineSpace;

//文字显示大小
@property int fontSize;

//行高
@property int lineHeight;

//行最宽
@property int maxWidth;

//每行最多单词
@property int maxLineWordNums;

//字符最小间距
@property int minFixSpace;

//需要计算的字符数组
@property NSArray * wordsArray;


//计算出的行数
@property int lineNums;

//计算出的每行的字符间距
@property NSMutableArray * fixSpaceArray;

//计算出的每个字符的X位置
@property NSMutableArray * XArray;

//计算出的每个字符的Y位置
@property NSMutableArray * YArray;

//每个文字的宽度
@property NSMutableArray * widthArray;

-(WordLayout *) initWithStartX:(int)startX
                StartY:(int)startY
             LineSapce:(int)lineSpace
            LineHeight:(int)lineHeight
              MaxWidth:(int)maxWidth
          CornerRadius:(int)cornerRadius
       MaxLineWordNums:(int)maxLineWordNums
           MinFixSpace:(int)minFixSpace
              FontSize:(int)fontSize
            WordsArray:(NSArray*)wordsArray;

@end
