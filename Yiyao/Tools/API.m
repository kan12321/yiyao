//
//  HTTPGET.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/19.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "API.h"

@implementation API

+(void)get:(NSString *) url Resp:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    [API get:url Params:nil Resp:success];
}

+(void)get:(NSString *) url Params:(id)parameters Resp:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    
    url = [Common getApiUrl:url];
    NSLog(@"Get.request.url:%@ token:%@ params:%@" , url , [Common getToken] , parameters );
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置token
    
    [manager.requestSerializer setValue:[Common getToken] forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"mt"];

    [manager
     GET:url
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         NSLog(@"Get.success resp:%@" , responseObject);
         //检测是否登录超时
         if ( ( [responseObject isKindOfClass:[NSDictionary class]] )
             &&
             [[Common getStrFromJson:responseObject Key:@"message"] isEqualToString:@"登录超时，请重新登录"]
         ) {
             //提示登录，点击后跳转到登录页面
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [Common logout];
             }]];
             
             UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
             
             NSLog(@"%@" , [window.rootViewController class]);
                          
             [window.rootViewController presentViewController:alert animated:YES completion:^{
                 
             }];
             return;
         }
         
         success(operation , responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //集中处理网络请求失败，返回登录页面
         NSLog(@"error:%@" , [error localizedDescription]);
     }
     ];
}

+(void)post:(NSString *) url Params:(id)parameters Resp:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success{
    url = [Common getApiUrl:url];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置token
    [manager.requestSerializer setValue:[Common getToken] forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"mt"];

    NSLog(@"Post.Request.url:%@,token:%@,params:%@" , url , [Common getToken] , parameters);
    [manager
     POST:url
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         NSLog(@"Post.success resp:%@" , responseObject);
         //检测是否登录超时
         if ( [[Common getStrFromJson:responseObject Key:@"message"] isEqualToString:@"登录超时，请重新登录"]) {
             //提示登录，点击后跳转到登录页面
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
                 [Common logout];
             }]];
             return;
         }
         
         success(operation , responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //集中处理网络请求失败，返回登录页面
         NSLog(@"error %@" , [error localizedDescription]);
     }
     ];

}
@end
