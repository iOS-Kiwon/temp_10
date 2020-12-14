#import "AmailPopUpView.h"
#import <QuartzCore/QuartzCore.h>
@implementation AmailPopUpView
static AmailPopUpView *amailPopUpView = nil;
static CGFloat kTransitionDuration = 0.3;
BOOL isPadding;
UIView *vContent=nil;
BOOL isBackTouch = YES;
+ (void)resizePopView:(CGSize)argSize {
    
    if(amailPopUpView) {
        [amailPopUpView setPopViewSize:argSize];
    }
    
}
+ (void)openCustomPopView {
    [self openCustomPopViewWithPadding:POP_PADDING];
}

+ (void)openCustomPopViewWithPadding:(float)argPadding {
    isPadding = YES;
    [[self alloc] initForView:CGSizeMake(argPadding, argPadding)];
}

+ (void)openCustomPopViewWithSize:(CGSize)argSize {
    isPadding = NO;
    [[self alloc] initForView:argSize];
}

+ (void)openCustomPopViewWithView:(UIView *)argView backTouch:(BOOL)argIsBackTouch {
    isBackTouch = argIsBackTouch;
    isPadding = NO;
    vContent = argView;
    [[self alloc] initForView:argView.frame.size];
}

+ (void)openCustomPopViewWithView:(UIView *)argView {
    isPadding = NO;
    vContent = argView;
    [[self alloc] initForView:argView.frame.size];
}

+ (void)openCustomPopViewWithString:(NSString *)argString {
    isPadding = NO;
    vContent = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f)];
    UITextView *tvStr = [[UITextView alloc] initWithFrame:vContent.frame];
    [tvStr setEditable:NO];
    [tvStr setText:argString];
    [vContent addSubview:tvStr];
    [[self alloc] initForView:vContent.frame.size];
}

+ (void)closeCustomPopView {
    if (!amailPopUpView) return;
    
    [amailPopUpView removeFromSuperview];
    amailPopUpView = nil;
}

+ (void)addMainView:(UIView *)argView {
    [amailPopUpView addMainView:argView];
}

- (void)addMainView:(UIView *)argView {
    [vMain addSubview:argView];
}

- (void)initForView:(CGSize)argSize;
{
//	if (!(self = [super initWithFrame:CGRectZero]))
//		return;
    
    //이미 존재한다면 기존의 팝업뷰 지우기
    if (amailPopUpView) [[self class] closeCustomPopView];
    
    // Remember the new view (it is already retained):
    amailPopUpView = self;
    
    size = argSize;
    [amailPopUpView setFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT)];
    [amailPopUpView setSubViews];
    [amailPopUpView show];
}

- (void)setPopViewSize:(CGSize)argSize {
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    [vMain setFrame:CGRectMake(vMain.frame.origin.x,
                               (int)(window.center.y - (argSize.height/2)),
                               vMain.frame.size.width,
                               argSize.height)];
                               
//    [vMain setFrame:CGRectMake((int)(window.center.x - (argSize.width/2)),
//                               (int)(window.center.y - (argSize.height/2)),
//                               argSize.width,
//                               argSize.height)];
	[UIView commitAnimations];
    
}

- (void)setSubViews {
    
    UIView *vBack = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    [vBack setBackgroundColor:[UIColor blackColor]];
    [vBack setAlpha:0.5f];
    if(isBackTouch) {
        UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(MessageTapped:)];
        [vBack addGestureRecognizer:tg];
    }
    [self addSubview:vBack];
    
    if(isPadding) {
        
        vMain = [[UIView alloc] initWithFrame:CGRectMake(size.width,
                                                         size.width,
                                                         self.frame.size.width - (size.width*2),
                                                         self.frame.size.height - (size.width*2))];
    } else {
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;	
        if (!window) {	
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];	
        }
        vMain = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                         0.0f,
                                                         size.width,
                                                         size.height)];
        vMain.center = window.center;
        
        if(vContent!=nil) {
            [vMain addSubview:vContent];
        }
    }
    [vMain setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:vMain];
    
}
- (void)show {
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;	
    if (!window) {	
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];	
    }	
    [window addSubview:self];
    
    vMain.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);	
    [UIView beginAnimations:nil context:nil];	
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];	
    vMain.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.02, 1.02);
    [UIView commitAnimations];
    
}
- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    vMain.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/4];
    vMain.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}


- (void)MessageTapped:(UIGestureRecognizer *)sender{
    @try {
        if (sender.state == UIGestureRecognizerStateEnded) {
            [[self class] closeCustomPopView];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleTextCellView MessageTapped : %@", exception);
    }
}
@end
