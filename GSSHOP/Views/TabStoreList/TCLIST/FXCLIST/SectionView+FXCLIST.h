//
//  SectionView+FXCLIST.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 23..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 매장 섹션뷰

#import "SectionView.h"

@interface SectionView (FXCLIST)

- (void)ScreenDefineFXCWith:(BOOL)isReDefine;           //테이블뷰 디파인
- (void)ScreenDefineFXCLIST;                            //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineFXCLIST;                          //리로드시 호출 , 캐시 사용함

//카테고리 선택시 API 재통신
-(void)SELECTEDFXCCATEGORYWITHTAG:(NSNumber*)tnum;

@end
