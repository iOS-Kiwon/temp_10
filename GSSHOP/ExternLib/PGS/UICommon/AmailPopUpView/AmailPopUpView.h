#import <UIKit/UIKit.h>
#define POP_PADDING     30.0f
@interface AmailPopUpView : UIView {
    UIView *vMain;
    CGSize size;
}
+ (void)resizePopView:(CGSize)argSize;
+ (void)openCustomPopView;
+ (void)openCustomPopViewWithPadding:(float)argPadding;
+ (void)openCustomPopViewWithSize:(CGSize)argSize;
+ (void)openCustomPopViewWithView:(UIView *)argView backTouch:(BOOL)argIsBackTouch;
+ (void)openCustomPopViewWithView:(UIView *)argView;
+ (void)openCustomPopViewWithString:(NSString *)argString;
+ (void)closeCustomPopView;
+ (void)addMainView:(UIView *)argView;
@end