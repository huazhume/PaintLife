//
//  MTMyPaintViewCell.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/5/2.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTMyPaintViewCell.h"
#import <Masonry/Masonry.h>
#import "MTPaintItemCell.h"
#import "MTPaintController.h"
#import "MTPaintCategoryController.h"


@interface MTMyPaintViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MTMyPaintViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initBaseViews];
    
}

- (void)initBaseViews
{
    
    [self.bgView addSubview:self.collectionView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    NSString *identifierString = NSStringFromClass([MTPaintItemCell class]);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MTPaintItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifierString];
}

- (void)setPageArray:(NSMutableArray *)pageArray
{
    _pageArray = pageArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用
    NSString *identifierString = NSStringFromClass([MTPaintItemCell class]);
    MTPaintItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierString forIndexPath:indexPath];
    
    
    NSArray *colors = @[[UIColor colorWithHex:0x96B46C],[UIColor colorWithHex:0xE48370],[UIColor colorWithHex:0xC496C5],[UIColor colorWithHex:0x79B47C],[UIColor colorWithHex:0xA299CE],[UIColor colorWithHex:0xA2AEBB] ];
    UIColor *color = (UIColor *)(colors[indexPath.row % colors.count]);
    cell.layer.borderColor = (color).CGColor;
    cell.layer.borderWidth = 1;
    
    //    self.titleLabel.textColor = (UIColor *)(colors[indexPath.section % colors.count]);
    cell.fileName = self.pageArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetHeight(self.bgView.frame), CGRectGetHeight(self.bgView.frame));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}
- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = self.pageArray[indexPath.row];
    
    MTPaintController *paint = [[MTPaintController alloc] init];
    paint.imageFileName = imageName;
    
    [[MTHelp currentNavigation] pushViewController:paint animated:YES];
    
//    [MTPaintPhotoView alertShowWithImage:self.pageArray[indexPath.row]];
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, CGRectGetHeight(self.bgView.bounds)) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return  _collectionView;
}

@end


