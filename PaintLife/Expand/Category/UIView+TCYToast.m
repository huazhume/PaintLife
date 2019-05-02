//
//  UIView+Toast.m
//  Meiyu
//
//  Created by QingyunLiao on 2/17/16.
//  Copyright © 2016 jimeiyibao. All rights reserved.
//

#import "UIView+TCYToast.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "MYHudToastView.h"


static const CGFloat VerticalPadding = 44.0;
static char kToastViewTapBlock;
static char kToastViewCompletionBlock;
static char kToastViewTapGestureRecognizer;
static char kToastViewTag;

@interface TapGestureRecognizerDelegateImpl : NSObject <UIGestureRecognizerDelegate>

+ (instancetype)sharedDelegateImpl;

@end

@implementation TapGestureRecognizerDelegateImpl

+ (instancetype)sharedDelegateImpl
{
    static TapGestureRecognizerDelegateImpl *sharedDelegateImpl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegateImpl = [[self alloc] init];
    });

    return sharedDelegateImpl;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

@interface UIView (SetGetToast) <UIGestureRecognizerDelegate>

@end

@implementation UIView (SetGetToast)

#pragma mark - Action Handle

- (void)onToastViewTap:(UIGestureRecognizer *)recognizer
{
    UIView *toastView = [self getToastView];
    if ([self toastViewTapBlock] && toastView) {
        [self toastViewTapBlock]();
    }
}

#pragma mark - Getter & Setter

- (void)setToastView:(UIView *)toast
{

    objc_setAssociatedObject(self, &kToastViewTag, toast, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)getToastView
{
    return objc_getAssociatedObject(self, &kToastViewTag);
}

- (void)setCompletion:(void (^)(void))completion
{
    objc_setAssociatedObject(self, &kToastViewCompletionBlock, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))completion
{
    return objc_getAssociatedObject(self, &kToastViewCompletionBlock);
}

- (void (^)(void))toastViewTapBlock
{
    return objc_getAssociatedObject(self, &kToastViewTapBlock);
}

- (void)setToastViewTapBlock:(void (^)(void))toastViewTapBlock
{
    objc_setAssociatedObject(self, &kToastViewTapBlock, toastViewTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITapGestureRecognizer *)toastViewTapGestureRecognizer
{
    return objc_getAssociatedObject(self, &kToastViewTapGestureRecognizer);
}

- (void)setToastViewTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    objc_setAssociatedObject(self, &kToastViewTapGestureRecognizer, tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Add & Remove TapGestureRecognizer

- (void)addTapGestureRecognizerWithTapBlock:(void (^)(void))tapBlock
{
    [self removeTapGestureRecognizerAndTapBlock];

    [self setToastViewTapBlock:tapBlock];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(onToastViewTap:)];
    tapGestureRecognizer.delegate = [TapGestureRecognizerDelegateImpl sharedDelegateImpl];
    [self addGestureRecognizer:tapGestureRecognizer];
    [self setToastViewTapGestureRecognizer:tapGestureRecognizer];
}

- (void)removeTapGestureRecognizerAndTapBlock
{
    if ([self toastViewTapGestureRecognizer]) {
        [self toastViewTapGestureRecognizer].delegate = nil;
        [self removeGestureRecognizer:[self toastViewTapGestureRecognizer]];
        [self setToastViewTapGestureRecognizer:nil];
    }

    if ([self toastViewTapBlock]) {
        [self setToastViewTapBlock:NULL];
    }
}

@end

@implementation UIView (TCYToast)

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(MYToastPosition)position
{
    [self showToastView:toastView duration:interval position:position animated:YES];
}

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(MYToastPosition)position
             animated:(BOOL)animated
{
    [self hideToastViewAnimated:animated];

    toastView.alpha = 0.5;

    [self setToastView:toastView];
    [self addSubview:toastView];

    if (position == MYToastPositionBottom) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
    } else if (position == MYToastPositionBottomWithTabbar) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-64);
        }];
    } else if (position == MYToastPositionCenter) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    } else if (position == MYToastPositionTop) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top);
        }];
    } else if (position == MYToastPositionAboveKeyboard) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-(252 + VerticalPadding));
        }];
    } else if (position == MYToastPositionFill) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(10);
        }];
    }

    __weak __typeof__(toastView) weakToast = toastView;

    __weak __typeof__(self) weakSelf = self;
    if (animated) {
        [UIView animateWithDuration:0.2
            delay:0.0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                weakToast.alpha = 1.0;
            }
            completion:^(BOOL finished) {
                if (interval != MAXFLOAT) {
                    [UIView animateWithDuration:0.2
                        delay:interval
                        options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            weakToast.alpha = 0.0;
                        }
                        completion:^(BOOL finished) {

                            if ([weakSelf completion]) {
                                [weakSelf completion]();
                            }

                            [weakSelf hideToastView];
                        }];
                }
            }];
    } else {
        weakToast.alpha = 1.0f;
        if (interval != MAXFLOAT) {
            [UIView animateWithDuration:0.2
                delay:interval
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                    weakToast.alpha = 0.0;
                }
                completion:^(BOOL finished) {

                    if ([weakSelf completion]) {
                        [weakSelf completion]();
                    }

                    [weakSelf hideToastView];
                }];
        }
    }
}

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             animated:(BOOL)animated
{
    [self showToastView:toastView duration:interval position:MYToastPositionDefault animated:YES];
}

- (void)hideToastViewAnimated:(BOOL)animated
{
    __weak UIView *tempView = [self getToastView];
    if (tempView) {
        if (animated) {
            [UIView animateWithDuration:0.2
                animations:^{
                    tempView.alpha = 0.0f;
                }
                completion:^(BOOL finished) {
                    [tempView removeFromSuperview];
                }];
        } else {
            [tempView removeFromSuperview];
        }
        tempView = nil;
        [self setToastView:nil];
    }

    // 移掉completion
    [self setCompletion:nil];

    // 如果有 TapGestureRecognizer，则移除
    [self removeTapGestureRecognizerAndTapBlock];
}

- (void)hideToastView
{
    [self hideToastViewAnimated:YES];
}

@end


@implementation UIView (HudToast)

+ (void)showToastInKeyWindow:(NSString *)message
{
    [[UIApplication sharedApplication].keyWindow showToast:message position:MYToastPositionCenter];
}

+ (void)showToastInKeyWindow:(NSString *)message duration:(CGFloat)interval
{
    [self showToastInKeyWindow:message duration:interval position:MYToastPositionCenter];
}

+ (void)showToastInKeyWindow:(NSString *)message
                    duration:(CGFloat)interval
                    position:(MYToastPosition)position
{
    if (message && message.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        UIView *toast = [MYHUDToastView HUDToastViewWithAttributedString:string inRect:[[[UIApplication sharedApplication] keyWindow] bounds]];

        [[UIApplication sharedApplication]
                .keyWindow showToastView:toast
                                duration:interval
                                position:position];
    }
}

- (void)showToast:(NSString *)message
{
    [self showToast:message highlightText:@"" highlightColor:nil position:MYToastPositionDefault];
}

- (void)showToast:(NSString *)message position:(MYToastPosition)position
{
    [self showToast:message highlightText:@"" highlightColor:nil position:position];
}

- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)interval
                    position:(MYToastPosition)position
{
    if (message && message.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        UIView *toast = [MYHUDToastView HUDToastViewWithAttributedString:string
                                                                  inRect:[[[UIApplication sharedApplication] keyWindow] bounds]];
        [self showToastView:toast duration:interval position:position];
    }
}

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color
{
    [self showToast:message highlightText:text highlightColor:color position:MYToastPositionDefault];
}

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color
         position:(MYToastPosition)position
{
    if (message && message.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        [string addAttribute:NSForegroundColorAttributeName value:color range:[message rangeOfString:text]];

        UIView *toast = [MYHUDToastView HUDToastViewWithAttributedString:string inRect:self.bounds];
        [self showToastView:toast duration:1 position:position];
    }
}

@end


