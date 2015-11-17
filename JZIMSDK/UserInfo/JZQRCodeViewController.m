//
//  JZQRCodeViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/10/8.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZQRCodeViewController.h"
#import "PlayerMoudle.h"
#import "UIView+MJExtension.h"

@interface JZQRCodeViewController ()
{
    UIView *_bgView;
}

@end

@implementation JZQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGCOLOR;
    self.title = @"我的二维码";
    [self createQrCodeView];
}

- (void)createQrCodeView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, SCREENFRAME_SIZE_WIDTH - 40, self.view.frame.size.height-120-64)];
    _bgView.layer.cornerRadius = 5;
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    
    [self.view addSubview:_bgView];
    
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    avatarView.backgroundColor = [UIColor clearColor];
    avatarView.layer.cornerRadius = 5;
    avatarView.image = [UIImage imageNamed:@"user"];
    [_bgView addSubview:avatarView];
    
    UIFont *nickNameFont = [UIFont fontWithName:@"Arial" size:20];
    
    CGSize size = CGSizeMake(_bgView.mj_w-70-25, 30);
    
    UILabel *nickName = [[UILabel alloc] init];
    nickName.font = nickNameFont;
    nickName.numberOfLines = 1;
    nickName.text = self.playerMoudle.playerNickName;
    CGSize currentSize = [nickName.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:nickNameFont,NSFontAttributeName, nil] context:nil].size;
    nickName.frame = CGRectMake(70, 15, currentSize.width, currentSize.height);
    [_bgView addSubview:nickName];
    
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nickName.mj_x+nickName.mj_w+5, nickName.mj_y, 25, 25)];
    sexImageView.backgroundColor = [UIColor clearColor];
    sexImageView.image = [UIImage imageNamed:@"user"];
    [_bgView addSubview:sexImageView];
    
    UILabel *postionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,nickName.mj_y+nickName.mj_h+5,_bgView.mj_w-75,20)];
    postionLabel.backgroundColor = _bgView.backgroundColor;
    postionLabel.font = [UIFont fontWithName:@"Arial" size:14];
    postionLabel.textAlignment = NSTextAlignmentLeft;
    postionLabel.text = self.playerMoudle.playerDescription;
    postionLabel.textColor = [UIColor lightGrayColor];
    
    [_bgView addSubview:postionLabel];
    
    UIImageView *qrCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 80+(_bgView.mj_h-_bgView.mj_w)/2-45, _bgView.mj_w-30,_bgView.mj_w-30)];
    qrCodeView.backgroundColor = [UIColor clearColor];
    qrCodeView.image = [UIImage imageNamed:@"user"];
    [_bgView addSubview:qrCodeView];

    UILabel *mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,_bgView.mj_h-35,_bgView.mj_w-30,20)];
    mentionLabel.backgroundColor = _bgView.backgroundColor;
    mentionLabel.font = [UIFont fontWithName:@"Arial" size:14];
    mentionLabel.text = @"扫一扫上面的二维码图案，加我微信";
    mentionLabel.textAlignment = NSTextAlignmentCenter;
    mentionLabel.textColor = [UIColor lightGrayColor];
    [_bgView addSubview:mentionLabel];
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
