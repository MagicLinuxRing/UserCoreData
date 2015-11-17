//
//  JZIMMocManager.h
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^RESULTBLOCK) (NSError *error);

@interface JZIMMocManager : NSObject

+ (instancetype)shareInstance;

/**
 *  the objectContext of saving to disk
 */
@property (readonly ,strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;

/**
 *  the objectContext of saving to memory & running, and then push merge to backgroundObjectContext
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

@property (nonatomic,copy)NSString *dataModelName;
@property (nonatomic,copy)NSString *storePath;

/**
 *  start store persistentCoordinator
 *
 *  @param modelName  \ dataModelName
 *  @param storePath  \ storePath
 *
 */
- (void)setupStoreStackWithModelName:(NSString *)modelName
                     storeDBFileName:(NSString *)storePath;

/**
 *  save to disk/memory
 *
 *  @param resultBlock \ NSError *
 */
- (void)save:(RESULTBLOCK)resultBlock;

/**
 *  create privateobjectContext
 *
 *  @return \ NSManagedObjectContext *
 */
- (NSManagedObjectContext *)createPrivateObjectContext;

@end
