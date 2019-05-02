//
//  MTLaunchCollectionCell.h
//  PaintLife
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLaunchCollectionCell : UICollectionViewCell

@property (copy, nonatomic) NSString *title;

@property (assign, nonatomic) BOOL isHSelected;

+ (CGSize)getSizeWithContent:(NSString *)content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
