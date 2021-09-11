//
//  file.h
//  ice_sudoku
//
//  Created by 王子诚 on 2019/1/24.
//  Copyright © 2019 王子诚. All rights reserved.
//

#ifndef file_h
#define file_h
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "TransferService.h"

@interface filer: NSObject
{
    
}
+(void)secrets_init;
+(NSString *)GetShareFilePath:(NSString*)filename;
+(NSString *)GetFilePath:(NSString*)filename;
+(void)File_Save:(NSString*)data to:(NSString*)filename;
+(NSString *)File_read:(NSString*)filename;
+(void)File_Save_Arch:(NSString*)data to:(NSString*)filename;
+(NSString*)File_read_Arch:(NSString*)filename;
+(void)File_Save_Share:(NSString*)data to:(NSString*)filename;
+(NSString*)File_read_Share:(NSString*)filename;
+(BOOL)Delete_File:(NSString*)filename;
+(void)File_cut_from:(NSString*)filepath to:(NSString*)newfilepath;
+(void)File_Save_Mutable_Array:(NSMutableArray*)data to:(NSString*)filename;
+(NSMutableArray *)File_read_Mutable_Array:(NSString*)filename;
+(NSString *)pack_sudoku:(const int[9][9])sudo;
+(NSString *)pack_sudoku_candidate:(int[10][9][9])sudo;
+(NSString *)pack_player_candidate:(int[9][9][10])sudo;
+(NSString *)pack_sudoku_normal_direction:(int[9][9])sudo;
+(void)release_sudoku:(int[9][9])sudo data:(NSString*)data;
+(void)release_sudoku_candidate:(int[10][9][9])sudo data:(NSString*)data;
+(void)release_player_candidate:(int[9][9][10])sudo data:(NSString*)data;
+(bool)scan_old_share_dir;
+(NSMutableArray<NSString*>*)get_all_save_names_and_time;
+(NSString*)get_date_str;
+(NSString*)get_org_save_name:(NSString*)file_name Time:(NSString*)time_str;
+(NSArray<NSString*>*)Read_Pieces_Archieve:(NSString*)full_file_name;
+(BOOL)Delete_Archieve:(NSString*)full_file_name;
+(void)quick_notify_image:(UIImage*)m_imgFore;
@end
#endif /* file_h */
