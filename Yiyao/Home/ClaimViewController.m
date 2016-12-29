//
//  ClaimViewController.m
//  Yiyao
//
//  Created by tobo on 16/9/30.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "ClaimViewController.h"
#import "YYTextView.h"
#import "API.h"
#import "NSString+Common.h"
@interface ClaimViewController ()<UITextViewDelegate, UITextFieldDelegate>
{
    CGFloat _lastViewY;
    YYTextView *_textView;
    UIButton *_button;
}
@end

@implementation ClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self regsiterNib];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self createButton];
    [Common setNavBarTitle:@"索取资料" Ctrl:self];
    // Do any additional setup after loading the view.
}

-(void)regsiterNib{
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightTextTableViewCell_ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextAreaTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextAreaTableViewCell_ID"];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        RightTextTableViewCell *cell = ( RightTextTableViewCell * )[tableView dequeueReusableCellWithIdentifier:@"RightTextTableViewCell_ID" forIndexPath:indexPath];
        cell.titleLeftLabel.text = @"邮箱";
        cell.RighttextField.placeholder = @"请输入邮箱";
        cell.RighttextField.delegate = self;
        cell.RighttextField.tag = indexPath.row;
        cell.RighttextField.returnKeyType = UIReturnKeyDone;
        self.emailTextField = cell.RighttextField;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if( indexPath.row == 1 )
    {
        RightTextTableViewCell *cell = ( RightTextTableViewCell * )[tableView dequeueReusableCellWithIdentifier:@"RightTextTableViewCell_ID" forIndexPath:indexPath];
        cell.titleLeftLabel.text = @"手机号码";
        cell.RighttextField.placeholder = @"请输入手机号码";
        cell.RighttextField.delegate = self;
        cell.RighttextField.tag = indexPath.row;
        cell.RighttextField.returnKeyType = UIReturnKeyDone;
        self.phoneTextField = cell.RighttextField;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        TextAreaTableViewCell *cell = ( TextAreaTableViewCell * )[tableView dequeueReusableCellWithIdentifier:@"TextAreaTableViewCell_ID" forIndexPath:indexPath];
        //添加YYTextView
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(8, 35, cell.layer.frame.size.width-12-12 , 100)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.placeholder = @"请输入内容";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        [cell addSubview:_textView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 2) {
        return 150;
    } else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)createButton{
    //Add a container view as self.view and the superview of the tableview
    UITableView *tableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    tableView.frame = tableView.bounds;
    self.view = containerView;
    [containerView addSubview:tableView];
    
    
    CGFloat y = SCREEN_HEIGHT - 50;
    
    UIButton * regBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, self.view.layer.frame.size.width, 50)];
    [regBtn.titleLabel setText:@"提交"];
    [regBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [regBtn setBackgroundColor:UIColorFromRGB(0x3786c7)];
    [regBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [self.view addSubview:regBtn];
    
    [regBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchDown];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)buttonAction{
    UITextField *mailText = self.emailTextField;
    UITextField *phoneText = self.phoneTextField;
    if (![NSString checkTel:phoneText.text andViewController:self]) {
        return;
    }
    if (_textView.text.length == 0 || mailText.text.length == 0) {
        return;
    }
    
    [API post:@"data/infoapply/add" Params:@{@"medicinesId":_Id,
                                             @"phone":phoneText.text,
                                             @"email":mailText.text,
                                             @"details":_textView.text}
         Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"%@",[responseObject objectForKey:@"status"]);
             if ([[responseObject objectForKey:@"status"] isEqualToString:@"ERROR"]) {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:[responseObject objectForKey:@"message"] message:@"重新填写" preferredStyle:UIAlertControllerStyleAlert];
                 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 }]];
                 
                 [self presentViewController:alert animated:YES completion:^{
                     
                 }];

                 return ;
             }
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:[responseObject objectForKey:@"message"] message:@"返回上一页" preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
             }]];
             
             [self presentViewController:alert animated:YES completion:^{
                 
             }];
         }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_textView resignFirstResponder];
    UITextField *mailText = (UITextField *)[self.view viewWithTag:10];
    UITextField *phoneText = (UITextField *)[self.view viewWithTag:11];
    [mailText resignFirstResponder];
    [phoneText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
