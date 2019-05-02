//
//  MTMTLaunchTwoController.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTMTLaunchTwoController.h"
#import "MTLaunchViewCell.h"
#import "MTMarketHotView.h"
#import <MJRefresh/MJRefresh.h>


@interface MTMTLaunchTwoController ()<UITableViewDelegate,UITableViewDataSource,MTLaunchViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSMutableArray *selectedTitles;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end

@implementation MTMTLaunchTwoController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.contentView addSubview:self.tableView];
    [self.button setBackgroundColor:[UIColor colorWithHex:0x999999]];
    [self loadData];
    
    self.headerHeight.constant = self.isNote ? 80 : 0.f;
    self.button.hidden = self.isNote;
}

- (void)loadData {
    self.dataList = [@[@[@"中国画",@"油画",@"版画",@"水粉画",@"水彩画",@"铅笔画",@"木炭画",@"钢笔画"],@[@"架上绘画",@"壁画"],@[@"卡宗教画",@"历史画",@"风俗画",@"人物画",@"肖像画",@"人体画",@"风景画",@"静物画"],@[@"年画",@"宣传画",@"电影广告画",@"商业广告画",@"电影动画",@"装饰画",@"建筑画",@"书籍画",@"漫画"],@[@"东方文化",@"西方文化"]] mutableCopy];

    self.titles = @[@"绘画工具",@"绘画形式",@"对象分类",@"绘画用途",@"绘画文化"];
    self.selectedTitles = [NSMutableArray array];
}

- (void)lanuchViewCell:(NSString *)title
{
    if (self.isNote) {
        [self.selectedTitles removeAllObjects];
        [self.selectedTitles addObject:title];
        [self.tableView reloadData];
        return;
    }
    
    
    if ([self.selectedTitles containsObject:title]) {
        [self.selectedTitles removeObject:title];
    } else {
         [self.selectedTitles addObject:title];
    }
    
    
    [self.tableView reloadData];
    
    NSInteger index = self.selectedTitles.count;
    NSString *titless = !index ? @"跳过" : @"开始体验吧";
    [self.button setTitle:titless forState:UIControlStateNormal];
//    self.button.enabled = index;
    
    [self.button setBackgroundColor:!index ? [UIColor colorWithHex:0x999999] : [UIColor blackColor]];
}
- (IBAction)dis:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)sava:(id)sender {
    
    if (!self.selectedTitles.count) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择一个爱好吧" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    __weak typeof(self)welkSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        if (welkSelf.block) {
            welkSelf.block();
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionViewWithIndex:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MTLaunchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MTLaunchViewCell getIdentifier]];
    [cell setDataArray:self.dataList[indexPath.section] selectTitles:self.selectedTitles];
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MTLaunchViewCell heightForCellWithCacheArray:self.dataList[indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}


//#pragma mark - Setter && Getter
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 0) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [self headerView];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MTLaunchViewCell class] forCellReuseIdentifier:[MTLaunchViewCell getIdentifier]];
    }
    return _tableView;
}

- (UIView *)sectionViewWithIndex:(NSInteger)index
{
    
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 20)];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.text = self.titles[index];
    label.textColor = [UIColor colorWithHex:0x333333];
    [sectionView addSubview:label];
    return sectionView;
}

- (UIView *)headerView
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80 + iPhoneTopMargin)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30 + iPhoneTopMargin, SCREEN_WIDTH - 40, 40)];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.numberOfLines = 2;
    label.text = self.isNote ? @"选择你内容相符的模块" : @"你喜欢什么...";
    label.textColor = [UIColor colorWithHex:0x333333];
    [sectionView addSubview:label];
    return sectionView;
}

- (IBAction)bottomAction:(id)sender {
    
    UIViewController * presentingViewController = self.presentingViewController;
    while (presentingViewController.presentingViewController) {
        presentingViewController = presentingViewController.presentingViewController;
    }
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
}


@end
