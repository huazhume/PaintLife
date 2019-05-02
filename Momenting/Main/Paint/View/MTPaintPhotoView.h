//
//  MTPaintPhotoView.h
//  Momenting
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTPaintPhotoViewDelegate <NSObject>

- (void)sharedImage:(UIImage *)image;

@end


@interface MTPaintPhotoView : UIView

@property (weak, nonatomic) id <MTPaintPhotoViewDelegate>delegate;

+ (void)alertShowWithImage:(NSString *)image delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
