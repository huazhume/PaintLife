//
//  MTLocalDataManager.m
//  PaintLife
//
//  Created by xiaobai zhang on 2018/8/9.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTLocalDataManager.h"
#import "MTCoreDataManager.h"
#import "MTNoteModel.h"
#import "MTNotePo+CoreDataProperties.h"
#import "MTNoteTextPo+CoreDataProperties.h"
#import "MTNoteImagePo+CoreDataProperties.h"
#import "MTNotificationVo.h"
#import "MTNotificationPo+CoreDataProperties.h"

@implementation MTLocalDataManager

+ (MTLocalDataManager *)shareInstance
{
    static MTLocalDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[MTLocalDataManager alloc] init];
        [manager shareTest];
    });
    
    return manager;
}


- (BOOL)insertDatas:(NSArray *)datas withType:(MTCoreDataContentType)type
{
    [self shareTest];
    [self shareTest];
    if (type != MTCoreDataContentTypeNoteSelf) {
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MTNoteTextVo class]]) {
                MTNoteTextVo *vo = (MTNoteTextVo *)obj;
                MTNoteTextPo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteTextPo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.fontSize = vo.fontSize;
                po.noteId = vo.noteId;
                po.fontType = vo.fontType;
                po.sortIndex = idx;
                po.text = vo.text;
                po.fontName = vo.fontName;
                
                
            } else {
                MTNoteImageVo *vo = (MTNoteImageVo *)obj;
                MTNoteImagePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteImagePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.height = vo.height;
                po.noteId = vo.noteId;
                po.sortIndex = idx;
                po.path = vo.path;
                po.width = vo.width;
            }
        }];
    } else {
        [datas enumerateObjectsUsingBlock:^(MTNoteModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MTNotePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNotePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
            po.noteId = obj.noteId;
            po.width = obj.width;
            po.height = obj.height;
            po.weather = obj.weather;
            po.imagePath = obj.imagePath;
            po.text = obj.text;
        }];
       
    }
    
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
    }
}

- (NSArray *)getNoteSelf
{
    [self shareTest];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
    NSArray *array = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *muArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MTNotePo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNoteModel *model = [MTNoteModel new];
        model.noteId = obj.noteId;
        model.width = obj.width;
        model.height = obj.height;
        model.weather = obj.weather;
        model.imagePath = obj.imagePath;
        model.text = obj.text;
        if (muArray.count != 0) {
            [muArray insertObject:model atIndex:0];
        } else {
            [muArray addObject:model];
        }
    }];
    return muArray;
}

- (NSArray *)getNoteDetailList:(NSString *)noteId
{
    [self shareTest];
    NSFetchRequest *textRequest=[NSFetchRequest fetchRequestWithEntityName:@"MTNoteTextPo"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    textRequest.predicate = predicate;
    NSArray *textArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:textRequest error:nil];
    
    NSFetchRequest *imageRequest=[NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
    NSPredicate *imagePredicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    imageRequest.predicate=imagePredicate;
    NSArray *imageArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:imageRequest error:nil];
    
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithArray:textArray];
    [muArray addObjectsFromArray:imageArray];
    NSMutableArray *muVoArray = [NSMutableArray array];
    [muArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MTNoteTextPo class]]) {
            MTNoteTextVo *vo = [MTNoteTextVo new];
            MTNoteTextPo *po = (MTNoteTextPo *)obj;
            vo.fontSize = po.fontSize;
            vo.noteId = po.noteId;
            vo.sortIndex = po.sortIndex;
            vo.fontType = po.fontType;
            vo.text = po.text;
            vo.fontName = po.fontName;
            [muVoArray addObject:vo];
            
        } else {
            MTNoteImageVo *vo = [MTNoteImageVo new];
            MTNoteImagePo *po = (MTNoteImagePo *)obj;
            vo.height = po.height;
            vo.noteId = po.noteId;
            vo.sortIndex = po.sortIndex;
            vo.path = po.path;
            vo.width = po.width;
            [muVoArray addObject:vo];
        }
    }];
    [muVoArray sortUsingComparator:^NSComparisonResult(MTNoteBaseVo *obj1, MTNoteBaseVo *obj2) {
        return obj1.sortIndex > obj2.sortIndex;
    }];

    return muVoArray;
}


- (BOOL)deleteNoteWithNoteId:(NSString *)noteId
{
    [self shareTest];
    [self shareTest];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    {
        NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
        deleRequest.predicate = predicate;
        NSArray *deleArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:deleRequest error:nil];
        for (MTNotePo *stu in deleArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    {
        NSFetchRequest *imageDeleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
        
        imageDeleRequest.predicate = predicate;
        NSArray *deleImageArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:imageDeleRequest error:nil];
        for (MTNoteImagePo *stu in deleImageArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    {
        NSFetchRequest *textDeleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
        textDeleRequest.predicate = predicate;
        NSArray *deleTextArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:textDeleRequest error:nil];
        for (MTNoteTextPo *stu in deleTextArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)insertNotificationDatas:(NSArray *)datas
{
    [self shareTest];
    [datas enumerateObjectsUsingBlock:^(MTNotificationVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNotificationPo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNotificationPo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
        po.content = obj.content;
        po.time = obj.time;
        po.state = obj.state.integerValue;
        po.notificationId = obj.notificationId;
    }];

    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
    }
}

- (NSArray *)getNotifications
{
    [self shareTest];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTNotificationPo"];
    NSArray *array = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *muArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MTNotificationPo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNotificationVo *po = [MTNotificationVo new];
        po.content = obj.content;
        po.time = obj.time;
        po.notificationId = obj.notificationId;
        po.state = [NSNumber numberWithInteger:obj.state];
        if (muArray.count == 0) {
            [muArray addObject:po];
        } else {
            [muArray insertObject:po atIndex:0];
        }
    }];
    return muArray;
}


- (BOOL)deleteNotificationWithContent:(NSString *)content
{
    [self shareTest];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"content=%@",content];
    {
        NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNotificationPo"];
        deleRequest.predicate = predicate;
        NSArray *deleArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:deleRequest error:nil];
        for (MTNotePo *stu in deleArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        return YES;
    }else{
        return NO;
    }
}


- (void)shareTest
{
    NSString *string = [NSString stringWithFormat:@"%@",@"stringsdsad"];
    NSString *string2 = [[NSString alloc] init];
    string2 = string;
}



@end
