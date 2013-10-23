//
//  UnzipTask.m
//  UnzipPOC
//
//  Created by Marcus on 2/19/13.
//  Copyright (c) 2013 Marcus. All rights reserved.
//

#import "FZipOperation.h"
#import "ZipArchive.h"

@interface FZipOperation ()

@property(nonatomic,retain) NSFileManager *fileManager;

@end

@implementation FZipOperation


- (void)main {
    
    if (_request.type == ZIP_TO_UNZIP) {

        if([zipArchive UnzipOpenFile:_request.zipFilePath])
        {
            BOOL isSuccess = NO;
            if (_request.mode == FAST_MODE) {
                isSuccess = [zipArchive FastUnzipFileTo:_request.unZipFilePath overWrite:_request.overWrite];
            }else{
                isSuccess = [zipArchive UnzipFileTo:_request.unZipFilePath overWrite:_request.overWrite];
            }
            if (isSuccess) {
                [zipArchive UnzipCloseFile];
                NSLog(@"End unZip file in Thread %@***************",_request.unZipFilePath);
                if (_request.delegate) {
                    if ([_request.delegate respondsToSelector:@selector(didFinishUnzip)]) {
                        [_request.delegate performSelectorOnMainThread:@selector(didFinishUnzip) withObject:nil waitUntilDone:NO];
                    }
                }else if(_request.finishUnzipHandler){
                    dispatch_async(dispatch_get_main_queue(), ^(void){_request.finishUnzipHandler();});
                }else{
                
                }
            }else{
                NSDictionary *dic = @{NSFilePathErrorKey:_request.zipFilePath};
                NSError *error = [NSError errorWithDomain:FZ_ERROR_DOMAIN code:FZ_UNZIP_ERROR userInfo:dic];
                [self failWithError:error];
            }
            
        }else{
            NSDictionary *dic = @{NSFilePathErrorKey:_request.zipFilePath};
            NSError *error = [NSError errorWithDomain:FZ_ERROR_DOMAIN code:FZ_OPEN_FILE_ERROR userInfo:dic];
            [self failWithError:error];
        }
        
    }else if(_request.type == FILE_TO_ZIP){
        if ([zipArchive CreateZipFile2:_request.zipFilePath Password:_request.password]) {
            if ([zipArchive addFileToZip:_request.zipFilePath newname:@"test"]) {
                NSLog(@"Archive zip Successin Thread ");
            }
        }
        
    }else{
        NSDictionary *dic = @{NSFilePathErrorKey:_request.zipFilePath};
        NSError *error = [NSError errorWithDomain:FZ_ERROR_DOMAIN code:FZ_OPEN_FILE_ERROR userInfo:dic];
        [self failWithError:error];
    }
    
}


- (id)initWithReqeust:(FZipRequest *)re{
    self = [super init];
    if (self) {
        self.request = re;
        self.fileManager = [NSFileManager defaultManager];
        _request.unZipFilePath =  [self checkPath:_request.unZipFilePath isCreated:YES];
        _request.zipFilePath = [self checkPath:_request.zipFilePath isCreated:YES];
        
        zipArchive = [[ZipArchive alloc]init];
        
    }
    
    return self;
}

- (void)dealloc{
    #if !__has_feature(objc_arc)
    [zipArchive release];
    [_fileManager release];
    [_request release];
    [super dealloc];
    #endif
}

- (void)failWithError:(NSError *)re
{
    
    if (_request.delegate) {
        if ([_request.delegate respondsToSelector:@selector(failWithError:)]) {
            [_request.delegate performSelectorOnMainThread:@selector(failWithError:) withObject:re waitUntilDone:NO];
        }
    }else if(_request.finishUnzipHandler){
        dispatch_async(dispatch_get_main_queue(), ^(void){_request.finishUnzipHandler(re);});
    }else{
        
    }
}

#pragma mark -- Zip Archive Delegate
- (void)ErrorMessage:(NSString *)msg{
    NSDictionary *dic = @{NSLocalizedDescriptionKey:msg};
    NSError *error = [NSError errorWithDomain:FZ_ERROR_DOMAIN code:FZ_ARCHIVE_ERROR userInfo:dic];
    [self failWithError:error];
    
}

- (BOOL)OverWriteOperation:(NSString *)file{

    return YES;
}

#pragma mark -- check & create path
- (NSString *) checkPath:(NSString *)path isCreated:(BOOL)isCreated{
    
    NSError *error;
    if (_fileManager) {
        if ([_fileManager fileExistsAtPath:path]) {
            return path;
        }
        
        if ([path isAbsolutePath]) {
           
            //absolute path
        }
        else{
        
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *newFolderPath = [documentsDirectory  stringByAppendingPathComponent:path];
            path = newFolderPath;
        }
        if (isCreated) {
            [_fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    return path;
}
@end
