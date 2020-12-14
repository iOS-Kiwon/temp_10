//
//  SectionFPCtypeSubview.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  TCF,FPC,SectionFPCHeaderView 속에 들어가는 모눈형 카테고리뷰 !!셀이 아니라 뷰이지만 주로 셀에서 사용해서 CustomCells 안에 넣어둠

#import <UIKit/UIKit.h>

#define kHEIGHTFPC 32 //한줄의 높이값 !!! 여기서 변경할경우 사용하는 모든곳에서 바뀜

#define kHEIGHTFPC_S 34 //한줄의 높이값 !!! 여기서 변경할경우 사용하는 모든곳에서 바뀜


@interface SectionFPCtypeSubview : UIView {
    
    NSArray *arrCateInfo;                                       //카테고리 정보 배열
    
    NSInteger idxSeleted;                                       //선택된 인덱스값 , 꼭 하나는 선텍 되어야함
    
    NSString *strCateBgColorOn;
    NSString *strCateBgColorOff;
    NSString *strCateLineColor;
}

@property (nonatomic, weak) id targetFPC;                           //클릭시 이벤트를 보낼 타겟

@property (nonatomic, strong) IBOutlet UIView *viewLineBottom;      //최 하단 라인 , 칼라값이 다름
@property (nonatomic, strong) IBOutlet UIView *viewLineVer01;       //왼쪽으로부터 세로 라인 1
@property (nonatomic, strong) IBOutlet UIView *viewLineVer02;       //왼쪽으로부터 세로 라인 2
@property (nonatomic, strong) IBOutlet UIView *viewLineVer03;       //왼쪽으로부터 세로 라인 3
@property (nonatomic, strong) IBOutlet UIView *viewLineVer04;       //왼쪽으로부터 세로 라인 4

-(void)setCateIndex:(NSInteger)indexCategory;                       //인덱스 선택시 해당 뷰 재 정의해야함

//셀 구성정보를 포함하고있는 딕셔너리 셋팅 , 인덱스 , 배스트 매장여부(기획 변경으로 사용은 안함)
-(void) setCellInfoNDrawData:(NSArray*)arrCate seletedIndex:(NSInteger)index;

//셀 구성정보를 포함하고있는 딕셔너리 셋팅 , 인덱스 , 배스트 매장여부(기획 변경으로 사용은 안함)
-(void) setCellInfoNDrawData:(NSArray*)arrCate seletedIndex:(NSInteger)index andItemViewColorOn:(NSString *)strViewColorOn andItemViewColorOff:(NSString *)strViewColorOff andLineColor:(NSString *)strLineColor;

@end