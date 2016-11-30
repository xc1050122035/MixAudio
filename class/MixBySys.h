//
//  MixBySys.h
//  quit
//
//  Created by 夏澄 on 3/17/16.
//  Copyright © 2016 夏澄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MixBySys : NSObject
typedef void (^inCompletionMix)(BOOL succ,NSString *mixPath,float mixtime , NSString * relativePath);

@property (nonatomic , copy) inCompletionMix comMixAndConverter;

@property (nonatomic , assign) float mixVolumeToRecord;
//@property (nonatomic , assign) CMTime mixCMTimeToRecord;

@property (nonatomic , assign) float mixVolumeTobackMusic;
//@property (nonatomic , assign) CMTime mixCMTimeTobackMusic;


+ (MixBySys *)sharedInstance;
- (void)mixWithRecordPath:(NSString *)recordPath backMusicPath:(NSString *)backMusicPath userId:(NSString *)userId mixVolumeToRecord:(float)mixVolumeToRecord  mixVolumeTobackMusic:(float) mixVolumeTobackMusic com:(inCompletionMix)com; //包括了转格式一起


@end
