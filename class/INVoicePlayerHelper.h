//
//  INVoicePlayerHelper.h
//  INUserCentrChat
//
//  Created by 夏澄 on 12/30/15.
//  Copyright © 2015 yangguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface INVoicePlayerHelper : NSObject
typedef void (^Completion)(BOOL  finish , NSError *error);
@property (nonatomic , retain) AVAudioPlayer *avAudioPlayer;   //播放器player
@property (nonatomic , copy) Completion completion;
+ (INVoicePlayerHelper *)sharedInstance;
- (void)initVoiceWithPath:(NSString *)path pause:(BOOL)pause
               completion: (Completion)completion;

- (void)stopPlayVoice:(Completion)completion;
@end
