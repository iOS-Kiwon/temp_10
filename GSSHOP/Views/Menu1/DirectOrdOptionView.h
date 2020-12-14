//
//  DirectOrdOptionView.h
//  GSSHOP
//
//  Created by gsshop on 2016. 3. 4..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  바로구매창 , 엡델리게이트에서 alloc 후 앱 전체에서 필요할떄마다 show & hide

#import <UIKit/UIKit.h>
#import "AutoLoginViewController.h"
#import "GSWKWebview.h"

@interface DirectOrdOptionView : UIView <WKNavigationDelegate,LoginViewCtrlPopDelegate>{
    
    //UIView *webViewOptionContaioner;            //웹뷰 컨테이너
    GSWKWebview *webViewOption;                 //바로구매창 웹뷰
    AutoLoginViewController *loginView;         //바로구매시 로그인이 필요한경우 새로띄워야할 로그인뷰 컨트롤러
    
    NSString *strStartUrl;                      //최초셋팅 url 비교조건이 필요할지 모르니 만들어둠
    int abNomalCount;
}
@property (nonatomic, weak) id target;
@property (nonatomic,strong) NSString *curRequestString;                //현재페이지 url , 로그인후 돌아와서 사용등 조건에따라 필요함




- (void)closeWithAnimated:(BOOL)animated;                               //애니매이션 닫기
- (void)openWithAnimated:(BOOL)animated withUrl:(NSString *)strUrl;     //시작url 과 애니매이션 바로구매창 열기

  
@end
