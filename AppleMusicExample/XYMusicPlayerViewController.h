//
//  XYMusicPlayerViewController.h
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MediaPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface XYMusicPlayerViewController : UIViewController

+ (XYMusicPlayerViewController *)sharedInstance;

/// 系统apple music app
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

@end

NS_ASSUME_NONNULL_END
