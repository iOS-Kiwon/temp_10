//
//  PCToastMessage.m
//  PCToastMessageTest
//
//  Created by Patrick Perini on 9/29/11.
//  Licensing information available in README.md
//

//Self
#define HorizontalPadding               40.0
#define VerticalPadding                 26.0
#define CornerRadius                    22.0
#define ShadowRadius                    0.00
#define ShadowOpacity                   0.00
#define ShadowOffset                    CGSizeZero
#define ShadowColor                     [[UIColor blackColor] CGColor]
#define BorderWidth                     0.00
#define BorderColor                     [[UIColor colorWithWhite: 0.70 alpha: 0.80] CGColor]
#define BackgroundColor                 [UIColor colorWithWhite: 0.30 alpha: 0.90]
#define VerticalPositionRatio           0.50
#define HorizontalPositionRatio         0.83
#define AutoResizingMask                UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin

//Label
#define LabelFont                       [UIFont systemFontOfSize: 15]
#define LabelFontColor                  [UIColor whiteColor]
#define LabelShadowRadius               1.00
#define LabelShadowOpacity              0.75
#define LabelShadowOffset               CGSizeZero
#define LabelShadowColor                [[UIColor blackColor] CGColor]
#define LabelVerticalPositionRatio      0.50
#define LabelHorizontalPositionRatio    0.50

//Animation
#define MessageFadeInDuration           0.50
#define MessageFadeOutDuration          0.50

#import "Mocha_ToastMessage.h"

@implementation Mocha_ToastMessage

@synthesize duration;
@synthesize text;

+ (void)toastWithText:      (NSString *)aString
{return [Mocha_ToastMessage toastWithDuration: Mocha_ToastMessageDefaultDuration
                                  andText: aString];}

+ (void)toastWithText:      (NSString *)aString inView:  (UIView *)view
{return [Mocha_ToastMessage toastWithDuration: Mocha_ToastMessageDefaultDuration
                                  andText: aString
                                   inView: view];}

+ (void)toastWithDuration:  (CGFloat)aDuration  andText: (NSString *)aString
{return [Mocha_ToastMessage toastWithDuration: aDuration
                                  andText: aString
                                   inView: [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view]];}

+ (void)toastWithDuration:  (CGFloat)aDuration  andText: (NSString *)aString inView: (UIView *)view
{
    Mocha_ToastMessage *singleton = [[Mocha_ToastMessage alloc] initWithDuration: aDuration
                                                                 andText: aString];
    [singleton displayInView: view];
}

- (id)initWithText:         (NSString *)aString
{return [self initWithDuration: Mocha_ToastMessageDefaultDuration
                       andText: aString];}

- (id)initWithDuration:     (CGFloat)aDuration  andText:(NSString *)aString
{
    self = [super init];
    if(self)
    {
        duration    = aDuration;
        text        = [aString copy];
        _label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
        
        
        [_label setFont: LabelFont];
        [_label setText: text];
        [_label setNumberOfLines:10];
        [_label setAdjustsFontSizeToFitWidth: YES];
       
        
        //NSLog(@"라벨프레임 %@",  NSStringFromCGSize( _label.frame.size ))
        CGRect frame = CGRectZero;
        //frame.size = [text sizeWithFont: _label.font];
        
        frame.size = [_label sizeThatFits:_label.frame.size];
        [_label setFrame: frame];
        
        frame.size = CGSizeMake(frame.size.width + HorizontalPadding, frame.size.height + VerticalPadding);
        [self setFrame: frame];
        
        //NSLog(@"라벨프레임2 %@", NSStringFromCGSize( frame.size ))
        [_label setCenter: CGPointMake(frame.size.width * LabelHorizontalPositionRatio, frame.size.height * LabelVerticalPositionRatio)];
        
        [_label.layer setShadowRadius: LabelShadowRadius];
        [_label.layer setShadowOpacity: LabelShadowOpacity];
        [_label.layer setShadowColor: LabelShadowColor];
        [_label.layer setShadowOffset: LabelShadowOffset];
        
        [self addSubview: _label];
        
        [_label setTextColor: LabelFontColor];
        [_label setBackgroundColor: [UIColor clearColor]];
        
        [self.layer setBorderColor: BorderColor];
        [self.layer setBorderWidth: BorderWidth];
         
        [self setBackgroundColor: BackgroundColor];
         
        [self.layer setCornerRadius: CornerRadius];
        
        [self.layer setShadowRadius: ShadowRadius];
        [self.layer setShadowOpacity: ShadowOpacity];
        [self.layer setShadowColor: ShadowColor];
        [self.layer setShadowOffset: ShadowOffset];
        
        [self setAutoresizingMask: AutoResizingMask];
    }
    return self;
}


- (void)display
{    
    [self displayInView: [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view]];
}

- (void)displayInView:      (UIView *)view
{    
    if(UIDeviceOrientationIsPortrait( (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation]))
    {[self setCenter: CGPointMake(view.frame.size.width * VerticalPositionRatio, view.frame.size.height * HorizontalPositionRatio)];}
    else
    {[self setCenter: CGPointMake(view.frame.size.height * VerticalPositionRatio, view.frame.size.width * HorizontalPositionRatio)];}
    
    self.alpha = 0;
    [view addSubview: self];
    
    [UIView beginAnimations: nil context: nil];
    //{
        [UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration: MessageFadeInDuration];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDidStopSelector: @selector(finishDisplay)];
        self.alpha = 1;
    //}
    [UIView commitAnimations];
}

- (void)finishDisplay
{
    [UIView beginAnimations: nil context: nil];
    //{
        [UIView setAnimationDelay: duration];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration: MessageFadeOutDuration];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
        self.alpha = 0;
    //}
    [UIView commitAnimations];
}

@end
