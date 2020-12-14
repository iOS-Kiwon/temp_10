//
//  SectionWebView.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 17..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLDefine.h"
#import "GSWKWebview.h"
@interface SectionWebView : GSWKWebview {
    
    UIView *refreshHeaderView;
    UIImageView *refreshGSSHOPCircle;
    BOOL isDragging;
    BOOL isLoading;
}

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UIImageView *refreshGSSHOPCircle;

/**
 *  리로딩 상태를 나타내는 string setting 메서드
 *
 */
- (void)setupStrings;

/**
 *  refresh 헤더영역 view를 구성하여 addsubview 해주는 메서드
 *
 */
- (void)addPullToRefreshHeader;

/**
 *  refresh 헤더영역의 loading indicator 동작 시작 액션수행
 *
 */
- (void)startLoading;

/**
 *  refresh 헤더영역의 loading indicator 동작 멈춤 액션수행
 *
 */
- (void)stopLoading;

/**
 *  테이블뷰스크롤 정도에 따라 refresh 재적재 동작 시작액션 수행
 *
 */
- (void)refresh;


- (CABasicAnimation *) boundsAnimation:(CGRect)start : (CGRect)end : (float)duration : (int)count;
@end
