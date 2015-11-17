//
//  PlayerEntity+Extentsion.h
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "PlayerEntity.h"
@class PlayerMoudle;

@interface PlayerEntity (Extentsion)

+ (PlayerEntity *)playerWithInfo:(PlayerMoudle *)playerMoudle
            managedObjectContext:(NSManagedObjectContext *)context;

+ (PlayerEntity *)transferPlayerMoudleToEntityWithMoudle:(PlayerMoudle *)playerMoudle
                                            playerEntity:(PlayerEntity *)player;

@end
