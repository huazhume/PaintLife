//
//  UIView+Toast.h
//  Meiyu
//
//  Created by QingyunLiao on 2/17/16.
//  Copyright © 2016 jimeiyibao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MYToastPosition) {
    MYToastPositionBottom,
    MYToastPositionBottomWithTabbar,
    MYToastPositionCenter,
    MYToastPositionTop,
    MYToastPositionFill,
    MYToastPositionAboveKeyboard,
    
    MYToastPositionDefault = MYToastPositionBottom,
};

@interface UIView (TCYToast)

// 展示Toast
- (void)showToastView:(UIView *)toast
             duration:(CGFloat)interval
             position:(MYToastPosition)position;

- (void)showToastView:(UIView *)toast
             duration:(CGFloat)interval
             position:(MYToastPosition)position
             animated:(BOOL)animated;

/**
 *  显示提示视图，视图的位置将使用 toastView 的 frame 值
 *
 *  @param toastView 待显示的提示视图
 *  @param interval  提示视图显示的时间间隔
 *  @param animated  显示时是否带动画
 */
- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             animated:(BOOL)animated;

// 隐藏 Toast
- (void)hideToastView;

- (void)hideToastViewAnimated:(BOOL)animated;

@end

@interface UIView (HudToast)

/**
 * message : 需要显示的文本
 * text : 需要高亮显示的文本
 * color : 高亮文本颜色
 * position: 需要显示的位置
 */
+ (void)showToastInKeyWindow:(NSString *)message;
+ (void)showToastInKeyWindow:(NSString *)message duration:(CGFloat)interval;
+ (void)showToastInKeyWindow:(NSString *)message
                    duration:(CGFloat)interval
                    position:(MYToastPosition)position;

- (void)showToast:(NSString *)message;
- (void)showToast:(NSString *)message
         position:(MYToastPosition)position;
- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)interval
                    position:(MYToastPosition)position;

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color;

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color
         position:(MYToastPosition)position;

@end

