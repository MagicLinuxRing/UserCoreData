//
//  JZIMLoginView.m
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "JZIMLoginView.h"
#import "UIColor+Custom.h"
#import "UIView+MJExtension.h"

#define USERNAME_MAXLENGTH 20
#define PASSWORD_MAXLENGTH 17

typedef enum : NSUInteger {
    LOGINBUTTON = 1000,
    REGISTERBUTTON,
    VISITORBUTTON,
    FINDPASSWORDBUTTON,
} CURRENTBUTTON;


@interface JZIMLoginView()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    UIView      *menuView;
    UIImageView *_mainGrayBg;
    
    UILabel *titleLlb;
    
    UIButton *loginButton;
    UIButton *registerButton;
    UIButton *findPasswordButton;
    UIButton *visitorButton;
    
    UIView   *topView;
    UIView   *bottomView;
    
    BOOL isAgreeableSelected;
    BOOL isShowRegisterBottomView;
}
@end

@implementation JZIMLoginView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame bgColor:(id)backgroud
{
    return [self initWithFrame:frame bgColor:backgroud isShowRegistBottomView:NO];
}

- (instancetype)initWithFrame:(CGRect)frame
                      bgColor:(id)backgroud
       isShowRegistBottomView:(BOOL)isShowRegistBottomView
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.typeColor = backgroud;
        
        self.layer.cornerRadius = 10;
        [self createLoginSubView];
        
        isShowRegisterBottomView = isShowRegistBottomView;
        if (isShowRegistBottomView)
        {
            [self createBottomRegisterView];
        }
        else
        {
            [self createLoginBottomView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _mainGrayBg.frame = CGRectMake(0, 0, SCREENFRAME_SIZE_WIDTH,SCREENFRAME_SIZE_HEIGHT);
    menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT-240)/2-20, SCREENFRAME_SIZE_WIDTH-40, 240);
    titleLlb.frame = CGRectMake(0, 0, menuView.frame.size.width, 40);
    userNameTextField.frame = CGRectMake(20, 40, menuView.frame.size.width-40, 40 );
    passwordTextField.frame = CGRectMake(20, 40+40+10, userNameTextField.frame.size.width, 40);
    
    if (!isShowRegisterBottomView)
    {
        bottomView.frame = CGRectMake(0, 40+40+40+20+10, menuView.mj_w, 100);
        loginButton.frame = CGRectMake(bottomView.mj_w/2+15, 0, passwordTextField.mj_w/2-15, 40);
        registerButton.frame = CGRectMake(20, 0, passwordTextField.mj_w/2-15, 40);
        visitorButton.frame = CGRectMake(20, 40+15, 120, 15);
        findPasswordButton.frame = CGRectMake(bottomView.mj_w-140, visitorButton.mj_y, 120, 15);
    }
    else
    {
        menuView.mj_h = 255;
        bottomView.frame = CGRectMake(0, 40+40+40+10, menuView.mj_w, 120);
        registerButton.frame = CGRectMake(20, 38, bottomView.mj_w-40, 40);
    }
    bottomView.userInteractionEnabled = YES;
}

- (void)setTypeColor:(UIColor *)typeColor
{
    _typeColor = typeColor;
}

- (void)createLoginSubView
{
    _mainGrayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENFRAME_SIZE_WIDTH,SCREENFRAME_SIZE_HEIGHT)];
    _mainGrayBg.backgroundColor = [UIColor lightGrayColor];
    _mainGrayBg.alpha = 0;
    [_mainGrayBg  setUserInteractionEnabled:YES];
    [self addSubview:_mainGrayBg];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                           action:@selector(cancelBtnClick:)];
    tapGR.numberOfTapsRequired = 1;
    [_mainGrayBg  addGestureRecognizer:tapGR];
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREENFRAME_SIZE_HEIGHT, SCREENFRAME_SIZE_WIDTH-40, 240)];
    menuView.layer.cornerRadius = 10;
    menuView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.4 animations:^{
        menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT-240)/2-20, SCREENFRAME_SIZE_WIDTH-40, 240);
        _mainGrayBg.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
    [self addSubview:menuView];
    
    titleLlb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, menuView.frame.size.width, 40)];
    titleLlb.textColor = self.typeColor;
    titleLlb.textAlignment = NSTextAlignmentCenter;
    titleLlb.font = [UIFont boldSystemFontOfSize:20];
    titleLlb.text = @"账号登录";
    [menuView addSubview:titleLlb];
    
    UILabel *userNameLeftMentionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    userNameLeftMentionLbl.textColor = [UIColor grayColor];
    userNameLeftMentionLbl.font = [UIFont fontWithName:@"Arail" size:20];
    userNameLeftMentionLbl.text = @"  账 号：";
    
    userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, menuView.mj_w-40, 40 )];
    [userNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [userNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    userNameTextField.keyboardType = UIKeyboardTypeDefault;
    userNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userNameTextField.layer.borderWidth = 0.5;
    userNameTextField.layer.cornerRadius = 4;
    userNameTextField.delegate = self;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.leftView = userNameLeftMentionLbl;
    userNameTextField.placeholder = @"普通账号/手机号";
    [menuView addSubview:userNameTextField];
    
    UILabel *passwordLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    passwordLeftLbl.textColor = [UIColor grayColor];
    passwordLeftLbl.font = [UIFont fontWithName:@"Arail" size:20];
    passwordLeftLbl.text = @"  密 码：";
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40+40+10, userNameTextField.mj_w, 40)];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordTextField.layer.borderWidth = 0.5;
    passwordTextField.layer.cornerRadius = 4;
    passwordTextField.leftView = passwordLeftLbl;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    passwordTextField.placeholder = @"请输入密码";
    [menuView addSubview:passwordTextField];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40+40+20, menuView.mj_w, 100)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.userInteractionEnabled = YES;
    [menuView addSubview:bottomView];
}

- (void)createLoginBottomView
{
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(bottomView.mj_w/2+15, 0, passwordTextField.mj_w/2-15, 40);
    loginButton.layer.cornerRadius = 5;
    loginButton.tag = LOGINBUTTON;
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = REDBGCOLOR;
    [bottomView addSubview:loginButton];
    
    
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(20, 0, passwordTextField.mj_w/2-15, 40);
    registerButton.layer.cornerRadius = 5.0;
    registerButton.tag = REGISTERBUTTON ;
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.backgroundColor  = self.typeColor;
    [bottomView addSubview:registerButton];
    
    visitorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    visitorButton.frame = CGRectMake(20, 40+15, 120, 15);
    [visitorButton setTitle:@"游客一键登录>" forState:UIControlStateNormal];
    [visitorButton setTitleColor:[UIColor colorWithHexString:@"0x45B6F6"] forState:UIControlStateNormal];
    visitorButton.tag = VISITORBUTTON;
    [visitorButton setTitleColor:self.typeColor forState:UIControlStateHighlighted];
    [visitorButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:visitorButton];
    
    findPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findPasswordButton.frame = CGRectMake(bottomView.mj_w-140, visitorButton.mj_y, 120, 15);
    [findPasswordButton setTitle:@"找回密码/账号" forState:UIControlStateNormal];
    [findPasswordButton setTitleColor:[UIColor colorWithHexString:@"0x45B6F6"] forState:UIControlStateNormal];
    findPasswordButton.tag = FINDPASSWORDBUTTON;
    [findPasswordButton setTitleColor:self.typeColor forState:UIControlStateHighlighted];
    
    
    [findPasswordButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:findPasswordButton];
}

- (void)createBottomRegisterView
{
    titleLlb.text = @"普通账号登陆";
    menuView.mj_h = 255;
    bottomView.frame = CGRectMake(0, 40+40+40+10, menuView.mj_w, 120);
    
    UIButton *selectProtocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectProtocalButton.frame = CGRectMake(20, 10, 20, 20);
    selectProtocalButton.backgroundColor = [UIColor clearColor];
    [selectProtocalButton setImage:[UIImage imageNamed:@"uncheckedbox"] forState:UIControlStateNormal];
    [selectProtocalButton setImage:[UIImage imageNamed:@"checkedbox"] forState:UIControlStateHighlighted];
    [selectProtocalButton addTarget:self
                             action:@selector(selectProtocal:)
                   forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:selectProtocalButton];
    
    UIButton *protocalShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    protocalShowButton.frame = CGRectMake(35 ,5, 220, 30);
    protocalShowButton.backgroundColor = [UIColor clearColor];
    [protocalShowButton setTitle:@"用户服务协议" forState:UIControlStateNormal];
    [protocalShowButton setTitleColor:[UIColor colorWithHexString:@"0x45B6F6"]
                             forState:UIControlStateNormal];
    [protocalShowButton  setTitleColor:self.typeColor forState:UIControlStateHighlighted];
    [protocalShowButton addTarget:self action:@selector(showProtocal)
                 forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:protocalShowButton];
    
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(20, 30 + 3, bottomView.mj_w-40, 40);
    registerButton.layer.cornerRadius = 5.0;
    registerButton.tag = REGISTERBUTTON ;
    [registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.backgroundColor  = [UIColor grayColor];
    registerButton.enabled = isAgreeableSelected;
    [bottomView addSubview:registerButton];
    
    UILabel *mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, bottomView.mj_h-25, 110, 20)];
    mentionLabel.textColor = [UIColor lightGrayColor];
    mentionLabel.font = [UIFont fontWithName:@"Arail" size:16];
    mentionLabel.text = @"你也可以选择";
    [bottomView addSubview:mentionLabel];
    
    UIButton *phoneRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneRegisterButton.frame = CGRectMake(120 ,bottomView.mj_h-25, 110, 20);
    phoneRegisterButton.backgroundColor = [UIColor clearColor];
    [phoneRegisterButton setTitle:@"手机账号注册" forState:UIControlStateNormal];
    [phoneRegisterButton setTitleColor:[UIColor colorWithHexString:@"0x45B6F6"]
                              forState:UIControlStateNormal];
    [phoneRegisterButton  setTitleColor:self.typeColor forState:UIControlStateHighlighted];
    [phoneRegisterButton addTarget:self
                            action:@selector(showPhoneRegisterView)
                  forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneRegisterButton];
}

- (void)showPhoneRegisterView
{
    if ([self.delegate respondsToSelector:@selector(popupPhoneRegisterView)])
    {
        [self cancelBtnClick:nil];
        [self.delegate popupPhoneRegisterView];
    }
}

- (void)showProtocal
{
    //TODO::show protocal
}

- (void)removeBottomLoginView
{
    [registerButton removeFromSuperview];
    [loginButton removeFromSuperview];
    [visitorButton removeFromSuperview];
    [findPasswordButton removeFromSuperview];
}

- (void)selectProtocal:(UIButton *)button
{

    isAgreeableSelected = !isAgreeableSelected;

    registerButton.enabled = isAgreeableSelected;
    
    if (!isAgreeableSelected)
    {
        [button setImage:[UIImage imageNamed:@"uncheckedbox"] forState:UIControlStateNormal];
        registerButton.backgroundColor =  [UIColor grayColor];
    }
    else
    {
        registerButton.backgroundColor = self.typeColor;
        [button setImage:[UIImage imageNamed:@"checkedbox"] forState:UIControlStateNormal];
    }
    
}

- (void)login:(UIButton *)button
{
    NSInteger buttonTag = button.tag;
    
    NSString *userName = userNameTextField.text;
    NSString *password = passwordTextField.text;
    
    //check
    
    switch (buttonTag)
    {
        case LOGINBUTTON:
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithUserInfo:)])
            {
                [self.delegate loginWithUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:userName,@"user",password,@"psw", nil]];
            }
            break;
        case REGISTERBUTTON:
        {
            if (isShowRegisterBottomView)
            {
                // TODO::完成注册
                if ([self.delegate respondsToSelector:@selector(registerLoginWithUserInfo:)])
                {
                    [self.delegate registerLoginWithUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:userName,@"user",password,@"psw", nil]];
                }
            }
            else
            {
                isShowRegisterBottomView = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    [self removeBottomLoginView];
                } completion:^(BOOL finished) {
                    [self createBottomRegisterView];
                    isShowRegisterBottomView = YES;
                }];
            }
        }
            break;
        case VISITORBUTTON:
            //TODO::游客一键登录
            break;
            
        default:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(popupFindSecretView)])
            {
                [self.delegate popupFindSecretView];
            }
            [self cancelBtnClick:nil];
        }
            break;
    }
}

#pragma mark - UITextFiled Delegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == userNameTextField)
    {
        if (textField.text.length > USERNAME_MAXLENGTH)
        {
            textField.text = [textField.text substringToIndex:USERNAME_MAXLENGTH];
        }
    }
    else
    {
        if (textField.text.length > PASSWORD_MAXLENGTH)
        {
            textField.text = [textField.text substringToIndex:PASSWORD_MAXLENGTH];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == userNameTextField)
//    {
//        if ([textField.text isEqualToString:ENTERWORD] || [textField.text isEqualToString:SPACENULL])
//        {
//            return NO;
//        }
//    }
    return YES;
}

- (void)cancelBtnClick:(UITapGestureRecognizer *)gesture
{
    _mainGrayBg.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.frame =CGRectMake(0, SCREENFRAME_SIZE.height, SCREENFRAME_SIZE.width-40, 260);
    }
                     completion:^(BOOL finished)
     {
         [userNameTextField resignFirstResponder];
         [passwordTextField resignFirstResponder];
         [self removeFromSuperview];
     }];
}

@end
