//
//  GetCreditTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "GetCreditTableViewController.h"

@interface GetCreditTableViewController ()

@end

@implementation GetCreditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setNavBarTitle:@"积分提现" Ctrl:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightTextTableViewCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInfoTableViewCell_ID"];
    
    [self addRegBtn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.layer.frame.size.width, 2)];
    [view setBackgroundColor:UIColorFromRGB(FooterBorderColor)];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.row == 0 ) {
        RightTextTableViewCell * cell = (RightTextTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RightTextTableViewCell_ID" forIndexPath:indexPath];
        cell.RighttextField.placeholder = @"请输入要提现的积分";
        cell.titleLeftLabel.text = @"提取积分";
        self.textField = cell.RighttextField;
        self.textField.delegate = self;
        return cell;
    } else {
        MyInfoTableViewCell * cell = (MyInfoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell_ID" forIndexPath:indexPath];
        cell.rightLabel.text = @"";
        cell.leftLabel.text = [NSString stringWithFormat:@"%@积分可以换成%@元人民币" , [self.data objectForKey:@"changeCount"] ,[self.data objectForKey:@"changeMonery"]];
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"is here");
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 提交按钮
-(void)addRegBtn{
    
    //Add a container view as self.view and the superview of the tableview
    UITableView *tableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    tableView.frame = tableView.bounds;
    self.view = containerView;
    [containerView addSubview:tableView];
    
    
    CGFloat y = self.view.layer.frame.size.height - 50;
    
    UIButton * regBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, self.view.layer.frame.size.width, 50)];
    [regBtn.titleLabel setText:@"提交"];
    [regBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [regBtn setBackgroundColor:UIColorFromRGB(0x3786c7)];
    [regBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    
    NSLog(@"%f,%f,%f,%f" , 0.0 , y , self.view.layer.frame.size.width, 50.0);
    
    [self.view addSubview:regBtn];
    
    [regBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
}

//提交
-(void)submit
{
    NSString * applyIntegral = self.textField.text;
    if( [applyIntegral integerValue] <= 0 )
    {
        [self message:@"请正确输入提现积分数"];
    }
    else
    {
        [API post:@"integral/cashpost/apply" Params:@{@"applyIntegral":applyIntegral} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }];
    }
}

-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}

@end
