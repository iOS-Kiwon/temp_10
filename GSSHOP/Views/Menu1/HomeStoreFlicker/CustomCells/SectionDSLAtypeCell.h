//
//  SectionDSLAtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 9..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 탭에서 매우 자주 사용
//  D슬라이딩 셀 A타입 , 조건에 따라 자동스크롤 기능 포함 

#import <UIKit/UIKit.h>

#import "iCarousel.h"

@interface SectionDSLAtypeCell : UITableViewCell{
    NSTimer *timerScroll;                                               //자동스크롤일경우 타이머
    NSString *viewType;
}

@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSArray *row_arr;                         //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic,strong) IBOutlet UIImageView *imgTopContents;      //상단 배경이미지
@property (nonatomic,strong) IBOutlet iCarousel *carouselProduct;       //상품정보가 슬라이딩 될 carousel
@property (nonatomic,strong) UIView *viewPaging;                //상품정보 갯수가 표시될 뷰
@property (nonatomic,strong) IBOutlet UIView *viewWhiteBG;              //흰색으로 깔린 배경뷰
@property (nonatomic,strong) UILabel *lblTotalPage;            //총 상품 갯수
@property (nonatomic,strong) UILabel *lblBar;       // /
@property (nonatomic,strong) UILabel *lblCurrentPage;          //현재 상품 페이지
@property (nonatomic,strong) IBOutlet UIView *viewBottomLine;           //하단 구분 라인
@property (nonatomic, assign) BOOL isAutoRolling;                       //자동 스크롤 여부
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (nonatomic, assign) CGFloat topHeight;

- (void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic;          //셀 구성정보를 포함하고있는 딕셔너리 셋팅
- (void)bannerButtonClicked:(id)sender;                                 //배너 버튼 클릭
- (void)autoScrollCarousel;                                              //자동 스크롤 실행
- (IBAction)backGroundButtonClicked:(id)sender;                          //백그라운드 배너 버튼 클릭



@end
