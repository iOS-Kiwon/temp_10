//
//  PTRWithSnowViewController.h
//  Mocha
//
//  Created by KIM HOECHEON on 2014. 12. 2..
//
//
 

#import <UIKit/UIKit.h>
#import "SnowEmitterView.h"

/**
 * @brief PullRefreshTableViewController
 * 페이스북 앱 스타일의 테이블뷰를 수직 스와이프하여 상단에 보여지는 reload UI안내를 통한 tableview 내용 재적재기능 UI.
 */

@interface PTRWithSnowViewController : UITableViewController {
   // UIView *refreshHeaderView;
    
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

@property (assign) BOOL snowing;

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) SnowEmitterView *tableBackBgView;

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
