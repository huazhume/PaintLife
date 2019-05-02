//
//  MTSharedManager.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/5/2.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTSharedManager.h"
#import <UMShare/UMSocialDataManager.h>
#import <UShareUI/UShareUI.h>

@implementation MTSharedManager


+ (MTSharedManager *)shareInstance
{
    static MTSharedManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTSharedManager alloc] init];
        
    });
    return manager;
}

- (void)shareImage:(UIImage *)image
{
    NSMutableArray *shareTypes = [@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Qzone)] mutableCopy];
    
    [shareTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![[UMSocialManager defaultManager] isInstall:obj]) {
            [shareTypes removeObject:obj];
        }
    }];
    [UMSocialUIManager setPreDefinePlatforms:shareTypes];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = image;
        [shareObject setShareImage:image];
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}


@end
