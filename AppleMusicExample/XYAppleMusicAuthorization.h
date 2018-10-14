//
//  XYAppleMusicAuthorization.h
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYAppleMusicAuthorization : NSObject

+ (void)authorizeAppleMusic;

+ (void)requestAppleMusicUserLibrarySongsWithOffset:(NSInteger)offset completion:(void (^)(NSDictionary * _Nullable response, NSInteger nextOffset))completion;
@end

NS_ASSUME_NONNULL_END
