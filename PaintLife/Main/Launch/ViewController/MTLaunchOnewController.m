//
//  MTLaunchOnewController.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTLaunchOnewController.h"
#import "MTMTLaunchTwoController.h"

@interface MTLaunchOnewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MTLaunchOnewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.text = @"由热爱生活的人\n 用 「马克」挑选出来的涂鸦好内容";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goInAction:(id)sender {
    MTMTLaunchTwoController *two = [MTMTLaunchTwoController new];
    
   [self presentViewController:[MTMTLaunchTwoController new] animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
