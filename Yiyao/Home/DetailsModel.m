//
//  DetailsModel.m
//  Yiyao
//
//  Created by tobo on 16/9/30.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "DetailsModel.h"


@implementation DetailsModel


+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
