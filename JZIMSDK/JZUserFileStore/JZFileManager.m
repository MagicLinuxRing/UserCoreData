//
//  JZFileManager.m
//  JZIMSDK
//
//  Created by king jack on 15/10/9.
//  Copyright © 2015年 kingJ. All rights reserved.
//
/****************************   warning  ******************************
    fileBasePath   Document/userName/...
*/

#import "JZFileManager.h"

@implementation JZFileManager

+ (instancetype)shareInstance
{
    static JZFileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[JZFileManager alloc] init];
    });
    return fileManager;
}

- (NSString *)fileBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)currentUserFileFullPath
{
    //userName instead of @"1"
    return [self createFileWithName:@"1"];
}


- (NSString *)createFileWithName:(NSString *)userName
{
    NSString *fullPath = [[self fileBasePath] stringByAppendingPathComponent:userName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *createDirectoryError;
    BOOL *isDirectory = false;
    BOOL isExistDirectory = [fileManager fileExistsAtPath:fullPath isDirectory:isDirectory];
    
    if (!(isExistDirectory && isDirectory))
    {
        [fileManager createDirectoryAtPath:fullPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&createDirectoryError];
        if (createDirectoryError)
        {
            NSLog(@"createDirectoryError:%@",createDirectoryError);
            return nil;
        }
    }
    return fullPath;
}

- (void)deleteFileWithName:(NSString *)fileName
{
    NSString *fileFullPath = [[self fileBasePath] stringByAppendingString:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager contentsOfDirectoryAtPath:fileFullPath error:nil]) return;
    
    [manager removeItemAtPath:fileFullPath error:nil];
}


@end
