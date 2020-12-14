//
//  TVSCDHeaderView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 13..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 탭에서 사용
//  방송 편성표 iScrollView , 방송내용은 TVSCDHeaderCellView 로 처리

 
#import <UIKit/UIKit.h>

#import "iScroll.h"
#import "TVSCDHeaderCellView.h"

@interface TVSCDHeaderView : UIView < iScrollDataSource, iScrollDelegate>{



 NSNumber* isthisMYSHOP;                                            //생방송,데이터방송 구분자
}
@property (nonatomic, strong) UIImageView *aniarrow;                //편성표 보기 화살표
@property (nonatomic, weak) id target;                              //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSArray *row_arr;              //생방송 데이터가 들어갈 배열

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;                 //이미지 통신 오퍼레이션


- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe;                                      //초기화
-(void) setCellInfoNDrawData:(NSArray*) rowinfoArr  withMode:(NSNumber*)intnype;     //셀 데이터 셋팅 , 테이블뷰에서 호출
- (void)bannerButtonClicked:(id)sender;                                                     //생방송 셀 클릭
@end
