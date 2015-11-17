//
//  UserDetailTableViewCell.h
//  JZIMSDK
//
//  Created by king jack on 15/9/23.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    AVATAR = 0,
    NICKNAME,
    ACCOUNT,
    QRCODE,
    SEX,
    POSITION,
    SIGNITURE,
} CELL_TAG;


@protocol UserDetailClickDelegate <NSObject>

- (void)clickDetailWithIndex:(CELL_TAG)tag;

@end


@class PlayerMoudle;

@interface UserDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *listLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,weak) id<UserDetailClickDelegate>clickDetailDelegate;

@property(nonatomic,strong)PlayerMoudle *playerMoudle;

- (void)setUserInfowithindexPath:(NSIndexPath *)indexPath;

@end

@interface AVatarTableViewCell : UserDetailTableViewCell

@property (nonatomic,strong)UIButton *avatarButton;

- (void)setUserInfowithindexPath:(NSIndexPath *)indexPath;

@end
