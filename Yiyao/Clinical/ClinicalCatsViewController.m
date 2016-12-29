//
//  ClinicalCatsViewController.m
//  Yiyao
//
//  Created by matthew.rod on 16/8/18.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import "ClinicalCatsViewController.h"

@interface ClinicalCatsViewController ()
{
    NSMutableDictionary *_departmentDictionary;
}
@end

@implementation ClinicalCatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //navi
    [Common setNavBarTitle:@"临床" Ctrl:self];
    [Common setNavBackBtn:self];
    _departmentDictionary = [[NSMutableDictionary alloc] init];
    self.nextList = [[NSArray alloc] init];
   

}

- (void)viewWillAppear:(BOOL)animated
{
    self.wordsArray = [[NSMutableArray alloc] init];
    //同步获取科室
    [API get:@"department/all" Resp:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary * room in responseObject) {
            
            NSLog(@"%@>>%@" , [room objectForKey:@"department_name"] , [room objectForKey:@"department_id"]);
            
            [_departmentDictionary setValue:[room objectForKey:@"department_id"] forKey:[room objectForKey:@"department_name"]];
            [self.wordsArray addObject:[room objectForKey:@"department_name"]];
        }
        
        [self showCatsBtns];
    }];
    self.tabBarController.tabBar.hidden = NO;
    //返回按钮设置
    [Common setNavBackBtn:self];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[Common device]isEqualToString:@"pad"]) {
        _bannerImageView.transform = CGAffineTransformMakeScale(1, 2);
        _bannerImageView.transform = CGAffineTransformTranslate(_bannerImageView.transform, 0, 20);
        _label.transform = CGAffineTransformMakeTranslation(0, 40);
        _otherLabel.transform = CGAffineTransformMakeTranslation(0,80);
        _btnsBgView.transform = CGAffineTransformMakeTranslation(0, 90);
    }else if ([[Common device]isEqualToString:@"iphone6p"]) {
        _bannerImageView.transform = CGAffineTransformMakeScale(1, 1.5);
        _bannerImageView.transform = CGAffineTransformTranslate(_bannerImageView.transform, 0, 13);
        _label.transform = CGAffineTransformMakeTranslation(0, 20);
        _otherLabel.transform = CGAffineTransformMakeTranslation(0,40);
        _btnsBgView.transform = CGAffineTransformMakeTranslation(0, 50);
    }
    
}


-(void)showCatsBtns{
    /**
     * 显示热门搜索关键词,固定每行4个
     */
    NSArray * hotWordsArray = self.wordsArray;
    
    int lineMaxBtnBums = 5;//一行最多6个按钮
    int bntOffsetX = 0 ; //
    int bntOffsetY = 0;
    int fixSpace = SCREEN_WIDTH > 320 ? 15 : 10 ; //推荐按钮间距
    //  int btnPaddingHori = 5;//按钮左右padding
    //最大宽度由autoLayout控制
    int maxWidth = self.view.layer.frame.size.width - 20;
    
//    NSLog(@"self.view.layer.frame.size.width :%f" , self.view.layer.frame.size.width);
//    NSLog(@"self.btnsBgView.layer.frame.size.width :%f" , self.btnsBgView.layer.frame.size.width);

//    NSLog(@"self.btnsBgView.layer.bounds.size.width :%i" , maxWidth);
    //圆角
    int cornerRadius = SCREEN_WIDTH > 320 ? 15 : 13;
    int fontSize = SCREEN_WIDTH > 320 ? 15 : 13;
    int lineSpace = SCREEN_WIDTH > 320 ? 15 : 10;
    
    WordLayout * wordLayout = [[WordLayout alloc]
                               initWithStartX:bntOffsetX
                               StartY:bntOffsetY
                               LineSapce:lineSpace
                               LineHeight:30
                               MaxWidth:maxWidth
                               CornerRadius:cornerRadius
                               MaxLineWordNums:lineMaxBtnBums
                               MinFixSpace:fixSpace
                               FontSize:fontSize
                               WordsArray:hotWordsArray];
//    NSLog(@"显示每个的元素X坐标: %@" ,wordLayout.XArray);
//    NSLog(@"显示每个的元素W宽度: %@" ,wordLayout.widthArray);
//    NSLog(@"显示每个的元素Y坐标: %@" ,wordLayout.YArray);
//    
    int index = 0;
    for( NSString * hotWord in hotWordsArray)
    {
        int x = (int)[[wordLayout.XArray objectAtIndex:index] integerValue];
        int y = (int)[[wordLayout.YArray objectAtIndex:index] integerValue];
        int w = (int)[[wordLayout.widthArray objectAtIndex:index] integerValue];
//        if(index == ([hotWordsArray count] -1 ) )
//        {
//            //该视图中，最后一个按钮修正使用正常间距，不需要两边对齐,修正X值
//            x = (int)(
//                [[wordLayout.XArray objectAtIndex:(index-1)] integerValue]
//                +
//                [[wordLayout.widthArray objectAtIndex:index] integerValue]
//                +
//                fixSpace);
//        }
        //按宽度生存按钮
        UIButton * qButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y , w , 30)];
        qButton.tag = [[_departmentDictionary objectForKey:hotWord] integerValue];
        NSLog(@"set tag:%ld , val:%i , str:%@" , (long)qButton.tag , (int)[_departmentDictionary objectForKey:hotWord],[_departmentDictionary objectForKey:hotWord]);
        
        [qButton setTitle:hotWord forState:UIControlStateNormal];
        qButton.titleLabel.font = [UIFont systemFontOfSize: fontSize];
        [qButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        qButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
        qButton.layer.cornerRadius = 15;
        
        [self.btnsBgView addSubview:qButton];
        
        [qButton addTarget:self action:@selector(showClinical:) forControlEvents:UIControlEventTouchDown];
        
        index++;
    }
}

//@todo api 调试错误Request failed: not found (404)
-(void)showClinical:(UIButton *) qButton{
    self.buttonTag = qButton.tag;
    [self performSegueWithIdentifier:@"showClinical" sender:self];
    self.tabBarController.tabBar.hidden = YES;
    //跳转
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CatDocsListTableViewController * view = [segue destinationViewController];
    view.titleString = [(UIButton *)[self.view viewWithTag:_buttonTag] currentTitle];
    view.cid = [NSString stringWithFormat:@"%ld",_buttonTag ];
    
    
}

@end
