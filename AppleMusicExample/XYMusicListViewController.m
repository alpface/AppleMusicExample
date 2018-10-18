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
@property (nonatomic, assign) BOOL isOnline;

@end

@implementation XYMusicListViewController

- (void)dealloc {
    
}

- (instancetype)initWithOnline:(BOOL)isOnline {
    if (self = [super init]) {
        self.isOnline = isOnline;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.viewModel = [[XYMusicListViewModel alloc] initWithTableView:self.tableView online:self.isOnline];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isOnline) {
            [XYAppleMusicAuthorization requestOnlineAppleMusicUserLibrarySongsWithOffset:0 completion:^(NSDictionary * _Nonnull response, NSInteger nextOffset) {
                weakSelf.musicOffset = nextOffset;
                NSArray *songsData = [response objectForKey:@"data"];
                [weakSelf.viewModel newDataArray:songsData];
                if (songsData.count && nextOffset != NSNotFound) {
                    [weakSelf addFooterRegresh];
                }
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        }
        else {
            [XYAppleMusicAuthorization requestOfflineAppleMusicUserLibrarySongsWithCompletion:^(NSArray<MPMediaItem *> * _Nullable musicList) {
                /// 本地音乐不需要上拉加载
                [weakSelf.viewModel newDataArray:musicList];
                [weakSelf.tableView.mj_header endRefreshing];
                weakSelf.tableView.mj_footer = nil;
            }];
        }
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = closeItem;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addFooterRegresh {
    if (self.tableView.mj_footer == nil) {
        // 上拉刷新
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [XYAppleMusicAuthorization requestOnlineAppleMusicUserLibrarySongsWithOffset:weakSelf.musicOffset completion:^(NSDictionary * _Nonnull response, NSInteger nextOffset) {
                weakSelf.musicOffset = nextOffset;
                NSArray *songsData = [response objectForKey:@"data"];
                [weakSelf.viewModel moewDataArray:songsData];
                [weakSelf.tableView.mj_footer endRefreshing];
                if (nextOffset == NSNotFound) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }];
    }
    
}

@end
