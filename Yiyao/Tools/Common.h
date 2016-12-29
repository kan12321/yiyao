//
//  Common.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginStartUpViewController.h"
#import "AppDelegate.h"
@interface Common : NSObject


+(CGSize)boundingRectWithString:(NSString *) string
                       withSize:(CGSize)size
                   withTextFont:(UIFont *)font
                withLineSpacing:(CGFloat)lineSpacing;

//设置返回按钮
+(void)setNavBackBtn:(UIViewController *) view;

//设置导航标题
+(void)setNavBarTitle:(NSString*)title Ctrl:(UIViewController*) ctrl;

+(NSArray *)oneBarItemWithImageName:(NSString *) image;
+(NSArray *)oneBarItemWithTitle:(NSString *) title;
//修改返回按钮title
+ (void)setBarTitle:(NSString *)title andUiViewController:(UIViewController *)viewController;

//刷新table的某一行    row表示第几行    section表示  第几个分区
+ (void)relodDataWithSection:(NSInteger)section andRow:(NSInteger)row andViewController:(UITableViewController *)viewController;

//根据方法名返回API的url
+ (NSString *) getApiUrl:(NSString *)action;
//通过view  找到view所在的viewController
+ (UIViewController *)viewController:(UIView *)view;

//token 设置与获取
+(NSString *) getToken;
+(void) setToken:(NSString *) token;

+(UIAlertView *) ALertInfo:(NSString *) message;


+(NSString *)dataWriteToFile:(NSData *) data filename:(NSString *) filename;
+(NSString *)localFilePath:(NSString *) filename;

+(id)getUserInfo:(NSString *) key;
+(void) setUserInfo:(NSData *) dict;

//时间字符串去除分秒
+(NSString *) getSimpleDateStr:(NSString *) str;
+(NSString *) getSimpleHMDateStr:(NSString *) str;

//获得JSON字典中的字符串数据，如果字符串中包含null字符串返回空
+(NSString *) getStrFromJson:(NSDictionary *) dict Key:(NSString *) key;
+(NSString *) strContainNullToEmpty:(NSString *) str;
//获取用户型号
+(NSString *)device;
//判断今日是否签到
+(BOOL)isSign;
//设置今日签到
+(void)setSign;
+(NSString * )todayByFormart:(NSString *) formart;

+(UIActivityIndicatorView *)getIndicator:(UIView *) view;

+(NSObject *) getFromJson:(NSDictionary *) dict Key:(NSString *) key;

/**
 * 退出注销用户状态
 */
+(void)logout;
@end
