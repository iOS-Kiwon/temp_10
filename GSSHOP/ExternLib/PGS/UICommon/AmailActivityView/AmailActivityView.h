#import <UIKit/UIKit.h>
@interface AmailActivityView : UIView
{
    UIView *_originalView;
    UIView *_borderView;
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_activityLabel;
    NSUInteger _labelWidth;
}
@property (nonatomic, readonly) UIView *borderView;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readonly) UILabel *activityLabel;
@property (nonatomic) NSUInteger labelWidth;
+ (AmailActivityView *)currentActivityView;
+ (AmailActivityView *)activityViewForView:(UIView *)addToView;
+ (AmailActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;
+ (AmailActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth;
+ (AmailActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText indicator:(BOOL)isIndicator;
- (AmailActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth indicator:(BOOL)argIsIndicator;
+ (void)removeView;
@end
#pragma mark -
@interface AmailActivityView ()
@property (nonatomic, retain) UIView *originalView;
- (UIView *)viewForView:(UIView *)view;
- (CGRect)enclosingFrame;
- (void)setupBackground;
- (void)animateShow;
- (void)animateRemove;
@end
#pragma mark -
@interface AmailBezelActivityView : AmailActivityView
{
}
+ (void)removeViewAnimated:(BOOL)animated;
@end
#pragma mark -
@interface AmailKeyboardActivityView : AmailBezelActivityView
{
}
+ (AmailKeyboardActivityView *)activityView;
+ (AmailKeyboardActivityView *)activityViewWithLabel:(NSString *)labelText;
@end
#pragma mark -
@interface UIApplication (KeyboardView)
- (UIView *)keyboardView;
@end;