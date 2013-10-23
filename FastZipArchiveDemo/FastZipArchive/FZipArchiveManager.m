//
//  UnzipProcessor.m
//  UnzipPOC
//
//  Created by Marcus on 2/19/13.
//  Copyright (c) 2013 Marcus. All rights reserved.
//

#import "FZipArchiveManager.h"
#import "FZipOperation.h"

@interface FZipArchiveManager ()

@property (nonatomic, retain) NSOperationQueue *archiveQueue;

@end

@implementation FZipArchiveManager 
@synthesize archiveQueue;

static FZipArchiveManager *deaultManager;

+ (FZipArchiveManager *)defaultManager
{
	@synchronized(self)
	{
		if (!deaultManager)
		{
			deaultManager = [[FZipArchiveManager alloc] init];

		}
	}
	return deaultManager;
}

- (id)init{
    self = [super init];
    if (self) {
        archiveQueue = [[NSOperationQueue alloc] init];
        archiveQueue.maxConcurrentOperationCount = DEFAULT_MAX_CONCURRENT_COUNT;
    }
    return self;
}

- (void)addTask:(FZipRequest *)re{
    FZipOperation *task = [[FZipOperation alloc] initWithReqeust:re];
    [archiveQueue addOperation:task];
    [task release];
}

- (void)dealloc {

    #if !__has_feature(objc_arc)
	[archiveQueue release];
    archiveQueue = nil;
	[super dealloc];
    #endif
}


- (void)setMaxConcurrentOperationCount:(int)max{
    if (max >0) {
        archiveQueue.maxConcurrentOperationCount = max;
    }
}
@end
