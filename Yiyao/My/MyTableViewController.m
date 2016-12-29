//
//  MyTableViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/21.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MyTableViewController.h"
#import "Common.h"
@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setNavBarTitle:@"个人中心" Ctrl:self];
    //返回back  设置成返回VPImageCropperViewController.h
    [Common setNavBackBtn:self];
    
    self.navConfigs = [[NSMutableArray alloc] init];
    
    [self.navConfigs addObject:[NSArray arrayWithObjects:@"积分中心",@"我的收藏",@"索取记录",@"浏览记录", nil]];
    [self.navConfigs addObject:[NSArray arrayWithObjects:@"我的信息",@"有奖推荐",@"设置", nil]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyNavTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyNavCell_ID"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyNavHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MyNavHeaderView_ID"];

    self.jobNum = @"";
    self.department_name =@"";
    self.head_icon = @"";
    self.integral = @"";
    self.name = @"";
    self.departmentID = @"";
    self.data = [[NSDictionary alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [API get:@"member/info/personal" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * data = [responseObject objectForKey:@"data"];
        NSLog(@"data:%@" , data);
        self.jobNum = [Common getStrFromJson:data Key:@"jobNum"];
        self.department_name = [Common getStrFromJson:data Key:@"department_name"];
        self.head_icon = [Common getStrFromJson:data Key:@"head_icon"];
        self.integral = [Common getStrFromJson:data Key:@"integral"];
        self.name = [Common getStrFromJson:data Key:@"name"];
        self.departmentID = [Common getStrFromJson:data Key:@"department"];
        
        [self.tableView reloadData];
    }];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.navConfigs objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0) {
        return 107;
    } else {
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)changeAvatar:(UIImageView *) avatarView;
{
    
    //弹出框
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
  
    
    NSString *albumButtonTitle = NSLocalizedString(@"相册", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击取消按钮");
    }];
    if ([[Common device] isEqualToString:@"pad"] ) {
        alertController.popoverPresentationController.sourceView = self.tableView;
        alertController.popoverPresentationController.sourceRect = CGRectMake(50, 50, 0, 0);
        self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 100);
    }
    
    NSString *cameraButtonTitle = NSLocalizedString(@"拍照", nil);
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:cameraButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //选择了照相机
        [self imagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    alertController.view.frame = CGRectMake(0, 0, 10, 10);
    [alertController addAction:cameraAction];
    
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:albumButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //选择相册
        [self imagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    
    [alertController addAction:cancelAction];

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

#pragma mark - 图片选择
//选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self.certImageBtn setBackgroundImage:[info valueForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
        //切图
        UIImage * portraitImg = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
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
    
    //开始上传头像
    //显示进度条
    UIActivityIndicatorView * indicator = [Common getIndicator:self.view];
    [indicator startAnimating];
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置token
    [manager.requestSerializer setValue:[Common getToken] forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"mt"];
    
    [manager
     POST:[Common getApiUrl:@"member/info/headicon"]
     parameters:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         
         [formData appendPartWithFileData:imageData name:@"file" fileName:filename mimeType:imageType];
         
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [indicator stopAnimating];
         if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
             [self.avatarImageView setImage:image];
             [self message:[responseObject objectForKey:@"message"]];
             
             
             [API get:@"member/info/personal" Params:nil Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"member/info/personal : %@" , responseObject);
                 NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"]  options:0 error:nil];
                 NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict];
                 [ dict2 setObject:[[responseObject objectForKey:@"data"] objectForKey:@"head_icon"] forKey:@"head_icon"];
                 NSData *data = [NSJSONSerialization dataWithJSONObject:dict2 options:NSJSONWritingPrettyPrinted error:nil];
                 [Common setUserInfo:data];
                 
             }];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self message:@"网络错误，上传头像失败"];
         [indicator stopAnimating];
     }];
    
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


-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
}


//头部
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        MyNavHeaderView * headerView = (MyNavHeaderView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MyNavHeaderView_ID"];
        NSString * dno = [self.jobNum isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"工号: %@" , self.jobNum];
        
        //名称与工号
        [headerView setUserName:self.name AndTag:self.department_name AndNo:dno];
        
        //头像
        if ( [self.head_icon isEqualToString:@""] ) {
            [headerView setAvatar:@"test-avatar2"];
        } else {
            [headerView setAvatarFromUrl:self.head_icon];
        }
        headerView.avatarImg.userInteractionEnabled = YES;
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar:)];
        [headerView.avatarImg addGestureRecognizer:singleTap];
        self.avatarImageView = headerView.avatarImg;
        
        //签到按钮
        [API get:@"/integral/sign/todayissign" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *str = [[responseObject objectForKey:@"data"] objectForKey:@"toDayIsSign"];
        if ( str.integerValue ==  0) {
            [headerView.signBtn setTitle:@"签到" forState:UIControlStateNormal];
            [headerView.signBtn addTarget:self action:@selector(submitSign:) forControlEvents:UIControlEventTouchDown];
        } else {
            [headerView.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [headerView.signBtn addTarget:self action:@selector(tipsSigned) forControlEvents:UIControlEventTouchDown];
        }
        }];
        
        return headerView;
    } else {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.layer.frame.size.width, 10)];
        [view setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
        return view;
    }
}
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * cfgs = [self.navConfigs objectAtIndex:indexPath.section];
    NSString * title = [cfgs objectAtIndex:indexPath.row];
    
    MyNavTableViewCell *cell = (MyNavTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"MyNavCell_ID" forIndexPath:indexPath];
    
    [cell resetTitle:title AndRight:( [title isEqualToString:@"积分中心"] ? self.integral:@"" )];
   
    
    return cell;
}

/**
 * 点击浏览记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && ( indexPath.row == 0) ) {
        [API get:@"integral/flow/member/1/10" Params:@{@"collectionType":@"3"} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@" , responseObject);
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                self.data = [responseObject objectForKey:@"data"];
                //积分中心
                [self performSegueWithIdentifier:@"to_credit_Segue" sender:self];
            }
        }];
    }
    else if( indexPath.section == 0 && ( indexPath.row == 1) )
    {
        [API get:@"member/collection/member/1/10" Params:@{@"collectionType":@"3"} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@" , responseObject);
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                self.data = [responseObject objectForKey:@"data"];
                //我的收藏
                [self performSegueWithIdentifier:@"to_fav_Segue" sender:self];
            }
        }];

    }
    else if( indexPath.section == 0 && (indexPath.row == 2) )
    {
        //索取记录
        [self  performSegueWithIdentifier:@"to_got_Segue" sender:self];
    }
    else if( indexPath.section == 0 && (indexPath.row == 3) )
    {
        [API get:@"record/file/member/1/10"
            Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@" , responseObject);
                if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                    self.data = [responseObject objectForKey:@"data"];
                    //浏览记录
                    [self  performSegueWithIdentifier:@"to_browsed_Segue" sender:self];
                }
            }];
    }
    else if( indexPath.section == 1 && (indexPath.row == 0) ){
        //我的信息

        [API get:@"member/info/detail" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] ) {
                self.data = [responseObject objectForKey:@"data"];
                [self  performSegueWithIdentifier:@"to_myinfo_Segue" sender:self];
            }
        }];
    }
    else if( indexPath.section == 1 && ( indexPath.row == 1 ) ){
        //有奖推荐
        [self performSegueWithIdentifier:@"to_qcode" sender:self];
    }
    else if( indexPath.section == 1 && ( indexPath.row == 2) ){
        //设置
        [self performSegueWithIdentifier:@"to_setting_Segue" sender:self];
    }
    //点击后取消
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

/**
 *分割线
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row %li" , (long)indexPath.row);
    //如果是最后一条信息，则不显示分割线
    if ( (indexPath.section == 1) && ( indexPath.row >= 2 ) ) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 400, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    } else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"to_myinfo_Segue"] ) {
        //我的信息
        MyInfoTableViewController * view = [segue destinationViewController];
        view.data = self.data;
    }
    else if( [segue.identifier isEqualToString:@"to_fav_Segue"] ) {
        //我的收藏
        MyFavTableViewController * view = [segue destinationViewController];
        view.data = (NSArray *) self.data;
        view.tabsIndex = 0;
    }
    else if( [segue.identifier isEqualToString:@"to_credit_Segue"] ) {
        //积分中心
        CreditTableViewController * view = [segue destinationViewController];
        view.fen = self.integral;
    }
    
    
        
}

//签到
-(void)submitSign:(UIButton *) btn
{
    if ( [btn.titleLabel.text isEqualToString:@"签到"] ) {
        [btn setTitle:@"已签到" forState:UIControlStateNormal];
        [API post:@"integral/sign/sign" Params:nil Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@" , responseObject);
            
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
                //签到成功
                [Common setSign];
            }
        }];
    }
}

-(void)tipsSigned
{
    [self message:@"今日已签到"];
}
@end
