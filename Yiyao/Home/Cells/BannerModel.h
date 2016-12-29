//
//  BannerModel.h
//  Yiyao
//
//  Created by tobo on 16/9/28.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "JSONModel.h"

@interface BannerModel : JSONModel

@property (nonatomic, copy)NSString *companyID;
@property (nonatomic, copy)NSString *fileUrl;
@property (nonatomic, copy)NSString *htmlUrl;
@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *type;

@end
