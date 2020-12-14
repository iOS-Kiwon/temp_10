//
//  SectionNO1typeView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 4. 3..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 매장 테이블뷰 헤더에서 사용가능하나 ,현재 사용안함
//  네비게이션 매장 데이터중 no1DealZone 값이 있을경우 테이블뷰 헤더에 표현

//  사용안한지 너무 오래되고 배너 표현방식이 많이 바뀌어서 삭제여부 판단해야함

#import <UIKit/UIKit.h>

#import "iCarousel.h"

@interface SectionNO1typeView : UIView



@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSMutableArray *row_arr;

//@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;


- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe; 
-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr;
- (void)bannerButtonClicked:(id)sender;
@end
