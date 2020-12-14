//
//  SectionSEtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 7..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  이벤트 매장에서 항상 사용
//  이미지 슬라이딩 배너 셀

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionSEtypeView : UIView {
    BOOL isOnlyTwoItem;                     //배너 데이터를 2개만 넣어도 carousel 에서 무한반복시 양옆으로 존재하는듯 표현하기위한 값
    iCarousel *pageView;                    //배너들을 넣을 carousel
}


@property (nonatomic, weak) id target;                              //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;              //배너들 데이터

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe;                          //초기화
-(void) setCellInfoNDrawData:(NSArray*) rowinfoArr;                             //셀 데이터 셋팅 , 테이블뷰에서 호출
- (void)bannerButtonClicked:(id)sender;                                         //버튼클릭

@end
