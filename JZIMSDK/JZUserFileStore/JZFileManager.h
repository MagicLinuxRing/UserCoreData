//
//  JZFileManager.h
//  JZIMSDK
//
//  Created by king jack on 15/10/9.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZFileManager : NSObject

+ (instancetype)shareInstance;

- (NSString *)fileBasePath;

/**
 *  根据用户名建立个人的文件夹
 *
 *  @param fileName userName
 *
 *  @return full base path
 */
- (NSString *)createFileWithName:(NSString *)userName;

- (NSString *)currentUserFileFullPath;

- (void)deleteFileWithName:(NSString *)fileName;

@end
