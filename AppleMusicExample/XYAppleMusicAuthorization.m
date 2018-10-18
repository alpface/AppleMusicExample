//
//  XYAppleMusicAuthorization.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYAppleMusicAuthorization.h"
@import StoreKit;

@interface XYAppleMusicAuthorization ()

@property (nonatomic, strong) SKCloudServiceController *cloudServiceController;
@property (nonatomic, strong) SKCloudServiceSetupViewController *setUpVC;
@property (nonatomic, copy) NSString *appleMusicDeveloperToken;
@property (nonatomic, copy) NSString *appleMusicUserToken;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy) NSString *appleMusicURLStr;

@end

@implementation XYAppleMusicAuthorization
+ (XYAppleMusicAuthorization *)sharedInstance {
    static XYAppleMusicAuthorization *authController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authController = [[XYAppleMusicAuthorization alloc] init];
    });
    return authController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cloudServiceController = [[SKCloudServiceController alloc] init];
        _setUpVC = [[SKCloudServiceSetupViewController alloc] init];
        NSString *AppleMusicDeviceTokenPath = [[NSBundle mainBundle] pathForResource:@"AppleMusicDeviceToken"
                                                                              ofType:@"json"];
        
        
        if (AppleMusicDeviceTokenPath) {
            NSData *configData = [NSData dataWithContentsOfFile:AppleMusicDeviceTokenPath];
            NSError *err = nil;
            NSDictionary * configDict = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingMutableContainers error:&err];
            _appleMusicDeveloperToken = configDict[@"appleMusicDeviceToken"];
            _appleMusicURLStr = @"https://api.music.apple.com/v1/me/library/songs";
        }
        NSAssert(_appleMusicDeveloperToken, @"apple music device token不能为nil, 参照配置[https://www.jianshu.com/p/17923efa622f]");
        
    }
    return self;
}

+ (void)requestAppleMusicAuthorize {
    switch ([SKCloudServiceController authorizationStatus]) {
        case SKCloudServiceAuthorizationStatusNotDetermined:
            NSLog(@"用户还没有做出选择");
            [[XYAppleMusicAuthorization sharedInstance] appleMusicRequestAuthorization];
            break;
        case SKCloudServiceAuthorizationStatusDenied:
            NSLog(@"用户已经明确拒绝数据的应用程序访问");
            break;
        case SKCloudServiceAuthorizationStatusRestricted:
            NSLog(@"此应用程序没有被授权访问的数据");
            break;
        case SKCloudServiceAuthorizationStatusAuthorized:
            NSLog(@"用户已经授权应用访问数据");
            [[XYAppleMusicAuthorization sharedInstance] appleMusicRequestCapabilities];
            break;
    }
}

- (void)appleMusicRequestAuthorization {
    [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
       if (status == SKCloudServiceAuthorizationStatusAuthorized) {
          NSLog(@"用户允许访问");
          [[XYAppleMusicAuthorization sharedInstance] appleMusicRequestCapabilities];
       }
    }];
}


- (void)appleMusicRequestCapabilities {
    [[XYAppleMusicAuthorization sharedInstance].cloudServiceController
     requestCapabilitiesWithCompletionHandler:
     ^(SKCloudServiceCapability capabilities, NSError * _Nullable error) {
         if (error) {
             NSLog(@"error requesting apple music capability: %@", [error localizedDescription]);
         } else {
             // capabilities is a bit to save space
             if (capabilities == SKCloudServiceCapabilityNone) {
                 NSLog(@"not capable");
             }
             if (capabilities & SKCloudServiceCapabilityMusicCatalogPlayback) {
                 NSLog(@"playback capable");
             }
             if (capabilities & SKCloudServiceCapabilityMusicCatalogSubscriptionEligible) {
                 NSLog(@"subscription eligible capable");
                 [self setUpSubscriptionView];
             }
             if (capabilities & SKCloudServiceCapabilityAddToCloudMusicLibrary) {
                 NSLog(@"addtocloudmusiclibrary capable");
             }
         }
     }];
}

-(void)setUpSubscriptionView {
    NSLog(@"setup subscription view");
    //SKCloudServiceSetupOptionsActionKey : SKCloudServiceSetupActionSubscribe,
    NSDictionary<SKCloudServiceSetupOptionsKey, id> *options = @{SKCloudServiceSetupOptionsActionKey: SKCloudServiceSetupActionSubscribe};
    [[XYAppleMusicAuthorization sharedInstance].setUpVC loadWithOptions:options
                                                              completionHandler:^(BOOL result, NSError * _Nullable error) {
                                                                  NSLog(@"load completion");
                                                                  if(result) {
                                                                      [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:[XYAppleMusicAuthorization sharedInstance].setUpVC animated:YES completion:nil];
                                                                  }
                                                                  if (error) {
                                                                      NSLog(@"error: %@", [error localizedDescription]);
                                                                  }
                                                              }];
}

#pragma mark - Apple Music User Token

+ (void)requestAppleMusicUserTokenWithCompletion:(void(^)(NSString *appleMusicUserToken))completionBlock {
    
    SKCloudServiceController *cloudServiceController = [self sharedInstance].cloudServiceController;
    [cloudServiceController
     requestUserTokenForDeveloperToken:[[self sharedInstance] appleMusicDeveloperToken]  completionHandler:^(NSString * _Nullable userToken, NSError * _Nullable error) {
         if (error) {
             NSLog(@"apple music user token error: %@", [error localizedDescription]);
             [[error userInfo] objectForKey:SKErrorDomain];
             completionBlock(nil);
         } else {
             NSLog(@"user token is %@", userToken);
             completionBlock( userToken);
         }
     }];
}
+ (void)requestOnlineAppleMusicUserLibrarySongsWithOffset:(NSInteger)offset completion:(nonnull void (^)(NSDictionary * _Nullable, NSInteger))completion {
    
    void (^ musicLibaryRequest)(NSString *userToken) = ^(NSString *userToken) {
        NSString *URLString = [self sharedInstance].appleMusicURLStr;
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?offset=%ld", offset]];
        NSString *developerTokenHeader = [NSString stringWithFormat:@"Bearer %@", [self sharedInstance].appleMusicDeveloperToken];
        
       NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
       request.timeoutInterval = 35.0;
        [request setValue:userToken forHTTPHeaderField:@"Music-User-Token"];
        [request setValue:developerTokenHeader forHTTPHeaderField:@"Authorization"];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSError *error = nil;
                    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    //                next = "/v1/me/library/songs?offset=25"
                    NSString *next = jsonObj[@"next"];
                    NSString *offsetStr = [next componentsSeparatedByString:@"offset="].lastObject;
                    NSInteger nextOffset = NSNotFound;
                    if (offsetStr) {
                        nextOffset = [offsetStr integerValue];
                    }
                    if (completion) {
                        completion(jsonObj, nextOffset);
                        return;
                    }
                }
                if (error) {
                    NSLog(@"error is %@", error);
                }
                completion(nil, NSNotFound);
            });
        }];
        [task resume];
        [self sharedInstance].dataTask = task;
    };
    
    if ([self sharedInstance].appleMusicUserToken.length == 0) {
        [self requestAppleMusicUserTokenWithCompletion:musicLibaryRequest];
    }
    else {
        musicLibaryRequest([self sharedInstance].appleMusicUserToken);
    }
}

+ (void)requestOfflineAppleMusicUserLibrarySongsWithCompletion:(void (^)(NSArray * _Nullable))completion {
   MPMediaQuery *mediaQueue = [MPMediaQuery songsQuery];
   //获取本地音乐库文件
   if (completion) {
      completion(mediaQueue.items);
   }
}
@end
