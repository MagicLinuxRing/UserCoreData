//
//  FriendListTableViewCell.m
//  JZIMSDK
//
//  Created by king jack on 15/9/16.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "FriendListTableViewCell.h"
#import "PlayerStoreManager.h"
#import "JZFileManager.h"

@interface FriendListTableViewCell()
{
    UIImageView *_friendAvator;
    UILabel     *_friendName;
    UILabel     *_friendDescription;
    
    UIButton    *_cancelButton;
}
@end

@implementation FriendListTableViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _friendAvator = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _friendAvator.backgroundColor = self.contentView.backgroundColor;
    _friendAvator.layer.cornerRadius = 30;
    _friendAvator.layer.masksToBounds = YES;
    [self.contentView addSubview:_friendAvator];
    
    _friendName = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, SCREENFRAME_SIZE_WIDTH-75-80, 30)];
    _friendName.backgroundColor = self.contentView.backgroundColor;
    _friendName.font = [UIFont fontWithName:@"Arial" size:20];
    _friendName.textColor = [UIColor blackColor];
    [self.contentView addSubview:_friendName];
    
    _friendDescription = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, SCREENFRAME_SIZE_WIDTH-75-80, 20)];
    _friendDescription.backgroundColor = self.contentView.backgroundColor;
    _friendDescription.font = [UIFont fontWithName:@"Arial" size:16];
    _friendDescription.textColor = [UIColor blackColor];
    [self.contentView addSubview:_friendDescription];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(SCREENFRAME_SIZE_WIDTH - 70, 20, 60, 40);
//    _cancelButton.backgroundColor = [UIColor greenColor];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cancelButton.layer.borderWidth = 0.5;
    _cancelButton.layer.cornerRadius = 5;
    [_cancelButton setTitle:@"Delete" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor yellowColor]  forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelRelationShip:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cancelButton];
}

- (void)cancelRelationShip:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeRelationShipWithInfo:)])
    {
        [self.delegate removeRelationShipWithInfo:_playerInfo.playerID];
    }
}

- (void)setPlayerInfo:(PlayerMoudle *)playerInfo
{
    _playerInfo = playerInfo;
}

- (void)setFriendDetail:(PlayerMoudle *)playerInfo
{
    self.playerInfo = playerInfo;
    
    NSString *fullPath = @"user";
    if (![playerInfo.playerAvatar isEqualToString:@"user"] && playerInfo.playerAvatar)
    {
        fullPath = [[[JZFileManager shareInstance] currentUserFileFullPath]
                    stringByAppendingPathComponent:playerInfo.playerAvatar];
        NSLog(@"%@",fullPath);
    }
    _friendAvator.image = [UIImage imageNamed:fullPath];
    _friendName.text = playerInfo.playerNickName;
    _friendDescription.text = playerInfo.playerDescription;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _friendName.frame = CGRectMake(80, 10, SCREENFRAME_SIZE_WIDTH-75-80, 30);
    _friendDescription.frame = CGRectMake(80, 50, SCREENFRAME_SIZE_WIDTH-75-80, 20);
    _cancelButton.frame = CGRectMake(SCREENFRAME_SIZE_WIDTH - 70, 20, 60, 40);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
