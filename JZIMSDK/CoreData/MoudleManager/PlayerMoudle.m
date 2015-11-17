//
//  PlayerMoudle.m
//  JZIMSDK
//
//  Created by king jack on 15/9/16.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "PlayerMoudle.h"
#import "PlayerEntity.h"

@implementation PlayerMoudle

@synthesize playerName;
@synthesize playerID;
@synthesize playerSex;
@synthesize playerAge;
@synthesize playerAvatar;
@synthesize playerNickName;
@synthesize playerDescription;
@synthesize isFriend;

+ (id)transferEntityToPlayerMoudleWithEntity:(PlayerEntity *)playerEntity
{
    PlayerMoudle *playerMoudle = [[PlayerMoudle alloc] init];
    playerMoudle.playerID = playerEntity.playerID;
    playerMoudle.playerName = playerEntity.playerName;
    playerMoudle.playerSex = playerEntity.playerSex;
    playerMoudle.playerAge = playerEntity.playerAge;
    playerMoudle.playerAvatar = playerEntity.playerAvatar;
    playerMoudle.playerNickName = playerEntity.playerNickName;
    playerMoudle.playerDescription = playerEntity.playerDescription;
    playerMoudle.isFriend = playerEntity.isFriend;
    return playerMoudle;
}



@end
