//
//  XYMusicListViewCell.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYMusicListViewCell.h"
#import "UIImageView+WebCache.h"
@import MediaPlayer;

@interface XYMusicListViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *artistNameLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation XYMusicListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.artistNameLabel];
    [self.contentView addSubview:self.iconView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconView .translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-3.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:3.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10.0].active = YES;
}

- (void)setMusicItem:(id)musicItem {
    _musicItem = musicItem;
    if ([musicItem isKindOfClass:[NSDictionary class]]) {
        NSDictionary *attritubes = [musicItem objectForKey:@"attributes"];
        self.nameLabel.text = [attritubes objectForKey:@"name"];
        self.artistNameLabel.text = [attritubes objectForKey:@"artistName"];
        /**
         artwork =         {
         height = 1200;
         url = "https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/21/09/aa/2109aa9d-13e2-b9ff-a209-a33bf97d869b/17UM1IM24651.jpg/{w}x{h}bb.jpeg";
         width = 1200;
         };
         */
        NSDictionary *artwork = attritubes[@"artwork"];
        NSString *imageUrl = artwork[@"url"];
        if (imageUrl.length) {
            // 获取原始宽高
//            CGFloat imageWidth = [artwork[@"width"] doubleValue];
//            CGFloat imageHeight = [artwork[@"height"] doubleValue];
            // 替换url中的宽高
//            NSRange range = [imageUrl rangeOfString:@"{w}" options:NSBackwardsSearch] ;
            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"{w}" withString:@"50"];
            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"{h}" withString:@"50"];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
        else {
            self.iconView.image = nil;
        }
    }
    else if ([musicItem isKindOfClass:[MPMediaItem class]]) {
        MPMediaItem *item = musicItem;
        NSString *musicName = [item valueForKey:MPMediaItemPropertyTitle];
        NSString *musicSinger = [item valueForKey:MPMediaItemPropertyAlbumArtist];
        // 专辑图片
        MPMediaItemArtwork *artwork= [item valueForKey:MPMediaItemPropertyArtwork];
        UIImage *image=[artwork imageWithSize:CGSizeMake(100, 100)];
        
        self.iconView.image = image;
        self.nameLabel.text = musicName;
        self.artistNameLabel.text = musicSinger;
    }
    
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _nameLabel;
}

- (UILabel *)artistNameLabel {
    if (!_artistNameLabel) {
        _artistNameLabel = [UILabel new];
        _artistNameLabel.textColor = [UIColor lightGrayColor];
        _artistNameLabel.numberOfLines = 1;
        _artistNameLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _artistNameLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode = UIViewContentModeScaleToFill;
    }
    return _iconView;
}

@end
