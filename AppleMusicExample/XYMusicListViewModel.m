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

@interface XYMusicListViewModel () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation XYMusicListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [XYAppleMusicAuthorization authorizeAppleMusic];
        
    }
    return self;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
     [self.collectionView registerClass:[XYMusicListViewCell class] forCellWithReuseIdentifier:@"XYMusicListViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)newDataArray:(NSArray *)dataArray {
    [self.list removeAllObjects];
    [self.list addObjectsFromArray:dataArray];
    [self.collectionView reloadData];
}

- (void)moewDataArray:(NSArray *)dataArray {
    [self.list addObjectsFromArray:dataArray];
    [self.collectionView reloadData];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYMusicListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYMusicListViewCell" forIndexPath:indexPath];
    NSDictionary *music = self.list[indexPath.row];
    cell.music = music;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *appleMusicUserLibrarySong = self.list[indexPath.row];
    NSString *songUserLibraryID = [appleMusicUserLibrarySong objectForKey:@"id"];
    NSLog(@"user library storeID is %@", songUserLibraryID);
    
    XYMusicPlayerViewController *musicPlayerVC = [XYMusicPlayerViewController sharedInstance];
    [musicPlayerVC.musicPlayer pause];
    [musicPlayerVC.musicPlayer setQueueWithStoreIDs:@[songUserLibraryID]];
    musicPlayerVC.musicPlayer.volume = 0.1;
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
// 当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/// 高亮时设置颜色
- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor grayColor]];
}

/// 正常状态时设置颜色
- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
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
