//
//  SectionMAP_SLD_C3_GBAtypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 6..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//  오늘추천 슬라이드 하위 3단 아이템 셀

#import <UIKit/UIKit.h>
#import "SectionMAP_SLD_C3_GBAtypeview.h"
#import "iCarousel.h"

@interface SectionMAP_SLD_C3_GBAtypeCell : UITableViewCell

@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;                  //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터


@property (nonatomic,strong) IBOutlet iCarousel *carouselProduct;       //상품정보가 슬라이딩 될 carousel

@property (nonatomic,strong) UIView *viewCount;                //상품정보 갯수가 표시될 뷰
@property (nonatomic,strong) UILabel *lblTotalPage;            //총 상품 갯수
@property (nonatomic,strong) UILabel *lblBar;                  // /
@property (nonatomic,strong) UILabel *lblCurrentPage;          //현재 상품 페이지

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션

-(void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
- (void)dellClick:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;


- (void)leftArrow:(id)sender;                               //좌측 클릭
- (void)rightArrow:(id)sender;                              //우측 클릭

@end

