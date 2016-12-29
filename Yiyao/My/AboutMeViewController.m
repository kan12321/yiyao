//
//  AboutMeViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/9/30.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [Common setNavBarTitle:self.title Ctrl:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString * urlSting  = [NSString stringWithFormat:@"%s%@" , API_DOMAIN , @"/app/aboutus"];
    NSURL* url = [[NSURL alloc] initWithString:urlSting];
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
    [self.webView.scrollView setScrollEnabled:YES];
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
