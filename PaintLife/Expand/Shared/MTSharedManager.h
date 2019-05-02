//
//  MTSharedManager.h
//  PaintLife
//
//  Created by xiaobai zhang on 2019/5/2.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTSharedManager : NSObject


+ (MTSharedManager *)shareInstance;

- (void)shareImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
