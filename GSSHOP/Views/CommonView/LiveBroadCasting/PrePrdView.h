//
//  PrePrdView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 2. 25..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLoginViewController.h"
#import "GSWKWebview.h"

@interface PrePrdView : UIView <WKNavigationDelegate>{
    
    GSWKWebview *webViewPrePrd;                 //미리보기창 웹뷰
    
    NSString *strStartUrl;                      //최초셋팅 url 비교조건이 필요할지 모르니 만들어둠
}
@property (nonatomic, weak) id target;
@property (nonatomic,strong) NSString *curRequestString;                //현재페이지 url , 로그인후 돌아와서 사용등 조건에따라 필요함

- (void)closeWithAnimated:(BOOL)animated;                               //애니매이션 닫기
- (void)openWithAnimated:(BOOL)animated withUrl:(NSString *)strUrl;     //시작url 과 애니매이션 바로구매창 열기

@end
