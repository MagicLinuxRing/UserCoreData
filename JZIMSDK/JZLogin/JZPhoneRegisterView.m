//
//  JZPhoneRegisterView.m
//  JZIMSDK
//
//  Created by king jack on 15/9/24.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZPhoneRegisterView.h"
#import "JZTextFiled.h"
#import "UIView+MJExtension.h"
#import "UIColor+Custom.h"
#import "JZIMLoginView.h"

@interface JZPhoneRegisterView()<UITextFieldDelegate>
{
    UIImageView *_mainGrayBg;
    UITextField *_accountField;
    UIView      *_menuView;
    UIButton    *_phoneRegisterButton;
    UILabel     *_titleLabel;
}

@property(nonatomic,retain)UIColor *typeColor;

@end

@implementation JZPhoneRegisterView

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)titleName bgColor:(UIColor *)typeColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.typeColor = typeColor;
        [self createContentView];
        _titleLabel.text = titleName;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _mainGrayBg.frame = CGRectMake(0, 0, SCREENFRAME_SIZE_WIDTH,SCREENFRAME_SIZE_HEIGHT);
    _menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT-230)/2-20, SCREENFRAME_SIZE_WIDTH-40, 230);
    _titleLabel.frame = CGRectMake(0, 0, _menuView.frame.size.width, 40);
    _accountField.frame = CGRectMake(20, 90, _menuView.mj_w-40, 40);
    _phoneRegisterButton.frame = CGRectMake(20, 140, _menuView.mj_w-40, 40);
}

- (void)createContentView
{
    _mainGrayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENFRAME_SIZE_WIDTH,SCREENFRAME_SIZE_HEIGHT)];
    _mainGrayBg.backgroundColor = [UIColor lightGrayColor];
    _mainGrayBg.alpha = 0;
    [_mainGrayBg  setUserInteractionEnabled:YES];
    [self addSubview:_mainGrayBg];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnClick:)];
    tapGR.numberOfTapsRequired = 1;
    [_mainGrayBg  addGestureRecognizer:tapGR];
    
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREENFRAME_SIZE_HEIGHT, SCREENFRAME_SIZE_WIDTH-40, 230)];
    _menuView.userInteractionEnabled = YES;
    _menuView.layer.cornerRadius = 10;
    _menuView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.4 animations:^{
        _menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT - 230)/2-20, SCREENFRAME_SIZE_WIDTH-40, 230);
        _mainGrayBg.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
    [self addSubview:_menuView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _menuView.frame.size.width, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = self.typeColor;
    [_menuView addSubview:_titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 10, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(normalRegister) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [_menuView addSubview:backButton];
    
    UILabel *mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, _menuView.mj_w-20, 20)];
    mentionLabel.textColor = [UIColor lightGrayColor];
    mentionLabel.textAlignment = NSTextAlignmentLeft;
    mentionLabel.font = [UIFont boldSystemFontOfSize:16];
    mentionLabel.text = @"使用手机号注册安全性高且方便记忆";
    [_menuView addSubview:mentionLabel];
    
    _accountField = [[JZTextFiled alloc] initWithFrame:CGRectMake(20, 80, _menuView.mj_w-40, 40) titleName:@" 手机号: "];
    _accountField.placeholder = @"普通账号/手机号";
    _accountField.delegate = self;
    [_menuView addSubview:_accountField];
    
    _phoneRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneRegisterButton.frame = CGRectMake(20, 140, _menuView.mj_w-40, 40);
    _phoneRegisterButton.layer.cornerRadius = 5;
    [_phoneRegisterButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_phoneRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_phoneRegisterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_phoneRegisterButton addTarget:self action:@selector(registerPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    _phoneRegisterButton.backgroundColor = self.typeColor;
    [_menuView addSubview:_phoneRegisterButton];
    
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _menuView.mj_h-30, 110, 20)];
    lastLabel.textColor = [UIColor lightGrayColor];
    lastLabel.font = [UIFont fontWithName:@"Arail" size:16];
    lastLabel.text = @"你也可以选择";
    [_menuView addSubview:lastLabel];
    
    UIButton *normalRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    normalRegisterButton.frame = CGRectMake(120 ,_menuView.mj_h-30, 110, 20);
    normalRegisterButton.backgroundColor = [UIColor clearColor];
    [normalRegisterButton setTitle:@"普通账号注册" forState:UIControlStateNormal];
    [normalRegisterButton setTitleColor:[UIColor colorWithHexString:@"0x45B6F6"] forState:UIControlStateNormal];
    [normalRegisterButton  setTitleColor:self.typeColor forState:UIControlStateHighlighted];
    [normalRegisterButton addTarget:self action:@selector(normalRegister) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:normalRegisterButton];

}

- (void)cancelBtnClick:(UITapGestureRecognizer *)gesture
{
    _mainGrayBg.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.mj_y = SCREENFRAME_SIZE_HEIGHT;
    }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

- (void)registerPhoneNumber
{
    //TODO:: 获取验证码
}

- (void)normalRegister
{

    if ([self.delegate respondsToSelector:@selector(backToshowNormalRegisterView:)])
    {
        [self cancelBtnClick:nil];
        [self.delegate backToshowNormalRegisterView:YES];
    }
}


@end







