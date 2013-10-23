//
//  ViewController.m
//  FastZipArchiveDemo
//
//  Created by 寻 亚楠 on 13-10-11.
//  Copyright (c) 2013年 寻 亚楠. All rights reserved.
//

#import "ViewController.h"
#import "FZipRequest.h"
#import "FZipArchiveManager.h"

@interface ViewController ()

@property (nonatomic,retain) FZipArchiveManager *zipArchiveManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _zipArchiveManager = [FZipArchiveManager defaultManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BtnPress:(id)sender {
    
    NSString *sourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"1.zip"];
    NSString *desPath = @"1";
    FZipRequest *re1 =[[FZipRequest alloc]init];
    re1.zipFilePath = sourcePath;
    re1.unZipFilePath = desPath;
    re1.type = ZIP_TO_UNZIP;
    re1.mode = FAST_MODE;
    re1.delegate = self;
    
    FZipRequest *re2 =[[FZipRequest alloc] init];
    sourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"2.zip"];
    re2.zipFilePath = sourcePath;
    re2.unZipFilePath = @"2";
    re2.type = ZIP_TO_UNZIP;
    re2.finishUnzipHandler = ^{[self didFinishUnzip];};
    
    FZipRequest *re3 =[[FZipRequest alloc] init];
    sourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"3.zip"];
    re3.zipFilePath = sourcePath;
    re3.unZipFilePath = @"3";
    re3.type = ZIP_TO_UNZIP;
    re3.delegate = self;
    NSArray *arr = @[re1,re2,re3];
    
    for (FZipRequest *request in arr) {
        [_zipArchiveManager addTask:request];
    }
}

#pragma mark -- FZip delegate

- (void)didFinishUnzip{

    NSLog(@"didFinishUnzip");

}
@end
