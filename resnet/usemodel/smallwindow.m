//
//  smallwindow.m
//  ice_checker
//
//  Created by 王子诚 on 2019/2/19.
//  Copyright © 2019 王子诚. All rights reserved.
//


#import "smallwindow.h"

@interface smallwindow()

@end

static bool commented = false;

@implementation smallwindow
-(smallwindow*)init_with_fatherwindow:(UIViewController*)aim;
{
    father_window=aim;
    return self;
}
-(void)Simple_NewsMessage_With_Title:(NSString*)title andMessage:(NSString*)message{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self->father_window presentViewController: alert animated: YES completion:nil];
}
-(void)Simple_alertMessage_With_Title:(NSString*)title andMessage:(NSString*)message{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self->father_window presentViewController: alert animated: YES completion:nil];
}
- (void)ShowAutoReleaseAlert:(NSString*)message{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [father_window presentViewController:alertCtrl animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertCtrl dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
-(void)set_father_view:(UIViewController*) aim;
{
    father_window=aim;
}
-(void)set_lang:(int)lang
{
    current_lang=lang;
}
-(void)Input_one_line_window_with_title:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placehoderstr process_NSString_func:(SEL)func
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placehoderstr; // if needs
        if(textField.placeholder.length==81)
        {
            textField.text=placehoderstr;
        }
    }];

    UIAlertAction * action_cancle = [UIAlertAction actionWithTitle:@"✕" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"✓" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
        UITextField *textField = [alert.textFields firstObject];
        [self->father_window performSelector:func withObject:textField.text afterDelay:0];
    }];
    [alert addAction:submit];
    [alert addAction:action_cancle];
    [father_window presentViewController:alert animated:YES completion:nil];
}
-(void)Input_one_line_window_with_title_and_realholder:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placehoderstr process_NSString_func:(SEL)func
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placehoderstr; // if needs
        textField.text=placehoderstr;
    }];
    UIAlertAction * action_cancle = [UIAlertAction actionWithTitle:@"✓" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action_cancle];
    [father_window presentViewController:alert animated:YES completion:nil];
}
-(void)Input_clip_window_with_title:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placehoderstr process_NSString_func:(SEL)func blue_toothshare_func:(SEL)blue_tooth_share_func
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placehoderstr; // if needs
        if(textField.placeholder.length==81)
        {
            textField.text=placehoderstr;
        }
    }];
    NSString* ret_str;
    NSString* read_str;
    NSString* share_str;
    if(current_lang==111)
    {
        ret_str=@"Cancle";
        read_str=@"Read clipboard";
        share_str=@"Bluetooth share";
    }
    else if(current_lang==222){
        ret_str=@"返回";
        read_str=@"读取剪切板";
        share_str=@"通过蓝牙共享";
    }
    else if(current_lang==333)
    {
        ret_str=@"戻る";
        read_str=@"クリップボードを読む";
        share_str=@"Bluetoothで共有";
    }
    UIAlertAction * action_cancle = [UIAlertAction actionWithTitle:ret_str style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *bluetoothshare = [UIAlertAction actionWithTitle:share_str style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
        [self->father_window performSelector:blue_tooth_share_func withObject:nil afterDelay:0];
    }];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:read_str style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
        UITextField *textField = [alert.textFields firstObject];
        [self->father_window performSelector:func withObject:textField.text afterDelay:0];
    }];
    [alert addAction:bluetoothshare];
    [alert addAction:submit];
    [alert addAction:action_cancle];
    [father_window presentViewController:alert animated:YES completion:nil];
}
-(void)Sure_or_not_window_with_title:(NSString*)title andMessage:(NSString*)message process_func:(SEL)func sure_button_title: (NSString*)sure_text cancle_button_title:(NSString*)cancle_text
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:sure_text style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:func withObject:nil afterDelay:0];
    }];
    UIAlertAction* cancelAction =[UIAlertAction actionWithTitle:cancle_text style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    // 弹出对话框
    [father_window presentViewController:alert animated:YES completion:nil];
}
-(void)Rich_NewsMessage_with_two_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two;
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle_action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancle_action];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:button_names[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_one withObject:nil afterDelay:0];
    }];
    [alert addAction:first_action];
    
    UIAlertAction *second_action = [UIAlertAction actionWithTitle:button_names[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_two withObject:nil afterDelay:0];
    }];
    [alert addAction:second_action];
    
    [self->father_window presentViewController: alert animated: YES completion:nil];
}
-(void)Rich_NewsMessage_with_three_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two funct3:(SEL)funct_three
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle_action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancle_action];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:button_names[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_one withObject:nil afterDelay:0];
    }];
    [alert addAction:first_action];
    
    UIAlertAction *second_action = [UIAlertAction actionWithTitle:button_names[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_two withObject:nil afterDelay:0];
    }];
    [alert addAction:second_action];
    
    UIAlertAction *third_action = [UIAlertAction actionWithTitle:button_names[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_three withObject:nil afterDelay:0];
    }];
    [alert addAction:third_action];
    
    [self->father_window presentViewController: alert animated: YES completion:nil];
}
-(void)Rich_NewsMessage_with_four_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two funct3:(SEL)funct_three funct4:(SEL)funct_four
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle_action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancle_action];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:button_names[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_one withObject:nil afterDelay:0];
    }];
    [alert addAction:first_action];
    
    UIAlertAction *second_action = [UIAlertAction actionWithTitle:button_names[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_two withObject:nil afterDelay:0];
    }];
    [alert addAction:second_action];
    
    UIAlertAction *third_action = [UIAlertAction actionWithTitle:button_names[2] style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_three withObject:nil afterDelay:0];
    }];
    [alert addAction:third_action];
    
    UIAlertAction *fourth_action = [UIAlertAction actionWithTitle:button_names[3] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_four withObject:nil afterDelay:0];
    }];
    [alert addAction:fourth_action];
    
    [self->father_window presentViewController: alert animated: YES completion:nil];
}

-(void)Rich_NewsAlert_with_two_button:(NSString*)title message:(NSString*)message button_nameset:(NSArray*)button_names funct1:(SEL)funct_one funct2:(SEL)funct_two;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:button_names[0] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
        [self->father_window performSelector:funct_one withObject:nil afterDelay:0];
    }];
    UIAlertAction* cancelAction =[UIAlertAction actionWithTitle:button_names[1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        [self->father_window performSelector:funct_two withObject:nil afterDelay:0];
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    // 弹出对话框
    [self->father_window presentViewController: alert animated: YES completion:nil];
}
-(void)Image_Alert:(NSString*)title image:(UIImage*)img
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: @"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:img];
    imageView.contentMode = UIViewContentModeRedraw;
    [alert.view addSubview:imageView];
    [self->father_window presentViewController: alert animated: YES completion:nil];
}
+(bool)is_comment_exist
{
    if(commented)
        return true;
    
    NSString* res = [filer File_read:@"I_HAVE_COMMENTED"];
    if([res isEqualToString:@"Y"]){
        commented = true;
        return true;
    }
    return false;
}
+(void)Show_limit_rate_win
{
    if([self is_comment_exist])
        return;
    [SKStoreReviewController requestReview];
    [filer File_Save:@"Y" to:@"I_HAVE_COMMENTED"];
}
+(void)Show_deep_link_comment_win:(bool)needcheck
{
    if(needcheck)
        if([self is_comment_exist])
            return;
    [self Show_deep_link_comment_win_force];
}
+(void)Show_deep_link_comment_win_force
{
        NSURL* url = [[NSURL alloc]initWithString:@"https://apps.apple.com/app/ice-sudoku/id1473595660?action=write-review"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"finish opening");
            [filer File_Save:@"Y" to:@"I_HAVE_COMMENTED"];
        }];
}
@end
