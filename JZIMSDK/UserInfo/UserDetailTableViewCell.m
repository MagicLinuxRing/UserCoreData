//
//  UserDetailTableViewCell.m
//  JZIMSDK
//
//  Created by king jack on 15/9/23.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "UserDetailTableViewCell.h"
#import "UIView+MJExtension.h"
#import "PlayerMoudle.h"
#import "AppDelegate.h"
#import "JZFileManager.h"


@implementation UserDetailTableViewCell
@synthesize listLabel = _listLabel;
@synthesize detailLabel = _detailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _listLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentView.mj_h/2-12.5, 150, 25)];
    _listLabel.backgroundColor = self.contentView.backgroundColor;
    _listLabel.font = [UIFont fontWithName:@"Arial" size:20];
    _listLabel.textAlignment = NSTextAlignmentLeft;
    _listLabel.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:_listLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENFRAME_SIZE_WIDTH-140, self.contentView.mj_h/2-10, 100, 25)];
    _detailLabel.backgroundColor = self.contentView.backgroundColor;
    _detailLabel.font = [UIFont fontWithName:@"Arial" size:14];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_detailLabel];
}

- (void)setUserInfowithindexPath:(NSIndexPath *)indexPath
{
    NSArray *userInfoTitleArr = @[@"头像",@"昵称",@"账户",@"二维码名片",@"性别",@"地区",@"个性签名"];
    NSArray *userDetailArray = @[@"",self.playerMoudle.playerNickName,self.playerMoudle.playerName,self.playerMoudle.playerID,self.playerMoudle.playerSex,@"",self.playerMoudle.playerDescription];
    if (indexPath.section == 0)
    {
        _listLabel.text = userInfoTitleArr[indexPath.row];
        _detailLabel.text = userDetailArray[indexPath.row];
    }
    else
    {
        _listLabel.text = userInfoTitleArr[indexPath.row + 4];
        _detailLabel.text = userDetailArray[indexPath.row + 4];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _listLabel.frame = CGRectMake(10, self.contentView.mj_h/2-12.5, 150, 25);
    _detailLabel.frame = CGRectMake(SCREENFRAME_SIZE_WIDTH-140, self.contentView.mj_h/2-10, 100, 25);
}

@end

@implementation AVatarTableViewCell
@synthesize avatarButton = _avatarButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [super createUI];
    
    if (self.detailLabel)
    {
        [self.detailLabel removeFromSuperview];
    }
    
    _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENFRAME_SIZE_WIDTH-90, 5, 60, 60)];
    _avatarButton.userInteractionEnabled = YES;
    _avatarButton.backgroundColor = [UIColor clearColor];
    
    [_avatarButton addTarget:self action:@selector(showBigAvatar) forControlEvents:UIControlEventTouchUpInside];
    _avatarButton.layer.cornerRadius = 8;
    [self.contentView addSubview:_avatarButton];
    
    self.listLabel.frame = CGRectMake(10, self.contentView.mj_h/2, 150, 25);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _avatarButton.frame = CGRectMake(SCREENFRAME_SIZE_WIDTH-90, 5, 60, 60);
    _avatarButton.layer.cornerRadius = 8;
}

- (void)showBigAvatar
{
    UIWindow *currentWindow = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    currentWindow.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] initWithFrame:SCREENFRAME];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.userInteractionEnabled = YES;
    bgView.tag = 66666;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    [bgView addGestureRecognizer:gesture];
    
    NSString *fullPath = @"user";
    if (self.playerMoudle.playerAvatar && ![self.playerMoudle.playerAvatar isEqualToString:@"user"])
    {
        fullPath = [[[JZFileManager shareInstance] currentUserFileFullPath] stringByAppendingPathComponent:self.playerMoudle.playerAvatar];
    }
    
    UIImage *image = [UIImage imageNamed:fullPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREENFRAME_SIZE_WIDTH/2, SCREENFRAME_SIZE_WIDTH, SCREENFRAME_SIZE_WIDTH)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:imageView];
    [currentWindow addSubview:bgView];
}

- (void)panClick:(UITapGestureRecognizer *)gesture
{
    UIWindow *currentWindow = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [currentWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 66666)
        {
            [obj removeFromSuperview];
        }
    }];
}

- (void)setUserInfowithindexPath:(NSIndexPath *)indexPath
{
    [super setUserInfowithindexPath:indexPath];
    NSString *fullPath = [[[JZFileManager shareInstance] currentUserFileFullPath] stringByAppendingPathComponent:self.playerMoudle.playerAvatar];
    NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
    if (imageData)
    {
        [_avatarButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        return;
    }
    [_avatarButton setBackgroundImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal] ;
}

@end
