//
//  NSString+Common.h
//  Leadinfo
//
//  Created by tobo on 15/9/19.
//  Copyright © 2015年 wdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
@interface NSString (Common)

NSString * MD5Hash(NSString *aString);
NSString * URLEncodedString(NSString *str);
//把一个秒字符串 转化为真正的本地时间
//  1432861705000
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;

+ (BOOL)checkTel:(NSString *)str andViewController:(UIViewController *)viewController;

@end
