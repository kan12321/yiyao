//
//  NewPDFModel.m
//  Yiyao
//
//  Created by tobo on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "NewPDFModel.h"

@implementation NewPDFModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id"}];
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
