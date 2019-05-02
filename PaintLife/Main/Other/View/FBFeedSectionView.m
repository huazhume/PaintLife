//
//  FBFeedSectionView.m
//  finbtc
//
//  Created by xiaobai zhang on 2019/1/16.
//  Copyright © 2019 MTY. All rights reserved.
//

#import "FBFeedSectionView.h"
#import "Masonry.h"


@interface FBFeedSectionView ()
//标题
@property (strong, nonatomic) UILabel *titleLabel;
//说明button
@property (strong, nonatomic) UIButton *infomationButton;

//更多
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIImageView *moreImageView;
@property (strong, nonatomic) UILabel *moreLabel;


@end

@implementation FBFeedSectionView


+ (CGFloat)heightForView
{
    return 40;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseViews];
    }
    return self;
}

#pragma mark - initBaseViews
- (void)initBaseViews
{
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.moreImageView];
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-11);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.infomationButton];
    [self.infomationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(0);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [self addSubview:self.moreLabel];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.moreImageView.mas_leading).offset(-4);
    }];
}

#pragma mark - setter
/**
 赋值
 @param title 标题
 @param desc 右侧更多按钮描述
 */
- (void)setTitle:(NSString *)title desc:(NSString *)desc
{
    self.titleLabel.text = title;
    self.moreLabel.text = desc;
    
}

- (void)setIsShowInfomation:(BOOL)isShowInfomation
{
    self.infomationButton.hidden = !isShowInfomation;
}

#pragma mark - Actions
- (void)moreButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(marketSectionMoreAction)]) {
        [self.delegate marketSectionMoreAction];
    }
}

- (void)informationButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(marketSectionInfomationAction)]) {
        [self.delegate marketSectionInfomationAction];
    }
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];;
        _titleLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    return _titleLabel;
}


- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.backgroundColor = [UIColor clearColor];
        [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIImageView *)moreImageView
{
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] init];
        _moreImageView.image = [UIImage imageNamed:@"mine_arrow"];
    }
    return _moreImageView;
}

- (UILabel *)moreLabel
{
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.font = [UIFont systemFontOfSize:11];
        _moreLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    return _moreLabel;
}


@end


