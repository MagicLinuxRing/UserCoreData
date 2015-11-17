//
//  PlayerEntity+Extentsion.m
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "NSManagedObject+Extention.h"
#import "PlayerEntity+Extentsion.h"
#import "JZIMMocManager.h"
#import "PlayerEntity.h"
#import "PlayerMoudle.h"

@implementation PlayerEntity (Extentsion)

+ (PlayerEntity *)playerWithInfo:(PlayerMoudle *)playerMoudle
            managedObjectContext:(NSManagedObjectContext *)context
{
    PlayerEntity *player = nil;
    NSString *playerId = playerMoudle.playerID;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayerEntity"];
    request.predicate = [NSPredicate predicateWithFormat:@"playerID = %@",playerId];
    
    NSError *error;
    NSArray *matches =  [context executeFetchRequest:request error:&error];
    if (!matches || error || [matches count]>1) {
        //error
    }
    else if ([matches count])
    {
        player = [matches firstObject];
    }
    else
    {
        player = [PlayerEntity createManagedObject:context];
        player.playerID = playerId;
        player.playerName = playerMoudle.playerName;
        player.playerSex = playerMoudle.playerSex;
        player.playerAge = playerMoudle.playerAge;
        player.playerAvatar = playerMoudle.playerAvatar;
        player.playerNickName = playerMoudle.playerNickName;
        player.playerDescription = playerMoudle.playerDescription;
        player.isFriend = playerMoudle.isFriend;
    }
    return player;
}

+ (PlayerEntity *)transferPlayerMoudleToEntityWithMoudle:(PlayerMoudle *)playerMoudle
                                            playerEntity:(PlayerEntity *)player
{
    player.playerID = playerMoudle.playerID;
    player.playerName = playerMoudle.playerName;
    player.playerSex = playerMoudle.playerSex;
    player.playerAge = playerMoudle.playerAge;
    player.playerAvatar = playerMoudle.playerAvatar;
    player.playerNickName = playerMoudle.playerNickName;
    player.playerDescription = playerMoudle.playerDescription;
    player.isFriend = playerMoudle.isFriend;
    return player;
}


@end
