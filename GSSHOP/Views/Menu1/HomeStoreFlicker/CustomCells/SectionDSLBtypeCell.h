//
//  SectionDSLBtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 14..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 탭에서 자주 사용
//  D슬라이딩 셀 B타입 , A타입과 다른점 => 자동스크롤 없고 ,페이지 라벨 칼라 다름, 이미지뷰 영역이 초기에는 달랐음

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionDSLBtypeCell : UITableViewCell {
    NSTimer *timerScroll;                                               //자동스크롤일경우 타이머
}

@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSArray *row_arr;                         //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic,strong) IBOutlet UIImageView *imgTopContents;      //상단 배경이미지
@property (nonatomic,strong) IBOutlet iCarousel *carouselProduct;       //상품정보가 슬라이딩 될 carousel
@property (nonatomic,strong) UIView *viewPaging;                //상품정보 갯수가 표시될 뷰
@property (nonatomic,strong) IBOutlet UIView *viewWhiteBG;              //흰색으로 깔린 배경뷰
@property (nonatomic,strong) UILabel *lblTotalPage;            //총 상품 갯수
@property (nonatomic,strong) UILabel *lblBar;
@property (nonatomic,strong) UILabel *lblCurrentPage;          //현재 상품 페이지
@property (nonatomic,strong) IBOutlet UIView *viewBottomLine;           //하단 구분 라인
- (void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic;                  //셀 구성정보를 포함하고있는 딕셔너리 셋팅
- (void)bannerButtonClicked:(id)sender;                                         //배너 버튼 클릭
- (IBAction)backGroundButtonClicked:(id)sender;                                  //백그라운드 배너 버튼 클릭
@property (nonatomic, assign) float autoRollingValue;                       // 자동 스크롤 여부
@property (nonatomic, assign) BOOL isRandom;                            // 렌덤 표시
- (void)autoScrollCarousel;                                              // 자동 스크롤 실행
@end
