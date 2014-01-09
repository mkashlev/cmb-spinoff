//
//  CMBAlertView.m
//  CMB-Mobile
//
//  Created by Dmitry Kashlev on 8/15/13.
//  Copyright (c) 2013 Dmitry Kashlev. All rights reserved.
//

#import "CMBalertView.h"

#define MAX_ALERT_HEIGHT 300.0
#define BUTTON_HEIGHT 46
#define BUTTON_WIDTH 200

@interface CMBAlertView ()

@property (nonatomic, strong) UIImageView *imageContainer;
@property (nonatomic, strong) UILabel *captionLabel;

@end

@implementation CMBAlertView

@synthesize delegate;

//Create an overlay popup with title and message only.
+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    CMBAlertView *alertView = [[CMBAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView drawAlert];
    return alertView;
}

//Create an overlay popup with Photo and caption, as well as title and message (same as above plus image/caption)
+ (id)alertViewWithPhoto:(UIImage *)image caption:(NSString *)caption title:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    CMBAlertView *alert = [[CMBAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    //set up UIAlertView to include image and caption
    //IMAGE
    if (image) {
        alert.image = image;
    }
    
    //CAPTION
    if (caption) {
        alert.caption = caption;
        UILabel *captionLbl = [[UILabel alloc] init];
        [captionLbl setTag:102];
        captionLbl.text = caption;
        captionLbl.numberOfLines = 2;
        captionLbl.backgroundColor = [UIColor clearColor];
        alert.captionLabel = captionLbl;
        [alert addSubview:captionLbl];
    }
    [alert drawAlert];
    return alert;
}


//1. outside wrapper to generate array of buttons and pass it to final intializer. (no idLabel)
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    if (otherButtonTitles) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
        {
            DLog(@"button: %@",arg);
            [buttons addObject:arg];
        }
        va_end(args);
    }
    
    self = [self initWithTitle:title withId:nil message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitlesArray:buttons];
    return self;
}

//2. outside wrapper to generate array of buttons and pass it to final intializer. (WITH idLabel)
- (id)initWithTitle:(NSString *)title withId:(NSString *)idLabel message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    if (otherButtonTitles) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
        {
            DLog(@"button: %@",arg);
            [buttons addObject:arg];
        }
        va_end(args);
    }
    self = [self initWithTitle:title withId:idLabel message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitlesArray:buttons];
    return self;
}

// Helper initializer. Never called outside of this object. Private method.
//responsible for layout arrangement. All layout code is defined here.
- (id)initWithTitle:(NSString *)title withId:(NSString *)idLabel message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitlesArray:(NSArray *)otherButtonTitles
{
    CGRect frame;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    else
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (idLabel) {
            self.idLabel = idLabel;
        }
        self.delegate = delegate;
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtons = otherButtonTitles;
    }
    
    return self;
}

- (void)drawAlert
{
    DLog(@"TEST");
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    float alert_width = self.frame.size.width-30;
    float alert_height = 25.0;
    
    CGFloat button_width = alert_width-20;
    
    UILabel *TitleLbl;
    UIScrollView *MsgScrollView;
    
    
    //INIT alertView
    alertView = [[UIView alloc] initWithFrame:CGRectMake((int)((self.frame.size.width-alert_width)/2.0), (int)((self.frame.size.height-alert_height)/2.0), alert_width, alert_height)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //roudned corners
    alertView.layer.cornerRadius = 10;
    [alertView clipsToBounds];
    
    
    //IMAGE
    if ( self.image ) {
        // add image to view
        CGFloat imgPositionX = (alertView.bounds.size.width - 78) / 2.0f;
        UIImageView *imgContainer = [[UIImageView alloc] initWithImage:self.image];
        [imgContainer setTag:101];
        self.imageContainer = imgContainer;
        //[alert addSubview:imgContainer];
        
        [self.imageContainer setFrame:CGRectMake(imgPositionX, alert_height, 78, 78)];
        CGRect newImage = self.imageContainer.frame;
        newImage.origin.y = alert_height;
        alert_height += newImage.size.height + 5.0;
        [self.imageContainer setFrame:newImage];
        
    }
    //IMAGE CAPTION
    if ( self.captionLabel ) {
        // add code for caption
        CGFloat maxCaptionWidth = alertView.bounds.size.width - 30;
        CGFloat captionPositionX = (alertView.bounds.size.width - maxCaptionWidth) / 2.0f;
        CGSize textSize = [self.captionLabel.text sizeWithFont:[self.captionLabel font] constrainedToSize:CGSizeMake(maxCaptionWidth, 50) lineBreakMode:NSLineBreakByWordWrapping];
        //CGFloat textWidth = textSize.width;
        //[self.captionLabel setFrame:CGRectMake(0, 0, textSize.height, textWidth)];
        [self.captionLabel setFrame:CGRectMake(captionPositionX, 0, maxCaptionWidth, textSize.height)];
        [self.captionLabel setTextAlignment:NSTextAlignmentCenter];
        self.captionLabel.font = [UIFont ralewayWithSize:15];
        CGRect newCaption = self.captionLabel.frame;
        alert_height += 5.0;
        newCaption.origin.y = alert_height;
        alert_height += (newCaption.size.height + 15) ;
        [self.captionLabel setFrame:newCaption];
    }
    
    
    //TITLE
    if (self.title)
    {
        TitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, alert_height, alert_width-20.0, 0.0)];
        //TitleLbl.adjustsFontSizeToFitWidth = YES;
        TitleLbl.font = [UIFont ralewayWithSize:20];
        TitleLbl.numberOfLines = 0;
        TitleLbl.textAlignment = NSTextAlignmentCenter;
        TitleLbl.minimumFontSize = 12.0;
        TitleLbl.backgroundColor = [UIColor clearColor];
        TitleLbl.textColor = [UIColor colorWithRed:0 green:108.0f/255.0f blue:204.0f/255.0f alpha:1.0f];

        TitleLbl.text = self.title;
        [TitleLbl sizeToFit];
        TitleLbl.frame = CGRectMake(10, alert_height, alert_width-20, TitleLbl.frame.size.height);
        
        alert_height += TitleLbl.frame.size.height + 5.0;
    } else {
        alert_height += 15.0;
    }
    
    //MESSAGE
    if (self.message)
    {
        float max_msg_height = MAX_ALERT_HEIGHT - alert_height - ((self.cancelButtonTitle)?(BUTTON_HEIGHT+30.0):30.0);
        
        UILabel *MessageLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, alert_width-40.0, 0.0)];
        MessageLbl.numberOfLines = 0;
        MessageLbl.font = [UIFont ralewayWithSize:15];
        MessageLbl.textAlignment = NSTextAlignmentCenter;
        MessageLbl.backgroundColor = [UIColor clearColor];
        MessageLbl.text = self.message;
        
        [MessageLbl sizeToFit];
        MessageLbl.frame = CGRectMake(10.0, 0.0, alert_width-40.0, MessageLbl.frame.size.height);
        
        while (MessageLbl.frame.size.height>max_msg_height && MessageLbl.font.pointSize>12) {
            MessageLbl.font = [UIFont systemFontOfSize:MessageLbl.font.pointSize-1];
            [MessageLbl sizeToFit];
            MessageLbl.frame = CGRectMake(10.0, 0.0, alert_width-40.0, MessageLbl.frame.size.height);
        }
        
        MsgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, alert_height, alert_width-20.0, (MessageLbl.frame.size.height>max_msg_height)?max_msg_height:MessageLbl.frame.size.height)];
        MsgScrollView.contentSize = MessageLbl.frame.size;
        [MsgScrollView addSubview:MessageLbl];
        
        alert_height += MsgScrollView.frame.size.height + 20.0;
    } else {
        alert_height += 20.0;
    }
    
    [self addSubview:alertView];
    
    if (self.imageContainer)
        [alertView addSubview:self.imageContainer];
    if (self.captionLabel)
        [alertView addSubview:self.captionLabel];
    if (TitleLbl)
        [alertView addSubview:TitleLbl];
    if (MsgScrollView)
        [alertView addSubview:MsgScrollView];
    
    
    //add buttons
    //BUTTONS
    CMBButton *CancelBtn;
    CMBButton *OtherBtn;
    
    if (self.cancelButtonTitle)
    {
        alert_height += 20;
        CancelBtn = [[CMBButton alloc] initWithFrame:CGRectMake((int)((alert_width-button_width)/2.0), alert_height, button_width, BUTTON_HEIGHT)];
        [CancelBtn setTag:1000];
        [CancelBtn setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [CancelBtn setTitle:self.cancelButtonTitle forState:UIControlStateHighlighted];
        [CancelBtn.titleLabel setFont:[UIFont ralewayBoldWithSize:15]];
        [CancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [CancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [CancelBtn setTitleColor:[UIColor colorWithHexString:@"ddddd"] forState:UIControlStateDisabled];
        [CancelBtn setBackgroundColor:[UIColor clearColor] borderColor:[UIColor colorWithHexString:@"d4d4d4"] textColor:[UIColor grayColor] forState:UIControlStateNormal];
        [CancelBtn setBackgroundColor:[UIColor colorWithHexString:@"d4d4d4"] borderColor:[UIColor colorWithHexString:@"d4d4d4"] textColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [CancelBtn setBackgroundColor:[UIColor whiteColor] borderColor:[UIColor colorWithHexString:@"dddddd"] textColor:[UIColor colorWithHexString:@"dddddd"] forState:UIControlStateDisabled];
        //CancelBtn.layer.borderColor = [[UIColor colorWithHexString:@"d4d4d4"] CGColor];
        CancelBtn.layer.borderWidth = 1.0f;
        CancelBtn.layer.cornerRadius = 10;
        //[CancelBtn setBackgroundImage:CancelBtnImg forState:UIControlStateNormal];
        //[CancelBtn setBackgroundColor:[UIColor colorWithHexString:@"d4d4d4"] forState:UIControlStateHighlighted];
        [CancelBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        alert_height += CancelBtn.frame.size.height + 10.0;
        [alertView addSubview:CancelBtn];
    }
    if ([self.otherButtons count] > 0)
    {
        int i=1;
        for (NSString *btn in self.otherButtons) {
            OtherBtn = [[CMBButton alloc] initWithFrame:CGRectMake((int)((alert_width-button_width)/2.0), alert_height, button_width, BUTTON_HEIGHT)];
            [OtherBtn setTag:1000+i];
            [OtherBtn setTitle:btn forState:UIControlStateNormal];
            [OtherBtn setTitle:btn forState:UIControlStateHighlighted];
            [OtherBtn.titleLabel setFont:[UIFont ralewayBoldWithSize:15]];
            [OtherBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [OtherBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [OtherBtn setTitleColor:[UIColor colorWithHexString:@"ddddd"] forState:UIControlStateDisabled];
            [OtherBtn setBackgroundColor:[UIColor clearColor] borderColor:[UIColor colorWithHexString:@"d4d4d4"] textColor:[UIColor grayColor] forState:UIControlStateNormal];
            [OtherBtn setBackgroundColor:[UIColor colorWithHexString:@"d4d4d4"] borderColor:[UIColor colorWithHexString:@"d4d4d4"] textColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [OtherBtn setBackgroundColor:[UIColor whiteColor] borderColor:[UIColor colorWithHexString:@"dddddd"] textColor:[UIColor colorWithHexString:@"dddddd"] forState:UIControlStateDisabled];
            
            //OtherBtn.layer.borderColor = [[UIColor colorWithHexString:@"d4d4d4"] CGColor];
            OtherBtn.layer.borderWidth = 1.0f;
            OtherBtn.layer.cornerRadius = 10;
            //[OtherBtn setBackgroundImage:OtherBtnImg forState:UIControlStateNormal];
            [OtherBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            alert_height += OtherBtn.frame.size.height + 10.0;
            [alertView addSubview:OtherBtn];
            i++;
        }
    } else {
        if (!self.cancelButtonTitle) {
            alert_height += 10.0;
        }
    }
    if (self.cancelButtonTitle || [self.otherButtons count] > 0) {
        alert_height += 5;
    }
    
    alertView.frame = CGRectMake((int)((self.frame.size.width-alert_width)/2.0), (int)((self.frame.size.height-alert_height)/2.0), alert_width, alert_height);
    
    //CLOSE BUTTON
    self.noDismiss = NO;
    CGFloat buttonPositionX = 250.0f;
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonPositionX, 0.0f, 40, 40)];
    self.closeButton = closeBtn;
    [closeBtn setTag:100];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    [closeBtn setImage:[[UIImage imageNamed:@"Close-Button.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [closeBtn setImage:[[UIImage imageNamed:@"Close-Button.png"] resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    [closeBtn setImage:[[UIImage imageNamed:@"Close-ButtonDeact.png"] resizableImageWithCapInsets:insets] forState:UIControlStateDisabled];
    [closeBtn addTarget:self
                 action:@selector(animateHide)
       forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:closeBtn];
    DLog(@"DRAW ALERT");
}


//trigger the display/appear of the overlay popup
- (void)animateShow
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.05, 1.05, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.95, 0.95, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.6],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.5;
    
    [alertView.layer addAnimation:animation forKey:@"show"];
    DLog(@"Animate SHOW");
}

//trigger the hide/disappear of the overlay popup
- (void)animateHide
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.0, 0.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.3;
    
    [alertView.layer addAnimation:animation forKey:@"hide"];
    DLog(@"Animate HIDE");
    
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.105];
}



//Calls customAlertView:clickedButtonAtIndex inside a delegate to handle button click action
- (void)onBtnPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int button_index = button.tag-1000;
    
    if ([delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
        [delegate customAlertView:self clickedButtonAtIndex:button_index];
    
    [self animateHide];
}

//equivalent to [alert show] but allows to specify a view.
- (void)showInView:(UIView*)view
{
    if ([view isKindOfClass:[UIView class]])
    {
        [view addSubview:self];
        [self animateShow];
    }
}
//equivalent to [alert show]
- (void)show
{
    [self showInView:[[[UIApplication sharedApplication] delegate] window]];
    //[(CMBAlertView*)alertView drawAlert];
}

- (void)close
{
    [self animateHide];
}

- (IBAction)closePopup:(id)sender {
    DLog(@"Should close the popup");
    if ([delegate respondsToSelector:@selector(closeAlert)]) {
        [delegate closeAlert];
    }
    [self animateHide];
}


- (UIView *)getAlertView
{
    return alertView;
}

@end
