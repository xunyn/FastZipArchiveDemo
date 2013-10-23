//
//  FZipRequest.m
//  FastZipArchive
//
//  Created by 寻 亚楠 on 13-10-11.
//  Copyright (c) 2013年 寻 亚楠. All rights reserved.
//

#import "FZipRequest.h"

@implementation FZipRequest

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    #if !__has_feature(objc_arc)
    [_zipFilePath release];
    [_unZipFilePath release];
    [_password release];
    
    [_finishUnzipHandler release];
    [_finishZipHandler release];
    [_failHandler release];

    [super dealloc];
    #endif
}


@end
