//
//  SubCategoryHomeListView.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 18..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//  (오늘오픈)FCLIST 필터컨텐츠 리스트 전용
//  SectionHomeFnSView 아래로 카테고리 내용을 펼쳐서 표현할 뷰

#import <UIKit/UIKit.h>

@interface SubCategoryHomeListView : UIView {
    
    NSMutableArray *category_arr;                           //카테고리 내용들을 담을 배열
    UIScrollView *base_scrollview;                          //카테고리 내용들을 그릴 뷰 , 영역을 넘어갈지 모르니 스크롤뷰
      UIView *containview;                                  //스크롤 뷰를 붙힐 뷰
    BOOL iscallWiseLog;                                     //와이즈 로그 호출여부, 초기에는 호출안하고 클릭시에만 호출
}

@property (nonatomic, weak) id target;                      //클릭시 이벤트를 보낼 타겟

- (id)initWithTarget:(id)sender andDic:(NSMutableArray*)tdic;       //초기화
-(void)clickBtn:(id)sender;                                         //카테고리 선택
@end
