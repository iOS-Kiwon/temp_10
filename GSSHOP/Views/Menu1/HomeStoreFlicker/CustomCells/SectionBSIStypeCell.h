//
//  SectionBSIStypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 24..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 탭에서 최초사용 -> 지금은 거의사용안함
//  다중 이미지 슬라이딩 셀 pageView 존재, 이미지가 1개 일경우 하나만 표현 pageView 비노출  ,이미지 높이 220

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionBSIStypeCell : UITableViewCell {    
    NSTimer *timerScroll;                                               //자동스크롤일경우 타이머
}

@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;                          //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, assign) float autoRollingValue;       //자동 스크롤 여부

-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr;                      //셀 구성정보를 포함하고있는 딕셔너리 셋팅
- (void)bannerButtonClicked:(id)sender;                                         //배너 버튼 클릭
@end
