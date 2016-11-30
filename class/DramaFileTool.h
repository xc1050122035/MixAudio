//
//  DramaFileTool.h
//  quit
//
//  Created by 夏澄 on 3/30/16.
//  Copyright © 2016 夏澄. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DOCVOICENAMEMIX @"DramaVoiceMix"
#define DOCVOICENAMERECORD @"DramaVoiceRecord"
@interface DramaFileTool : NSObject

+ (NSString *)returnTime;

//默认shi tem
+ (NSString *)returnTemporaryPathWithName:(NSString *)temName extensionType:(NSString *)extensionType;

//url 或者 时间戳 来作为 voiceUrlOrName
+ (NSString *)voiceSavedPathWithUserId:(NSString *)userId isNameElseUrl:(BOOL)isNameOrUrl voiceUrlOrName:(NSString *)voiceUrlOrName extensionType:(NSString *)extensionType WithDoc:(NSString *)doc;
+ (BOOL)deleteAllAudioDataWithDoc:(NSString *)doc;
+ (BOOL)deleteAudioWithPaht:(NSString *)audioPath;
+ (NSInteger) getFileSize:(NSString*) path;


+ (NSString *)floatTimeTransferToStrWithTime:(float)time;

+ (NSString *)getDataWithFormatter:(NSString *)formatter;

+ (NSString *)floatTimeTransferToStrWithTimeToMyRecord:(float)time;
+ (float)timeStrToFloat:(NSString *)time;

@end
