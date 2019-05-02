//
//  MTPaintWorksView.h
//  Momenting
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTPaintWorksViewDelegate <NSObject>

- (void)sharedImage:(UIImage *)image;

@end

@interface MTPaintWorksView : UIView

+ (instancetype)loadFromNib;

@property (weak, nonatomic) id <MTPaintWorksViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
