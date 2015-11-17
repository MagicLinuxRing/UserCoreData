//
//  JZIMLoginManager.h
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginResultBlock) (NSDictionary *loginResult,NSError *error);

@interface JZIMLoginManager : NSObject

/**
 *  login action
 *
 *  @param userInfo         \userName,password ...
 *  @param resultCompletion \LoginResultBlock
 */
- (void)loginWithUserInfo:(NSDictionary *)userInfo
                         completion:(LoginResultBlock)resultCompletion;

/**
 *  get verify code
 *
 *  @param userInfo         phone number
 *  @param resutlCompletion <#resutlCompletion description#>
 */
- (void)getVerifyCodeWithUserInfo:(NSString *)userInfo
                       completion:(LoginResultBlock)resutlCompletion;

/**
 *  registe user info
 *
 *  @param userInfo         <#userInfo description#>
 *  @param resultCompletion <#resultCompletion description#>
 */
- (void)registeWithUserInfo:(NSDictionary *)userInfo
                 completion:(LoginResultBlock)resultCompletion;

/**
 *  login with visitor
 *
 *  @param userInfo         <#userInfo description#>
 *  @param resutlCompletion <#resutlCompletion description#>
 */
- (void)visitorLoginWithUserInfo:(NSDictionary *)userInfo
                      compleiton:(LoginResultBlock)resutlCompletion;

/**
 *  find the secret of user
 *
 *  @param userInfo         <#userInfo description#>
 *  @param resultCompletion <#resultCompletion description#>
 */
- (void)findSecretWithUserInfo:(NSDictionary *)userInfo
                    completion:(LoginResultBlock)resultCompletion;

@end


