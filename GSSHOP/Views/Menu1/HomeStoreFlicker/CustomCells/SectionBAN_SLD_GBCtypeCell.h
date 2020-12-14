//
//  SectionBAN_SLD_GBCtypeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 2. 8..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionBAN_SLD_GBCtypeCell : UITableViewCell {
    NSTimer *timerScroll;                                               //자동스크롤일경우 타이머
    BOOL isOnlyTwoItem;                       //배너 데이터를 2개만 넣어도 carousel 에서 무한반복시 양옆으로 존재하는듯 표현하기위한 값
}

@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;                         //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic,strong) IBOutlet iCarousel *carouselProduct;       //상품정보가 슬라이딩 될 carousel
@property (nonatomic,strong) IBOutlet UIView *viewPaging;               //상품정보 갯수가 표시될 뷰
@property (nonatomic,strong) IBOutlet UILabel *lblTotalPage;            //총 상품 갯수
@property (nonatomic,strong) IBOutlet UILabel *lblCurrentPage;          //현재 상품 페이지
@property (nonatomic, assign) float autoRollingValue;                   // 자동 스크롤 여부
@property (nonatomic, assign) BOOL isRandom;                            // 렌덤 표시

- (void)setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic;          //셀 구성정보를 포함하고있는 딕셔너리 셋팅
- (void)autoScrollCarousel;                                             // 자동 스크롤 실행


@end
