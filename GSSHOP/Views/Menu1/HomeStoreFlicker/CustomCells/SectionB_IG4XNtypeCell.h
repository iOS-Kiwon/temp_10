//
//  SectionB_IG4XNtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 12. 3..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 탭에서 , 지금은 거의 사용 안함
//  12개 이미지를 표현할수 있는 카테고리 셀 

#import <UIKit/UIKit.h>

@interface SectionB_IG4XNtypeCell : UITableViewCell

@property (nonatomic, weak) id target;                                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;                            //셀 베이스뷰
@property (nonatomic, strong) IBOutlet UIImageView *imgTopBG;                           //상단 백그라운드 이미지
@property (nonatomic, strong) IBOutlet UIView *viewAllCategory;                         //상단 이미지, 카테고리버튼, 하단 버튼 올라갈뷰
@property (nonatomic, strong) NSArray *row_arr;                                         //케테고리를 표현할 버튼 배열
@property (nonatomic, strong) NSDictionary *row_dic;                                    //셀을 구성할 모든데이터가 포함된 딕셔너리

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;             //이미지 통신 오퍼레이션


@property (nonatomic, strong) IBOutlet UIView *viewMiddle;                              //카테고리 버튼이 올라가는뷰

@property (nonatomic, strong) IBOutlet UIView *viewBottom;                              //하단 버튼이 올라가는뷰
@property (nonatomic, strong) IBOutlet UIImageView *imgBottom;                          //하단 버튼 이미지
@property (nonatomic, strong) IBOutlet UIButton *btnBottom;                             //하단 버튼


@property (nonatomic,strong) IBOutlet UIView *viewCateHLine00;                          //가로 라인
@property (nonatomic,strong) IBOutlet UIView *viewCateHLine01;
@property (nonatomic,strong) IBOutlet UIView *viewCateHLine02;

@property (nonatomic,strong) IBOutlet UIView *viewCateWLine00;                          //세로 라인
@property (nonatomic,strong) IBOutlet UIView *viewCateWLine01;
@property (nonatomic,strong) IBOutlet UIView *viewCateWLine02;

-(void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic;                          //셀 데이터 셋팅 , 테이블뷰에서 호출




-(IBAction)onBtnCateGory:(id)sender;                                                    //카테고리 버튼 클릭시 호출이벤트
-(IBAction)backGroundButtonClicked:(id)sender;                                          //백그라운드 버튼 클릭시 이벤트

@end
