//
//  CreateDirectory.m
//  TestBlock
//
//  Created by Xun on 12-12-2.
//  Copyright (c) 2012年 user. All rights reserved.
//

#import "FZipCreateDirectory.h"

@implementation FZipCreateDirectory

static CFTreeRef dirTree;
static CFAllocatorRef allocator = NULL;
static void FreeTreeInfo (const void *info);


static CFTreeRef CreateDirTree(CFAllocatorRef allocator,CFStringRef name, int level) {
    DirTreeInfo * info;
    CFTreeContext ctx;
    info = CFAllocatorAllocate(allocator, sizeof(DirTreeInfo), 0);

    info->dirName = CFStringCreateCopy(allocator, name);
    
    info->isExit = 1;
    info->level = level;
    ctx.version = 0;
    ctx.info = info;
    ctx.retain = NULL;
    ctx.release = FreeTreeInfo;
    ctx.copyDescription = NULL;
    return CFTreeCreate(allocator, &ctx);
}


static CFTreeRef findSiblingWithName(CFTreeRef curTree,CFStringRef name)
{
    
    CFTreeContext context;
    DirTreeInfo *info;
    
    if (curTree == NULL) {
        return NULL;
    }
    

    CFTreeGetContext(curTree, &context);
    info = context.info;
    int i = CFStringCompare(info->dirName, name, 0);
    if (i==0)
    {
        return curTree;
    }
    CFTreeRef siblingTree;
    siblingTree = curTree;
    do {
        siblingTree = CFTreeGetNextSibling(siblingTree);
        if (siblingTree == NULL) {
            return NULL;
        }
        
        CFTreeContext ctx;
        CFTreeGetContext(siblingTree, &ctx);
        int j = CFStringCompare(((DirTreeInfo *)ctx.info)->dirName, name, 0);
        if (j == 0) {
            return siblingTree;
        }
        
    } while (siblingTree);
    
    return NULL;
}

static CFTreeRef findTreeChildWithName(CFTreeRef curTree,CFStringRef name )
{
    CFTreeRef childTree;
    CFTreeContext context;
    DirTreeInfo *info;

    
    if (curTree == NULL) {
        return NULL;
    }
    
        
    childTree = CFTreeGetFirstChild(curTree);

    if (childTree == NULL) {
         return NULL;
    }
    
    CFTreeGetContext(childTree, &context);
    info = context.info;
    int i = CFStringCompare(info->dirName, name, 0);
    if (i==0)
    {
        return childTree;
    }
  
    CFTreeRef siblingTree;
    for (siblingTree =CFTreeGetNextSibling(childTree) ; siblingTree; ) {
        
        CFTreeContext ctx;
        CFTreeGetContext(siblingTree, &ctx);
        int j = CFStringCompare(((DirTreeInfo *)ctx.info)->dirName, name, 0);
        if (j == 0) {
            return siblingTree;
        }
        
        siblingTree =CFTreeGetNextSibling(siblingTree);

    }
    return NULL;
    
}

static void FreeTreeInfo (const void *info)
{
    //tree  will recursively release;
    NSLog(@"FreeTreeInfo");
}

- (id)init
{

    self = [super init];
    
    if (self) {
       
        fileManager = [NSFileManager defaultManager];
        
        allocator  = CFAllocatorGetDefault();
        
    }
    return self;
}

- (void) createDirRootTree :(NSString *) rootDir
{
    //init allcator
    if (!allocator) {
        allocator = CFAllocatorGetDefault();
    }
    
    if ([rootDir isEqualToString:@"."]) {
        //the root node is not a real directory
        dirTree = CreateDirTree(allocator,(CFStringRef) rootDir, 0 );
    }
    else
    {
        [fileManager createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
        dirTree = CreateDirTree(allocator,(CFStringRef) rootDir, 0 );
    }
         

}

- (int) manageDirTree:(NSString *)fullPath dirArray:(NSArray *) dirArray
{
    if (dirTree == NULL) {
        NSLog(@"inital dir tree ");
        [self createDirRootTree:@"."];
    }
    
    
    CFTreeContext ctx;
    CFTreeRef resultTree ;
    CFTreeRef newTree;
    CFTreeRef curTree;
    
    curTree = dirTree;
    
    for (int i = 0; i < [dirArray count]; i++) {
        
        NSString * dirName = [dirArray objectAtIndex:i];
        CFStringRef name = (CFStringRef) dirName;
        

        resultTree = findTreeChildWithName(curTree,name);
        
        if (resultTree) {
            curTree = resultTree;
            continue;
        }
        else
        {
            CFTreeGetContext(curTree, &ctx);
            if (((DirTreeInfo *)ctx.info)->level  == i) {
                if ([self createFolder:fullPath newDir:dirName]) {
                     newTree =CreateDirTree(allocator ,name,i +1);
                    
                    CFTreePrependChild(curTree, newTree);
                    curTree = newTree;
                    
                }
            }
            else
            {
                //not in this dir ,why?
#pragma mark how to handle?
                NSLog(@"Error");
                //return 10;
            }
              
        }
        
        
    }
    return 0;
}

- (void) checkDirectory:(NSString *)fullPath zipPath:(NSString *) zipPath
{

    //find rootPath
    // remove "/" at fullPath end;
   // fullPath = [fullPath stringByAppendingString:@"/"];
    
    NSMutableArray *pathMuArray;
    NSArray * pathArray;
    pathMuArray = [[NSMutableArray alloc] init];
   
    pathArray = [zipPath componentsSeparatedByString:@"/"];

    
    for(int i=0; i<[pathArray count]; i++)
    {
        NSString * str = [pathArray objectAtIndex:i];
        if ([str isEqualToString:@""]) {

        }
        else
        {
        [pathMuArray addObject:str];
        }
    }
    
    for (int i =0 ; i< [pathMuArray count]; i++) {
        NSString * subPath;
        NSMutableArray *dirMuArray;
        dirMuArray = [[NSMutableArray alloc] init];
        
        subPath = fullPath;
        for (int j = i; j< [pathMuArray count]; j++) {
            subPath = [subPath stringByDeletingLastPathComponent];
           
        }
        
        for (int k =0 ; k <= i; k++) {
            NSString * name;
            name = [pathMuArray objectAtIndex:k];
            [dirMuArray  addObject:name];
        }


        int result;
        //result = [self manageDirTree:subPath dirName:dirName dirLevel:i+1] ;
        result = [self manageDirTree:subPath dirArray:(NSArray *)dirMuArray];
 
        [dirMuArray release];

    }
    
    
    [pathMuArray release];
    
    //for
    //createTree
    
    //findTree
    
    //addTree

}




- (BOOL) createFolder :(NSString*) currentDir newDir: (NSString*)newDir
{
    
    NSError *error ;
    //handle error?
    
    BOOL iscreated;
    NSString * fullPath;
    error = nil;
    fullPath =  [currentDir stringByAppendingPathComponent:newDir];
    
    iscreated =  [fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    //NSLog(@"at %@ create Dir %@ ,%@",fullPath,newDir,iscreated?@"YES":@"NO");
    
    // if dir is Exit , function will return NO,
    // so set return YES;
    //return iscreated;
    return YES;

}


- (void)dealloc
{
    #if !__has_feature(objc_arc)
    //release tree
    CFTreeRemoveAllChildren(dirTree);
    CFRelease(dirTree);
    [super dealloc];
    #endif
}
@end
