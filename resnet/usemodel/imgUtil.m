//
//  imgUtil.m
//  ice sudoku
//
//  Created by 王子诚 on 2021/9/4.
//  Copyright © 2021 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imgUtil.h"



@implementation imgUtil

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage*)highcontrast_transfer:(UIImage*)img
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    // 修改亮度   -1---1   数越大越亮
    [lighten setValue:@(-1) forKey:@"inputBrightness"];
    // 修改饱和度  0---2
    [lighten setValue:@(2) forKey:@"inputSaturation"];
    // 修改对比度  0---4
    [lighten setValue:@(4) forKey:@"inputContrast"];
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    
    // 得到修改后的图片
    UIImage* myImage = (__bridge UIImage *)((__bridge CGImageRef)([UIImage imageWithCGImage:cgImage]));
    
    // 释放对象
    CGImageRelease(cgImage);
    return myImage;
    
}
+ (UIImage *)preprocess_to_normal_image:(UIImage*)img
{
   // img = [img getGrayImageForce];
   // img = [imgUtil highcontrast_transfer:img];
    return img;
}
+ (UIImage*)cut_origin_image:(UIImage*)img startx:(int)startx andstarty:(int)starty endx:(int)endx endy:(int)endy
{
    //转化为位图
    CGImageRef temImg = img.CGImage;
    //根据范围截图
    CGRect cropRect;
    cropRect.origin.x = starty;
    cropRect.origin.y = startx;
    cropRect.size.width = endy - starty;
    cropRect.size.height = endx - startx;
    temImg=CGImageCreateWithImageInRect(temImg, cropRect);
    //得到新的图片
    UIImage *newimg = [UIImage imageWithCGImage:temImg];
    //释放位图对象
    CGImageRelease(temImg);
    
    return newimg;
}
+ (UIImage*)Transfer_to_square_image:(UIImage*)recevimg
{
    CGRect Screensize=[UIScreen mainScreen].bounds;
    UIImage* reversed;
    if(Screensize.size.height>Screensize.size.width)
        reversed = [recevimg imageRotateWithIndegree:-M_PI/2];
    else{
        reversed = recevimg;
    }
   // NSLog(@"after reversed: %@", reversed);
    int indexer = 120;
    UIImage* cutted = [imgUtil cut_origin_image:reversed startx:indexer andstarty:420+indexer endx:1080-indexer endy:1500-indexer];
    return cutted;
}
+(void)getSizeFromImage:(UIImage *)image width:(long*)widthall height:(long*)heightall
{
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    long resW = CGImageGetWidth(imageRef);
    long resH = CGImageGetHeight(imageRef);
    *widthall = resW;
    *heightall = resH;
    // CGImageRelease(imageRef);
}
+(UIImage*)jitterImage:(UIImage *)image widval:(double)widrand heightval:(double)heirand digreeval:(int)angle
{
    double angle_unit = M_PI/180;
    int angel_change = rand()%angle;
    double realanglechange = angel_change * angle_unit;
    if(rand()%2==0)
        realanglechange = -realanglechange;
    
    long total_width;
    long total_height;
    UIImage* jittered = [image imageRotateWithIndegree:realanglechange];
    [self getSizeFromImage:image width:&total_width height:&total_height];
    long randwidmax = total_width*widrand;
    long randheimax = total_height*heirand;
    long widchangereal = rand()%randwidmax;
    long heichangereal = rand()%randheimax;
    double divwid = (rand()%100)/100;
    double divhei = (rand()%100)/100;
    int startx = widchangereal*divwid;
    int starty = heichangereal*divhei;
    int endxoffset = widchangereal*(1-divwid);
    int endyoffset = heichangereal*(1-divhei);
    jittered = [self cut_origin_image:jittered startx:startx andstarty:starty endx:total_width-endxoffset endy:total_height-endyoffset];
    return jittered;
}
@end


