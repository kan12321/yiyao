//
//  LoginStartUpViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/8/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//**未登录用户启示页面，引导登录，搜索，注册
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "API.h"
#import "WordLayout.h"
#import "SearchResultTableViewController.h"

@interface LoginStartUpViewController : UIViewController<UITextFieldDelegate>

//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *RegBtn;
//搜索框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
//热门搜索词区域
@property (weak, nonatomic) IBOutlet UIView *hotWordView;

@property NSString * searchWord;
@property NSDictionary * sData; //搜索结果数据

@end
