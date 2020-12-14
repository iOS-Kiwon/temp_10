//
//  PopupWebView.h
//  GSSHOP
//
//  Created by 조도연 on 2014. 6. 17..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSWKWebview.h"
#import "VerticalSlider.h"

@interface PopupWebView : UIView <UIScrollViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) GSWKWebview *wview;

@property (nonatomic, weak) id delegate;

+ (id)openPopupWithFrame:(CGRect)aFrame
               superview:(UIView *)superview
                delegate:(id)delegate
                     url:(NSString *)urlString
                   title:(NSString *)title
                animated:(BOOL)animated;

- (void)closeWithAnimated:(BOOL)animated;

@end
