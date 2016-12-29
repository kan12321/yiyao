//
//  WordLayout.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/8.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "WordLayout.h"

@implementation WordLayout

-(WordLayout * ) initWithStartX:(int)startX
                StartY:(int)startY
             LineSapce:(int)lineSpace
            LineHeight:(int)lineHeight
              MaxWidth:(int)maxWidth
          CornerRadius:(int)cornerRadius
       MaxLineWordNums:(int)maxLineWordNums
           MinFixSpace:(int)minFixSpace
              FontSize:(int)fontSize
            WordsArray:(NSArray*)wordsArray
{
    self.startX = startX;
    self.startY = startY;
    self.lineSpace = lineSpace;
    self.maxWidth  = maxWidth;
    self.maxLineWordNums = maxLineWordNums;
    self.wordsArray = wordsArray;
    self.lineHeight = lineHeight;
    self.fontSize = fontSize;
    self.minFixSpace = minFixSpace;
    
    self.widthArray = [[NSMutableArray alloc] init];
    
    //计算元素循环索引
    int index = 0;
   
    //存储行索引数据
    NSMutableArray * rowIndex = [[NSMutableArray alloc] init];
    //存储每行的实际字符间距
    NSMutableArray * lineRealFixSpaceArray = [[NSMutableArray alloc] init];
    //存储每行的间距误差
    NSMutableArray * lineFixSpaceDiffer =  [[NSMutableArray alloc] init];
    
    //每行总间距
    int lineAllOfFixSpace = 0;
    //存储每行的元素索引
    NSMutableArray * lineIndex = [[NSMutableArray alloc] init];
    int lineRealWidth = 0;
    BOOL isNextLineOrEndForEach = false;
    
    for (NSString * hotWord in wordsArray) {
        NSLog(@"%@" , hotWord);
        if( index == ([wordsArray count] -1 ) )
        {
            isNextLineOrEndForEach = true; //最后一个元素，可能不会换行
        }
        
        if ( index >0 && (lineRealWidth == 0)) {
            //另起一行时,从行索引纪录里面取出第一个元素，计算宽度
            lineRealWidth = (int) [[self.widthArray objectAtIndex:(index - 1)] integerValue];
        }
        
        NSLog(@"index%i = %i" , index , lineRealWidth);

        
        //计算文字宽度
        CGSize size = [Common boundingRectWithString:hotWord withSize:CGSizeMake(MAXFLOAT, self.lineHeight) withTextFont:[UIFont systemFontOfSize:self.fontSize] withLineSpacing:0];
        //如果小于最小指定宽度，则使用最小指定宽度
        float sizeWidth = size.width + ( cornerRadius * 2 );
        //记录宽度
        [self.widthArray addObject:[[NSNumber alloc] initWithInt:sizeWidth]];
        
        if( [self isLineInWitLineRealWidth:lineRealWidth WordWidth:sizeWidth] )
        {
            if ( lineRealWidth != 0 ) {
                //不是首个元素，添加间距
                lineRealWidth += minFixSpace;
                lineAllOfFixSpace += minFixSpace;
            }
            lineRealWidth += sizeWidth;
            //添加行内元素
            [lineIndex addObject:[[NSNumber alloc] initWithInt:index]];
        }
        else {
            NSLog(@"换行");
            isNextLineOrEndForEach = true; //换行
        }
        
        //换行或结束前纪录
        if( isNextLineOrEndForEach )
        {
            [rowIndex addObject:lineIndex];
            //多个元素重新计算间距
            if( [lineIndex count] > 1 ){
                //实际间距
                int realFixSpace = (int) ( maxWidth - (lineRealWidth - lineAllOfFixSpace) ) / ( [lineIndex count] - 1);
                NSLog(@"实际间距 %i" , realFixSpace);
                
                [lineRealFixSpaceArray addObject:[[NSNumber alloc] initWithInt:realFixSpace]];
                //行间距误差
                int fixSpaceDiffer = (int) maxWidth - (lineRealWidth - lineAllOfFixSpace) - (int)( realFixSpace * ( [lineIndex count] - 1) );

                [lineFixSpaceDiffer addObject:[[NSNumber alloc] initWithInt:fixSpaceDiffer]];
            } else {
                [lineRealFixSpaceArray addObject:[[NSNumber alloc] initWithInt:0]];
            }
            lineRealWidth = 0; //置零另起一行
            lineAllOfFixSpace = 0; //置零重新累计
            isNextLineOrEndForEach = false;
        }
        
        
        
        //换行前，将当前元素追加到新行的第一个元素
        if(lineRealWidth == 0 )
        {
            //新建一行
            lineIndex = [[NSMutableArray alloc] init];
            [lineIndex addObject:[[NSNumber alloc] initWithInt:(index)]];
            
            if ( index == ([wordsArray count] - 1) ) {
                //如果是循环结束
                [rowIndex addObject:lineIndex];
                [lineRealFixSpaceArray
                    addObject:[[NSNumber alloc] initWithInt:0]];
                [lineFixSpaceDiffer
                    addObject:[[NSNumber alloc] initWithInt:0]];
            }
        }
        
        index++;
        
    }
    
    int pointY = startY;
    int pointX = startX;
    
    self.XArray = [[NSMutableArray alloc] init];
    self.YArray = [[NSMutableArray alloc] init];
    //行号
    int j=0;
    
    for (NSMutableArray * lineArray in rowIndex) {
        int i = 0;
        for (NSNumber * index in lineArray) {
            
            if ( (j != 0 ) && (i==0) ) {
                pointY += self.lineHeight + self.lineSpace;
            }

            [self.XArray addObject:[[NSNumber alloc] initWithInt:pointX]];
            [self.YArray addObject:[[NSNumber alloc] initWithInt:pointY]];

            //偏移字符宽度
            pointX +=  (int) [[self.widthArray objectAtIndex:[index integerValue]] integerValue];
            //偏移间距
            pointX += [[lineRealFixSpaceArray objectAtIndex:j] integerValue];
            //如果下个元素是倒数第二个元素再移动本行误差
            if ( (i+1) == ([lineArray count]-1) ) {
                pointX += [[lineFixSpaceDiffer objectAtIndex:j] integerValue];
            }
            
            i++;
        }
        
        pointX = startX;
        j++;
    }
//    for(int i = 0 ; i < [wordsArray count] ; i++ )
//    {
//        int width = (int) [self.widthArray objectAtIndex:i];
//        
//        if( (pointX + width) < (startX + maxWidth) )
//        {
//            [self.XArray addObject:[[NSNumber alloc] initWithInt:pointX]];
//        }
//    }
//    
//    NSLog(@"显示全部字符串宽度: %@" , self.widthArray);
//    NSLog(@"显示每行的元素索引: %@" , rowIndex);
//    NSLog(@"显示每行的元素间距: %@" , lineRealFixSpaceArray);
//    NSLog(@"显示每行的间距误差: %@" , lineFixSpaceDiffer);
//    NSLog(@"显示每个的元素X坐标: %@" ,self.XArray);
//    NSLog(@"显示每个的元素Y坐标: %@" ,self.YArray);
    
    return self;
}


-(BOOL)isLineInWitLineRealWidth:(int)lineRealWidth
                  WordWidth:(int)wordWidth
{
    if( lineRealWidth == 0 ){
        return true; //首个元素肯定显示
    } else{
        if( (lineRealWidth + self.minFixSpace + wordWidth ) > self.maxWidth )
        {
            return false;
        } else {
            return true;
        }
    }
    
}
@end
