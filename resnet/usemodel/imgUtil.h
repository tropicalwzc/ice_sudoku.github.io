//
//  imgUtil.h
//  ice sudoku
//
//  Created by 王子诚 on 2021/9/4.
//  Copyright © 2021 王子诚. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIImage+grayImage.h"
#import "TransferService.h"
#ifndef imgUtil_h
#define imgUtil_h

@interface imgUtil : NSObject
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)highcontrast_transfer:(UIImage*)img;
+ (UIImage *)preprocess_to_normal_image:(UIImage*)img;
+ (UIImage*)cut_origin_image:(UIImage*)img startx:(int)startx andstarty:(int)starty endx:(int)endx endy:(int)endy;
+ (UIImage*)Transfer_to_square_image:(UIImage*)recevimg;
+ (void)getSizeFromImage:(UIImage *)image width:(long*)widthall height:(long*)heightall;
+ (UIImage*)jitterImage:(UIImage *)image widval:(double)widrand heightval:(double)heirand digreeval:(int)angle;
@end

#endif /* imgUtil_h */
