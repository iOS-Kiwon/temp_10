//
//  SectionView+EILIST.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 25..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  이벤트 탭용 SectionView 뷰 확장

#import "SectionView.h"

@interface SectionView (EILIST)

- (void)ScreenDefineEIWith:(BOOL)isReDefine;    //이벤트 테이블뷰 디파인
- (void)ScreenDefineEILIST;                 //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineEILIST;               //리로드시 호출 , 캐시 사용함

//이벤트 탭은 카테고리 선택시 API 재통신  
-(void)RELOADEICATEGORYWITHTAG:(NSNumber*)tnum;

@end
