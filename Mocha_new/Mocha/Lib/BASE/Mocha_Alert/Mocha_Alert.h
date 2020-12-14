//
//  Mocha_Alert.h
//  Mocha_Alert
//
//  Created by Hoecheon Kim on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
/**
 *  optional Protocal 로 initWithTitle: 메서드로 표출한 버튼의 클릭 이벤트 발생시 콜백메서드로 활용
 *  호출한 delegate 객체에서 구현되어 메세지 클릭 이벤트 처리.
 *
 *   @param alert: Alert View (UIView)
 *   @param index: 클릭한 AlertView상의 버튼 tag index키값 (NSInteger)
 *   @return void
 *
 */


@protocol Mocha_AlertDelegate <NSObject>

@optional

- (void) customAlertView:(UIView*)alert clickedButtonAtIndex:(NSInteger)index;

@end


//
//typedef enum{
//    ButtonIndexClose = 0,      // 취소(닫기) 버튼 타입정보
//    ButtonIndexOK,             // 다른 선택 버튼 타입정보 (예, 실행, 이동 등)
//    ButtonIndexOther
//}BTNINDEX;
//
//typedef void (^AlertButonIndex)(BTNINDEX index);    // 버튼 이벤트 블럭을 가집니다.


/**
 * @brief UIAlertView 형태의 popup형태의 custom Alert 을  구현한 UIView 객체 - optional protocol 존재
 *기본 SDK에서 제공되는 UIAlertView의 사용자화 및 확장된 사용자와의 소통의 UI로 편리하게 개발하고
 *더나은 맞춤형 UI를 제공하기 위해 도입.
 *UI custmizing된 animation popup AlertView를 통해
 *공통메시지(안내/경고/에러/검증/기타) 및 모듈별 메시지 alert 및 사용자 선택 결과에 따른 앱 Flow 분기 처리담당.
 */


@interface Mocha_Alert : UIView{
    id<Mocha_AlertDelegate> __weak adelegate;
    NSString *_maintitle;
    NSString *_title;
    UIView *_messageView;
    NSArray *_buttonTitle;
    UIView *alertview;
    UIImageView *iv_background;
    BOOL isrotateview;
//    AlertButonIndex     _alertBtnIndex;             // 버튼 이벤트 블럭을 가집니다.
    
}
void drawPxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, float linewidth);
void RetinaAwareUIGraphicsBeginImageContext(CGSize size);

@property (nonatomic, strong) UIImageView *iv_background;
@property (nonatomic, strong) UIView *alertview;
@property (weak, nonatomic) id<Mocha_AlertDelegate> adelegate;
@property (nonatomic, readwrite) CGFloat fdurationTime;
//@property (nonatomic, strong)       AlertButonIndex     alertBtnIndex;

//window 회전관련
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic, assign) BOOL isonwindow;



//// Block alert : 참고)버튼 하나만 있을 땐, 버튼 클릭 시 응답 값 : ButtonIndexClose
//- (void) block_alertWithTitle:(NSString*)title message:(NSString *)message btnOK:(NSString *)strOk btnClose:(NSString *) btnClose btnOther : (NSString *)strOther block_BtnEvent:(AlertButonIndex)btnEvent;


/**
 *  parameter를 바탕으로 구성한  UIView 형태의 최종 AlertView반환. (이 뷰를 반환받아 addSubView: 로 화면표출)
 *
 *   @param title AlertView를 구성할 타이틀 string(20여줄까지 자동개행처리표현지원) (NSString)
 *   @param messageView title string대신 특정 UIview를 표출하고자할때 사용될 View (UIView)
 *   @param delegate 본 Mocha_Alert 객체의 delegate 객체 (보통은 호출한 객체 self) (id)
 *   @param buttonTitle 표현할 버튼 갯수만큼의 버튼title Array  (NSArray)
 *   @return UIView
 *
 */
- (UIView *)initWithView:(NSString *)title message:(UIView *)messageView delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle;




/**
 *  parameter를 바탕으로 구성한  UIView 형태의 최종 AlertView반환. (이 뷰를 반환받아 addSubView: 로 화면표출)
 *
 *   @param title AlertView를 구성할 타이틀 string(20여줄까지 자동개행처리표현지원) (NSString)
 *   @param maintitle 상단 제목에 해당되는 string (NSString)
 *   @param delegate 본 Mocha_Alert 객체의 delegate 객체 (보통은 호출한 객체 self) (id)
 *   @param buttonTitle 표현할 버튼 갯수만큼의 버튼title Array  (NSArray)
 *   @return UIView
 *
 */
- (UIView *)initWithTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle;
//오로지 닫기 기능만추가 닫기 return tag= 1000 예약
- (UIView *)initWithCloseBtn:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle;





//회전 전용
- (UIView *)initWithRotateTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate onwindow:(BOOL)onwindow buttonTitle:(NSArray *)buttonTitle;

//회전
-(void)forcelayoutSubviews;

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations;


// nami0342 - 특정 텍스트의 폰드와 컬러를 변경 (1 영역)
- (UIView *)initWithTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle changeFont:(UIFont*) changeFont changeColor:(UIColor*) changeColor changeMessage:(NSString *) strChageMessage;

// nami0342 - 특정 텍스트들의 폰트와 컬러를 변경 (n 영역)
- (UIView *)initWithTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle changeItems:(NSArray *) arChanges;


@end




@interface MochaWindowViewHelper : NSObject

BOOL UIInterfaceOrientationsIsForSameAxis(UIInterfaceOrientation o1, UIInterfaceOrientation o2);
CGFloat UIInterfaceOrientationAngleBetween(UIInterfaceOrientation o1, UIInterfaceOrientation o2);
CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation);
UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation);

@end
