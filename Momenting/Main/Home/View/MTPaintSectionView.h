//
//  MTPaintSectionView.h
//  Momenting
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTPaintSectionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
