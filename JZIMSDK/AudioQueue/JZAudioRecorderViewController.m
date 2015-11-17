//
//  JZAudioRecorderViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/10/13.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZAudioRecorderViewController.h"
#import "UIView+MJExtension.h"
#import "JZAudioQueueManager.h"

@interface JZAudioRecorderViewController ()<AVAudioPlayerDelegate>
{
    JZAudioQueueManager *_audioQueueManager;
    AVAudioPlayer       *_audioPlayer;
}
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation JZAudioRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _audioQueueManager = [JZAudioQueueManager shareInstance];
    
    [self createAudioButton];
    
//    [self timer];
}

- (void)createAudioButton
{
    UIButton *recorderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recorderButton.frame = CGRectMake(10, 100, 40, 40);
    [recorderButton addTarget:self action:@selector(recorder:) forControlEvents:UIControlEventTouchUpInside];
    recorderButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:recorderButton];
    
    UIButton *stopRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    stopRecord.frame = CGRectMake(40+60, 100, 40, 40);
    [stopRecord addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    stopRecord.backgroundColor = [UIColor redColor];
    [self.view addSubview:stopRecord];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(40*3+40, 100, 40, 40);
    [playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    playButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:playButton];
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer
{
    if (!_timer)
    {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f
                                                target:self
                                              selector:@selector(audioPowerChange)
                                              userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [_audioQueueManager.audioRecorder updateMeters];//更新测量值
    float power= [_audioQueueManager.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    NSLog(@"%f",progress);
//    [_audioQueueManager.audioPower setProgress:progress];
}


- (void)recorder:(UIButton *)button
{
    if (![_audioQueueManager.audioRecorder isRecording]) {
        [_audioQueueManager.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
//        self.timer.fireDate=[NSDate distantPast];
    }
}

- (void)stopRecord:(UIButton *)button
{
    if ([_audioQueueManager.audioRecorder isRecording]) {
        [_audioQueueManager.audioRecorder stop];
//        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer)
    {
        NSURL *url=[_audioQueueManager getSavePath];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        //设置后台播放模式
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}

-(void)routeChange:(NSNotification *)notification
{
}

/**
 *  播放音频
 */
-(void)play
{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
//        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}

/**
 *  暂停播放
 */
-(void)pause
{
    if ([self.audioPlayer isPlaying])
    {
        [self.audioPlayer pause];
    }
}

- (void)playClick:(UIButton *)button
{
    [self play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
