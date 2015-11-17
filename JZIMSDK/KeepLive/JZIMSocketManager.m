//
//  JZSocketManager.m
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "JZIMSocketManager.h"
#import "GCDAsyncSocket.h"

@interface JZIMSocketManager()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_asynSocket;
}

@end

@implementation JZIMSocketManager
@synthesize asynSocket = _asynSocket;

+ (instancetype)shareInstance
{
    static JZIMSocketManager *socketManager = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        socketManager = [[JZIMSocketManager alloc] init];
    });
    return socketManager;
}

- (GCDAsyncSocket *)asynSocket
{
    return [self createAsynSocket];
}

- (GCDAsyncSocket *)createAsynSocket
{
    if (!_asynSocket)
    {
        _asynSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                 delegateQueue:dispatch_get_main_queue()];
        _asynSocket.delegate = self;
    }
    return _asynSocket;
}

- (BOOL)isConnectedSocket
{
    if (![_asynSocket isConnected])
    {
        return [self connectAsynSocketWithIP:self.socketHost port:self.hostPort];
    }
    return YES;
}

- (BOOL)connectAsynSocketWithIP:(NSString *)ipAddress port:(NSInteger)port
{
    NSError *error;
    if (![_asynSocket connectToHost:ipAddress onPort:port
                        withTimeout:SOCKET_TIMEOUT error:&error])
    {
        NSLog(@"%@",error);
        return NO;
    }
    return YES;
}

#pragma mark - GCDAsynSocket delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}



@end




