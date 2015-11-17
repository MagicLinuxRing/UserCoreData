//
//  JZSocketManager.h
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DISCONNECT_SERVER = 0,
    DISCONNECT_USER,
    DISCONNECT_ERROR,
} DISCONNECT_TYPE;

@class GCDAsyncSocket;

@protocol JZIMsocketDelegate;

@interface JZIMSocketManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,strong) GCDAsyncSocket *asynSocket;
@property (nonatomic,copy)   NSString *socketHost;
@property (nonatomic,assign) NSInteger hostPort;

@end

@protocol JZIMsocketDelegate <NSObject>

- (void)socket:(GCDAsyncSocket *)socket didConnectWithHost:(NSString *)host port:(NSInteger)port;

- (void)socket:(GCDAsyncSocket *)socket didDisConnectWithType:(DISCONNECT_TYPE)disConncetType;

- (void)socket:(GCDAsyncSocket *)socket didReceiveMessage:(NSData *)message;

- (void)socket:(GCDAsyncSocket *)socket didSendMessage:(NSData *)message;

@end
