//
//  NormalFullWebViewController.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2015. 1. 9..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLDefine.h"
#import "AppDelegate.h"


@interface NormalFullWebViewController: UIViewController<WKNavigationDelegate> {
    NSString *urlString;
    WKWebView *wview;
}
@property (nonatomic,strong) NSString *urlString;
- (id)initWithUrlString:(NSString *)url;
- (void)showPopup;

@end


