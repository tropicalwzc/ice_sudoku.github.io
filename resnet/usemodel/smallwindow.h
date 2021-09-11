//
//  smallwindow.h
//  ice_checker
//
//  Created by 王子诚 on 2019/2/19.
//  Copyright © 2019 王子诚. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#ifndef smallwindow_h
#define smallwindow_h

#import <Foundation/Foundation.h>
#import "file.h"

@interface smallwindow:UIAlertController
{
    @public
    int choice;
    int current_lang;
    UIViewController* father_window; 
}
-(smallwindow*)init_with_fatherwindow:(UIViewController*)aim;
-(void)Simple_NewsMessage_With_Title:(NSString*)title andMessage:(NSString*)message;
-(void)Simple_alertMessage_With_Title:(NSString*)title andMessage:(NSString*)message;

-(void)Sure_or_not_window_with_title:(NSString*)title andMessage:(NSString*)message process_func:(SEL)func sure_button_title: (NSString*)sure_text cancle_button_title:(NSString*)cancle_text;
-(void)Input_one_line_window_with_title:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placehoderstr process_NSString_func:(SEL)func;
-(void)Input_one_line_window_with_title_and_realholder:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placehoderstr process_NSString_func:(SEL)func;
//func should be a void(*)(NSString*) type function
-(void)Input_clip_window_with_title:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placehoderstr process_NSString_func:(SEL)func blue_toothshare_func:(SEL)blue_tooth_share_func;
-(void)ShowAutoReleaseAlert:(NSString*)message;
-(void)set_lang:(int)lang;
-(void)set_father_view:(UIViewController*) aim;
-(void)Rich_NewsMessage_with_two_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two;
-(void)Rich_NewsMessage_with_three_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two funct3:(SEL)funct_three;
-(void)Rich_NewsMessage_with_four_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two funct3:(SEL)funct_three funct4:(SEL)funct_four;
-(void)Rich_NewsAlert_with_two_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two;
-(void)Image_Alert:(NSString*)title image:(UIImage*)img;
+(bool)is_comment_exist;
+(void)Show_limit_rate_win;
+(void)Show_deep_link_comment_win:(bool)needcheck;
+(void)Show_deep_link_comment_win_force;
@end

#endif /* smallwindow_h */
