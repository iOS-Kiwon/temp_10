//
//  SectionFPCtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  지금BEST 매장 , 백화전 매장 사용중
//  카테고리 제한은 12개 (3의배수) 이지만 이상과 이하도 모두 작동하도록 개발


#import <UIKit/UIKit.h>
#import "SectionFPCtypeSubview.h"
#import "SectionFPC_SubCategoryView.h"


@interface SectionFPCtypeCell : UITableViewCell


@property (nonatomic, weak) id target;                              //클릭시 이벤트를 보낼 타겟

@property (nonatomic, weak) id sectionViewTarget;                   //클릭시 써브써브 카테고리 펼칠SectionView;

@property (nonatomic, strong) IBOutlet UIView *viewBackground;        //백그라운드 뷰

@property (nonatomic, strong) IBOutlet UIView *view_Default;        //베이스뷰
@property (nonatomic, strong) NSArray *arrFPC;                      //카테고리를 구성할 배열값

@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;               //최하단 라인

@property (nonatomic, strong) SectionFPC_SubCategoryView *viewFPC_SubCate;

//셀 구성정보를 포함하고있는 딕셔너리 셋팅 , 인덱스 값도 셋팅
-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index;

//셀 구성정보를 포함하고있는 딕셔너리 셋팅 , 인덱스 값도 셋팅 , 칼라값 추가됨
-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index andSeletedSubIndex:(NSInteger)subIndex andBgColor:(NSString *)strBgColor andItemViewColorOn:(NSString *)strViewColorOn andItemViewColorOff:(NSString *)strViewColorOff andLineColor:(NSString *)strLineColor;

//카테고리 클릭시 테이블뷰에서 FPC 셀 아래로 보이는 모든 셀 데이터 재정의 , 중요 !!!! TCF와 다르게 FPC는 API통신후 받아와서 재정의함
-(void)onBtnCateTag:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic;

//DFCLIST(백화점) 매장일경우 지금BEST와 다르기떄문에 높이값 조절
-(void)modifyTopForDFCLIST;
@end
