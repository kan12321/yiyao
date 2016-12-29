//
//  MyInfoTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/2.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyInfoTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyInfoTableViewController ()

@end

@implementation MyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:self.title Ctrl:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self registerNib];
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"手机号码",@"姓名",@"性别",@"地区",@"地址",@"医院",@"科室",@"支付宝账号",@"胸卡",nil];
    
    self.keyArray = [[NSMutableArray alloc] initWithObjects:@"mobile",@"username",@"sex",@"area",@"address",@"hospital",@"workroom",@"alipay",@"cart",nil];
    NSLog(@"data:%@" , self.data);
    NSString * area = [NSString stringWithFormat:@"%@|%@" , [Common getStrFromJson:self.data Key:@"province"] , [Common getStrFromJson:self.data Key:@"city"] ];
    NSString * sex = [[Common getStrFromJson:self.data Key:@"sex"] isEqualToString:@"1"] ? @"男" : @"女";
    self.valArray = [[NSMutableArray alloc]
                     initWithObjects:
                     [Common getStrFromJson:self.data Key:@"phone"],
                     [self.data objectForKey:@"name"],
                     sex,
                     area,
                     [Common getStrFromJson:self.data Key:@"address"],
                     [Common getStrFromJson:self.data Key:@"hospital"],
                     [Common getStrFromJson:self.data Key:@"department_name"],
                     [Common getStrFromJson:self.data Key:@"alipay"],
                     [Common getStrFromJson:self.data Key:@"photo"] //图片
                     ,nil];
}

-(void)registerNib{

    [self.tableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInfoTableViewCell_ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAreaTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAreaTableViewCell_ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCardTableViewCell_ID"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout{
    NSLog(@"注销用户");
}


#pragma mark - Table layout

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = [self.keyArray objectAtIndex:indexPath.row];
    if ( [key isEqualToString:@"cart"]) {
        return 76;
    } else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * key = [self.keyArray objectAtIndex:indexPath.row];
    NSString * right = [self.titleArray objectAtIndex:indexPath.row];
    NSString * val = [self.valArray objectAtIndex:indexPath.row];

    NSLog(@"key:%@" , key);
    NSLog(@"right:%@" , right);
    NSLog(@"val:%@" , val);

    
    if ( [key isEqualToString:@"cart"]) {
        MyCardTableViewCell * cell = (MyCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCardTableViewCell_ID" forIndexPath:indexPath];

        [cell.cartImage sd_setImageWithURL: [[NSURL alloc] initWithString:val]];
        [cell startCartImage];
        
        return cell;
    }
    else if( [key isEqualToString:@"area"] ){
        MyAreaTableViewCell * cell = (MyAreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyAreaTableViewCell_ID" forIndexPath:indexPath];
        
        /**@todo 测试用｜分割**/
        NSArray * areaArray = [val componentsSeparatedByString:@"|"];
        NSLog(@"%@ , %@" , [areaArray objectAtIndex:0] , [areaArray objectAtIndex:1] );
        
        
        [cell setProvince:[areaArray objectAtIndex:0] City:[areaArray objectAtIndex:1]];
        
        return cell;
    }
    else {
        MyInfoTableViewCell * cell = (MyInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell_ID" forIndexPath:indexPath];
        [cell setLeft:right Right:val];
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

@end
