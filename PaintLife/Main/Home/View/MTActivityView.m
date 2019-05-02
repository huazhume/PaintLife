
//
//  MTActivityView.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/4/13.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTActivityView.h"
#import <MJRefresh/MJRefresh.h>
#import "MTHomePaintViewCell.h"
#import "MTNoteDetailViewController.h"
#import "MTMediaFileManager.h"
#import "UIImage+ImageCompress.h"

@interface MTActivityView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSTimer *marketTimer;
@property (nonatomic, assign) NSInteger totalTimes;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MTActivityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self);
    }];
    
    self.dataArray = [NSMutableArray array];
    
    __block NSMutableArray *mu = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0,0),  ^{
        NSArray *paints_plist = @[@"animal_plist",@"msg_plist",@"floral_plist",@"author_plist",@"mandala_plist",@"famous_plist",@"garden_plist",@"dongfang_plist",@"exotic_plist"];
        [paints_plist enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:obj ofType:@"plist"];
            NSMutableDictionary *data= [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
            
            NSArray *datas = [((NSDictionary *)[data objectForKey:@"frames"]) allKeys];
            NSLog(@"%@",datas);
            [mu addObject:datas];
            
            [datas enumerateObjectsUsingBlock:^(NSString *imageUrl, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *path = [[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGEBATE_TYPE];
                NSString *beta_path = [NSString stringWithFormat:@"%@/%@",path,imageUrl];
                if (![fileManager fileExistsAtPath:beta_path]) {
                    NSString *imagePath = [imageUrl substringFromIndex:4];
                    UIImage *image = [UIImage compressImage:[UIImage imageNamed:imagePath] compressRatio:0.001];
                    NSData *beta_data = nil;
                    if (UIImagePNGRepresentation(image) == nil) {
                        beta_data = UIImageJPEGRepresentation(image, 1.0);
                    } else {
                        beta_data = UIImagePNGRepresentation(image);
                    }
                    [fileManager createFileAtPath:beta_path contents:beta_data attributes:nil];
                }
            }];
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = mu;
            [self.tableView reloadData];
        });
    });
   
    
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
    self.tableView.mj_header = header;
    
}


- (void)dealloc
{
    [self cleanTimer];
}


- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTHomePaintViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MTHomePaintViewCell getIdentifier]];
    
    NSArray *items = @[@"动物",@"奇妙物语",@"花朵",@"生活作品",@"曼陀罗",@"现代生活",@"奇妙花园",@"古代东方",@"异国风景"];
    [cell setTitle:items[indexPath.row]];
    [cell setPageArray:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 197.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - Timer
//添加定时器
-(void)addTimer{
    [[NSRunLoop currentRunLoop] addTimer:self.marketTimer forMode:NSRunLoopCommonModes];
}

- (void)timerAction:(id)sender
{
    self.totalTimes ++;
    [self.hotView switchCurrentBanner];
}

//删除定时器
-(void)cleanTimer{
    
    if (_marketTimer) {
        [_marketTimer invalidate];
        _marketTimer = nil;
    }
}

-(void)pauseTimer{
    
    if (_marketTimer) {
        _marketTimer.fireDate = [NSDate distantFuture];
    }
}
//继续定时器
- (void)continueTimer {
    if (_marketTimer) {
        _marketTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
    }
}



#pragma mark - Lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.hotView;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"MTHomePaintViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTHomePaintViewCell getIdentifier]];
        
    }
    return _tableView;
}

- (MTMarketHotView *)hotView
{
    if (!_hotView) {
        _hotView = [[MTMarketHotView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        [_hotView setDataArray:nil];
    }
    return _hotView;
}

- (NSTimer *)marketTimer
{
    if (!_marketTimer) {
        _marketTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    return _marketTimer;
}

@end
