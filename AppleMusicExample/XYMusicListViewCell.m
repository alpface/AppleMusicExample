//
//  XYMusicListViewCell.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/14.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "XYMusicListViewCell.h"

@interface XYMusicListViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *artistNameLabel;

@end

@implementation XYMusicListViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.artistNameLabel];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.artistNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.artistNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.artistNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0].active = YES;
}

- (void)setMusic:(NSDictionary *)music {
    _music = music;
    self.nameLabel.text = [[music objectForKey:@"attributes"] objectForKey:@"name"];
    self.artistNameLabel.text = [[music objectForKey:@"attributes"] objectForKey:@"artistName"];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor purpleColor];
        _nameLabel.numberOfLines = 2.0;
    }
    return _nameLabel;
}

- (UILabel *)artistNameLabel {
    if (!_artistNameLabel) {
        _artistNameLabel = [UILabel new];
        _artistNameLabel.textColor = [UIColor orangeColor];
        _nameLabel.numberOfLines = 2.0;
    }
    return _artistNameLabel;
}
- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
    
    [self setNeedsLayout];
    
    [self layoutIfNeeded];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
    
    CGRect cellFrame = layoutAttributes.frame;
    
    cellFrame.size.height= size.height;
    
    layoutAttributes.frame= cellFrame;
    
    return layoutAttributes;
    
}

@end
