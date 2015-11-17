//
//  JZFindAccountView.m
//  JZIMSDK
//
//  Created by king jack on 15/9/24.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZFindAccountView.h"
#import "JZFindSecretView.h"
#import "UIView+MJExtension.h"
#import "UIColor+Custom.h"
#import "JZIMLoginView.h"

@interface JZFindAccountView()
{
    UIImageView *_mainGrayBg;
    UITextField *_accountField;
    UIView      *_menuView;
    UIButton    *_phoneRegisterButton;
    UILabel     *_titleLabel;
}

@property(nonatomic,retain)UIColor *typeColor;

@end

@implementation JZFindAccountView

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
    _menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT - 230)/2-20, SCREENFRAME_SIZE_WIDTH-40, 230);
    _titleLabel.frame = CGRectMake(0, 10, _menuView.frame.size.width, 40);
    _phoneRegisterButton.frame = CGRectMake(20, 160, _menuView.mj_w-40, 40);
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
    
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(SCREENFRAME_SIZE_WIDTH, (SCREENFRAME_SIZE_HEIGHT - 230)/2-20, SCREENFRAME_SIZE_WIDTH-40, 230)];
    _menuView.userInteractionEnabled = YES;
    _menuView.layer.cornerRadius = 10;
    _menuView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.4 animations:^{
        _menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT - 230)/2-20, SCREENFRAME_SIZE_WIDTH-40, 230);
        _mainGrayBg.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
    [self addSubview:_menuView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _menuView.frame.size.width, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = self.typeColor;
    [_menuView addSubview:_titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 10, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToFindSecret) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [_menuView addSubview:backButton];
    
    UILabel *mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, _menuView.mj_w-20, 20)];
    mentionLabel.textColor = [UIColor lightGrayColor];
    mentionLabel.textAlignment = NSTextAlignmentLeft;
    mentionLabel.font = [UIFont boldSystemFontOfSize:16];
    mentionLabel.text = @"账号忘了？请联系客服：";
    [_menuView addSubview:mentionLabel];
    
    _phoneRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneRegisterButton.frame = CGRectMake(20, 160, _menuView.mj_w-40, 40);
    _phoneRegisterButton.layer.cornerRadius = 5;
    [_phoneRegisterButton setTitle:@"拨打客服电话" forState:UIControlStateNormal];
    [_phoneRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_phoneRegisterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_phoneRegisterButton addTarget:self action:@selector(callServer) forControlEvents:UIControlEventTouchUpInside];
    _phoneRegisterButton.backgroundColor = self.typeColor;
    [_menuView addSubview:_phoneRegisterButton];
}

- (void)callServer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://"]];
}

- (void)backToFindSecret
{
    [self cancelBtnClick:nil];
}

- (void)cancelBtnClick:(UITapGestureRecognizer *)gesture
{
    _mainGrayBg.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.mj_x = SCREENFRAME_SIZE_WIDTH;
        
    }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}


@end
