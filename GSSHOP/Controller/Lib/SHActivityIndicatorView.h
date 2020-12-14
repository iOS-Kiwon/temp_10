//
//  SHActivityIndicatorView.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 9. 23..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 인디케이터 뷰 클래스
@interface SHActivityIndicatorView : UIView
{
    BOOL isloading;
	UIImageView		*gactivityIndicator;
}

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
- (void)isDownLoding;

@end
