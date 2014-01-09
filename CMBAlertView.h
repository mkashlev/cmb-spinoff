//
//  CMBAlertView.h
//  CMB-Mobile
//
//  Created by Dmitry Kashlev on 8/15/13.
//  Copyright (c) 2013 Dmitry Kashlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CMBAlertView : UIView
{
    __weak id delegate;
    UIView *alertView;
}
//@property id delegate;

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) NSString *idLabel;
@property (strong, nonatomic) NSString *params;
@property (nonatomic) BOOL noDismiss;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSArray *otherButtons;
@property (strong, nonatomic) NSString *cancelButtonTitle;

@property (weak, nonatomic) id delegate;

+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (id)alertViewWithPhoto:(UIImage *)image caption:(NSString *)caption title:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (id)initWithTitle:(NSString *)title withId:(NSString *)idLabel message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)showInView:(UIView*)view;
- (void)show;
- (IBAction)closePopup:(id)sender;
- (void)close;

- (UIView *)getAlertView;


@end


@protocol CMBAlertDelegate
- (void)customAlertView:(CMBAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)closeAlert;
@end
