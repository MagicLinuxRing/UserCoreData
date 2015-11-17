//
//  PlayerStoreManager.h
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlayerMoudle.h"

typedef void(^PlayerAllNodeBlock) (NSArray *allNode,NSError *error);
typedef void(^AsynSearchBlock)(NSManagedObjectContext *privateContext,NSString *entityName);

@interface PlayerStoreManager : NSObject

@property (readonly,nonatomic,strong)NSManagedObjectContext *mainObjectContext;

@property (nonatomic,strong)NSManagedObjectContext *privateObjectContext;

@property (nonatomic,strong)PlayerMoudle *playerMoudle;

+ (instancetype)shareInstance;

- (void)saveWithObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)insertObjectWithPlayerMoudle:(NSDictionary *)playerInfo
                       objectContext:(NSManagedObjectContext *)managedContext;

- (void)save;
/**
 *  save entity data
 *
 *  @param playerInfoList PlayerStoreManager *
 */
- (void)saveWithPlayerData:(NSArray *)playerInfoList objectContext:(NSManagedObjectContext *)managedContext;

/**
 *  find all data of PlayerEntity
 *
 *  @param playerListBlock
 */
- (void)findAllPlayerListWithResultCompletion:(PlayerAllNodeBlock)playerListBlock;

- (void)findOnePlayerEntityWithPredicate:(NSPredicate *)predicate
                                 context:(NSManagedObjectContext *)context
                        resultCompletion:(PlayerAllNodeBlock)playerListBlock;

- (void)findSuitPlayerEntityWithPredicate:(NSPredicate *)predicate
                     managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                         resultCompletion:(PlayerAllNodeBlock)playerListBlock;

- (void)findSuitPlayerEntityWithPredicate:(NSPredicate *)predicate
                          sortDescription:(NSArray *)sortDescriptors
                            objectContext:(NSManagedObjectContext *)managedObjectContext
                         resultCompletion:(PlayerAllNodeBlock)playerListBlock;

/**
 *  delete muti entity record
 *
 *  @param playerArray          <#playerArray description#>
 *  @param managedObjectContext \ in your manageObjectContext,defaults is privateContext
 */
- (void)deleteEntityWithPlayerArray:(NSArray *)playerArray objectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)deleteEntityWithPlayerID:(NSString *)playerID objectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 *  modify entity record
 *
 *  @param moudleData           <#moudleData description#>
 *  @param managedObjectContext <#managedObjectContext description#>
 */
- (void)modifyEntityWithPlayer:(PlayerMoudle *)moudleData context:(NSManagedObjectContext *)managedObjectContext;

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

- (id)fetchAllNode;

@end
