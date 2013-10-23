//
//  FZipRequest.h
//  FastZipArchive
//
//  Created by 寻 亚楠 on 13-10-11.
//  Copyright (c) 2013年 寻 亚楠. All rights reserved.
//

#import <Foundation/Foundation.h>

//for arc and non-arc
#ifndef FZ_STRONG
#if __has_feature(objc_arc)
#define FZ_STRONG strong
#else
#define FZ_STRONG retain
#endif
#endif

#ifndef FZ_WEAK
#if __has_feature(objc_arc_weak)
#define FZ_WEAK weak
#elif __has_feature(objc_arc)
#define FZ_WEAK unsafe_unretained
#else
#define FZ_WEAK assign
#endif
#endif

#if __has_feature(objc_arc)
#define FZ_AUTORELEASE(exp) exp
#define FZ_RELEASE(exp) exp
#define FZ_RETAIN(exp) exp
#else
#define FZ_AUTORELEASE(exp) [exp autorelease]
#define FZ_RELEASE(exp) [exp release]
#define FZ_RETAIN(exp) [exp retain]
#endif

#define ZIP_TO_UNZIP 0
#define FILE_TO_ZIP 1

#define NORMAL_MODE 0
#define FAST_MODE 1


@protocol FZipDelegate;
typedef void(^finishZipBlock) () ;
typedef void(^finishUnzipBlock) ();
typedef void(^failWithError) (NSError *er);


@interface FZipRequest : NSObject

@property (nonatomic,copy)NSString *zipFilePath;
@property (nonatomic,copy)NSString *unZipFilePath;
@property (nonatomic) int type;
@property (nonatomic) BOOL overWrite;
@property (nonatomic,copy) NSString *password;
@property (nonatomic) int mode;

@property (nonatomic,FZ_WEAK)NSObject *delegate;

@property (nonatomic,copy)finishZipBlock finishZipHandler;
@property (nonatomic,copy)finishUnzipBlock finishUnzipHandler;
@property (nonatomic,copy)failWithError failHandler;


@end
