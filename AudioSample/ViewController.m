//
//  ViewController.m
//  AudioSample
//
//  Created by Khaterine Castellano on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)getSongSample:(id)sender {
    
   // BOOL done = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil; 
    
    NSString *audioFilePath = [NSString stringWithFormat:@"Dog Days Are Over.mp3"];
    NSString *audio_inputFileUrl = [documentsDirectory stringByAppendingPathComponent:audioFilePath];
    NSURL    *audioURL = [[NSURL alloc] initFileURLWithPath:audio_inputFileUrl];   
    AVURLAsset* avAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil]; 
    
    
    // create the export session
    // no need for a retain here, the session will be retained by the
    // completion handler since it is referenced there
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:avAsset
                                           presetName:AVAssetExportPresetAppleM4A];
    
 //   CMTime startTime = CMTimeMake(249, 1);
 //   CMTime stopTime = CMTimeMake(252, 1);
 //   CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
   
    CMTime start = CMTimeMakeWithSeconds(252,1);
    CMTime minus = CMTimeMakeWithSeconds(10.0, 1);
    CMTime startAudio = CMTimeSubtract(start, minus);
    CMTime startTime = startAudio;
    CMTime stopTime = CMTimeMake(252, 1);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
    
    NSString *stringAudio = [NSString stringWithFormat:@"newMedia.m4a.mov"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:stringAudio]; 
    
    // configure export session  output with all our parameters
    exportSession.outputURL = [NSURL fileURLWithPath:filePath]; // output path
    exportSession.outputFileType = @"com.apple.m4a-audio"; // output file type
    exportSession.timeRange = exportTimeRange; // trim time range
    
    // perform the export
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"Fails because:%@", [exportSession error]);
            NSLog(@"AVAssetExportSessionStatusFailed");
        } else {
            NSLog(@"Export Session Status: %d", exportSession.status);
        }
    }];
    NSURL    *audioSampleUrl = [NSURL fileURLWithPath:filePath]; 
    AVAsset* audioSampleURLAsset = [[AVURLAsset alloc] initWithURL:audioSampleUrl options:nil]; 
    NSLog(@"%@",[audioSampleURLAsset tracksWithMediaType:AVMediaTypeAudio]);   
    }

@end
