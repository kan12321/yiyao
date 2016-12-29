//
//  NewPDFModel.h
//  Yiyao
//
//  Created by tobo on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NewPDFModel : JSONModel

@property (nonatomic, copy)NSString *folderName;
@property (nonatomic, copy)NSString *jpgNum;
@property (nonatomic, copy)NSString *coverUrl;
@property (nonatomic, copy)NSString *Id;


@end
