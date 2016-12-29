//
//  BannerHtmlViewController.m
//  Yiyao
//
//  Created by tobo on 16/9/28.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "BannerHtmlViewController.h"
#import "UMSocialUIManager.h"
#import "API.h"
#import "Common.h"
#import <UMSocialCore/UMSocialCore.h>
@interface BannerHtmlViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation BannerHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNava];
    // Do any additional setup after loading the view.
}

- (void)createNava{
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemAction)];
    button.title = @"分享";
    self.navigationItem.rightBarButtonItem = button;
    
   }

- (void)buttonItemAction
{
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        [weakSelf shareDataWithPlatform:platformType];
    }];
    
    
    
}


- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_model.title descr:self.title thumImage:_model.fileUrl];
    //设置网页地址
    shareObject.webpageUrl = _model.htmlUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform: platformType
                                        messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                                            if (error) {
                                                NSLog(@"************Share fail with error %@*********",error);
                                            }else{
                                                
                                                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                    NSLog(@"%@",[Common getUserInfo:@"id"]);
                                                    [API  get:[NSString stringWithFormat:@"recommend/record/share?memberid=%@",[Common getUserInfo:@"id"] ] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        NSLog(@"分享%@",[responseObject objectForKey:@"data"]);
                                                    }];
                                                }else{
                                                    NSLog(@"response data is %@",data);
                                                }
                                            }
                                            
                                        }];
//    [UMSocialShareResponse shareResponseWithMessage:<#(NSString *)#>]
    
}
//- (void)alertWithError:(NSError *)error
//{
//    NSString *result = nil;
//    if (!error) {
//        result = [NSString stringWithFormat:@"Share succeed"];
//    }
//    else{
//        if (error) {
//            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
//        }
//        else{
//            result = [NSString stringWithFormat:@"Share fail"];
//        }
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
//                                                    message:result
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
//                                          otherButtonTitles:nil];
//    [alert show];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(BannerModel *)model{
    _model = model;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIWebView * view = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.htmlUrl]]];
    view.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:view];

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
