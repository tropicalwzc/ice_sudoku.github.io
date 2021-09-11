//
//  file.m
//  ice_sudoku
//
//  Created by 王子诚 on 2019/1/24.
//  Copyright © 2019 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "file.h"

static NSMutableArray *bitsecrets;
@implementation filer
+(void)secrets_init
{
    if(bitsecrets==nil){
    //this is fake secrets
    //the real secrets only I know
    //You can not use this secrets to attack ice sudoku saves
        bitsecrets = [[NSMutableArray alloc]initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,]];
    }
}
+(NSString*)GetShareRootPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
+(NSString *)GetShareFilePath:(NSString*)filename
{
    return [[self GetShareRootPath] stringByAppendingPathComponent:filename];
}
+(NSString *)GetShareArchRootPath
{
    NSString* documentsDirectory = [[self GetShareRootPath] stringByAppendingPathComponent:@"IceSudokuShare"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:documentsDirectory]){
        [[NSFileManager defaultManager]createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}
+(NSString *)GetShareArchivePath:(NSString*)filename
{
    return [[self GetShareArchRootPath] stringByAppendingPathComponent:filename];
}
+(NSString*)GetCacheRootPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
+(NSString *)GetFilePath:(NSString*)filename
{
    return [[self GetCacheRootPath] stringByAppendingPathComponent:filename];
}
+(void)File_Save:(NSString*)data to:(NSString*)filename
{
    NSError * error;
    [data writeToFile:[self GetFilePath:filename] atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
+(NSString *)File_read:(NSString*)filename
{
    NSError * error;
    NSString * aimpath = [self GetFilePath:filename];
    if([[NSFileManager defaultManager]fileExistsAtPath:aimpath]){
        NSString* res=[[NSString alloc]initWithContentsOfFile:aimpath encoding:NSUTF8StringEncoding error:&error];
        return res;
    }
    else{
        return nil;
    }
}
+(void)File_Save_Share:(NSString*)data to:(NSString*)filename
{
    NSError * error;
    [data writeToFile:[self GetShareFilePath:filename] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    // NSLog(@"save %@ to %@",data,filename);
}
+(NSString*)File_read_Share:(NSString*)filename
{
    NSError * error;
    NSString * aimpath = [self GetShareFilePath:filename];
    if([[NSFileManager defaultManager]fileExistsAtPath:aimpath]){
        NSString* res=[[NSString alloc]initWithContentsOfFile:aimpath encoding:NSUTF8StringEncoding error:&error];
        return res;
    }
    else{
        return @"";
    }
}
+(void)File_Save_Arch:(NSString*)data to:(NSString*)filename
{
    NSError * error;
    NSString * realdata = [self bitleftrun:data];
    [realdata writeToFile:[self GetShareArchivePath:[filename stringByAppendingString:@".ice_sudoku_save"]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    // NSLog(@"save %@ to %@",data,filename);
}
+(NSString*)File_read_Arch:(NSString*)filename
{
    NSError * error;
    NSString * aimpath = [self GetShareArchivePath:[filename stringByAppendingString:@".ice_sudoku_save"]];
    if([[NSFileManager defaultManager]fileExistsAtPath:aimpath]){
        NSString* res=[[NSString alloc]initWithContentsOfFile:aimpath encoding:NSUTF8StringEncoding error:&error];
        NSString* realres = [self bitrightrun:res];
        return realres;
    }
    else{
        return @"";
    }
}
+(void)File_cut_from:(NSString*)filepath to:(NSString*)newfilepath
{
    NSFileManager* mg = [NSFileManager defaultManager];
    [mg copyItemAtPath:filepath toPath:newfilepath error:nil];
    [mg removeItemAtPath:filepath error:nil];
}
+(NSString *)pack_sudoku_normal_direction:(int[9][9])sudo
{
    char dir[100]={};
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            dir[j*9+i]=(char)(sudo[i][j]+48);
    dir[81]='\0';
    return [[NSString alloc] initWithCString:dir encoding:NSUTF8StringEncoding];
}
+(NSString *)pack_sudoku:(const int[9][9])sudo
{
    char dir[100]={};
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            dir[i*9+j]=(char)(sudo[i][j]+48);
    dir[81]='\0';
    return [[NSString alloc] initWithCString:dir encoding:NSUTF8StringEncoding];
}
+(NSString *)pack_sudoku_candidate:(int[10][9][9])sudo
{
    char dir[1000];
    int le=0;
    for(int k=0;k<10;k++)
      for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            {
                dir[le]=(char)(sudo[k][i][j]+48);
                ++le;
            }
    dir[le]='\0';
    return [[NSString alloc] initWithCString:dir encoding:NSUTF8StringEncoding];
}
+(NSString *)pack_player_candidate:(int[9][9][10])sudo
{
    char dir[1000];
    int le=0;
        for(int i=0;i<9;i++)
            for(int j=0;j<9;j++)
                for(int k=0;k<10;k++)
                {
                dir[le]=(char)(sudo[i][j][k]+48);
                ++le;
                }
        dir[le]='\0';
    return [[NSString alloc] initWithCString:dir encoding:NSUTF8StringEncoding];
}
+(void)release_sudoku:(int[9][9])sudo data:(NSString*)data
{
    if(data.length!=81)
        return;
    const char* dir=[data UTF8String];
    int le=0;
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            sudo[i][j]=dir[le]-'0';
            ++le;
        }
}
+(void)release_sudoku_candidate:(int[10][9][9])sudo data:(NSString*)data
{
    if(data.length!=810)
        return;
    const char* dir=[data UTF8String];
    int le=0;
    for(int k=0;k<10;k++)
      for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            sudo[k][i][j]=dir[le]-'0';
            ++le;
        }
}
+(void)release_player_candidate:(int[9][9][10])sudo data:(NSString*)data
{
    if(data.length!=810)
        return;
    const char* dir=[data UTF8String];
    int le=0;
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            for(int k=0;k<10;k++)
            {
            sudo[i][j][k]=dir[le]-'0';
            ++le;
            }
}
+(BOOL)Delete_File:(NSString*)filename
{    
    if([[NSFileManager defaultManager] removeItemAtPath:[self GetFilePath:filename] error:NULL]==NO)
    {
        // NSLog(@"Delete %@ failed",filename);
        return NO;
    }
    
    return true;
}
+(void)File_Save_Mutable_Array:(NSMutableArray*)data to:(NSString*)filename
{
    [data writeToFile:[self GetFilePath:filename] atomically:true];
}
+(NSMutableArray*)File_read_Mutable_Array:(NSString*)filename
{
    NSMutableArray*data=[[NSMutableArray alloc]initWithContentsOfFile:[self GetFilePath:filename]];
    return data;
}
+(NSMutableArray*)File_read_Mutable_Array_Old:(NSString*)filename
{
    NSMutableArray*data=[[NSMutableArray alloc]initWithContentsOfFile:[self GetShareFilePath:filename]];
    return data;
}
+(NSString*)bitleftrun:(NSString*)data
{
    [self secrets_init];
    NSString* res = [[NSString alloc]init];
    bool last_is_zero = false;
    int zero_acu = 0;
    int outid = 0;
    for(int i=0;i<[data length];i++){
        char mc = [data characterAtIndex:i];
        if(mc == '0'){
            if(!last_is_zero){
                last_is_zero = true;
                zero_acu = 1;
            }
            else{
                zero_acu++;
                continue;
            }
        }
        else{
            if(last_is_zero){
                char nc = ';'+rand()%20 + [bitsecrets[outid++ & 31] intValue];
                res = [res stringByAppendingFormat:@"%c",nc];
                char buffer[10]={};
                snprintf(buffer, 10, "%d",zero_acu);
                for(int j=0;j<strlen(buffer);j++){
                    nc = buffer[j] + [bitsecrets[outid++ & 31] intValue];
                    res = [res stringByAppendingFormat:@"%c",nc];
                }
                nc = ';'+rand()%20 + [bitsecrets[outid++ & 31] intValue];
                res = [res stringByAppendingFormat:@"%c",nc];
                last_is_zero = false;
            }
            char nc = mc + [bitsecrets[outid++ & 31] intValue];
            res = [res stringByAppendingFormat:@"%c",nc];
        }
    }
    NSString* finres = [[NSString alloc]initWithFormat:@"%@%@",[self sha1:res],res];
    return finres;
}
+(NSString*)bitrightrun:(NSString*)data
{
    if([data length]<40)
        return @"FAILED";
    [self secrets_init];
    NSString* orgsha = [data substringToIndex:40];
    NSString* orgdata = [data substringFromIndex:40];
    NSString* nowsha = [self sha1:orgdata];
    if(![nowsha isEqualToString:orgsha])
        return @"FAILED";
    char buffer[10]={};
    int buffer_pointer = 0;
    NSString* res = [[NSString alloc]init];
    bool leftfound = false;
    for(int i=0;i<[orgdata length];i++){
        
        char mc = [orgdata characterAtIndex:i];
        int bc = i & 31;
        char nc = mc - [bitsecrets[bc] intValue];
        
        if(nc>=';'){
            if(leftfound){
                leftfound = false;
                NSString* bf = [[NSString alloc]initWithUTF8String:buffer];
                int zerocount = [bf intValue];
                for(int p=0;p<buffer_pointer;p++)
                    buffer[p]=0;
                buffer_pointer=0;
                for(int ci=0;ci<zerocount;ci++){
                    res = [res stringByAppendingString:@"0"];
                }
            }
            else{
                leftfound = true;
                continue;
            }
        }
        else{
            if(leftfound){
                buffer[buffer_pointer++]=nc;
            }
            else{
                res = [res stringByAppendingFormat:@"%c",nc];
            }
        }
        
    }
    return res;
}

+(NSString *)sha1:(NSString *)inputString{
    [self secrets_init];
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",((unsigned int)digest[i]+127+[bitsecrets[i&31] intValue])&255];
    }
    return [outputString lowercaseString];
}
+(NSString*)get_org_save_name:(NSString*)file_name Time:(NSString*)time_str
{
    return [[NSString alloc]initWithFormat:@"%@___%@",time_str,file_name];
}
+(NSMutableArray<NSString*>*)get_all_save_names_and_time
{
    NSString* ShareArchRootPath = [self GetShareArchRootPath];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ShareArchRootPath error:nil];
    NSMutableArray* res = [[NSMutableArray alloc]init];
    for(NSString* filename in fileNames){
        if([filename hasSuffix:@".ice_sudoku_save"]){
            if(![filename containsString:@"autosave"] && ![filename containsString:@"tp_stack"]){
                if([filename containsString:@"___"])
                    [res addObject:filename];
                else{
                    NSString* newfilename = [self get_org_save_name:filename Time:[self get_date_str]];
                    [self File_cut_from:[ShareArchRootPath stringByAppendingPathComponent:filename] to:[ShareArchRootPath stringByAppendingPathComponent:newfilename]];
                    [res addObject:newfilename];
                }
            }
        }
    }
    return res;
}
+(NSString*)get_date_str
{
    NSDate * currentDate = [[NSDate alloc] init];
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH_mm_ss-MM-dd"];
    [df setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]]; // 设置北京时区
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *ret = [df stringFromDate:currentDate];
    return ret;
}
+(bool)scan_old_share_dir
{
    NSString* scanned = [self File_read:@"old_save_scanned"];
    if(scanned!=nil)
        return false;
    NSFileManager* mg = [NSFileManager defaultManager];
    NSString* ShareRootPath = [self GetShareRootPath];
    NSString* CacheRootPath = [self GetShareRootPath];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ShareRootPath error:nil];
    NSMutableArray<NSString*>* oldfiles_paths = [[NSMutableArray alloc]init];
    NSArray<NSString*>*save_suffixes = @[@"_main",@"_candidate",@"_system",@"_setting",@"_update_time"];
    for(NSString* fileName in fileNames){
        NSString* abs_path_old = [ShareRootPath stringByAppendingPathComponent:fileName];
        NSString* abs_path_new = [CacheRootPath stringByAppendingPathComponent:fileName];
        bool has_bad_suffix = false;
        for(NSString* suffix in save_suffixes){
            if([abs_path_old hasSuffix:suffix]){
                has_bad_suffix = true;
                break;
            }
        }
        if(!has_bad_suffix)
            [mg copyItemAtPath:abs_path_old toPath:abs_path_new error:nil];
        [oldfiles_paths addObject:abs_path_old];
    }
    NSMutableArray* savers = [self File_read_Mutable_Array_Old:@"Savers_Names"];
    for(int i=0;i<[savers count];i++){
        NSLog(@"transfer %@",savers[i]);
        [self transfer_to_arch:savers[i]];
    }
    for(NSString* abs_path_old in oldfiles_paths)
    {
        [mg removeItemAtPath:abs_path_old error:nil];
        NSLog(@"Del old %@",abs_path_old);
    }
    [self File_Save:@"1" to:@"old_save_scanned"];
    return true;
}

+(bool)transfer_to_arch:(NSString*)filename
{
    NSString* main_f=[[NSString alloc]initWithFormat:@"%@_main",filename];
    NSString* candidate_f=[[NSString alloc]initWithFormat:@"%@_candidate",filename];
    NSString* system_f=[[NSString alloc]initWithFormat:@"%@_system",filename];
    NSString* setting_f=[[NSString alloc]initWithFormat:@"%@_setting",filename];

    NSString* data_main=[filer File_read_Share:main_f];
    NSString* res = [[NSString alloc]initWithFormat:@"%@:",data_main];
    NSString* data_candidate=[filer File_read_Share:candidate_f];
    res = [res stringByAppendingFormat:@"%@:",data_candidate];
    NSString* data_system=[filer File_read_Share:system_f];
    res = [res stringByAppendingFormat:@"%@:",data_system];
    NSString* data_setting=[filer File_read_Share:setting_f];
    res = [res stringByAppendingString:data_setting];
    NSString* new_name = [self get_org_save_name:filename Time:[self get_date_str]];
    [self File_Save_Arch:res to:new_name];
    return true;
}
+(NSArray<NSString*>*)Read_Pieces_Archieve:(NSString*)full_file_name
{
    NSString* data_org = [self File_read_Arch:full_file_name];
    if(data_org == nil || [data_org isEqualToString:@""])
        return nil;
    NSArray<NSString*>*pieces = [data_org componentsSeparatedByString:@":"];
    if([pieces count]!=4 || [pieces[0]length]!=81 || [pieces[2]length]!=810)
        return nil;
    return pieces;
}
+(BOOL)Delete_Archieve:(NSString*)full_file_name
{
    if([[NSFileManager defaultManager] removeItemAtPath:[self GetShareArchivePath:[full_file_name stringByAppendingString:@".ice_sudoku_save"]] error:NULL]==NO)
    {
        return NO;
    }
    return true;
}
+(NSString *)getUniqueID
{
    NSUUID * UID = [[NSUUID alloc]init];
    NSString* res = [UID UUIDString];
    return res;
}
+(NSString*)image_root_dir
{
    NSString *rootPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SudokuDataSet"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:rootPath] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return rootPath;
}
+(NSString*)image_dir_for_number:(int)num
{
    NSString* rootdir = [self image_root_dir];
    NSString* numberfoldername = [[NSString alloc]initWithFormat:@"%d",num];
    NSString* numberdir = [rootdir stringByAppendingPathComponent:numberfoldername];
    if ([[NSFileManager defaultManager] fileExistsAtPath:numberdir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:numberdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return numberdir;
}
+(NSString*)save_image_to_folder:(UIImage*)m_imgFore number:(int)num
{
    NSData *imagedata = UIImagePNGRepresentation(m_imgFore);
    NSString* numimagedir = [self image_dir_for_number:num];
    NSString* imagefilename = [[NSString alloc]initWithFormat:@"%@.png",[self getUniqueID]];
    NSString *savedImagePath=[numimagedir stringByAppendingPathComponent:imagefilename];
    [imagedata writeToFile:savedImagePath atomically:NO];
    return savedImagePath;
}
+(void)quick_notify_image:(UIImage*)m_imgFore
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       // NSString* newly_saved_image_path = [self save_image_to_folder:m_imgFore number:SCANCACHENUMBER];
        NSDictionary* userInfo = @{@"recev":m_imgFore};
        [[NSNotificationCenter defaultCenter]postNotificationName:please_scan_this_sudoku object:@"" userInfo:userInfo];
    });
}
@end
