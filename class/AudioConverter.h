//
//  AudioConverter.h
//  quit
//
//  Created by 夏澄 on 3/17/16.
//  Copyright © 2016 夏澄. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

extern NSString * TPAACAudioConverterErrorDomain;

enum {
    TPAACAudioConverterFileError,
    TPAACAudioConverterFormatError,
    TPAACAudioConverterUnrecoverableInterruptionError,
    TPAACAudioConverterInitialisationError
};

@protocol TPAACAudioConverterDelegate;
@protocol TPAACAudioConverterDataSource;

@interface AudioConverter : NSObject

+ (BOOL)AACConverterAvailable;

- (id)initWithDelegate:(id<TPAACAudioConverterDelegate>)delegate source:(NSString*)sourcePath destination:(NSString*)destinationPath;
- (id)initWithDelegate:(id<TPAACAudioConverterDelegate>)delegate dataSource:(id<TPAACAudioConverterDataSource>)dataSource audioFormat:(AudioStreamBasicDescription)audioFormat destination:(NSString*)destinationPath;
- (void)start;
- (void)cancel;

- (void)interrupt;
- (void)resume;

@property (nonatomic, readonly, strong) NSString *source;
@property (nonatomic, readonly, strong) NSString *destination;
@property (nonatomic, readonly) AudioStreamBasicDescription audioFormat;
@end


@protocol TPAACAudioConverterDelegate <NSObject>
- (void)AACAudioConverterDidFinishConversion:(AudioConverter*)converter;
- (void)AACAudioConverter:(AudioConverter*)converter didFailWithError:(NSError*)error;
@optional
- (void)AACAudioConverter:(AudioConverter*)converter didMakeProgress:(float)progress;
@end

@protocol TPAACAudioConverterDataSource <NSObject>
- (void)AACAudioConverter:(AudioConverter*)converter nextBytes:(char*)bytes length:(NSUInteger*)length;
@optional
- (void)AACAudioConverter:(AudioConverter *)converter seekToPosition:(NSUInteger)position;
@end
