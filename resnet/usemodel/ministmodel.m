//
//  ministmodel.m
//  ice sudoku
//
//  Created by 王子诚 on 2021/9/2.
//  Copyright © 2021 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ministmodel.h"


@implementation ministmodel

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(ministmodel*)init
{
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *modelPath = [bundlePath stringByAppendingPathComponent:@"IceSudokuModel.mlmodelc"];
    NSURL* url = [[NSURL alloc]initFileURLWithPath:modelPath];
    NSLog(@"model path %@",modelPath);
    if (@available(iOS 13.0, *)) {
        NSError* err;
        MLModelConfiguration* config = [[MLModelConfiguration alloc]init];
        config.computeUnits = MLComputeUnitsAll;
        our_resnet = [[IceSudokuModel alloc]initWithContentsOfURL:url configuration:config error:&err];
        NSLog(@"nerr %@",err);
    } else {
        // Fallback on earlier versions
    }
    return self;
}
-(int)PredictWithInputimage:(UIImage*)input_img
{
    UIImage* resized_img = [self imageWithImage:input_img scaledToSize:CGSizeMake(64, 64)];
    CGImageRef temImg = resized_img.CGImage;
    NSError* err;
    IceSudokuModelInput* myinput = [[IceSudokuModelInput alloc]initWithMy_inputFromCGImage:temImg error:&err];
    IceSudokuModelOutput *iceout = [our_resnet predictionFromFeatures:myinput error:&err];
    if(err!=nil){
        NSLog(@"error = %@",err);
    }
    MLMultiArray *arrout = [iceout my_output];
    int res = 0;
    double maxv = 0;
    for(int i=0;i<[arrout count];i++){
        NSString* val = [[NSString alloc]initWithFormat:@"%@",[arrout objectAtIndexedSubscript:i]];
        double rv = [val doubleValue];
        if(i==0){
            maxv=rv;
        }
        else{
            if(rv>maxv){
                res = i;
                maxv = rv;
            }
        }
        //NSLog(@"%d rate = %@",i,[arrout objectAtIndexedSubscript:i]);
    }
    return res;
}
@end
