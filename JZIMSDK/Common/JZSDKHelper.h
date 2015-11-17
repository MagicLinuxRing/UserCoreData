//
//  JZSDKHelper.h
//  JZIMSDK
//
//  Created by king jack on 15/10/12.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZSDKHelper : NSObject

/**
 *  request data for transfer
 *
 *  @param receiveData requst data
 *
 *  @return json
 */
+ (NSDictionary *)dictionaryFromData:(NSData *)receiveData;

/**
 *  check respose status
 *
 *  @param response response
 *
 *  @return BOOL
 */
+ (BOOL)isRequestSussessWithResponse:(NSURLResponse *)response;

@end
