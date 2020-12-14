#import "AmailActivityView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppPushConstants.h"
@implementation AmailActivityView
@synthesize originalView = _originalView, labelWidth = _labelWidth;
static AmailActivityView *amailActivityView = nil;
BOOL isIndicator = YES;
BOOL isTouch = YES;
+ (AmailActivityView *)currentActivityView;
{
    return amailActivityView;
}
+ (AmailActivityView *)activityViewForView:(UIView *)addToView;
{
    return [self activityViewForView:addToView withLabel:APPPUSH_DEF_LOADING_TEXT width:0];
}
+ (AmailActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;
{
    return [self activityViewForView:addToView withLabel:labelText width:0];
}
+ (AmailActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth;
{
    // Not autoreleased, as it is basically a singleton:
    return [[self alloc] initForView:addToView withLabel:labelText width:labelWidth indicator:YES];
}
+ (AmailActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText indicator:(BOOL)isIndicator;
{
    // Not autoreleased, as it is basically a singleton:
    return [[self alloc] initForView:addToView withLabel:labelText width:0 indicator:isIndicator];
}
- (AmailActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth indicator:(BOOL)argIsIndicator;
{
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
    // Immediately remove any existing activity view:
    if (amailActivityView)
        [[self class] removeView];
    // Remember the new view (it is already retained):
    amailActivityView = self;
    // Allow subclasses to change the view to which to add the activity view (e.g. to cover the keyboard):
    self.originalView = addToView;
    addToView = [self viewForView:addToView];
    // Configure this view (the background) and the label text (the label is automatically created):
    [self setupBackground];
    self.labelWidth = labelWidth;
    self.activityLabel.text = labelText;
    // Assembile the subviews (the border and indicator are automatically created):
	[addToView addSubview:self];
    [self addSubview:self.borderView];
    isIndicator = argIsIndicator;
    if(isIndicator) {
        [self.borderView addSubview:self.activityIndicator];
    }
    [self.borderView addSubview:self.activityLabel];
	// Animate the view in, if appropriate:
	[self animateShow];
    
    if(isTouch) {
        UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(actViewTapped:)];
        [amailActivityView addGestureRecognizer:tg];
    }
    
	return self;
}
- (void)actViewTapped:(UIGestureRecognizer *)sender{
    @try {
        if (!amailActivityView)
            return;
        [amailActivityView removeFromSuperview];
        amailActivityView = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleTextCellView MessageTapped : %@", exception);
    }
}
+ (void)removeView;
{
    if (!amailActivityView)
        return;
    [amailActivityView removeFromSuperview];
    amailActivityView = nil;
}
- (UIView *)viewForView:(UIView *)view;
{
    return view;
}
- (CGRect)enclosingFrame;
{
    return self.superview.bounds;
}
- (void)setupBackground;
{
	self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}
- (UIView *)borderView;
{
    if (!_borderView)
    {
        _borderView = [[UIView alloc] initWithFrame:CGRectZero];
        _borderView.opaque = NO;
        _borderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _borderView;
}
- (UIActivityIndicatorView *)activityIndicator;
{
    if (!_activityIndicator)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator startAnimating];
    }
    return _activityIndicator;
}
- (UILabel *)activityLabel;
{
    if (!_activityLabel)
    {
        _activityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _activityLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _activityLabel.textAlignment = NSTextAlignmentLeft;
        _activityLabel.textColor = [UIColor blackColor];
        _activityLabel.backgroundColor = [UIColor clearColor];
        _activityLabel.shadowColor = [UIColor whiteColor];
        _activityLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    return _activityLabel;
}
- (void)layoutSubviews;
{
    self.frame = [self enclosingFrame];
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
//    CGSize textSize = [self.activityLabel.text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    CGSize textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    // Calculate the size and position for the border view: with the indicator to the left of the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width = self.activityIndicator.frame.size.width + textSize.width + 25.0;
    borderFrame.size.height = self.activityIndicator.frame.size.height + 10.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height));
    self.borderView.frame = borderFrame;
    // Calculate the position of the indicator: vertically centered and at the left of the border view:
    CGRect indicatorFrame = self.activityIndicator.frame;
	indicatorFrame.origin.x = 10.0;
	indicatorFrame.origin.y = 0.5 * (borderFrame.size.height - indicatorFrame.size.height);
    self.activityIndicator.frame = indicatorFrame;
    // Calculate the position of the label: vertically centered and at the right of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = borderFrame.size.width - labelFrame.size.width - 10.0;
	labelFrame.origin.y = floor(0.5 * (borderFrame.size.height - labelFrame.size.height));
    self.activityLabel.frame = labelFrame;
}
- (void)animateShow;
{
    // Does nothing by default
}
- (void)animateRemove;
{
    // Does nothing by default
}
@end
#pragma mark -
@implementation AmailBezelActivityView
- (UIView *)viewForView:(UIView *)view;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    if (keyboardView)
        view = keyboardView.superview;
    return view;
}
- (CGRect)enclosingFrame;
{
    CGRect frame = [super enclosingFrame];
    if (self.superview != self.originalView)
        frame = [self.originalView convertRect:self.originalView.bounds toView:self.superview];
    return frame;
}
- (void)setupBackground;
{
    [super setupBackground];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
}
- (UIView *)borderView;
{
    if (!_borderView)
    {
        [super borderView];
        _borderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _borderView.layer.cornerRadius = 10.0;
    }
    return _borderView;
}
- (UIActivityIndicatorView *)activityIndicator;
{
    if (!_activityIndicator)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicator startAnimating];
    }
    return _activityIndicator;
}
- (UILabel *)activityLabel;
{
    if (!_activityLabel)
    {
        _activityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _activityLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        _activityLabel.textAlignment = NSTextAlignmentCenter;
        _activityLabel.textColor = [UIColor whiteColor];
        _activityLabel.backgroundColor = [UIColor clearColor];
    }
    return _activityLabel;
}
- (void)layoutSubviews;
{
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    self.frame = [self enclosingFrame];
//    CGSize textSize = [self.activityLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    CGSize textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]}];
    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    // Require that the label be at least as wide as the indicator, since that width is used for the border view:
    if (textSize.width < self.activityIndicator.frame.size.width)
        textSize.width = self.activityIndicator.frame.size.width + 10.0;
    // If there's no label text, don't need to allow height for it:
    if (self.activityLabel.text.length == 0)
        textSize.height = 0.0;
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    // Calculate the size and position for the border view: with the indicator vertically above the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width = textSize.width + 30.0;
    borderFrame.size.height = self.activityIndicator.frame.size.height + textSize.height + 40.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height));
    self.borderView.frame = borderFrame;
    // Calculate the position of the indicator: horizontally centered and near the top of the border view:
    CGRect indicatorFrame = self.activityIndicator.frame;
	indicatorFrame.origin.x = 0.5 * (borderFrame.size.width - indicatorFrame.size.width);
	indicatorFrame.origin.y = 20.0;
    self.activityIndicator.frame = indicatorFrame;
    // Calculate the position of the label: horizontally centered and near the bottom of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = floor(0.5 * (borderFrame.size.width - labelFrame.size.width));
    labelFrame.origin.y = borderFrame.size.height - labelFrame.size.height - 10.0;
    if(!isIndicator) {
        labelFrame.origin.y -= 25.0f;
    }
    self.activityLabel.frame = labelFrame;
}
- (void)animateShow;
{
    self.alpha = 0.0;
    self.borderView.transform = CGAffineTransformMakeScale(3.0, 3.0);
	[UIView beginAnimations:nil context:nil];
    //	[UIView setAnimationDuration:5.0];            // Uncomment to see the animation in slow motion
    self.borderView.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
	[UIView commitAnimations];
}
- (void)animateRemove;
{
    self.borderView.transform = CGAffineTransformIdentity;
	[UIView beginAnimations:nil context:nil];
    //	[UIView setAnimationDuration:5.0];            // Uncomment to see the animation in slow motion
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
    self.borderView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0.0;
	[UIView commitAnimations];
}
- (void)removeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
{
    [[self class] removeView];
}
+ (void)removeViewAnimated:(BOOL)animated;
{
    if (!amailActivityView)
        return;
    if (animated)
        [amailActivityView animateRemove];
    else
        [[self class] removeView];
}
@end
#pragma mark -
@implementation AmailKeyboardActivityView
+ (AmailKeyboardActivityView *)activityView;
{
    return [self activityViewWithLabel:APPPUSH_DEF_LOADING_TEXT];
}
+ (AmailKeyboardActivityView *)activityViewWithLabel:(NSString *)labelText;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    if (!keyboardView)
        return nil;
    else
        return (AmailKeyboardActivityView *)[self activityViewForView:keyboardView withLabel:labelText];
}
- (UIView *)viewForView:(UIView *)view;
{
    return view;
}
- (void)animateShow;
{
    self.alpha = 0.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
    self.alpha = 1.0;
	[UIView commitAnimations];
}
- (void)animateRemove;
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
    self.alpha = 0.0;
	[UIView commitAnimations];
}
- (void)setupBackground;
{
    [super setupBackground];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
}
- (UIView *)borderView;
{
    if (!_borderView)
        [super borderView].backgroundColor = nil;
    return _borderView;
}
@end
#pragma mark -
@implementation UIApplication (KeyboardView)
- (UIView *)keyboardView;
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
            printf("%s\n", object_getClassName(view));
			if (!strcmp(object_getClassName(view), "UIKeyboard") || !strcmp(object_getClassName(view), "UIPeripheralHostView"))
			{
				return view;
			}
		}
	}
	return nil;
}
@end