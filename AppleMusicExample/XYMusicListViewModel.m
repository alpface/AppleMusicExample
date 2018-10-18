//
//  XYMusicListViewModel.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYMusicListViewModel.h"
#import "XYAppleMusicAuthorization.h"
#import "XYMusicListViewCell.h"
#import "XYMusicPlayerViewController.h"

@interface XYMusicListViewModel () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL isOnline;

@end

@implementation XYMusicListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [XYAppleMusicAuthorization requestAppleMusicAuthorize];
        
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView online:(BOOL)isOnline {
    if (self = [self init]) {
        self.tableView = tableView;
        self.isOnline = isOnline;
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [tableView registerClass:[XYMusicListViewCell class] forCellReuseIdentifier:@"XYMusicListViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)newDataArray:(NSArray *)dataArray {
    [self.list removeAllObjects];
    [self.list addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

- (void)moewDataArray:(NSArray *)dataArray {
    [self.list addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYMusicListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYMusicListViewCell" forIndexPath:indexPath];
    id musicItem = self.list[indexPath.row];
    cell.musicItem = musicItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id musicItem = self.list[indexPath.row];
    
    XYMusicPlayerViewController *musicPlayerVC = [XYMusicPlayerViewController sharedInstance];
    [musicPlayerVC.musicPlayer pause];
    
//    musicPlayerVC.musicPlayer.volume = 0.1;
    
    if (self.isOnline == NO) { // 播放apple music本地的歌曲
        // 申明一个Collection便于下面给MusicPlayer赋值
//        MPMediaItemCollection *mediaItemCollection;
//        // 将音乐信息赋值给musicPlayer
//        mediaItemCollection = [[MPMediaItemCollection alloc] initWithItems:[self.list copy]];
//        [musicPlayerVC.musicPlayer setQueueWithItemCollection:mediaItemCollection];
//        [musicPlayerVC.musicPlayer play];
        
        /// 从当前index 顺序播放全部
        [[XYMusicPlayerViewController sharedInstance] playWithItems:self.list trackNumber:indexPath.row];
    }
    else { // 播放apple music cloud 中的歌曲
        NSString *musicId = [musicItem objectForKey:@"id"];
        [musicPlayerVC.musicPlayer setQueueWithStoreIDs:@[musicId]];
        [musicPlayerVC.musicPlayer
         prepareToPlayWithCompletionHandler:^(NSError * _Nullable error) {
             if (error) {
                 NSLog(@"error is %@", error);
             } else {
                 [musicPlayerVC.musicPlayer play];
                 NSLog(@"now playing item: %@ %@ %f", musicPlayerVC.musicPlayer.nowPlayingItem.title, musicPlayerVC.musicPlayer.nowPlayingItem.artist, musicPlayerVC.musicPlayer.nowPlayingItem.playbackDuration);
             }
         }];
    }
    
}



////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////
- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

@end
