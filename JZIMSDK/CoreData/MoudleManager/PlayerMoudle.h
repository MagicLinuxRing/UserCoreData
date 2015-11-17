//
//  PlayerMoudle.h
//  JZIMSDK
//
//  Created by king jack on 15/9/16.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlayerEntity;

@interface PlayerMoudle : NSObject

@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * playerSex;
@property (nonatomic, retain) NSNumber * playerAge;
@property (nonatomic, retain) NSString   * playerAvatar;
@property (nonatomic, retain) NSString * playerNickName;
@property (nonatomic, retain) NSString * playerDescription;
@property (nonatomic, retain) NSNumber * isFriend;

+ (id)transferEntityToPlayerMoudleWithEntity:(PlayerEntity *)playerEntity;

@end
