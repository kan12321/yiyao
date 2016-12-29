//
//  QcodeViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/30.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "QcodeViewController.h"
#import "UMSocialUIManager.h"
#import <AFHTTPSessionManager.h>
@interface QcodeViewController ()
{
    NSString *_url;
}
@end

@implementation QcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [Common setNavBarTitle:self.title Ctrl:self];
    [self createNava];
}
- (void)createNava
{
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
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"药点在线" descr:@"有奖推荐" thumImage:[UIImage imageNamed:@"default"]];
    //设置网页地址
    shareObject.webpageUrl = _url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform: platformType
                                        messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                                            if (error) {
                                                NSLog(@"************Share fail with error %@*********",error);
                                            }else{
                                                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                    [API  get:[NSString stringWithFormat:@"recommend/record/share?memberid=%@",[Common getUserInfo:@"id"] ] Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        NSLog(@"分享%@",[responseObject objectForKey:@"data"]);
                                                    }];
                                                    
                                                }else{
                                                    NSLog(@"response data is %@",data);
                                                }
                                            }
                                            
                                        }];
    
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    NSString * urlSting  = [NSString stringWithFormat:@"%s%@" , API_DOMAIN , @"/recommend/record/qrcode"];
    
    NSURL* url = [[NSURL alloc] initWithString:urlSting];
    _url = urlSting;
    NSLog(@"request:url %@" , url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:[Common getToken] forHTTPHeaderField:@"token"];
    [mutableRequest addValue:@"1" forHTTPHeaderField:@"mt"];
   
    [self.webView loadRequest:[mutableRequest copy]];
    //  self.webView.delegate = self;
    
    self.webView.scalesPageToFit = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.hidden = NO;
    [self.webView.scrollView setScrollEnabled:NO];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
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
