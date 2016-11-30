//
//  MixBySys.m
//  quit
//
//  Created by 夏澄 on 3/17/16.
//  Copyright © 2016 夏澄. All rights reserved.
//

#import "MixBySys.h"
#import <AVFoundation/AVFoundation.h>
#import "INVoicePlayerHelper.h"
#import "DramaFileTool.h"
#import "AudioConverter.h"
@interface MixBySys ()<TPAACAudioConverterDelegate, TPAACAudioConverterDataSource>
@property (nonatomic) AudioConverter *audioConverter;
@property (nonatomic , strong) NSString * recordPath;
@property (nonatomic , strong) NSString *voiceName;
@property (nonatomic , strong) NSString *mixM4aPath;

@end

@implementation MixBySys


+ (MixBySys *)sharedInstance{
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (NSString *)nslogTime
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"mmss"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"time = %@",locationString);
    return locationString;
}
- (void)mixWithRecordPath:(NSString *)recordPath backMusicPath:(NSString *)backMusicPath userId:(NSString *)userId mixVolumeToRecord:(float)mixVolumeToRecord  mixVolumeTobackMusic:(float) mixVolumeTobackMusic com:(inCompletionMix)com;
{
    _recordPath = recordPath;
    __weak MixBySys *weakSelf = self;
    _comMixAndConverter = com;
    _mixVolumeToRecord = mixVolumeToRecord;
    _mixVolumeTobackMusic = mixVolumeTobackMusic;
    [MixBySys nslogTime];
    //NSURL *audioFilePath = [NSURL fileURLWithPath:@"var/mobile/Applications/822732B6-67B9-485F-BA44-FAACAB34C4FD/Documents/Coisir Cheoil10_09_2014_1429.m4a"];
    // need to fix link to backing Track

    AVMutableComposition *composition = [AVMutableComposition composition];
    NSArray* tracks = [NSArray arrayWithObjects:recordPath, backMusicPath, nil];
    NSString* audioFileType = @"mp3";
    
    
    AVURLAsset* audioAssetTime = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:recordPath]options:nil];
    AVMutableAudioMix * audioMix = [AVMutableAudioMix audioMix];
    
    NSMutableArray * audioMixParams = [NSMutableArray array];
    
    for (NSString* trackName in tracks) {
        AVURLAsset* audioAsset;
        if ([trackName isEqualToString:recordPath]) {
            audioAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:recordPath]options:nil];
            
        }
        else
        {
            audioAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:trackName]options:nil];
        }
        AVMutableCompositionTrack* audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                         preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        if ([trackName isEqualToString:recordPath]) {
            
            //Set Volume
            AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
            [trackMix setVolume:self.mixVolumeToRecord atTime:kCMTimeZero];
            [audioMixParams addObject:trackMix];
            NSLog(@"audioMixParams ======%@",audioMixParams);
        }
        else
        {
            //Set Volume
            AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
            [trackMix setVolume:self.mixVolumeTobackMusic atTime:kCMTimeZero];
            [audioMixParams addObject:trackMix];
            
            //            AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
            //            NSLog(@"audioAssetTime =%f",audioAssetTime.duration.value);
            ////            [trackMix1 setVolume:1.0f atTime:CMTimeMake(100,audioAssetTime.duration.timescale)];
            //
            //            [audioMixParams addObject:trackMix1];
            
            NSLog(@"audioMixParams ======%@",audioMixParams);
            
            
        }
        
        
        
        NSError* error;
        @try {
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAssetTime.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:kCMTimeZero error:&error];
        }
        @catch (NSException *exception) {
            return;
        }
        @finally {
            
        }
        
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    //    NSString* mixedAudio = @"mixedAudio.m4a";
  _voiceName = [DramaFileTool returnTime];
    NSString *exportPath = [DramaFileTool voiceSavedPathWithUserId:userId isNameElseUrl:YES voiceUrlOrName:_voiceName extensionType:@"m4a" WithDoc:@"temm4a"];
    _mixM4aPath = exportPath;
    
    NSLog(@"%@",exportPath);
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:exportPath]) {
        [[NSFileManager defaultManager]removeItemAtPath:exportPath error:nil];
    }
    _assetExport.outputFileType = AVFileTypeAppleM4A;
    _assetExport.audioMix = audioMix;
    _assetExport.outputURL = exportURL;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"Completed Sucessfully");
        if (![AudioConverter AACConverterAvailable]) {
            return;
        }
//                weakSelf.comMixAndConverter(YES,exportPath,[[MixBySys nslogTime] floatValue] ,weakSelf.voiceName);

        // Register an Audio Session interruption listener, important for AAC conversion
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioSessionInterrupted:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        // Set up an audio session compatible with AAC conversion.  Note that AAC conversion is incompatible with any session that provides mixing with other device audio.
        NSError *error = nil;
        if ( ![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                               withOptions:0
                                                     error:&error] ) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            return;
        }
        
        // Activate audio session
        if ( ![[AVAudioSession sharedInstance] setActive:YES error:NULL] ) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            return;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
             _voiceName = [DramaFileTool returnTime];
            NSString *converterexportPath = [DramaFileTool voiceSavedPathWithUserId:userId isNameElseUrl:YES voiceUrlOrName:_voiceName extensionType:@"aac" WithDoc:DOCVOICENAMEMIX];
            NSLog(@"converterexportPath ==%@",converterexportPath);
            self.audioConverter = [[AudioConverter alloc] initWithDelegate:self
                                                                         source:exportPath
                                                                    destination:converterexportPath];
            [_audioConverter start]; });
        
    }];
}


#pragma mark - Audio session interruption

- (void)audioSessionInterrupted:(NSNotification*)notification {
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    
    if ( type == AVAudioSessionInterruptionTypeEnded) {
        [[AVAudioSession sharedInstance] setActive:YES error:NULL];
        if ( _audioConverter ) [_audioConverter resume];
    } else if ( type == AVAudioSessionInterruptionTypeBegan ) {
        if ( _audioConverter ) [_audioConverter interrupt];
    }
}

#pragma mark - converter delegate

- (void)AACAudioConverterDidFinishConversion:(AudioConverter*)converter;
{
    _comMixAndConverter(YES,converter.destination,[[MixBySys nslogTime] floatValue] ,_voiceName);
    [DramaFileTool deleteAudioWithPaht:_recordPath];
//    [DramaFileTool deleteAudioWithPaht:_mixM4aPath];
    NSLog(@"converter Sucessfully");
    NSLog(@"converter.destination==%@",converter.destination);


}
- (void)AACAudioConverter:(AudioConverter*)converter didFailWithError:(NSError*)error;
{
    NSLog(@"转失败 %@", converter.destination);
}


@end
