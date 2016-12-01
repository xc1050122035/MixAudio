//
//  DramaFileTool.m
//  quit
//
//  Created by 夏澄 on 3/30/16.
//  Copyright © 2016 夏澄. All rights reserved.
//

#import "DramaFileTool.h"


@implementation DramaFileTool

+ (NSString *)returnTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddhhmmssfff"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

+ (NSString *)returnTemporaryPathWithName:(NSString *)temName extensionType:(NSString *)extensionType;
{
    NSString *tmpDir = NSTemporaryDirectory();
    if (temName.length<= 0) {
    temName = @"tem";
    }
    NSString* tempFile = [[tmpDir stringByAppendingPathComponent:temName] stringByAppendingPathExtension:extensionType];
    return tempFile;
}


+ (NSString *)voiceSavedPathWithUserId:(NSString *)userId isNameElseUrl:(BOOL)isNameOrUrl voiceUrlOrName:(NSString *)voiceUrlOrName extensionType:(NSString *)extensionType WithDoc:(NSString *)doc;
{
    if (!isNameOrUrl) {
        voiceUrlOrName = [DramaFileTool getUrlPath:voiceUrlOrName];
    }
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *voiceDocPath = [documentPath stringByAppendingPathComponent:doc];
    userId = [NSString stringWithFormat:@"%@",userId];
    voiceDocPath = [voiceDocPath stringByAppendingPathComponent:userId];
    BOOL isDir = TRUE;
    if (![fileManager fileExistsAtPath:voiceDocPath isDirectory:&isDir]) {
        //创建ImageFile文件夹
        [fileManager createDirectoryAtPath:voiceDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //返回保存图片的路径（图片保存在ImageFile文件夹下）
    NSString * voicePath;
//    = [[[voiceDocPath stringByAppendingPathComponent:voiceUrlOrName]stringByAppendingPathExtension:extensionType]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return voicePath;
}

+ (NSString *)getUrlPath:(NSString *)urlStr
{
    NSURL *urlVoice = [NSURL URLWithString:urlStr];
    urlStr = urlVoice.path;
    return urlStr;
    
}

+ (BOOL)deleteAllAudioDataWithDoc:(NSString *)doc
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSString *voiceDocPath = [documentPath stringByAppendingPathComponent:doc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:voiceDocPath]) {
        if([fileManager removeItemAtPath:voiceDocPath error:nil])
        {
            return YES;
        }
        else
            return NO;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)deleteAudioWithPaht:(NSString *)audioPath
{
    //获取Documents文件夹目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:audioPath]) {
        if([fileManager removeItemAtPath:audioPath error:nil])
        {
            return YES;
        }
        else
            return NO;
    }
    else
    {
        return NO;
    }
 
}


#pragma mark - 获取文件大小
+ (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

+ (NSString *)floatTimeTransferToStrWithTime:(float)time
{
    NSInteger timeValue = (NSInteger)time;
    float temDecimaValue = time - timeValue;
    NSInteger floorValue = floor(temDecimaValue);
    NSInteger decimalValue = timeValue % 60 + floorValue;
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)(timeValue / 60),(long)decimalValue];
}

+ (NSString *)floatTimeTransferToStrWithTimeToMyRecord:(float)time
{
    NSInteger timeValue = (NSInteger)time;
    float temDecimaValue = time - timeValue;
    float decimalValue = timeValue % 60 + temDecimaValue;
    return [NSString stringWithFormat:@"%02ld:%.1f",(long)(timeValue / 60),decimalValue];
}


+ (NSString *)getDataWithFormatter:(NSString *)formatter
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

+ (float)timeStrToFloat:(NSString *)time;
{
    __block float timevalue = 0;
    NSArray *arr = [time componentsSeparatedByString:@":"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            timevalue = ([obj integerValue])*60;
        }
        else
        {
            timevalue = timevalue + [obj integerValue];
        }
    }];
    return timevalue;
}

@end
