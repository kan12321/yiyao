//
//  MeetingViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "Common.h"

@interface MeetingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property NSString * mid;
@property NSString * type;
@property NSString * url;
@property BOOL isYuYue; //是否已预约接口数据

@property UIAlertView * alertView;


@end
