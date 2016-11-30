//
//  INVoicePlayerHelper.m
//  INUserCentrChat
//
//  Created by 夏澄 on 12/30/15.
//  Copyright © 2015 yangguang. All rights reserved.
//

#import "INVoicePlayerHelper.h"
#import <UIKit/UIKit.h>
@interface INVoicePlayerHelper()<AVAudioPlayerDelegate>

@end
@implementation INVoicePlayerHelper

+ (INVoicePlayerHelper *)sharedInstance{
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];;
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:_fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}
- (void)initVoiceWithPath:(NSString *)path pause:(BOOL)pause
               completion: (Completion)completion
{
    self.completion = completion;
    NSError *playbackError = nil;
    NSError *readingError = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:path options:NSDataReadingMapped error:&readingError];
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                             error:&playbackError];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    

    self.avAudioPlayer = newPlayer;
    
    if (self.avAudioPlayer != nil) {
        self.avAudioPlayer.delegate = self;
        if (pause) {
            [self.avAudioPlayer prepareToPlay];
            self.completion(NO,nil);
        }
        else
        {
            if ([self.avAudioPlayer prepareToPlay] == YES &&
                [self.avAudioPlayer play] == YES) {
                NSLog(@"开始播放录制的音频！");
            } else {
                NSLog(@"不能播放录制的音频！");
                self.completion(YES,playbackError);
            }
        }
        
    }else {
        self.completion(YES,playbackError);
        NSLog(@"音频播放失败！");
    }
}

- (void)stop
{
    self.completion(YES,nil);
    _avAudioPlayer.currentTime = 0;
    [_avAudioPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    self.completion(YES,nil);
}

- (void)stopPlayVoice:(Completion)completion;
{
    _completion = completion;
    [self stop];
}
/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error;
{
    self.completion(YES,error);
}

@end
