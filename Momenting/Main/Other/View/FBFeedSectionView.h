//
//  FBFeedSectionView.h
//  finbtc
//
//  Created by xiaobai zhang on 2019/1/16.
//  Copyright © 2019 MTY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FBFeedSectionViewDelegate <NSObject>

@optional

//点击说明
- (void)marketSectionInfomationAction;

//电击更多
- (void)marketSectionMoreAction;

@end

@interface FBFeedSectionView : UIView

@property (weak, nonatomic) id <FBFeedSectionViewDelegate> delegate;

//是否显示说明按钮 默认隐藏
@property (assign, nonatomic) BOOL isShowInfomation;

/**
 赋值
 @param title 标题
 @param desc 右侧更多按钮描述
 */
- (void)setTitle:(NSString *)title desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
