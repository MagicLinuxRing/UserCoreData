//
//  ViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "ViewController.h"
#import "JZIMLoginView.h"
#import "FriendListTableViewController.h"
#import "JZAssiveTouchView.h"
#import "UIColor+Custom.h"
#import "FloatView.h"
#import "JZPhoneRegisterView.h"
#import "JZFindSecretView.h"

typedef enum : NSUInteger
{
    LEFTBAR = 0,
    RIGHTBAR,
} BarButtenItem;

@interface ViewController ()<JZIMLoginDelegate,FindSecretDelegate,AssistiveTouchDelegate,FloatingButtonDelegate,NormalRegisterDelegate>
{
    JZIMLoginView *_loginView;
    JZAssiveTouchView *_assiveView;
    FloatView *_floatView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self createLoginView];
    [self createNavBar];
    
    self.title = @"JZIMSDK";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithHexString:@"0xFBA73C"] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createFloatView];
}

- (void)createFloatView
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"个人",@"好友",@"消息",@"服务", nil];
//    _floatView = [FloatView defaultFloatViewWithButtonImageNameArray: titleArray:titleArray];
    _floatView = [[FloatView alloc] initWithButtonImageNameArray:@[@"user",@"relationship",@"message",@"help"] titleArray:titleArray];
    _floatView.delegate = self;
}

 - (void)addAssiveTouchView
{
    _assiveView = [[JZAssiveTouchView alloc] initWithFrame:CGRectMake(100, 100, 60, 60) imageName:@"1"];
    _assiveView.delegate = self;
    [self.view addSubview:_assiveView];
}

- (void)createNavBar
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleBordered target:self action:@selector(navBarButtonClick:)];
    leftButton.tag = LEFTBAR;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"好友列表" style:UIBarButtonItemStyleDone target:self action:@selector(navBarButtonClick:)];
    rightButton.tag = RIGHTBAR;

    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)navBarButtonClick:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem.tag == LEFTBAR)
    {
        [self createLoginView:NO];
    }
    else
    {
        [self pushToFriendListView];
        [_floatView removeWindow];
    }
}

- (void)pushToFriendListView
{
    FriendListTableViewController *friendListView = [[FriendListTableViewController alloc] init];
    [self.navigationController pushViewController:friendListView animated:YES];
}

- (void)createLoginView:(BOOL)isShowRegisterBottomView
{
    if (_loginView)
    {
        [_loginView removeFromSuperview];
        _loginView = nil;
    }
    _loginView = [[JZIMLoginView alloc] initWithFrame:SCREENFRAME
                                              bgColor:[UIColor colorWithHexString:@"0xFBA73C"]
                               isShowRegistBottomView:isShowRegisterBottomView];
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
}

#pragma mark - floating button delegate
- (void)floatButtonClick:(UIButton *)button
{
    [self pushToFriendListView];
    
}

#pragma mark - assivetouch delegate

-(void)assistiveTocuhs:(BOOL)isShowMenu
{
    if (isShowMenu)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _assiveView.frame;
            _assiveView.frame = CGRectMake(rect.origin.x, rect.origin.y, SCREENFRAME_SIZE_WIDTH, rect.size.height);
            _assiveView.backgroundColor = [UIColor redColor];
        } completion:nil];
    }
}

#pragma mark - login delegate

- (void)loginWithUserInfo:(NSDictionary *)userInfo
{
    //TODO::login request
}

- (void)registerLoginWithUserInfo:(NSDictionary *)userInfo
{
    //TODO:: Register login
}

- (void)visitorLoginWithUserInfo
{
    //TODO:: Visitor login
}

- (void)popupPhoneRegisterView
{
    JZPhoneRegisterView *registerView = [[JZPhoneRegisterView alloc] initWithFrame:SCREENFRAME
                                                                         titleName:@"手机账号注册"
                                                                           bgColor:[UIColor colorWithHexString:@"0xFBA73C"]];
    registerView.delegate = self;
    [self.view addSubview:registerView];
}

- (void)popupFindSecretView
{
    JZFindSecretView *findSecretView = [[JZFindSecretView alloc] initWithFrame:SCREENFRAME
                                                                     titleName:@"找回密码"
                                                                       bgColor:[UIColor colorWithHexString:@"0xFBA73C"]];
    findSecretView.delegate = self;
    [self.view addSubview:findSecretView];
}

- (void)backToshowNormalRegisterView:(BOOL)isShowRegisterBottomView
{
    [self createLoginView:isShowRegisterBottomView];
}


#pragma mark -orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
