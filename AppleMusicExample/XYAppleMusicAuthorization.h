//
//  XYAppleMusicAuthorization.h
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface XYAppleMusicAuthorization : NSObject

+ (void)requestAppleMusicAuthorize;

+ (void)requestOnlineAppleMusicUserLibrarySongsWithOffset:(NSInteger)offset completion:(void (^)(NSDictionary * _Nullable response, NSInteger nextOffset))completion;

+ (void)requestOfflineAppleMusicUserLibrarySongsWithCompletion:(void (^)(NSArray<MPMediaItem *> * _Nullable musicList))completion;
@end

NS_ASSUME_NONNULL_END
