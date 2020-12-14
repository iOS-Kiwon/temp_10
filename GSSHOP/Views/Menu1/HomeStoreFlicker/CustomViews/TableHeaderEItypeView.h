//
//  TableHeaderEItypeView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 21..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 매장 테이블뷰 헤더에서 사용중
//  네비게이션 매장 데이터중 headerList 데이터중 viewType 이 B_IM 이거나 , no1DealList 데이터중 viewType 이 I 일경우 사용
//  이미지 1장 배너뷰 기본 320x160


#import <UIKit/UIKit.h>

@interface TableHeaderEItypeView : UIView {
    NSDictionary *rdic;                                                                 //셀 전체 데이터
}

@property (nonatomic, weak) id target;                                                  //클릭시 이벤트를 보낼 타겟

@property (nonatomic, weak) IBOutlet UIImageView *productImageView;                     //상품 이미지뷰
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;             //이미지 통신 오퍼레이션
@property (nonatomic, strong) NSString *imageURL;                                       //이미지 주소

@property (nonatomic, weak) IBOutlet UIImageView *tag_no1BestDeal;                      //no1 베딜 딱지

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe;                                  //초기화
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                                //셀 데이터 셋팅 , 테이블뷰에서 호출
-(IBAction)clickEvtwithDic:(id)sender;                                                  //배너 클릭


@end
