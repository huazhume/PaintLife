//
//  MTLaunchViewCell.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTLaunchViewCell.h"
#import <Masonry/Masonry.h>
#import "UICollectionViewLeftAlignedLayout.h"
#import "MTLaunchCollectionCell.h"

@interface MTLaunchViewCell ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *sdataArray;


@end

@implementation MTLaunchViewCell

#pragma mark - Public
+ (CGFloat)heightForCellWithCacheArray:(NSArray *)array
{
    __block CGFloat height = 40.f;
    __block CGFloat width =  0.f;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemWidth = [MTLaunchCollectionCell getSizeWithContent:obj maxWidth:SCREEN_WIDTH - 40 customHeight:40].width;
        width += itemWidth;
        if (width > SCREEN_WIDTH - 40) {
            width = 0;
            width += itemWidth;
            height += 40;
        }
    }];
    return height + 30;
}

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initBaseViews];
    }
    return self;
}

#pragma mark - Setter
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray selectTitles:(nonnull NSArray *)selectedArray
{
    _dataArray = dataArray;
    self.sdataArray =selectedArray;
    [self.collectionView reloadData];
}

- (void)initBaseViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self);
        make.trailing.equalTo(self).offset(-20);
    }];
}

#pragma mark - Actions


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTLaunchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTLaunchCollectionCell" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    cell.isHSelected = [self.sdataArray containsObject:cell.title];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lanuchViewCell:)]) {
        [self.delegate lanuchViewCell:self.dataArray[indexPath.row]];
    }
}

#pragma mark - UICollectionViewDelegate
#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArray[indexPath.row];
    return [MTLaunchCollectionCell getSizeWithContent:title maxWidth:SCREEN_WIDTH - 40 customHeight:40];
}

#pragma mark - private


#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:[[UICollectionViewLeftAlignedLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"MTLaunchCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MTLaunchCollectionCell"];
    }
    return _collectionView;
}


@end

