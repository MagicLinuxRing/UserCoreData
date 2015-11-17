//
//  FriendListTableViewCell.h
//  JZIMSDK
//
//  Created by king jack on 15/9/16.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerMoudle;

@protocol FriendRelationShipDelegate <NSObject>

- (void)removeRelationShipWithInfo:(NSString *)friendID;

@end

@interface FriendListTableViewCell : UITableViewCell

/**
 *  set cell detail
 *
 *  @param playerInfo \ friend detialinfo
 */
- (void)setFriendDetail:(PlayerMoudle *)playerInfo;

@property (nonatomic,strong)PlayerMoudle *playerInfo;

@property (nonatomic,weak)id<FriendRelationShipDelegate>delegate;

@end
