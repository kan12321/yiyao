//
//  RegisterViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Common.h"
@interface RegisterViewController ()
{
    NSMutableDictionary *_departmentDictionary;
}
@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:@"注册" Ctrl:self];
    
    _departmentDictionary = [[NSMutableDictionary alloc] init];
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"手机号码",@"验证码",@"密码",@"姓名",@"姓别",@"地区",@"地址",@"医院",@"科室",@"支付宝",@"胸卡",nil];
    
    self.keyArray = [[NSMutableArray alloc] initWithObjects:@"phone",@"verifyCode",@"password",@"name",@"sex",@"area",@"address",@"hospital",@"department",@"alipay",@"file",nil];
    
    //上传字段初始化
    self.phone = @"";
    self.verifyCode = @"";
    self.password = @"";
    self.name = @"";
    self.province = @"";
    self.city = @"";
    self.address = @"";
    self.hospital = @"";
    self.department = @"";
    self.sex = @"1"; //默认男
    
    self.valArray = [[NSMutableArray alloc] initWithObjects:@"请输入手机号码",@"",@"输入6位字符以上密码",@"请输入姓名",@"",@"",@"地址",@"请输入医院",@"",@"请输入支付宝账号",@"添加图片",nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.sexArray = @[@"男",@"女"];
    
    [self regsiterNib];
    [self addRegBtn];
    
    [self initAreapickerView];
}



-(void)regsiterNib{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightTextTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightBtnAndTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightBtnAndTextTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightBtnTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightBtnTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInfoTableViewCell_ID"];
}
#pragma mark - WorkroomPickerView科室选择控件
-(void)initWorkroomPickerView
{
    self.WorkroomPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
    self.WorkroomPickerView.delegate = self;
    self.WorkroomPickerView.dataSource = self;
    self.WorkroomPickerView.tag = 101;
}

#pragma mark - AreapickerView 地区选择控件

-(void)initAreapickerView{
    //地区选择控件
    self.AreapickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
    self.AreapickerView.delegate = self;
    self.AreapickerView.dataSource = self;
    self.AreapickerView.tag = 201;
    //省市
    
    
    NSData *response = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"]];
    
    self.areaJsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    
    self.provinces = [[NSMutableArray alloc] init];
    self.cities = [[NSMutableArray alloc] init];
    for (NSDictionary * row in self.areaJsonArray) {
        NSArray * cities = [row objectForKey:@"city"];
        NSMutableArray * citiesTmp = [[NSMutableArray alloc] init];
        if ( [cities count] == 1) {
            NSDictionary * tmpIcity = [cities objectAtIndex:0];
            NSArray * areaIcity = [tmpIcity objectForKey:@"area"];
            for (NSString * city in areaIcity ) {
                [citiesTmp addObject:city];
            }
            
        } else {
            for (NSDictionary * city in cities) {
                [citiesTmp addObject:[city objectForKey:@"name"]];
            }
        }
        
        [self.provinces addObject:[row objectForKey:@"name"]];
        [self.cities addObject:citiesTmp];
    }
    
    self.citiesDidSelected = [self.cities objectAtIndex:0];
    self.province = [self.provinces objectAtIndex:0];
    self.city = [self.citiesDidSelected objectAtIndex:0];
    
}

//联动级别 省市2级
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerView.tag == 201 ? 2 :1 ;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25.0f;
}
//数据量
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( pickerView.tag == 201 ) {
        return component == 0 ? [self.provinces count] : [self.citiesDidSelected count];
    }
    else if( pickerView.tag == 501 ){
        return [self.sexArray count];
    }
    else {
        return [self.workroomArray count];
    }
}
//省市 显示
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( pickerView.tag == 201 ) {
        return component == 0 ? [self.provinces objectAtIndex:row] : [self.citiesDidSelected objectAtIndex:row];
    }
    else if( pickerView.tag == 501 ){
        NSLog(@"501%@" , [self.sexArray objectAtIndex:row]);
        return [self.sexArray objectAtIndex:row]; //性别
    }
    else {
        return [self.workroomArray objectAtIndex:row];
    }
}
//二级联动选择了省市
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ( pickerView.tag == 201 ) {
        if ( component == 0 ) {
            self.citiesDidSelected = [self.cities objectAtIndex:row];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            self.province = [self.provinces objectAtIndex:row];
            self.city = [self.citiesDidSelected objectAtIndex:0];
        } else {
            self.city = [self.citiesDidSelected objectAtIndex:row];
        }
        
    }
    else if( pickerView.tag == 501 ){
        self.sexLabel.text = [self.sexArray objectAtIndex:row];
        self.sex = [self.sexArray objectAtIndex:row];
    }
    else {
        self.workroomLabel.text = [self.workroomArray objectAtIndex:row];
        self.department = [self.workroomArray objectAtIndex:row];
    }
}

#pragma mark - 注册按钮
-(void)addRegBtn{
    
    //Add a container view as self.view and the superview of the tableview
    UITableView *tableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    tableView.frame = tableView.bounds;
    self.view = containerView;
    [containerView addSubview:tableView];
    
    
    CGFloat y = SCREEN_HEIGHT - 50;
    
    UIButton * regBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, self.view.layer.frame.size.width, 50)];
    [regBtn.titleLabel setText:@"注册"];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    [regBtn setBackgroundColor:UIColorFromRGB(0x3786c7)];
    [regBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    
    NSLog(@"%f,%f,%f,%f" , 0.0 , y , self.view.layer.frame.size.width, 50.0);

    [self.view addSubview:regBtn];
    
    [regBtn addTarget:self action:@selector(registerSubmit) forControlEvents:UIControlEventTouchDown];
}

/*
 * 注册用户
 * @todo先实现手机号码，密码，验证码。
 */
-(void)registerSubmit{
    
    if (![NSString checkTel:self.phoneTextField.text andViewController:self]) {
        
        return;
    }
    NSLog(@"%ld",self.password.length);
    if (self.password.length > 20 || self.password.length < 6) {
        [self message:@"请输入正确格式的密码"];
        return;
    }
    if (self.verifyCode.length != 6 ) {
        [self message:@"请输入6位数字组成的验证码"];
        return;
    }
    if ([self verify:self.name message:@"姓名不能为空"] ||
        [self verify:self.province message:@"地区不能为空"] ||
        [self verify:self.city message:@"城市不能为空"] ||
        [self verify:self.address message:@"地址不能为空"] ||
        [self verify:self.hospital message:@"医院不能为空"] ||
        [self verify:self.department message:@"科室不能为空"] ||
        [self verify:self.alipay message:@"支付宝账号不能为空"]) {
        return;
    }
    NSString * sex = [self.sex isEqualToString:@"男"] ? @"1" : @"2";
    
    NSDictionary * params = @{@"phone":self.phone ,
                              @"password":self.password ,
                              @"name":self.name ,
                              @"province":self.province ,
                              @"city":self.city ,
                              @"address":self.address ,
                              @"hospital" : self.hospital ,
                              @"department" : [_departmentDictionary objectForKey:self.department ],
                              @"sex":sex ,
                              @"verifyCode":self.verifyCode ,
                              @"alipay" : self.alipay //@todo 此处需要确认字段名
                              };
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置token
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"mt"];

    
    [manager
     POST:[Common getApiUrl:@"member/info/register"]
     parameters:params
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
         if (self.imageData != nil ){
             [formData appendPartWithFileData:self.imageData name:@"file" fileName:self.filename mimeType:self.imageType];
         }
         
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"ERROR"]) {
            [self message:[responseObject objectForKey:@"message"]];
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功，等待审核" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //返回登录页面
                if (__isLogin == YES) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                [self performSegueWithIdentifier:@"to_login_view" sender:self];
                }
            }]];
            
            [self presentViewController:alert animated:YES completion:^{
            }];

            
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error %@" , error.description);

    }];
}


//验证字符串是否为空
- (BOOL)verify:(NSString *)str message:(NSString *)message{
    if ([str isEqualToString:@""]) {
        [self message:message];
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view layout

/**
 * 不显示多余空行
 */

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
/***Up 不显示多余空行**/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = [self.keyArray objectAtIndex:indexPath.row];

    if ([[Common device] isEqualToString:@"pad"]) {
        if( [key isEqualToString:@"file"] ){
            return 130;
        } else {
            return 54;
        }
    }
    if( [key isEqualToString:@"file"] ){
        return 120;
    } else {
        return 44;
    }
    
}

/**
 * 点击浏览记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //@"手机号码",@"验证码",@"密码",@"姓名",@"姓别",@"地区",@"地址",@"医院",@"科室",@"支付宝",@"胸卡",
    [self.nameTextField resignFirstResponder];
    switch ( indexPath.row ) {
        case 4:
        {
            //性别控件
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *manButtonTitle = NSLocalizedString(@"男", nil);
            NSString *womenButtonTitle = NSLocalizedString(@"女", nil);

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            if ([[Common device] isEqualToString:@"pad"]) {
                alertController.popoverPresentationController.sourceView = self.view;
                alertController.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-50, 0, 0);
            }
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击取消按钮");
            }];
            
            UIAlertAction * manAction = [UIAlertAction actionWithTitle:manButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                 //男
                 self.sex = @"男";
                 self.sexLabel.text = self.sex;
            }];
            
            UIAlertAction * womenAction = [UIAlertAction actionWithTitle:womenButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //女
                self.sex = @"女";
                self.sexLabel.text = self.sex;
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:manAction];
            [alertController addAction:womenAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        case 5://省市选择
        {
            //地区选择控件
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *destructiveButtonTitle = NSLocalizedString(@"确定", nil);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                NSLog(@"点击取消按钮");
            }]; 
            if ([[Common device] isEqualToString:@"pad"] ) {
                alertController.popoverPresentationController.sourceView = self.view;
                alertController.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-50, 0, 0);
            }
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                //选载了省市，修改数据
                NSLog(@"%@ %@" , self.province , self.city);
                
                self.areaLabel.text = [NSString stringWithFormat:@"%@ %@" , self.province , self.city];
                
                //修改省市显示
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:destructiveAction];
            [alertController.view addSubview:self.AreapickerView];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        break;
        case 8://科室选择
        {
            [API get:@"department/all" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                //整理数据
                self.workroomArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary * room in responseObject) {
                    [_departmentDictionary setValue:[room objectForKey:@"department_id"] forKey:[room objectForKey:@"department_name"]];
                    [self.workroomArray addObject:[room objectForKey:@"department_name"]];
                }
                
                
                //弹出框
                NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
                NSString *destructiveButtonTitle = NSLocalizedString(@"确定", nil);
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    NSLog(@"点击取消按钮");
                }];
                if ([[Common device] isEqualToString:@"pad"] ) {
                    alertController.popoverPresentationController.sourceView = self.view;
                    alertController.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-50, 0, 0);
                }
                UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    //选载了省市，修改数据
                    NSLog(@"%@ %@" , self.province , self.city);
                    
                    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@" , self.province , self.city];
                    
                    //修改省市显示
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:destructiveAction];
                
                [self initWorkroomPickerView];
                [alertController.view addSubview:self.WorkroomPickerView];
                
                [self presentViewController:alertController animated:YES completion:nil];

                
            }];
        }
        break;
        default:
            break;
    }
    
    
    /**
     * 返回取消选中效果
     * 清除选中的Cell，这样就不会一直灰色
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"deselectRowAtIndexPath");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.keyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * key = [self.keyArray objectAtIndex:indexPath.row];
    //验证码
    if ( [key isEqualToString:@"verifyCode" ]) {
        
        RightBtnAndTextTableViewCell *cell = (RightBtnAndTextTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RightBtnAndTextTableViewCell_ID" forIndexPath:indexPath];
        [cell startUp];
        [cell.authcodeBtn addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchDown];
        cell.leftTextField.delegate = self;
        cell.leftTextField.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if( [key isEqualToString:@"file"] )
    {
        RightBtnTableViewCell *cell = (RightBtnTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RightBtnTableViewCell_ID" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.certImageBtn = cell.rightBtn;
        [self.certImageBtn addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    else if( [key isEqualToString:@"area"] ){
        MyInfoTableViewCell * cell = (MyInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell_ID" forIndexPath:indexPath];
        cell.rightLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftLabel.text =[self.titleArray objectAtIndex:indexPath.row];
        self.areaLabel = cell.rightLabel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if( [key isEqualToString:@"sex"] ){
        MyInfoTableViewCell * cell = (MyInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell_ID" forIndexPath:indexPath];
        cell.rightLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftLabel.text =[self.titleArray objectAtIndex:indexPath.row];
        self.sexLabel = cell.rightLabel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if( [key isEqualToString:@"department"] ){
        MyInfoTableViewCell * cell = (MyInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell_ID" forIndexPath:indexPath];
        cell.rightLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftLabel.text =[self.titleArray objectAtIndex:indexPath.row];
        self.workroomLabel = cell.rightLabel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        RightTextTableViewCell *cell = ( RightTextTableViewCell * )[tableView dequeueReusableCellWithIdentifier:@"RightTextTableViewCell_ID" forIndexPath:indexPath];
        
        cell.titleLeftLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        
        cell.RighttextField.placeholder = [self.valArray objectAtIndex:indexPath.row];
        cell.RighttextField.delegate = self;
        cell.RighttextField.tag = indexPath.row;
        
//        if ( [key isEqualToString:@"phone"] || [key isEqualToString:@"verifyCode"]) {
//            //数字键盘
//            cell.RighttextField.keyboardType = UIKeyboardTypePhonePad;
//        }
        cell.RighttextField.returnKeyType = UIReturnKeyDone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ( [key isEqualToString:@"password"] ) {
            cell.RighttextField.secureTextEntry = YES;
        }
        
        if ( [key isEqualToString:@"phone"]) {
            self.phoneTextField = cell.RighttextField;
            self.phoneTextField.keyboardType =  UIKeyboardTypePhonePad;
        }else if ([key isEqualToString:@"name"]){
            self.nameTextField = cell.RighttextField;
        }
        
        return cell;
    }

}
#pragma mark - 文本框

#pragma mark - 屏幕上弹
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString * key = [self.keyArray objectAtIndex:textField.tag];
    if ( [key isEqualToString:@"address"]
        || [key isEqualToString:@"hospital"]
        || [key isEqualToString:@"alipay"]) {
        [self screanUp];
    }
}

#pragma mark -屏幕恢复
- (void)textFieldDidEndEditing:(UITextField *)textField;
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
//测试commit
    NSString * key = [self.keyArray objectAtIndex:textField.tag];
    if( [key isEqualToString:@"phone"] ){
        self.phone = textField.text;
    }
    else if( [key isEqualToString:@"name"] ){
        self.name = textField.text;
    }
    else if( [key isEqualToString:@"password"] ){
        self.password = textField.text;
    }
    else if( [key isEqualToString:@"verifyCode"] ){
        self.verifyCode = textField.text;
    }
    else if( [key isEqualToString:@"address"] ){
        self.address = textField.text;
        [self screanDown];
    }
    else if( [key isEqualToString:@"hospital"] ){
        self.hospital = textField.text;
        [self screanDown];
    }
    else if( [key isEqualToString:@"alipay"] ){
        self.alipay = textField.text;
        [self screanDown];
    }
}

-(void)screanUp
{
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}

-(void)screanDown
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
    ////////
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// called when 'return' key pressed. return NO to ignore.
{
    return [textField resignFirstResponder];
}

#pragma mark 其他
//点击获取验证码
-(void)getAuthCode{
    NSLog(@"is here getAuthCode");
    NSLog(@"self.phoneTextField.text :%@" , self.phoneTextField.text);
    if ([NSString checkTel:self.phoneTextField.text andViewController:self]) {
    [API post:@"verifycode/notokencode" Params:@{@"type":@"1",@"phone":self.phoneTextField.text} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self message:@"验证码已发送"];
        }
        else {
            [self message:[responseObject objectForKey:@"message"]];
        }
    }];
    }
}

-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}



#pragma mark - 胸卡部分代码
-(void)changeAvatar:(UIButton *) avatarView;
{
    
    //弹出框
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *cameraButtonTitle = NSLocalizedString(@"拍照", nil);
    NSString *albumButtonTitle = NSLocalizedString(@"相册", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传胸卡" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSLog(@"点击取消按钮");
    }];
    if ([[Common device] isEqualToString:@"pad"] ) {
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-50, 0, 0);
    }
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:cameraButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //选择了照相机
        [self imagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:albumButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //选择相册
        [self imagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//打开相机 或 相册
-(void)imagePicker:(NSUInteger) sourceType
{
    NSLog(@"选择了%@" , sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? @"相册" :@"相机");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
}

//选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        //切图
        UIImage * portraitImg = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        

        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width/2) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

#pragma mark -- 切图工具
-(void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)image {
    
    //将切过的图片数据
    NSData * imageData;
    //按图片类型转NSData
    NSString * imageType;
    NSString * filename;
    
    if( UIImagePNGRepresentation( image ) == nil ){
        imageType = @"image/png";
        imageData = UIImagePNGRepresentation( image ); //png
        filename = [NSString stringWithFormat:@"avatar_%f.png" , [[NSDate date] timeIntervalSince1970] * 1000 ];
        
    } else {
        imageType = @"image/jpg";
        imageData = UIImageJPEGRepresentation( image , 1); //jpg
        filename = [NSString stringWithFormat:@"avatar_%f.jpg" , [[NSDate date] timeIntervalSince1970] * 1000 ];
        
    }
    
    self.imageData = imageData;
    self.imageType = imageType;
    self.filename = filename;
    [self.certImageBtn setBackgroundImage:image forState:UIControlStateNormal];

    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        //TO DO
    }];
}

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
