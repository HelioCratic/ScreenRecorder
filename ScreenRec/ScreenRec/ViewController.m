//
//  ViewController.m
//  ScreenRecorder
//
//  Created by Dmytro Nosulich on 11/1/15.
//  Copyright © 2015 Dmytro Nosulich. All rights reserved.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>

@interface ViewController () <RPPreviewViewControllerDelegate, RPScreenRecorderDelegate> {
    RPScreenRecorder *_screenRecorder;
    NSTimer *_timer;
    NSInteger seconds;
}
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenRecorder = [RPScreenRecorder sharedRecorder];
    _screenRecorder.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

- (IBAction)startRecordDidPressed:(id)sender {
    [self startTimer];
    [_screenRecorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
        if(error) {
            [self stopTimer];
        }
    }];
}

- (IBAction)stopRecordDidPressed:(id)sender {
    [_screenRecorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        [self stopTimer];
        if(!error && previewViewController) {
            previewViewController.previewControllerDelegate = self;
            [self presentViewController:previewViewController animated:YES completion:nil];
        }
    }];
}

#pragma mark - Private methods

- (void)startTimer {
    seconds = 0;
    [self updateTimerLabel];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)updateTimer:(NSTimer *)timer {
    seconds++;
    [self updateTimerLabel];
}

- (void)updateTimerLabel {
    _timerLabel.text = [NSString stringWithFormat:@"%zd", seconds];
}

#pragma mark - RPPreviewViewControllerDelegate

/* @abstract Called when the view controller is finished. */
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

/* @abstract Called when the view controller is finished and returns a set of activity types that the user has completed on the recording. The built in activity types are listed in UIActivity.h. */
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    //handle user's action (if activityTypes is empty, then user canceled editing)
}

#pragma mark - RPScreenRecorderDelegate

- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController {
    [previewViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder {
    //this method is called when user changes screen recorder availability and before screen recording begins
}


@end
