//
//  BannerModel.m
//  Yiyao
//
//  Created by tobo on 16/9/28.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel


 + (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id"}];
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
