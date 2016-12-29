//
//  RightBtnAndTextTableViewCell.h
//  Yiyao
//
//  Created by matthew.rod on 16/9/3.
//  Copyright © 2016年 Yiyao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightBtnAndTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UIButton *authcodeBtn;
-(void)startUp;
@end
