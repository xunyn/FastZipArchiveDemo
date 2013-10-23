//
//  FZipArchiveManager.h
//  FastZipArchive
//
//  Created by 寻 亚楠 on 13-10-11.
//  Copyright (c) 2013年 寻 亚楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZipRequest.h"
#import "FZipOperation.h"
#define DEFAULT_MAX_CONCURRENT_COUNT 3
@interface FZipArchiveManager : NSObject {
    
}


+ (FZipArchiveManager *)defaultManager;

- (void)addTask:(FZipRequest *)re;

- (void)setMaxConcurrentOperationCount:(int)max;
@end
