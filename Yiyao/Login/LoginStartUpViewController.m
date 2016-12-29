//
//  LoginStartUpViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/4.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "LoginStartUpViewController.h"

@interface LoginStartUpViewController ()

@end

@implementation LoginStartUpViewController

/**
 * 正确隐藏导航栏
 */
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [Common setNavBackBtn:self];
    [super viewWillAppear:animated];
    
    [self.searchTextField resignFirstResponder];
    
    self.sData = [[NSDictionary alloc] init];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Common setBarTitle:@"返回" andUiViewController:self];
    //设置按钮圆角的半径
    self.LoginBtn.layer.cornerRadius = 10.0;
    self.RegBtn.layer.cornerRadius = 10.0;
    
    //登录按钮设置边框
    self.LoginBtn.layer.borderColor = [UIColorFromRGB(0x3786c7) CGColor];
    self.LoginBtn.layer.borderWidth = 1.0;
    
    //设置搜索框的icon
    UIImageView * searchTxtRightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    UIView * searchTxtRightRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, 40)];
    [searchTxtRightImage setFrame:CGRectMake(7, 12, 15, 15)];
    [searchTxtRightRightView addSubview:searchTxtRightImage];
    
    self.searchTextField.leftView = searchTxtRightRightView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //设置搜索框的边框为0
    self.searchTextField.layer.borderWidth = 0;
    //设置Placeholder 与 颜色
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索说明书" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xa3a3a3)}];

    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    
    
    //清除token
    
    [Common setToken:@""];
    [Common setUserInfo:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    
    if( textField.text.length > 0 )
    {
        [self searchText:textField.text];
    }
    return YES;
}

-(void)hotWordSearch:(UIButton *) button
{
    [self searchText:button.titleLabel.text];
}

-(void)searchText:(NSString *) text
{
    [API post:@"medicines/search/1/10" Params:@{@"searchContent":text} Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        if( [[responseObject objectForKey:@"status"] isEqualToString:@"OK"] )
        {
            self.searchWord = text;
            self.sData = (NSDictionary * ) [responseObject objectForKey:@"data"];
            [self performSegueWithIdentifier:@"to_search_Segue" sender:self];
        }
    }];

}

-(void)viewDidAppear:(BOOL)animated
{
    /**
     * 显示热门搜索关键词,固定每行4个
     */
    NSArray * hotWordsArray = @[@"学术资料查询" , @"会议查询" , @"临床资料" , @"积分兑换" , @"药品说明书" ,  @"文献索取" , @"书籍查询",@"企业资料"];
    
    int lineMaxBtnBums = 6;//一行最多6个按钮
    int bntOffsetX = 0 ; //
    int bntOffsetY = 0;
    int fixSpace = SCREEN_WIDTH > 320 ? 20 : 15 ; //推荐按钮间距
    if([[Common device]isEqualToString:@"pad"]){
        fixSpace = 100;
    }
//  int btnPaddingHori = 5;//按钮左右padding
    //最大宽度由autoLayout控制
    int maxWidth = self.hotWordView.layer.bounds.size.width;
    int fontSize = SCREEN_WIDTH > 320 ? 14 : 12;
    int lineSpace = SCREEN_WIDTH > 320 ? 18 : 12;

    
    WordLayout * wordLayout = [[WordLayout alloc]
        initWithStartX:bntOffsetX
                StartY:bntOffsetY
             LineSapce:lineSpace
            LineHeight:15
              MaxWidth:maxWidth
          CornerRadius:0    //无圆角
       MaxLineWordNums:lineMaxBtnBums
           MinFixSpace:fixSpace
              FontSize:fontSize
            WordsArray:hotWordsArray];
    
    NSLog(@"显示每个的元素X坐标: %@" ,wordLayout.XArray);
    NSLog(@"显示每个的元素Y坐标: %@" ,wordLayout.YArray);
    
    int index = 0;
    for( NSString * hotWord in hotWordsArray)
    {
        int x = (int)[[wordLayout.XArray objectAtIndex:index] integerValue];
        int y = (int)[[wordLayout.YArray objectAtIndex:index] integerValue];
        int w = (int)[[wordLayout.widthArray objectAtIndex:index] integerValue];
        //按宽度生存按钮
        UIButton * qButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y , w , 15)];
        [qButton setTitle:hotWord forState:UIControlStateNormal];
        qButton.titleLabel.font = [UIFont systemFontOfSize: fontSize];
        [qButton setTitleColor:[[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
//        [qButton addTarget:self action:@selector(hotWordSearch:) forControlEvents:UIControlEventTouchDown];
        qButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.hotWordView addSubview:qButton];
        
        index++;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"to_search_Segue"] ) {
        SearchResultTableViewController * view = (SearchResultTableViewController *)[ segue destinationViewController];
        view.sData = self.sData;
        view.preSearchWord = self.searchWord;
    }
}

@end
