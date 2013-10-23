//
//  FZipCreateDirectory.h
//  FastZipArchive
//
//  Created by 寻 亚楠 on 13-10-11.
//  Copyright (c) 2013年 寻 亚楠. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int isExit;
    CFStringRef  dirName;
    int level;
} DirTreeInfo;



@interface FZipCreateDirectory : NSObject
{
    NSFileManager * fileManager;
}


- (void) checkDirectory:(NSString *)fullPath zipPath:(NSString *) zipPath;

- (void) createDirRootTree :(NSString *) rootDir;



@end
