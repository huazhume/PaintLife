//
//  MTPaintCategoryController.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTPaintCategoryController.h"
#import "MTMarketHotView.h"
#import <MJRefresh/MJRefresh.h>
#import "MTActivityViewCell.h"
#import "MTNoteDetailViewController.h"
#import "MTPaintItemCell.h"
#import "SPPageMenu.h"
#import "MTPaintController.h"

@interface MTPaintCategoryController () <UICollectionViewDataSource, UICollectionViewDelegate,SPPageMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *totalArray;

@end

@implementation MTPaintCategoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.subTitle;
    [self.tableView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    NSString *identifierString = NSStringFromClass([MTPaintItemCell class]);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MTPaintItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifierString];
    NSArray *paints_plist = @[@"animal_plist",@"msg_plist",@"floral_plist",@"author_plist",@"mandala_plist",@"famous_plist",@"garden_plist",@"dongfang_plist",@"exotic_plist"];
    
    __block NSMutableArray *mu= [NSMutableArray array];
    [paints_plist enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:obj ofType:@"plist"];
        NSMutableDictionary *data= [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        NSArray *datas = [((NSDictionary *)[data objectForKey:@"frames"]) allKeys];
        NSLog(@"%@",datas);
        [mu addObject:datas];
    }];
    
    self.totalArray = [mu copy];
    [self.menuView addSubview:self.pageMenu];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.titleLabel.text = _subTitle;
}

- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

#pragma mark - SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index
{
    self.dataArray = [self.totalArray objectAtIndex:index];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    cell.imageUrl = self.dataArray[indexPath.row];
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
    NSString *imageName = self.dataArray[indexPath.row];
    MTPaintController *paint = [[MTPaintController alloc] init];
    paint.imageName = [imageName substringFromIndex:4];
    [[MTHelp currentNavigation] pushViewController:paint animated:YES];
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.tableView.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return  _collectionView;
}

- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:self.menuView.bounds trackerStyle:SPPageMenuTrackerStyleLineAttachment];
        _pageMenu.bounces = NO;
        _pageMenu.trackerFollowingMode = SPPageMenuTrackerFollowingModeEnd;
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:14];
        _pageMenu.selectedItemTitleColor =[UIColor colorWithHex:0x039369];
        _pageMenu.selectedItemTitleFont = [UIFont boldSystemFontOfSize:14];
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithHex:0x666666];
        _pageMenu.tracker.backgroundColor = [UIColor colorWithHex:0x039369];
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.trackerWidth = 12;
        _pageMenu.bridgeScrollView = self.collectionView;
        [_pageMenu setTrackerHeight:2 cornerRadius:0];
        
         NSArray *items = @[@"动物",@"奇妙物语",@"花朵",@"生活作品",@"曼陀罗",@"现代生活",@"奇妙花园",@"古代东方",@"异国风景"];
        [_pageMenu setItems:items selectedItemIndex:self.index];
    }
    return _pageMenu;
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


