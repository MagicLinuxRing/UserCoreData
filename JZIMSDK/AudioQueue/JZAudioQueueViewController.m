//
//  JZAudioQueueViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/10/19.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZAudioQueueViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"

@interface JZAudioQueueViewController ()<RecordingDelegate,PlayingDelegate>
{
    UIProgressView *_levelMeter;
    UILabel *_consoleLabel;
    UIButton *_recordButton;
    UIButton *_playButton;
}

@property (nonatomic, retain) UIProgressView *levelMeter;

@property (nonatomic,retain)UILabel *consoleLabel;
@property (nonatomic,retain)UIButton *recordButton;
@property (nonatomic,retain)UIButton *playButton;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *filename;
@end

@implementation JZAudioQueueViewController
@synthesize levelMeter = _levelMeter;
@synthesize consoleLabel = _consoleLabel;
@synthesize playButton = _playButton;
@synthesize recordButton = _recordButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addUI];
    
    [self addObserver:self forKeyPath:@"isRecording" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    self.title = @"Speex";
    
    self.levelMeter.progress = 0;
    
    self.consoleLabel.numberOfLines = 0;
    self.consoleLabel.text = @"A demo for recording and playing speex audio.";
    
    [self.recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"isRecording"];
    [self removeObserver:self forKeyPath:@"isPlaying"];
}

- (void)addUI
{
    _levelMeter = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 60, SCREENFRAME_SIZE_WIDTH, 1)];
    _levelMeter.progressTintColor = [UIColor  greenColor];
    _levelMeter.trackTintColor = [UIColor redColor];
    [self.view addSubview:_levelMeter];
    
    _consoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREENFRAME_SIZE_WIDTH, 30)];
    _consoleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    _consoleLabel.textColor = [UIColor lightGrayColor];
    _consoleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_consoleLabel];
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 40)];
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_recordButton setTitleColor:BGCOLOR forState:UIControlStateHighlighted];
    [_recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 60, 40)];
    [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    [_playButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_playButton setTitleColor:BGCOLOR forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isRecording"]) {
        [self.recordButton setTitle:(self.isRecording ? @"停止录音" : @"录音") forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"isPlaying"]) {
        [self.playButton setTitle:(self.isPlaying ? @"停止播放" : @"播放") forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recordButtonClicked:(id)sender {
    if (self.isPlaying) {
        return;
    }
    if ( ! self.isRecording) {
        self.isRecording = YES;
        self.consoleLabel.text = @"正在录音";
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecording];
    }
    else {
        self.isRecording = NO;
        [[RecorderManager sharedManager] stopRecording];
    }
}

- (void)playButtonClicked:(id)sender {
    if (self.isRecording) {
        return;
    }
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        
        self.isPlaying = YES;
        self.consoleLabel.text = [NSString stringWithFormat:@"正在播放: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]];
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}

#pragma mark - Recording & Playing Delegate

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    self.levelMeter.progress = 0;
    self.filename = filePath;
    [self.consoleLabel performSelectorOnMainThread:@selector(setText:)
                                        withObject:[NSString stringWithFormat:@"录音完成: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]]
                                     waitUntilDone:NO];
}

- (void)recordingTimeout {
    self.isRecording = NO;
    self.consoleLabel.text = @"录音超时";
}

- (void)recordingStopped {
    self.isRecording = NO;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    self.consoleLabel.text = @"录音失败";
}

- (void)levelMeterChanged:(float)levelMeter {
    self.levelMeter.progress = levelMeter;
}

- (void)playingStoped {
    self.isPlaying = NO;
    self.consoleLabel.text = [NSString stringWithFormat:@"播放完成: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]];
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
