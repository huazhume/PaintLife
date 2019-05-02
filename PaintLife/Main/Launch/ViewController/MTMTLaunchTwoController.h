//
//  MTMTLaunchTwoController.h
//  PaintLife
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveBlock)(void);

@interface MTMTLaunchTwoController : UIViewController

@property (assign, nonatomic) BOOL isNote;

@property (copy, nonatomic) SaveBlock block;

@end

NS_ASSUME_NONNULL_END
