//
//  Copyright (c) 2013 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "MDCScrollBarLabel.h"
#import <QuartzCore/QuartzCore.h>


#undef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(x) M_PI * (x) / 180.0


static CGFloat const kMDCScrollBarLabelWidth = 45.0f;
static CGFloat const kMDCScrollBarLabelHeight = 45.0f;
//static CGFloat const kMDCScrollBarLabelClockWidth = 24.0f;
//static CGFloat const kMDCScrollBarLabelClockTopMargin = -1.0f;
//static CGFloat const kMDCScrollBarLabelClockLeftMargin = 4.0f;
//static CGFloat const kMDCScrollBarLabelClockRightMargin = 7.0f;
//static NSTimeInterval const kMDCScrollBarLabelDefaultClockAnimationDuration = 0.2f;
static NSTimeInterval const kMDCScrollBarLabelDefaultFadeAnimationDuration = 0.3f;
static CGFloat const kMDCScrollBarLabelDefaultHorizontalPadding = 10.0f;
static CGFloat const kMDCScrollBarLabelDefaultVerticalPadding = 20.0f;

//static CGFloat const kMDCScrollBarLabelDefaultBottomVerticalPadding = 80.0f;


typedef enum {
    MDCClockHandTypeHour = 0,
    MDCClockHandTypeMinute
} MDCClockHandType;


@interface MDCScrollBarLabel ()
@property (nonatomic, strong) NSDate *displayedDate;
@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UIImageView *clockCenterImageView;
@property (nonatomic, strong) UIImageView *hourHandImageView;
@property (nonatomic, strong) UIImageView *minuteHandImageView;
@property (nonatomic, strong) UILabel *str1Label;
@property (nonatomic, strong) UILabel *str2Label;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *weekdayDateFormatter;
@end


@implementation MDCScrollBarLabel


#pragma mark - Object Lifecycle

- (id)initWithScrollView:(UIScrollView *)scrollView {
    CGRect frame = CGRectMake(scrollView.frame.size.width - kMDCScrollBarLabelWidth-10,
                              kMDCScrollBarLabelDefaultVerticalPadding,
                              kMDCScrollBarLabelWidth,
                              kMDCScrollBarLabelHeight);

    self = [super initWithFrame:frame];
    if (self) {
        _fadeAnimationDuration = kMDCScrollBarLabelDefaultFadeAnimationDuration;
        _horizontalPadding = kMDCScrollBarLabelDefaultHorizontalPadding;
        _verticalPadding = kMDCScrollBarLabelDefaultVerticalPadding;

        _scrollView = scrollView;


        self.alpha = 0.0f;
        self.backgroundColor = [UIColor clearColor];

       
        UIImage *backgroundImage = [UIImage imageNamed:@"sect_counting_bg.png"];
      //  backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:15.0f
        //                                                       topCapHeight:5.0f];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:backgroundImageView];

        
        
        
        
        
        UIView *ttmlineView = [[UIView alloc] initWithFrame:CGRectMake(10,  22, self.frame.size.width-20,  1)] ;
        ttmlineView.backgroundColor = [Mocha_Util getColor:@"C9C9C9"];
        [self addSubview:ttmlineView];
    
        
        
        
        CGFloat label1Height = 13.0f;
        CGFloat label1Width = self.frame.size.width  ;
        self.str1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, label1Width, label1Height)];
        self.str1Label.textColor = [UIColor whiteColor];
 
        
        CGFloat label2Height = 13.0f;
        CGFloat label2Width = self.frame.size.width  ;
        self.str2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, label2Width, label2Height)];
        self.str2Label.textColor = [UIColor whiteColor];
        
        
        for (UILabel *label in @[self.str1Label]) {
            label.font = [UIFont boldSystemFontOfSize:13];
            label.textColor = [Mocha_Util getColor:@"444444"];
            //label.shadowColor = [UIColor darkTextColor];
            label.shadowOffset = CGSizeMake(0, -1);
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
        }
        
        
        for (UILabel *label in @[self.str2Label]) {
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [Mocha_Util getColor:@"999999"];
            //label.shadowColor = [UIColor darkTextColor];
            label.shadowOffset = CGSizeMake(0, -1);
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
        }
        
        [self addSubview:self.str1Label];
        [self addSubview:self.str2Label];
    }
    return self;
}


#pragma mark - Public Interface

- (void)setStrdata1:(NSString *)str {
    
    self.str1Label.text = str;
    
    
}


- (void)setStrdata2:(NSString *)str {
    
    
    self.str2Label.text = str;
    
    
}



- (void)adjustPositionForScrollView:(UIScrollView *)scrollView {
    CGSize size = self.frame.size;
    CGPoint origin = self.frame.origin;
   // UIView *indicator = [[scrollView subviews] lastObject];

    
    /*
    float y = \
        scrollView.contentOffset.y \
        + scrollView.contentOffset.y * (scrollView.frame.size.height/scrollView.contentSize.height)
        + scrollView.frame.size.height/scrollView.contentSize.height \
        + (indicator.frame.size.height - size.height)/2;

    float topLimit = self.verticalPadding + scrollView.contentOffset.y;

    //float bottomLimit =  scrollView.contentOffset.y - kMDCScrollBarLabelDefaultBottomVerticalPadding;
    
    if (y < topLimit || isnan(y)) {
        y = topLimit;
    }
    */
    
    float y =   scrollView.contentOffset.y    +  scrollView.frame.size.height - 55;

    
    
    
    
   // NSLog(@"업셋 %f ,,,, %f",y, indicator.frame.origin.y );
    
    //kMDCScrollBarLabelDefaultBottomVerticalPadding
    
    self.frame = CGRectMake(origin.x, y, size.width, size.height);
}

- (void)setDisplayed:(BOOL)displayed animated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
   // CGFloat end = displayed ? -self.horizontalPadding : 0.0;

    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:self.fadeAnimationDuration
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                        // self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, end, 0.0);
                         self.alpha = displayed ? 1.0f : 0.0f;
                     } completion:^(BOOL finished) {
                         if (finished) {
                         //    self.center = CGPointMake(floorf(self.scrollView.frame.size.width - self.frame.size.width/2),
                         //                              self.center.y);
                             _displayed = YES;
                         }
                     }];
    [UIView setAnimationsEnabled:animationsEnabled];
}



@end
