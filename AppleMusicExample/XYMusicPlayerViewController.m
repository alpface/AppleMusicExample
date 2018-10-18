//
//  XYMusicPlayerViewController.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYMusicPlayerViewController.h"

@interface XYMusicPlayerViewController () <AVAudioPlayerDelegate>
/// 当前播放的歌曲序号， 只适应AVAudioPlayer的本地歌曲
@property (nonatomic, assign) NSInteger currentTrackNumber;
@property (nonatomic, strong) NSArray<MPMediaItem *> *localItems;

@end

@implementation XYMusicPlayerViewController

+ (XYMusicPlayerViewController *)sharedInstance {
    static XYMusicPlayerViewController *musicPlayerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlayerVC = [[XYMusicPlayerViewController alloc] init];
    });
    return musicPlayerVC;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /**
         (1)applicationMusicPlayer,
         官方文档注释的意思是:通过applicationMusicPlayer播放的音乐在应用退出后将还原用户的播放状态
         实际效果是:用户退出应用界面后，音乐无法后台播放。
         (2)systemMusicPlayer，
         官方文档注释的意思是:通过systemMusicPlayer播放的音乐将替换用户当前播放音乐的状态。
         实际效果是:用户退出应用界面后，音乐可以后台播放
         并且可以通过苹果自带的功能，在锁屏模式下切换音乐并控制音乐的播放和暂停。
        */
        _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNowPlayingItemDidChange) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:_musicPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMusicPlaybackStateDidChange) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object:_musicPlayer];
    }
    return self;
}

- (void)playeWithLocalURL:(NSURL *)assetUrl {
    NSError *error = nil;
    [_audioPlayer stop];
    _audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:assetUrl error:&error];
    [self.audioPlayer play];
    self.audioPlayer.delegate = self;
    self.audioPlayer.enableRate = YES;
    self.audioPlayer.meteringEnabled = YES;
}

- (void)playWithItems:(NSArray<MPMediaItem *> *)items trackNumber:(NSInteger)trackNumber {
    self.localItems = items;
    self.currentTrackNumber = trackNumber;
    [self.audioPlayer pause];
    NSURL *musicURL = nil;
    MPMediaItem *musicItem = items[self.currentTrackNumber];
    musicURL = [musicItem valueForKey:MPMediaItemPropertyAssetURL];
    if (musicURL) {
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
        [self.audioPlayer play];
        self.audioPlayer.delegate = self;
        self.audioPlayer.enableRate = YES;
        self.audioPlayer.meteringEnabled = YES;
    }
    else {
        [self playNextMusic];
    }
}

- (void)playNextMusic {
    if (self.currentTrackNumber < [self.localItems count] - 1) {
        self.currentTrackNumber ++;
        if (_audioPlayer) {
            [_audioPlayer stop];
            _audioPlayer = nil;
        }
        MPMediaItem *musicItem = self.localItems[self.currentTrackNumber];
        NSURL *musicURL = [musicItem valueForKey:MPMediaItemPropertyAssetURL];
        if (musicURL) {
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:NULL];
            self.audioPlayer.enableRate = YES;
            self.audioPlayer.meteringEnabled = YES;
            self.audioPlayer.delegate = self;
            [self.audioPlayer play];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - MPMusicPlayerController Notifications

- (void)handleNowPlayingItemDidChange {
    if (self.musicPlayer.indexOfNowPlayingItem != NSNotFound) {
        
    } else {
        // no song in music player queue
        NSLog(@"没有歌曲播放");
    }
}

- (void)handleMusicPlaybackStateDidChange {
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStateStopped:
            NSLog(@"音乐播放停止");
            // playlist, song, album ended
            break;
        case MPMusicPlaybackStatePlaying:
            NSLog(@"音乐播放中");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"音乐播放暂停");
            break;
        case MPMusicPlaybackStateInterrupted:
            NSLog(@"音乐播放中断");
            break;
        case MPMusicPlaybackStateSeekingForward:
            NSLog(@"音乐播放寻求前进");
            break;
        case MPMusicPlaybackStateSeekingBackward:
            NSLog(@"音乐播放寻求后退");
            break;
    }
}

#pragma mark  AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self playNextMusic];
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    [self playNextMusic];
}


@end
