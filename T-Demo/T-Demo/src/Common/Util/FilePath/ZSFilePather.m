//
//  ZSFilePather.m
//  JHZS
//
//  Created by Yangtsing.Zhang on 2020/3/6.
//  Copyright © 2020 BeiTianSoftware. All rights reserved.
//

#import "ZSFilePather.h"
#import "ZSExtendedLog.h"

@implementation ZSFilePather

+ (NSString *)docPathWithUserID:(NSString *)userID{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *specificUserDocPath = [docDir stringByAppendingPathComponent: userID];
    if ([[NSFileManager defaultManager] fileExistsAtPath: specificUserDocPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath: specificUserDocPath
                                  withIntermediateDirectories: YES
                                                   attributes:nil
                                                        error: &error];
        if (error) {
            NSLog(@"创建用户缓存目录失败,%@", error);
        }
    }
    
    return specificUserDocPath;
}

+ (void)createPathIfNoExist:(NSString *)filePath isDir:(BOOL)isDir{
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirType = NO;
    BOOL needCreate = YES;
    if ([fileManager fileExistsAtPath: filePath isDirectory: &isDirType] == YES) {
        if (isDir != isDirType) {
            [fileManager removeItemAtPath: filePath error: &err];
            if (err) {
                devLog(@"file delete err: %@", err.localizedDescription);
            }
        }else{
            needCreate = NO;
        }
    }
    if (needCreate == YES) {
        if (isDir == YES) {
            [fileManager createDirectoryAtPath: filePath withIntermediateDirectories: YES attributes: nil error: &err];
            if (err) {
                devLog(@"dir create err: %@", err);
            }
        }else{
            //先确保父级目录存在，不存在则创建
            NSInteger backSlashLoc = 0;
            for (NSInteger i = (filePath.length - 1); i >= 0; --i) {
                unichar c = [filePath characterAtIndex: i];
                if (c == 0x2f) {//0x2f 是字符 '/' 的unicode16值
                    backSlashLoc = i;
                    break;
                }
            }
            NSString *dirPath = [filePath substringToIndex: backSlashLoc];
            if (![[NSFileManager defaultManager] fileExistsAtPath: dirPath isDirectory: nil]) {
                [fileManager createDirectoryAtPath: dirPath withIntermediateDirectories: YES attributes: nil error: &err];
                if (err) {
                    devLog(@"dir create err: %@", err);
                }
            }
            
            BOOL ret = [fileManager createFileAtPath: filePath contents: nil attributes: nil];
            if (ret == NO) {
                devLog(@"file create fail:%@", filePath);
            }
        }
    }
}

+ (NSString *)commonCacheDirPath{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *commonDir = [cacheDir stringByAppendingPathComponent: @"common"];
    [self createPathIfNoExist: commonDir isDir: YES];
    return commonDir;
}

+ (NSString *)cacheDirPathWithUserID:(NSString *)userID{
    NSString *commonPath = [self commonCacheDirPath];
    NSString *userCachePath = [commonPath stringByAppendingPathComponent: userID];
    [self createPathIfNoExist: userCachePath isDir: YES];
    return userCachePath;
}

@end
