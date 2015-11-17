//
//  JZIMMocManager.m
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "JZIMMocManager.h"

@implementation JZIMMocManager

+ (instancetype)shareInstance
{
    static JZIMMocManager *mocManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        mocManager = [[JZIMMocManager alloc] init];
    });
    return mocManager;
}

- (void)setupStoreStackWithModelName:(NSString *)modelName storeDBFileName:(NSString *)storePath
{
    self.dataModelName  = modelName;
    self.storePath = storePath;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator)
    {
        _backgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundObjectContext setPersistentStoreCoordinator:coordinator];
        
        _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainObjectContext.parentContext = _backgroundObjectContext;
    }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storePath];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NSMigratePersistentStoresAutomaticallyOption],[NSNumber numberWithBool:NSInferMappingModelAutomaticallyOption], nil];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSURL *dataModelUrl = [[NSBundle mainBundle] URLForResource:self.dataModelName withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:dataModelUrl];
    return managedObjectModel;
}

- (NSManagedObjectContext *)createPrivateObjectContext
{
    NSManagedObjectContext *privateObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateObjectContext.parentContext = _mainObjectContext;
    return privateObjectContext;
}

- (void)save:(RESULTBLOCK)resultBlock
{
    NSError *error;
    if (_mainObjectContext.hasChanges)
    {
        [_mainObjectContext save:&error];
        [_backgroundObjectContext performBlock:^{
            __block NSError *innerError = nil;
            [_backgroundObjectContext save:&innerError];
            if (resultBlock)
            {
                [_mainObjectContext performBlock:^{
                    resultBlock(error);
                }];
            }
        }];
    }
}

@end
