//
//  BrandBannerListView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 18..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  브랜드 매장
//  브랜드 매장에서만 쓰이는 가로 슬라이딩 배너 뷰


#import <UIKit/UIKit.h>

#import "iCarousel.h"

@interface BrandBannerListView : UIView



@property (nonatomic, weak) id target;                                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;                                  //배너뷰를 구성할 배열 데이터

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;             //이미지 통신 오퍼레이션


- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe;                                  //초기화
-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr;                              //셀 데이터 셋팅
- (void)bannerButtonClicked:(id)sender;                                                 //배너 클릭시 이벤트
@end
