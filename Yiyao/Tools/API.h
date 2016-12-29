//
//  HTTPGET.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/19.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "LoginStartUpViewController.h"
@interface API : NSObject

+(void)get:(NSString *) url Resp:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

+(void)get:(NSString *) url Params:(id)parameters Resp:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

+(void)post:(NSString *) url Params:(id)parameters Resp:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

@end
