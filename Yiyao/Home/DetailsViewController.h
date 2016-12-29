//
//  DetailsViewController.h
//  Yiyao
//
//  Created by tobo on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPDFModel.h"
@interface DetailsViewController : UIViewController

//文件id
@property (nonatomic, copy)NSString *Id;
//1 企业资料 2 药品说明书 3 学术资料 4 临床表单 5 住院流程
@property (nonatomic,copy)NSString *type;

@property UIAlertView * alertView;



@end
