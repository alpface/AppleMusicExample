//
//  XYMusicListViewController.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYMusicListViewController.h"
#import "XYAppleMusicAuthorization.h"
#import "XYMusicListViewCell.h"
#import "XYMusicListViewModel.h"
#import "MJRefresh.h"

@interface XYMusicListViewController ()

@property (nonatomic, strong) XYMusicListViewModel *viewModel;
@property (nonatomic, assign) NSInteger musicOffset;

@end

@implementation XYMusicListViewController

+ (instancetype)sharedInstance {
//    static XYMusicListViewController *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.minimumInteritemSpacing = 10;
//        flowLayout.minimumLineSpacing      = 10;
//        flowLayout.estimatedItemSize = CGSizeMake(60, 60.0);
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        instance = [[XYMusicListViewController alloc] initWithCollectionViewLayout:flowLayout];
//    });
//    return instance;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing      = 10;
    flowLayout.estimatedItemSize = CGSizeMake(60, 60.0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    XYMusicListViewController *vc = [[XYMusicListViewController alloc] initWithCollectionViewLayout:flowLayout];
    return vc;
}

- (void)dealloc {
    
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _viewModel = [XYMusicListViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    self.viewModel.collectionView = self.collectionView;
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [XYAppleMusicAuthorization requestAppleMusicUserLibrarySongsWithOffset:0 completion:^(NSDictionary * _Nonnull response, NSInteger nextOffset) {
            weakSelf.musicOffset = nextOffset;
            NSArray *songsData = [response objectForKey:@"data"];
            [weakSelf.viewModel newDataArray:songsData];
            if (songsData.count && nextOffset != NSNotFound) {
                [weakSelf addFooterRegresh];
            }
            [weakSelf.collectionView.mj_header endRefreshing];
        }];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.collectionView.mj_header beginRefreshing];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = closeItem;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addFooterRegresh {
    if (self.collectionView.mj_footer == nil) {
        // 上拉刷新
        __weak typeof(self) weakSelf = self;
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [XYAppleMusicAuthorization requestAppleMusicUserLibrarySongsWithOffset:weakSelf.musicOffset completion:^(NSDictionary * _Nonnull response, NSInteger nextOffset) {
                weakSelf.musicOffset = nextOffset;
                NSArray *songsData = [response objectForKey:@"data"];
                [weakSelf.viewModel moewDataArray:songsData];
                [weakSelf.collectionView.mj_footer endRefreshing];
                if (nextOffset == NSNotFound) {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }];
    }
    
}


@end
