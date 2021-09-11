//
//  smart.h
//  ice sudoku
//
//  Created by 王子诚 on 2021/8/30.
//  Copyright © 2021 王子诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imgUtil.h"
#import "ministmodel.h"
#import "smallwindow.h"
#import "IceSudokuModel.h"
#import "sudoku.h"

#ifndef smart_h
#define smart_h

@interface spos : NSObject
{
    NSString* sid_;
    int iden_;
    int x_;
    int y_;
}
-(spos*)init_with_iden:(int)iden x:(int)x y:(int)y;
-(int)X;
-(int)Y;
-(int)Val;
-(void)setVal:(int)val;
-(NSString*)Sid;
@end

@interface imgimformation : NSObject

@end

@interface imgimformation ()
@property(assign)double balance_up;
@property(assign)double balance_left;
@property(assign)double longest_ver;
@property(assign)double longest_hori;
@property(assign)double ver_pos_rate;
@property(assign)double hori_pos_rate;
@property(assign)int circlenum;
@end

#define smartImage NSArray< NSArray<spos*>* >*
static bool need_create_dataset;
API_AVAILABLE(ios(13.0))
@interface smart: NSObject
{
    sudoku* sudo_player;
    long img_width;
    long img_height;
    long backcolor;
    long linecolor;
    long littletravelaimcolor;
    long littletravelenemycolor;
    long littleticktock;
    long littlehistory;
    int rateacu;
    int imformationid;
    int little_end_x;
    int little_end_y;
    bool maxinfo_notinited;
    int mh;
    int mw;
     ministmodel* clever_minist;
     smallwindow* father_wincontroller;
     int splitinfo[100][4];
     smartImage littleimg;
     NSMutableArray *arr;
     UIImage* original_image;

    int dataset_answer[9][9];
    int job_for_x[9];
    int job_for_y[9];
    int finished_num ;
    dispatch_semaphore_t finish_lock;
    dispatch_semaphore_t job_lock;
    int next_job_id;
    NSArray<NSThread*>* father_support_threads;
    NSMutableArray<ministmodel*>* support_minists;
    bool support_got;
    int extra_labor_count;
    void(^all_finish_callback)(const int res[9][9]);
}
-(smart*)init;
-(smart*)initwithAnswer:(int[9][9])answer;
-(void)updateAnswer:(int[9][9])answer;
-(void)grant_access_for_labor:(NSArray<NSThread*>*)labors;
-(void)set_father_controller:(smallwindow*)fatherwincontrol;
-(int)ScanDataSet:(int[9][9])sudores img:(UIImage*)image callback:(void(^)(bool res))callback;
-(int)ScanForSudoku:(UIImage *)image callback:(void(^)(const int res[9][9]))callback;
-(UIImage*)cut_origin_image:(int)startx andstarty:(int)starty endx:(int)endx endy:(int)endy;
-(int)PredictWithInputimage:(UIImage*)img;
@end
#endif /* smart_h */
