//
//  DataTVCategoryCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 27..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 , 오늘추천에서 최초사용 - > 지금은 사용안함 (확인 필요함)
//  8버튼 이미지 다운로드 카테고리셀 ,버튼간 라인없음 ex.(휴대폰/주방식기/화장품/생활가전  줄바꿈 아동의류/신선식품/수납가구/전체보기) 

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface DataTVCategoryCell : UITableViewCell{
    NSMutableArray *arrCate;                        //카테고리 데이터를 저장할 배열
}

@property (nonatomic, weak) id target;                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIButton *btn_cate1;     //카테고리 버튼1
@property (nonatomic, strong) IBOutlet UIButton *btn_cate2;     //카테고리 버튼2
@property (nonatomic, strong) IBOutlet UIButton *btn_cate3;     //카테고리 버튼3
@property (nonatomic, strong) IBOutlet UIButton *btn_cate4;     //카테고리 버튼4
@property (nonatomic, strong) IBOutlet UIButton *btn_cate5;     //카테고리 버튼5
@property (nonatomic, strong) IBOutlet UIButton *btn_cate6;     //카테고리 버튼6
@property (nonatomic, strong) IBOutlet UIButton *btn_cate7;     //카테고리 버튼7
@property (nonatomic, strong) IBOutlet UIButton *btn_cate8;     //카테고리 버튼8

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션
//@property (nonatomic, strong) NSString *imageURL;

  



-(void)cellScreenDefine;                                                    //셀 화면 그리기
-(void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                     //셀 구성정보를 포함하고있는 딕셔너리 셋팅
-(void)setButtonImages:(NSString *)imageUrl withButton:(UIButton *)btn;     //각 버튼 이미지 셋팅

@end
