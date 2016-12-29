//
//  MeetingViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/29.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "MeetingViewController.h"

@interface MeetingViewController ()

@end

@implementation MeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setNavBarTitle:@"会议详情" Ctrl:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    //判断url是否带domian
    if( [self.url rangeOfString:@"http://"].location == NSNotFound )
    {
        self.url = [NSString stringWithFormat:@"%s%@" , API_DOMAIN , self.url];
    }
    
    //显示WebView
    NSURL* url = [[NSURL alloc] initWithString:self.url];
    NSLog(@"self.url %@" , self.url);
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:request];
//  self.webView.delegate = self;
    
    self.webView.scalesPageToFit = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.hidden = NO;
    [self.webView.scrollView setScrollEnabled:YES];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    //NSArray * type = @[@"-1",@"2",@"3",@"1"];
    NSDictionary * tips = @{@"1":@"预约会议",@"2":@"会议已取消"};
    NSDictionary * tipsYiyue = @{@"2":@"已预约",@"3":@"正在审核中",@"1":@"预约申请被驳回"};
    
    
    if ( self.isYuYue ) {
        [self.bottomBtn setTitle:[tipsYiyue objectForKey:self.type] forState:UIControlStateNormal];
    } else {
        [self.bottomBtn setTitle:[tips objectForKey:self.type] forState:UIControlStateNormal];
    }
    
    [self.tabBarController.tabBar setHidden:YES];
    if( self.isYuYue == NO && [self.type isEqualToString:@"1"] ) {
        [self.bottomBtn addTarget:self action:@selector(addYuyue) forControlEvents:UIControlEventTouchDown];
    }
}

//添加预约
-(void)addYuyue
{
    NSLog(@"is addYuyue");
    [API post:@"meeting/meetingreservation/add" Params:@{@"meetingId":self.mid,@"token":[Common getToken]} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self.bottomBtn setTitle:@"等待处理中" forState:UIControlStateNormal];
        }
        [self message:[responseObject objectForKey:@"message"]];
    }];
}


-(void)message:(NSString *) msg {
    self.alertView = [Common ALertInfo:msg];
    [self.alertView show];
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
