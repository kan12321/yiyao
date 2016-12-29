//
//  DetailsModel.h
//  Yiyao
//
//  Created by tobo on 16/9/30.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface DetailsModel : JSONModel

@property (nonatomic, strong)NSString *Id;
@property (nonatomic, strong)NSString *fileName;
@property (nonatomic, strong)NSString *fileUrl;
@property (nonatomic, strong)NSString *coverUrl;
@property (nonatomic, strong)NSString *folderName;
@property (nonatomic, strong)NSString *jpgNum;
@property (nonatomic, strong)NSString *fileType;
@property (nonatomic, strong)NSString *isCollect;
@property (nonatomic, strong)NSString *recordId;
@end
