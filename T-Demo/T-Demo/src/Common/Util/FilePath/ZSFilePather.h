//
//  ZSFilePather.h
//  JHZS
//
//  Created by Yangtsing.Zhang on 2020/3/6.
//  Copyright © 2020 BeiTianSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

//防止某个文件路径下被同步到iCloud
#define ESAddSkipBackupAttributeToItemAtPath(filePathString) \
{ \
NSURL* URL= [NSURL fileURLWithPath: filePathString]; \
if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){ \
[URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: nil]; \
} \
}

NS_ASSUME_NONNULL_BEGIN

@interface ZSFilePather : NSObject

///区分用户账号的doc目录,用账号做子目录
+ (NSString *)docPathWithUserID:(NSString *)userID;
///不存在便创建 目录/文件
+ (void)createPathIfNoExist:(NSString *)filePath isDir:(BOOL)isDir;
///公共缓存目录
+ (NSString *)commonCacheDirPath;
///区分用户账号的缓存目录,用账号做子目录
+ (NSString *)cacheDirPathWithUserID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END
