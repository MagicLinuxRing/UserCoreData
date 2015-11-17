//
//  JZIMLoginManager.m
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "JZIMLoginManager.h"
#import "JZSDKHelper.h"
#import "MKNetworkKit.h"

#define BASEURL @""
#define LOGINPATH @""
#define REGISTERPATH @""
#define VISTITORLOGINPATH @""
#define GETVERIFYPATH @""
#define FINDSECRETPATH @""

@implementation JZIMLoginManager

- (void)loginWithUserInfo:(NSDictionary *)userInfo
               completion:(LoginResultBlock)resultCompletion
{
    if (![userInfo isKindOfClass:[NSDictionary class]] || !userInfo)
    {
        resultCompletion(nil,nil);
        return;
    }
    
    NSURL *loginUrl = [NSURL URLWithString:[BASEURL stringByAppendingPathComponent:LOGINPATH]];
    [self requestWithUrl:loginUrl bodyContent:nil httpMethod:@"GET" completion:resultCompletion];
}

- (void)registeWithUserInfo:(NSDictionary *)userInfo completion:(LoginResultBlock)resultCompletion
{
    if (![userInfo isKindOfClass:[NSDictionary class]] || !userInfo)
    {
        resultCompletion(nil,nil);
        return;
    }
    
    NSURL *registerUrl = [NSURL URLWithString:[BASEURL stringByAppendingPathComponent:REGISTERPATH]];
    [self requestWithUrl:registerUrl bodyContent:nil httpMethod:@"GET" completion:resultCompletion];
}

- (void)postRequestWithUrl:(NSURL *)url
                  body:(NSData *)bodyContent
            completion:(LoginResultBlock)resultCompletion
{
    if (!url)
    {
        resultCompletion(nil,nil);
        return;
    }
    [self requestWithUrl:url bodyContent:bodyContent httpMethod:@"POST" completion:resultCompletion];
}

- (void)requestWithUrl:(NSURL *)url
           bodyContent:(NSData *)bodyContent
            httpMethod:(NSString *)httpMethod
            completion:(LoginResultBlock)resultCompletion
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = NO;
    sessionConfig.timeoutIntervalForRequest = 15;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] initWithURL:url/*[NSURL URLWithString:[BASEURL stringByAppendingPathComponent:REGISTERPATH]]*/];
    //    NSString *bodyString = [userInfo jsonEncodedKeyValueString];
    //    NSData *body = [NSData dataFromBase64String:bodyString];
    [request setHTTPMethod:httpMethod];
    
    if ([httpMethod isEqualToString:@"POST"])
    {
        [request setHTTPBody:bodyContent];
    }

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response,
                                                                    NSError *error)
                                      {
                                          if ([JZSDKHelper isRequestSussessWithResponse:response])
                                          {
                                              NSDictionary *jsonDic = [JZSDKHelper dictionaryFromData:data];
                                              NSLog(@"%@",jsonDic);
                                              resultCompletion(jsonDic,error);
                                          }
                                          else
                                          {
                                              resultCompletion(nil,error);
                                          }
                                      }];
    [dataTask resume];

}

- (void)getVerifyCodeWithUserInfo:(NSString *)userInfo completion:(LoginResultBlock)resultCompletion
{
    if (![userInfo isKindOfClass:[NSDictionary class]] || !userInfo)
    {
        resultCompletion(nil,nil);
        return;
    }
    
    NSURL *verifyCodeUrl = [NSURL URLWithString:[BASEURL stringByAppendingPathComponent:GETVERIFYPATH]];
    [self requestWithUrl:verifyCodeUrl bodyContent:nil httpMethod:@"GET" completion:resultCompletion];
}

- (void)visitorLoginWithUserInfo:(NSDictionary *)userInfo compleiton:(LoginResultBlock)resultCompletion
{
    if (![userInfo isKindOfClass:[NSDictionary class]] || !userInfo)
    {
        resultCompletion(nil,nil);
        return;
    }
    
    NSURL *vistorUrl = [NSURL URLWithString:[BASEURL stringByAppendingPathComponent:VISTITORLOGINPATH]];
    [self requestWithUrl:vistorUrl bodyContent:nil httpMethod:@"GET" completion:resultCompletion];
}

- (void)findSecretWithUserInfo:(NSDictionary *)userInfo completion:(LoginResultBlock)resultCompletion
{
    if (![userInfo isKindOfClass:[NSDictionary class]] || !userInfo)
    {
        resultCompletion(nil,nil);
        return;
    }
    
    NSURL *findSecretURL = [NSURL URLWithString:[BASEURL stringByAppendingPathComponent:FINDSECRETPATH]];
    [self requestWithUrl:findSecretURL bodyContent:nil httpMethod:@"GET" completion:resultCompletion];
}

@end

















