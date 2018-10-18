//
//  XYMusicListViewModel.h
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYMusicListViewModel : NSObject

- (void)newDataArray:(NSArray *)dataArray;
- (void)moewDataArray:(NSArray *)dataArray;

- (instancetype)initWithTableView:(UITableView *)tableView online:(BOOL)isOnline;

@end

NS_ASSUME_NONNULL_END
