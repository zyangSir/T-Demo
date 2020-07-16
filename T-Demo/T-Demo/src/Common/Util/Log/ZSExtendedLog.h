//
//  ZSExtendedLog.h
//  JHZS
//
//  Created by Yangtsing.Zhang on 2020/1/15.
//  Copyright © 2020 BeiTianSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define devLog(args...) ZSExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define devLog(x...)
#endif

void ZSExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

NS_ASSUME_NONNULL_BEGIN

@interface ZSExtendedLog : NSObject

@end

NS_ASSUME_NONNULL_END
