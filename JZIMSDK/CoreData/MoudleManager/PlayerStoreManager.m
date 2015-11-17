//
//  PlayerStoreManager.m
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "PlayerEntity.h"
#import "JZIMMocManager.h"
#import "PlayerStoreManager.h"
#import "PlayerEntity+Extentsion.h"
#import "NSManagedObject+Extention.h"
#import "NSFetchRequest+Extensions.h"
#import "NSManagedObjectContext+Fetching.h"
#import "NSManagedObjectContext+Extensions.h"

@implementation PlayerStoreManager

@synthesize playerMoudle;

+ (instancetype)shareInstance
{
    static PlayerStoreManager *playerManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        playerManager = [[PlayerStoreManager alloc] init];
    });
    return playerManager;
}

- (NSManagedObjectContext *)mainObjectContext
{
    return [JZIMMocManager shareInstance].mainObjectContext;
}

- (NSManagedObjectContext *)privateObjectContext
{
    if (_privateObjectContext)
    {
        return _privateObjectContext;
    }
    return [self createCurrentPrivateObjectContext];
}

- (NSManagedObjectContext *)createCurrentPrivateObjectContext
{
    self.privateObjectContext = [[JZIMMocManager shareInstance] createPrivateObjectContext];
    return self.privateObjectContext;
}

- (void)save
{
    [[JZIMMocManager shareInstance] save:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)saveWithObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [managedObjectContext performBlock:^{
         NSError *error;
         [managedObjectContext save:&error];
        [self save];
    }];
}

- (void)insertObjectWithPlayerMoudle:(NSDictionary *)playerInfo
                       objectContext:(NSManagedObjectContext *)managedContext
{
    PlayerMoudle *moudle = [[PlayerMoudle alloc] init];
    moudle.playerID = playerInfo[@"playerID"];
    moudle.playerAge = @([playerInfo[@"playerAge"] integerValue]);
    moudle.playerDescription = playerInfo[@"playerDescription"];
    moudle.playerName = playerInfo[@"playerName"];
    moudle.playerNickName = playerInfo[@"playerNickName"];
    moudle.playerSex = playerInfo[@"playerSex"];
    moudle.playerAvatar = playerInfo[@"playerAvatar"];
    moudle.isFriend = @(0);
    
    [PlayerEntity playerWithInfo:moudle managedObjectContext:managedContext];
}

- (void)saveWithPlayerData:(NSArray *)playerInfoList objectContext:(NSManagedObjectContext *)managedContext
{
    if ([playerInfoList count] == 0 || ![playerInfoList isKindOfClass:[NSArray class]]) return;
    
    for (NSDictionary *playerInfo in playerInfoList)
    {
        [self insertObjectWithPlayerMoudle:playerInfo objectContext:managedContext];
    }
    [self saveWithObjectContext:managedContext];
}

- (void)findAllPlayerListWithResultCompletion:(PlayerAllNodeBlock)playerListBlock
{
    NSString *entityName = [PlayerEntity entityName];
    NSManagedObjectContext *privateContext = self.privateObjectContext;
    
    [privateContext performBlock:^{
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"playerName" ascending:YES]]];
        
        NSError *error;
        NSArray *dataArray = [privateContext executeFetchRequest:request error:&error];
        
        NSMutableArray *idArray = [[NSMutableArray alloc] init];
        for (NSManagedObject *obj in dataArray)
        {
            [idArray addObject:obj.objectID];
        }

        [self.mainObjectContext performBlock:^{
            NSMutableArray *objArray = [[NSMutableArray alloc] init];
            
            for (NSManagedObjectID *robjId in idArray)
            {
                [objArray addObject:[self.mainObjectContext objectWithID:robjId]];
            }
            
            [objArray enumerateObjectsUsingBlock:^(PlayerEntity *entity, NSUInteger idx, BOOL *stop) {
                objArray[idx] = [PlayerMoudle transferEntityToPlayerMoudleWithEntity:entity];
            }];
            playerListBlock(objArray,error);
        }];
    }];
}

- (void)findOnePlayerEntityWithPredicate:(NSPredicate *)predicate
                                 context:(NSManagedObjectContext *)context
                        resultCompletion:(PlayerAllNodeBlock)playerListBlock
{
    [self findSuitPlayerEntityWithPredicate:predicate managedObjectContext:context
                           resultCompletion:^(NSArray *allNode, NSError *error)
     {
        if ([allNode count] ==0 || ![allNode isKindOfClass:[NSArray class]])
        {
            playerListBlock(nil,error);
        }
        else
        {
            playerListBlock(@[allNode[0]],error);
        }
    }];
}

- (void)findSuitPlayerEntityWithPredicate:(NSPredicate *)predicate
                     managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                         resultCompletion:(PlayerAllNodeBlock)playerListBlock
{
    [self findSuitPlayerEntityWithPredicate:predicate
                            sortDescription:nil
                              objectContext:managedObjectContext
                           resultCompletion:playerListBlock];
}

- (void)findSuitPlayerEntityWithPredicate:(NSPredicate *)predicate
                          sortDescription:(NSArray *)sortDescriptors
                            objectContext:(NSManagedObjectContext *)managedObjectContext
                         resultCompletion:(PlayerAllNodeBlock)playerListBlock
{
    NSArray *resultQuery = [managedObjectContext fetchObjects:[PlayerEntity entityName]
                                               usingPredicate:predicate
                                         usingSortDescriptors:sortDescriptors
                                             returningAsFault:YES];
    playerListBlock(resultQuery,nil);
}

- (void)deleteEntityWithPlayerID:(NSString *)playerID objectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerID == %@",playerID];
    
    [self findSuitPlayerEntityWithPredicate:predicate sortDescription:nil objectContext:managedObjectContext resultCompletion:^(NSArray *allNode, NSError *error) {
        [allNode enumerateObjectsUsingBlock:^(PlayerEntity* entity, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([entity validateForDelete:nil])
            {
                [managedObjectContext deleteObject:entity];
            }
        }];
    }];
}

- (void)deleteEntityWithPlayerArray:(NSArray *)playerArray objectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([playerArray count] == 0 || ![playerArray isKindOfClass:[NSArray class]]) return;
    
    for (PlayerMoudle *moudle in playerArray)
    {
        [self deleteEntityWithPlayerID:moudle.playerID objectContext:managedObjectContext];
    }
}

- (void)modifyEntityWithPlayer:(PlayerMoudle *)moudleData context:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerID == %@",moudleData.playerID];

    [self findOnePlayerEntityWithPredicate:predicate context:managedObjectContext resultCompletion:^(NSArray *allNode, NSError *error)
     {
         if ([allNode count] == 0 || error )
         {
             NSLog(@"%@",error);
         }
         else
         {
             PlayerEntity *playerEntity = allNode[0];
             playerEntity = [PlayerEntity transferPlayerMoudleToEntityWithMoudle:moudleData playerEntity:playerEntity];
             [self saveWithObjectContext:managedObjectContext];
         }
    }];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [NSFetchRequest fetchRequestWithEntity:entity
                                        predicate:predicate
                                  sortDescriptors:sortDescriptors];
}

- (id)fetchAllNode
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[PlayerEntity entityName] inManagedObjectContext:self.mainObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"playerName" ascending:YES];
    return [NSFetchRequest fetchRequestWithEntity:entityDescription sortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
}

@end















