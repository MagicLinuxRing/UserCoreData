//
//  JZAudioQueueManager.h
//  JZIMSDK
//
//  Created by king jack on 15/10/13.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define kRecordAudioFile @"myRecord.caf"

@interface JZAudioQueueManager : NSObject

+ (instancetype)shareInstance;

-(void)setAudioSession;

-(NSURL *)getSavePath;

@property(nonatomic,retain) AVAudioRecorder *audioRecorder;
@property(nonatomic,retain) AVAudioPlayer   *audioPlayer;

@end
