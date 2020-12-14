//
//  SectionBAN_SLD_GBABtypeView
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 7..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.


#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionBAN_SLD_GBABtypeView : UIView {
    BOOL isOnlyTwoItem;                     //배너 데이터를 2개만 넣어도 carousel 에서 무한반복시 양옆으로 존재하는듯 표현하기위한 값
    NSString *gbType;                       // GBA, GBB
    NSTimer *timerScroll;                   //자동스크롤일경우 타이머
    NSMutableDictionary *mapPosition;
    NSInteger myPos;
}

@property (nonatomic, weak) id target;                      //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;      //배너들 데이터
@property (nonatomic, strong) UIView *viewPaging;           //하단 페이징영역
@property (nonatomic, strong) UILabel *lblCurrentPage;      //현재 페이지
@property (nonatomic, strong) UILabel *lblbar;              // /
@property (nonatomic, strong) UILabel *lblTotalPage;        //총 페이지
@property (nonatomic, strong) iCarousel *pageView;          //배너들을 넣을 carousel
@property (nonatomic, assign) float autoRollingValue;       //자동 스크롤 여부
@property (nonatomic, assign) BOOL isRandom;                // 렌덤 표시

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe Type:(NSString*)type;     //초기화, type: GBA(우측하단), GBB(우측상단)
- (void) setCellInfoNDrawData:(NSArray*) rowinfoArr;                            //셀 데이터 셋팅 , 테이블뷰에서 호출
- (void)bannerButtonClicked:(id)sender;                                         //버튼클릭
- (void)prepareForReuse;                                                        //재사용
- (void)leftArrow:(id)sender;
- (void)rightArrow:(id)sender;
- (void)autoScrollCarousel;                                              //자동 스크롤 실행
- (void)setPositionKey:(NSInteger )key;
- (void) setSlidePostion:(NSInteger) postion;
@end
