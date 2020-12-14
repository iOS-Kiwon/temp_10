//
//  FXCCategoryView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 매장 테이블뷰 헤더 최상단 카테고리 이미지형 버튼 , 플랙서블 매장 도입시기에 생성됨

#import <UIKit/UIKit.h>

@interface FXCCategoryView : UIView {
    IBOutlet UIView *viewBG;                    //백그라운드 뷰
}

@property (nonatomic, weak) id target;          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;                 //이미지 통신 오퍼레이션


-(id)initWithTarget:(id)sender cate:(NSArray *)arrCate seletedIndex:(NSInteger)index;       //초기화 하면서 그리고 인덱스 셋팅
-(void)setCateIndex:(NSInteger)indexCategory;                                               //인덱스 셋팅하면서 하이라이트

@end
