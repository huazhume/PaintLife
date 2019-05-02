//
//  MTPaintWorksView.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTPaintWorksView.h"
#import <Masonry/Masonry.h>
#import "MTPaintItemCell.h"
#import "MTPaintController.h"
#import "MTPaintCategoryController.h"
#import "MTPaintPhotoView.h"

@interface MTPaintWorksView ()<UICollectionViewDataSource, UICollectionViewDelegate,MTPaintPhotoViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSMutableArray *pageArray;

@end

@implementation MTPaintWorksView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTPaintWorksView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

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
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    NSString *identifierString = NSStringFromClass([MTPaintItemCell class]);
    _collectionView.backgroundColor = [UIColor whiteColor];
    //    [_collectionView registerClass:[MTPaintItemCell class] forCellWithReuseIdentifier:identifierString];
    [_collectionView registerNib:[UINib nibWithNibName:@"MTPaintItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifierString];
    
    self.pageArray = [NSMutableArray array];
    for (int i = 1; i < 18 ; i ++) {
        NSString *string = [NSString stringWithFormat:@"works_%d.jpeg",i];
        [self.pageArray addObject:string];
    }
    [self.collectionView reloadData];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    NSMutableArray *muImage = [NSMutableArray array];
    for (int i = 1 ; i < 34 ; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%d",i]];
        [muImage addObject:image];
    }
    // 设置普通状态的动画图片
    [header setImages:muImage forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:muImage forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:muImage forState:MJRefreshStateRefreshing];
    // 设置header
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.collectionView.mj_header = header;
}

- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
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
    cell.webUrl = self.pageArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 30)/2.0, (SCREEN_WIDTH - 30)/2.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MTPaintPhotoView alertShowWithImage:self.pageArray[indexPath.row] delegate:self];
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
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, CGRectGetHeight(self.bgView.bounds)) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return  _collectionView;
}

- (void)sharedImage:(UIImage *)image
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedImage:)]) {
        [self.delegate sharedImage:image];
    }
}

@end



