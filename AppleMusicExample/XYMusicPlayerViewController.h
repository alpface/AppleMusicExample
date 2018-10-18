//
//  XYMusicPlayerViewController.h
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MediaPlayer;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface XYMusicPlayerViewController : UIViewController

+ (XYMusicPlayerViewController *)sharedInstance;

/// 系统apple music app
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
/// 播放本地资源
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

/// 播放一首歌曲
- (void)playeWithLocalURL:(NSURL *)assetUrl;

/// 顺序播放多首歌曲，从trackNumber开始播放到最后一首歌
- (void)playWithItems:(NSArray<MPMediaItem *> *)items trackNumber:(NSInteger)trackNumber;

@end

NS_ASSUME_NONNULL_END
