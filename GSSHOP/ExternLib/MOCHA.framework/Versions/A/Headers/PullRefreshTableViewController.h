//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>


/**
 * @brief PullRefreshTableViewController
 * 페이스북 앱 스타일의 테이블뷰를 수직 스와이프하여 상단에 보여지는 reload UI안내를 통한 tableview 내용 재적재기능 UI.
 */

@interface PullRefreshTableViewController : UITableViewController {
    UIView *refreshHeaderView;
    UIImageView *refreshGSSHOPCircle;
    //UILabel *refreshLabel;
    //UIImageView *refreshArrow;
    
    //UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    //NSString *textPull;
    //NSString *textRelease;
    //NSString *textLoading;
}

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UIImageView *refreshGSSHOPCircle;
/*
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
*/
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
