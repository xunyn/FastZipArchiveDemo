//
//  FZipOperation.h
//  FastZipArchive
//
//  Created by 寻 亚楠 on 13-10-11.
//  Copyright (c) 2013年 寻 亚楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZipRequest.h"
#import "ZipArchive.h"

#define FZ_ERROR_DOMAIN @"FZipErrorDomain"

#define FZ_ARCHIVE_ERROR -2000
#define FZ_OPEN_FILE_ERROR -2001
#define FZ_UNZIP_ERROR -2002


@class ZipArchive;

@protocol FZipDelegate <NSObject>

- (void)didFinishZip;
- (void)didFinishUnzip;
- (void)didFailWithError:(NSError*)er;


@end

@interface FZipOperation : NSOperation<ZipArchiveDelegate> {
    ZipArchive *zipArchive;
    
}



@property (nonatomic, FZ_STRONG)FZipRequest *request;


- (id)initWithReqeust:(FZipRequest *)re;

@end
