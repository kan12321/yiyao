//
//  Common.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "Common.h"

@implementation Common

//计算文字宽度
+(CGSize)boundingRectWithString:(NSString *) string
                       withSize:(CGSize)size
                   withTextFont:(UIFont *)font
                withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString * attributedText = [Common attributedStringFromSting:string WithFont:font withLineSpacing:lineSpacing];
    CGSize textSize = [attributedText boundingRectWithSize:size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size;
    return textSize;
}

//刷新table的某一行    row表示第几行    section表示  第几个分区
+ (void)relodDataWithSection:(NSInteger)section andRow:(NSInteger)row andViewController:(UITableViewController *)viewController

{
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:row inSection:section];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [viewController.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

//修改导航返回按钮title
+ (void)setBarTitle:(NSString *)title andUiViewController:(UIViewController *)viewController{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    viewController.navigationItem.backBarButtonItem = backItem;
    backItem.title = title;
}

+ (UIViewController *)viewController:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+(NSMutableAttributedString *) attributedStringFromSting:(NSString *) string
                                                WithFont:(UIFont *)font
                                         withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

//设置返回按钮
+(void)setNavBackBtn:(UIViewController *) view
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    [view.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    view.navigationItem.backBarButtonItem = backItem;
}

//设置导航标题
+(void)setNavBarTitle:(NSString*)title Ctrl:(UIViewController*) ctrl{
    [ctrl.navigationController setNavigationBarHidden:NO];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setText:title];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    ctrl.navigationItem.titleView = titleLab;
}

+(NSArray *)oneBarItemWithImageName:(NSString *) image{
    
    UIButton * rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0 , 36, 20)];
    
    [rightBarButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    return [NSArray arrayWithObjects:negativeSpacer,rightBarItem,nil];
}

+(NSArray *)oneBarItemWithTitle:(NSString *) title{
    
    UIButton * rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0 , 25, 25)];
    [rightBarButton setTitle:title forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    return [NSArray arrayWithObjects:negativeSpacer,rightBarItem,nil];
}


-(NSString *)device{
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height == 480)
    {
        return @"iphone4";
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        return @"iphone5";
        // 5,5s,5c,5se
    }
    else if ([UIScreen mainScreen].bounds.size.height == 667)
    {
        //6,6s
        return @"iphone6";
    }
    else if ([UIScreen mainScreen].bounds.size.height == 736)
    {
        return @"iphone6p";
        //6p,6sp
    }
    else
    {
        return @"pad";
        //pad;
    }
}
//获取用户型号
+(NSString *)device{
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height == 480)
    {
        return @"iphone4";
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        return @"iphone5";
        // 5,5s,5c,5se
    }
    else if ([UIScreen mainScreen].bounds.size.height == 667)
    {
        //6,6s
        return @"iphone6";
    }
    else if ([UIScreen mainScreen].bounds.size.height == 736)
    {
        return @"iphone6p";
        //6p,6sp
    }
    else
    {
        return @"pad";
        //pad;
    }
}


-(BOOL)isBigScreen{
    if( [[self device] isEqualToString:@"pad"] ||
       [[self device] isEqualToString:@"iphone6p"] ){
        return YES;
    } else {
        return NO;
    }
}

//根据方法名返回API的url
+ (NSString *) getApiUrl:(NSString *)action{
    NSString * apiurl = [[NSString alloc] initWithFormat:@"%s%@" , API_PRE , action];
    //NSLog(@"api request:%@" , apiurl);
    return apiurl;
}

//token
+(NSString *) getToken{
    NSString * toekn = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    return toekn == nil ? @"" : toekn;
}

+(void) setToken:(NSString *) token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
}

//userinfo
+(id)getUserInfo:(NSString *) key
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSDictionary * dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return [self getFromJson:dict Key:key];
}

+(void) setUserInfo:(NSData *) dict
{
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
}





//消息提示
+(UIAlertView *) ALertInfo:(NSString *) message{
    return [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:Nil, nil];
}


//将data数据保存到本地沙盒中，使用用户指定的文件名
+(NSString *)dataWriteToFile:(NSData *) data filename:(NSString *) filename{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *filePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:filename];   // 保存文件的名称
    BOOL result = [data writeToFile:filePath atomically:YES];
    if( result ){
        //        NSLog(@"filepath %@" , filePath );
        return filePath;
    } else {
        return nil;
    }
}

//App下Documents目录是否存在该文件
+(NSString *)localFilePath:(NSString *) filename{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *filePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:filename];   // 保存文件的名称
    //判读文件是否存在
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ){
        return filePath;
    } else {
        return nil;
    }
}

//时间字符串去除分秒
+(NSString *) getSimpleDateStr:(NSString *) str
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [df dateFromString:str];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:date];
}

//时间字符串去除分秒
+(NSString *) getSimpleHMDateStr:(NSString *) str
{
    NSDate * date;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
     [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    date = [df dateFromString:str];

    if (date == nil) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [df dateFromString:str];
    }
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [df stringFromDate:date];
}


+(void) SB4Json
{
//    NSString *requestTmp = [NSString stringWithString:operation.responseString];
//    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    SBJson4Parser *parser = [SBJson4Parser parserWithBlock:^(id item, BOOL *stop) {
//        NSObject *itemObject = item;
//        if ([item isKindOfClass:[NSDictionary class]]) {
//            NSDictionary * dict = (NSDictionary*)itemObject;
//            NSLog(@"jobNum:%@", [[dict objectForKey:@"data"] objectForKey:@"jobNum"] );
//            NSLog(@"jobNum:%@", ([[dict objectForKey:@"data"] objectForKey:@"jobNum"] == nil) ? @"YES" : @"NO" );
//            
//        }
//    } allowMultiRoot:NO unwrapRootArray:NO errorHandler:^(NSError *error) {
//        NSLog(@"SBJson4Parser error:%@" , [error localizedDescription]);
//    }];
//    [parser parse:resData];
}

//获得JSON字典中的字符串数据，如果字符串中包含null字符串返回空
+(NSString *) getStrFromJson:(NSDictionary *) dict Key:(NSString *) key
{
    if ( [dict objectForKey:key] == nil ) {
        return @"";
    }
    else if( [dict objectForKey:key] == [NSNull null])
    {
        return @"";
    }
    else
    {
        NSObject * item = [dict objectForKey:key];
        if( [item isKindOfClass:[NSString class]] )
        {
            NSString * str = (NSString *) item;
            return [self strContainNullToEmpty:str];
        }
        else {
            NSString * str = [NSString stringWithFormat:@"%@" , item];
            return [self strContainNullToEmpty:str];
        }
    }
}

+(NSObject *) getFromJson:(NSDictionary *) dict Key:(NSString *) key
{
    if ( [dict objectForKey:key] == nil ) {
        return @"";
    }
    else if( [dict objectForKey:key] == [NSNull null])
    {
        return @"";
    }
    else {
        return [dict objectForKey:key];
    }
}

+(NSString *) strContainNullToEmpty:(NSString *) str
{
    if ( [[str lowercaseString] rangeOfString:@"null"].location != NSNotFound ) {
        return @"";
    } else {
        return str;
    }
}

//判断今日是否签到
+(BOOL)isSign
{
    NSString * signedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"signed"];
    if ( signedDate == nil ) {
        return NO;
    }
    else if( [signedDate isEqualToString:[self todayByFormart:@"yyyy-MM-dd"]] )
    {
        return YES;
    }
    else {
        return NO;
    }
}

//设置今日签到
+(void)setSign
{
    NSString * today = [self todayByFormart:@"yyyy-MM-dd"];
    [[NSUserDefaults standardUserDefaults] setObject:today forKey:@"signed"];
}

//当天日期本地时区
+(NSDate *)today
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"Now is At:%@" , localeDate);
    return localeDate;
}

//返回当天日期，根据指定日期格式:yyyy-MM-dd
+(NSString * )todayByFormart:(NSString *) formart
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:formart];
    NSDate * date = [self today];
    NSString * today = [df stringFromDate:date];
    return today;
}


/**
 * 生成网络调用进度条
 */

+(UIActivityIndicatorView *)getIndicator:(UIView *) view{
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake( view.center.x , view.center.y )];
    indicator.backgroundColor = [UIColor grayColor];
    indicator.alpha = 0.5;
    indicator.layer.masksToBounds = YES;
    indicator.layer.cornerRadius = 4;
    [view addSubview:indicator];
    
    return indicator;
}


/**
 * 退出注销用户状态
 */
+(void)logout
{
    [Common setToken:@"failure"];
    [Common setUserInfo:nil];
    [(AppDelegate *)[UIApplication sharedApplication].delegate logout];
}
@end
