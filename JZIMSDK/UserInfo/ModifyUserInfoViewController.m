//
//  ModifyUserInfoViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/9/29.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "ModifyUserInfoViewController.h"
#import "PlayerStoreManager.h"
#import "PlayerMoudle.h"

#import "FriendListTableViewController.h"

@interface ModifyUserInfoViewController ()<UITextFieldDelegate>
{
    UITextField  *_nickNameView;
    UIButton     *_rightButton;
}

@end

@implementation ModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavBar];
    
    [self createNickNameView];
}

- (void)createNavBar
{
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 60, 40)];
    _rightButton.backgroundColor = [UIColor clearColor];
    [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [_rightButton setTitleColor:BLUDEBGCOLOR forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_rightButton addTarget:self
                     action:@selector(saveNickName:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *_rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    UIBarButtonItem *_leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                    style:UIBarButtonItemStyleBordered
                                                   target:self
                                                   action:@selector(popUp)];
    
    self.navigationItem.leftBarButtonItem = _leftBarItem;
    self.navigationItem.rightBarButtonItem = _rightBarItem;
}

- (void)saveNickName:(UIButton *)button
{
    if (_nickNameView.text.length == 0) return;
    
    PlayerMoudle *playerMoudle = [[PlayerMoudle alloc] init];
    playerMoudle.playerID = self.playerMoudle.playerID;
    playerMoudle.playerAge = self.playerMoudle.playerAge;
    playerMoudle.playerAvatar = self.playerMoudle.playerAvatar;
    playerMoudle.playerDescription = self.playerMoudle.playerDescription;
    playerMoudle.playerName = self.playerMoudle.playerName;
    playerMoudle.playerNickName = _nickNameView.text;
    playerMoudle.playerSex = self.playerMoudle.playerSex;
    
    
    [[PlayerStoreManager shareInstance] modifyEntityWithPlayer:playerMoudle context:[PlayerStoreManager shareInstance].privateObjectContext];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *controller in viewControllers)
    {
        if ([controller isKindOfClass:[FriendListTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)popUp
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNickNameView
{
    self.title = @"名字";
    _nickNameView = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, SCREENFRAME_SIZE_WIDTH, 40)];
    _nickNameView.backgroundColor = [UIColor whiteColor];
    _nickNameView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _nickNameView.delegate = self;
    _nickNameView.text = self.playerMoudle.playerNickName;
    _nickNameView.layer.borderWidth = 0.5;
    _nickNameView.returnKeyType = UIReturnKeyDone;
    _nickNameView.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_nickNameView];
}

#pragma mark -  textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
    if (currentString.length >30)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveNickName:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end










