//
//  SectionTSLtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 11..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 탭에서 매우 자주 사용
//  테마 슬라이딩 셀 , 테마 배경 이미지 높이 274 , 중앙에 꽉차지 않게 상품 슬라이딩 

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionTSLtypeCell : UITableViewCell {
    NSTimer *timerScroll;                                               //자동스크롤일경우 타이머
}

@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSArray *row_arr;                                 //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터

@property (nonatomic,strong) IBOutlet UIView *view_Default;                     //베이스가되는 뷰
@property (nonatomic,strong) IBOutlet iCarousel *carouselProduct;               //상품정보가 슬라이딩 될 carousel

@property (nonatomic,strong) UIView *viewPaging;                //상품정보 갯수가 표시될 뷰
@property (nonatomic,strong) UILabel *lblTotalPage;            //총 상품 갯수
@property (nonatomic,strong) UILabel *lblBar;       // /
@property (nonatomic,strong) UILabel *lblCurrentPage;          //현재 상품 페이지

@property (nonatomic,strong) IBOutlet UIImageView *imgBG;                       //배경으로 깔리는 이미지의 noimg 셋팅
@property (nonatomic,strong) IBOutlet UIImageView *imgContents;                 //배경으로 깔리는 이미지

//@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션

@property (nonatomic,strong) IBOutlet UIView *viewBottomLine;                 //하단 라인

-(void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic;                  //셀 구성정보를 포함하고있는 딕셔너리 셋팅
- (void)bannerButtonClicked:(id)sender;                                         //배너 버튼 클릭

-(IBAction)backGroundButtonClicked:(id)sender;                                  //백그라운드 이미지 버튼 클릭

@property (nonatomic, assign) float autoRollingValue;                       // 자동 스크롤 여부
@property (nonatomic, assign) BOOL isRandom;                            // 렌덤 표시
-(void)autoScrollCarousel;                                              // 자동 스크롤 실행


@end
