//
//  NSManagedObject+Extention.h
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extention)

+ (id)createManagedObject:(NSManagedObjectContext*)context;

+ (id)createManagedObjectWithInfo:(NSDictionary*)dict
                          context:(NSManagedObjectContext*)context;

+ (id)findManagedObjectWithPredicate:(NSPredicate *)predicate
                             context:(NSManagedObjectContext *)context;

+ (id)findManagedObjectWithPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
                             context:(NSManagedObjectContext *)context;

+ (NSArray*)findAllManagedObjectWithPredicat:(NSPredicate *)predicate
                                   inContext:(NSManagedObjectContext *)context;

+ (NSArray*)findAllManagedObjectWithPredicat:(NSPredicate *)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                                     context:(NSManagedObjectContext *)context;

+ (NSUInteger)countDataWithPredicate:(NSPredicate *)predicate
                             context:(NSManagedObjectContext *)contex;

+ (NSString *)entityName;

+ (NSError*)deleteAll:(NSManagedObjectContext*)context;

@end
