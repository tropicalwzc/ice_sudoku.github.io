//
//  smart.m
//  ice sudoku
//
//  Created by 王子诚 on 2021/8/30.
//  Copyright © 2021 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "smart.h"

@implementation imgimformation

@end

@implementation spos

-(spos*)init_with_iden:(int)iden x:(int)x y:(int)y
{
    iden_ = iden;
    x_ = x;
    y_ = y;
    sid_ = [[NSString alloc]initWithFormat:@"%d",iden_];
    return self;
}
-(int)X
{
    return x_;
}
-(int)Y
{
    return y_;
}
-(int)Val;
{
    return iden_;
}
-(void)setVal:(int)val
{
    iden_ = val;
}
-(NSString*)Sid
{
    return sid_;
}
@end

@implementation smart

-(smart*)init
{
    sudo_player = [[sudoku alloc]init];
    clever_minist = [[ministmodel alloc]init];
    finish_lock = dispatch_semaphore_create(1);
    job_lock = dispatch_semaphore_create(1);
    support_got = false;
    extra_labor_count = 0;
    return self;
}
-(smart*)initwithAnswer:(int[9][9])answer
{
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            dataset_answer[i][j]=answer[i][j];
    need_create_dataset = true;
    finish_lock = dispatch_semaphore_create(1);
    return self;
  //  return [self init];
}
-(void)updateAnswer:(int[9][9])answer
{
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            dataset_answer[i][j]=answer[i][j];
    
    need_create_dataset = true;
}
-(int)PredictWithInputimage:(UIImage*)img
{
    int resm = [clever_minist PredictWithInputimage:img];
    return resm;
}
-(int)PredictWithInputimage_onworker:(UIImage*)img workerid:(int)ider
{
    int resm = [support_minists[ider] PredictWithInputimage:img];
    return resm;
}
- (UIImage*)cut_origin_image:(int)startx andstarty:(int)starty endx:(int)endx endy:(int)endy
{
  //  return [imgUtil cut_origin_image:original_image startx:startx andstarty:starty endx:endx endy:endy];
    UIImage * img = original_image;
    //转化为位图
    CGImageRef temImg = img.CGImage;
    //根据范围截图
    CGRect cropRect;
    cropRect.origin.x = starty;
    cropRect.origin.y = startx;
    cropRect.size.width = endy - starty;
    cropRect.size.height = endx - startx;
  //  NSLog(@"%d %d %d %d",cropRect.origin.x,cropRect.origin.y,cropRect.size.width,cropRect.size.height);
    temImg=CGImageCreateWithImageInRect(temImg, cropRect);
    //得到新的图片
    UIImage *newimg = [UIImage imageWithCGImage:temImg];
    //释放位图对象
    CGImageRelease(temImg);

    return newimg;
}
-(NSString*)image_root_dir
{
    NSString *rootPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SudokuDataSet"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:rootPath] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return rootPath;
}
-(NSString*)image_dir_for_number:(int)num
{
    NSString* rootdir = [self image_root_dir];
    NSString* numberfoldername = [[NSString alloc]initWithFormat:@"%d",num];
    NSString* numberdir = [rootdir stringByAppendingPathComponent:numberfoldername];
    if ([[NSFileManager defaultManager] fileExistsAtPath:numberdir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:numberdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return numberdir;
}
-(NSString *)getUniqueID
{
    NSUUID * UID = [[NSUUID alloc]init];
    NSString* res = [UID UUIDString];
    return res;
}
-(void)save_image_to_folder:(UIImage*)m_imgFore number:(int)num
{
    NSData *imagedata = UIImageJPEGRepresentation(m_imgFore, 0.9);
    NSString* numimagedir = [self image_dir_for_number:num];
    NSString* imagefilename = [[NSString alloc]initWithFormat:@"%@.jpg",[self getUniqueID]];
    NSString *savedImagePath=[numimagedir stringByAppendingPathComponent:imagefilename];
    [imagedata writeToFile:savedImagePath atomically:YES];
}


-(void)set_father_controller:(smallwindow*)fatherwincontrol
{
    father_wincontroller = fatherwincontrol;
}
-(void)getSizeFromImage:(UIImage *)image
{
    NSLog(@"image");
    original_image = image;
    long H,W;
    [imgUtil getSizeFromImage:image width:&W height:&H];
    img_width = W;
    img_height = H;
}
-(int)force9_9Split_quick
{
    int smallw = (int)img_width/9;
    int smallh = (int)img_height/9;
    int splitid = 0;
    for(int i=0;i<9;i++){
        for(int j=0;j<9;j++){
            int startx = i*smallh;
            int endx = (i+1)*smallh;
            int starty = j*smallw;
            int endy = (j+1)*smallw;
            splitinfo[splitid][0]=startx;
            splitinfo[splitid][1]=starty;
            splitinfo[splitid][2]=endx;
            splitinfo[splitid][3]=endy;
            splitid++;
        }
    }
    return 81;
}

-(int)ScanDataSet:(int[9][9])sudores img:(UIImage*)image callback:(void(^)(bool res))callback
{
    [self getSizeFromImage:image];
    [self updateAnswer:sudores];
    [self force9_9Split_quick];

    if(need_create_dataset){
        for(int i=0;i<81;i++){
            int exp_w = 0;
            int exp_h = 0;
            UIImage* cutted_img = [self cut_origin_image:splitinfo[i][0]+exp_w andstarty:splitinfo[i][1]+exp_h endx:splitinfo[i][2]-exp_w endy:splitinfo[i][3]-exp_h];
            NSLog(@"cutted %@",cutted_img);
            int answer = dataset_answer[i/9][i%9];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.1*NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self save_image_to_folder:cutted_img number:answer];
                callback(true);
            });
        }
        return 1;
    }
    return 0;
}
-(void)grant_access_for_labor:(NSArray<NSThread*>*)labors
{
    dispatch_semaphore_wait(job_lock, DISPATCH_TIME_FOREVER);
    father_support_threads = [[NSArray alloc]initWithArray:labors];
    extra_labor_count = (int)[father_support_threads count];
    if(extra_labor_count>4)
        extra_labor_count=4;
    if(!support_got){
        support_minists = [[NSMutableArray alloc]init];
        for(int i=0;i<extra_labor_count;i++){
            ministmodel* cle = [[ministmodel alloc]init];
            [support_minists addObject:cle];
        }
        support_got = true;
        NSLog(@"for support now");
    }
    dispatch_semaphore_signal(job_lock);
}

-(int)get_next_job
{
    int jobid;
    dispatch_semaphore_wait(job_lock, DISPATCH_TIME_FOREVER);
    jobid = next_job_id;
    next_job_id++;
    dispatch_semaphore_signal(job_lock);
    if(jobid>=81)
        return -1;
    return jobid;
}

//if there are unfinished task, return img_reg_id
//if all finish return -1
-(void)write_answer:(int)res at_x:(int)x y:(int)y
{
    dispatch_semaphore_wait(finish_lock, DISPATCH_TIME_FOREVER);
    if([sudo_player canputin:dataset_answer row:x col:y bit:res]!=-1)
        dataset_answer[x][y]=res;
    finished_num++;
    dispatch_semaphore_signal(finish_lock);
    if(finished_num>=81){
        all_finish_callback(dataset_answer);
    }
}
-(void) task_for_labor_worker:(NSString*)ider
{
    int laborid = [ider intValue];
    [self task_for_img_piece:laborid workid:laborid];
    int nextpiece = [self get_next_job];
    while (nextpiece!=-1) {
        [self task_for_img_piece:nextpiece workid:laborid];
        nextpiece = [self get_next_job];
    }
}
-(void)task_for_img_piece:(int)ic workid:(int)ider
{
    int joberx = ic/9;
    int jobery = ic%9;
    int i = job_for_x[joberx]*9 + job_for_y[jobery];
    int startx = splitinfo[i][0];
    int endx = splitinfo[i][2];
    int starty = splitinfo[i][1];
    int endy = splitinfo[i][3];
    double origin_x_len = endx - startx;
    double origin_y_len = endy - starty;
    double randcropxval = (rand()%45 + 36)/10.0;
    double randcropyval = (rand()%45 + 36)/10.0;
    int exp_w = origin_x_len/randcropxval;
    int exp_h = origin_y_len/randcropxval;
    UIImage* cutted_img = [self cut_origin_image:startx   andstarty:starty   endx:endx   endy:endy ];
    
//    NSLog(@"Pred %d,%d",i/9,i%9);
    int realres = [self PredictWithInputimage_onworker:cutted_img workerid:ider];
    int randtrytimeremain = 3;
    if(realres==0&&randtrytimeremain>0){
        randcropxval = (rand()%45 + 36)/10.0;
        randcropyval = (rand()%45 + 36)/10.0;
        exp_w = origin_x_len/randcropxval;
        exp_h = origin_y_len/randcropyval;
        cutted_img = [self cut_origin_image:startx + exp_w andstarty:starty + exp_h endx:endx - exp_w endy:endy - exp_h];
        realres = [self PredictWithInputimage_onworker:cutted_img workerid:ider];
        randtrytimeremain--;
    }
    [self write_answer:realres at_x:i/9 y:i%9];
}

-(int)ScanForSudoku:(UIImage *)image callback:(void(^)(const int res[9][9]))callback
{
    all_finish_callback = callback;
    need_create_dataset = true;
    finished_num = 0;
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            dataset_answer[i][j]=0;
    
    UIImage * inputed_img = [imgUtil preprocess_to_normal_image:image];
    [self getSizeFromImage:inputed_img];
    [self force9_9Split_quick];
    
    if(support_got){
        NSLog(@"father_support_threads %d support_minists %d",[father_support_threads count],[support_minists count]);
        if([father_support_threads count]>=2&&[support_minists count]>=2)
            support_got = true;
        else{
            support_got = false;
        }
    }
    if(support_got){
        long support_count = [support_minists count];
        next_job_id = support_count;
        [sudo_player randbar:job_for_x];
        [sudo_player randbar:job_for_y];
        NSLog(@"GOT SUPPORT");
        for(int i=0;i<[support_minists count];i++){
            NSString* taskstr = [[NSString alloc]initWithFormat:@"%d",i];
            [self performSelector:@selector(task_for_labor_worker:) onThread:father_support_threads[i] withObject:taskstr waitUntilDone:NO];
        }
    }
    else{
        NSLog(@"NO SUPPORT");
        for(int ic=0;ic<81;ic++){
            __block int i = ic;
            __block int startx = splitinfo[i][0];
            __block int endx = splitinfo[i][2];
            __block int starty = splitinfo[i][1];
            __block int endy = splitinfo[i][3];
            
            //没有援助情况下直接使用异步队列
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                double origin_x_len = endx - startx;
                double origin_y_len = endy - starty;
                int exp_w = origin_x_len/6;
                int exp_h = origin_y_len/6;
                UIImage* cutted_img = [self cut_origin_image:startx + exp_w andstarty:starty + exp_h endx:endx - exp_w endy:endy - exp_h];
                
               // NSLog(@"Pred %d,%d",i/9,i%9);
                int realres = [self PredictWithInputimage:cutted_img];
                if(realres==0){
                    exp_w = origin_x_len/4.5;
                    exp_h = origin_y_len/4.5;
                    cutted_img = [self cut_origin_image:startx + exp_w andstarty:starty + exp_h endx:endx - exp_w endy:endy - exp_h];
                    realres = [self PredictWithInputimage:cutted_img];
                }
                [self write_answer:realres at_x:i/9 y:i%9];
            });
        }
    }
    return 0;
}



@end
