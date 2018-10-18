//
//  XYMusicPlayerViewController.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYMusicPlayerViewController.h"

@interface XYMusicPlayerViewController ()

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
        _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNowPlayingItemDidChange) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:_musicPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMusicPlaybackStateDidChange) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object:_musicPlayer];
    }
    return self;
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


@end
