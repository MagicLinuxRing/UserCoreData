//
//  JZSDKHelper.m
//  JZIMSDK
//
//  Created by king jack on 15/10/12.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZSDKHelper.h"

@implementation JZSDKHelper


+ (NSDictionary *)dictionaryFromData:(NSData *)receiveData
{
    NSString *receiveStr = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
    
    NSData * jsonData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:jsonData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    if (!jsonObject) return nil;
    return jsonObject;
}

/* 输出http响应的状态码 */
+ (BOOL)isRequestSussessWithResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = httpResponse.statusCode;
    if (statusCode>=200 && statusCode<300)
    {
        return YES;
    }
    return NO;
}

@end
