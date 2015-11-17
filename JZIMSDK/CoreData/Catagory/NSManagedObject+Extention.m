//
//  NSManagedObject+Extention.m
//  JZIMSDK
//
//  Created by king jack on 15/9/15.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "NSManagedObject+Extention.h"
#import "NSManagedObjectContext+Extensions.h"

@implementation NSManagedObject (Extention)

+ (id)createManagedObject:(NSManagedObjectContext *)context
{
     return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                          inManagedObjectContext:context];
}

+ (NSString *)entityName
{
    return [NSString stringWithCString:object_getClassName(self)
                              encoding:NSASCIIStringEncoding];
}


+ (id)createManagedObjectWithInfo:(NSDictionary*)dict
                          context:(NSManagedObjectContext*)context
{
    id instance = [self createManagedObject:context];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
        [instance setValue:obj forKey:key];
    }];
    return instance;
}

+ (id)findManagedObjectWithPredicate:(NSPredicate *)predicate
                             context:(NSManagedObjectContext *)context
{
    return [context fetchObjectForEntity:[self entityName] predicate:predicate];
}

+ (id)findManagedObjectWithPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
                             context:(NSManagedObjectContext *)context
{
    return [context fetchObjectForEntity:[self entityName]
                               predicate:predicate
                         sortDescriptors:sortDescriptors];
}

+ (NSArray*)findAllManagedObjectWithPredicat:(NSPredicate *)predicate
                                   inContext:(NSManagedObjectContext *)context
{
    return [context fetchObjectsForEntity:[self entityName] predicate:predicate];
}

+ (NSArray*)findAllManagedObjectWithPredicat:(NSPredicate *)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                                     context:(NSManagedObjectContext *)context
{
    return [context fetchObjectsForEntity:[self entityName]
                                predicate:predicate sortDescriptors:sortDescriptors];
}

+ (NSUInteger)countDataWithPredicate:(NSPredicate *)predicate
                             context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSError *error = nil;
    return [context countForFetchRequest:request error:&error];
}

+ (NSError*)deleteAll:(NSManagedObjectContext*)context
{
    NSFetchRequest * req = [[NSFetchRequest alloc] init];
    [req setEntity:[NSEntityDescription entityForName:[self entityName]
                               inManagedObjectContext:context]];
    [req setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * objects = [context executeFetchRequest:req error:&error];
    //error handling goes here
    for (NSManagedObject * obj in objects)
    {
        [context deleteObject:obj];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    return error;
}

@end
