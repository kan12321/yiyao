//
//  RegisterViewController.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightTextTableViewCell.h"
#import "RightBtnAndTextTableViewCell.h"
#import "RightBtnTableViewCell.h"
#import "MyInfoTableViewCell.h"
#import "API.h"
#import "Common.h"
#import "VPImageCropperViewController.h"
#define ORIGINAL_MAX_WIDTH 320.0f


@interface RegisterViewController : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>


@property NSMutableArray * titleArray;
@property NSMutableArray * keyArray;
@property NSMutableArray * valArray;

@property UIAlertView * alertView;



//**定义控件

//地区选载
@property UIPickerView * AreapickerView;
@property NSMutableArray *provinces;
@property NSMutableArray *cities;
@property NSMutableArray *citiesDidSelected;
@property NSArray *areaJsonArray;
//字段
@property NSString * province;
@property NSString * city;

@property UILabel * areaLabel;

//科室选择控件
@property UILabel * workroomLabel;
@property UIPickerView * WorkroomPickerView;
@property NSMutableArray * workroomArray;

//字段必填 手机号码 密码 验证码
@property NSString * phone;
@property NSString * password;
@property NSString * verifyCode;

@property NSString * name;
@property NSString * address;
@property NSString * hospital;
@property NSString * department;

//图片选择
@property UIButton * certImageBtn;
@property NSString * filename;
@property NSString * imageType;
@property NSData * imageData;

//性别
@property UILabel * sexLabel;
@property UIPickerView * sexPickerView;
@property NSArray * sexArray;
@property NSString * sex; //1:男 2:女
//判断上一级是都是登录界面
@property BOOL _isLogin;
//支付宝
@property NSString * alipay;

//手机
@property UITextField * phoneTextField;
//姓名
@property UITextField * nameTextField;
@end
