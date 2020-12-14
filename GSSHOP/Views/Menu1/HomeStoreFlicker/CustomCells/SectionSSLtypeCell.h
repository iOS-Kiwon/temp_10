//
//  SectionSSLtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 11..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  숏방 슬라이드 셀. TSL 복사함. // 2016.07.14

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionSSLtypeCell : UITableViewCell


@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSArray *row_arr;                                 //carousel 로 표현할 전체뷰 데이터
@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터

@property (nonatomic,strong) IBOutlet UIView *view_Default;                     //베이스가되는 뷰
@property (nonatomic,strong) IBOutlet iCarousel *carouselProduct;               //상품정보가 슬라이딩 될 carousel
@property (nonatomic,strong) IBOutlet UILabel *lblPage;                         //페이지정보가 표시될 라벨
@property (nonatomic,strong) IBOutlet UILabel *lblTotalPage;                    //전체 페이지정보가 표시될 라벨
@property (nonatomic,strong) IBOutlet UIView *lblView;                          //전체 페이지정보가 표시될 컨테이너뷰
@property (nonatomic,strong) IBOutlet UIImageView *imgBG;                       //배경으로 깔리는 이미지의 noimg 셋팅
@property (nonatomic,strong) IBOutlet UIImageView *imgContents;                 //배경으로 깔리는 이미지
@property (nonatomic,strong) IBOutlet UIButton *imgButton;                      //배경으로 깔리는 이미지 버튼
@property (nonatomic,strong) IBOutlet UIView *underLine;                          //언더라인

@property (strong, nonatomic) NSIndexPath *indexPath;                           //테이블뷰 속의 인덱스 패스
@property (strong, nonatomic) UIImage *imgSeleted;                              //선택된 셀의 이미지 주소
@property (assign, nonatomic) BOOL isOnlyTwo;                                   //셀데이터가 2개만 들어올경우

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션

- (void) setCellInfoNDrawData:(NSDictionary*)rowinfoDic;                  //셀 구성정보를 포함하고있는 딕셔너리 셋팅
- (void)bannerButtonClicked:(id)sender;                                         //배너 버튼 클릭

- (IBAction)backGroundButtonClicked:(id)sender;                                  //백그라운드 이미지 버튼 클릭

@end
