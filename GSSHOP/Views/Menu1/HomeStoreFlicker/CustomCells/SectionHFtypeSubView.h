//
//  SectionHFtypeSubView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 1..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  날방HF 셀 전용
//  SectionHFtypeCell 셀의 서브뷰이며 혹시 다른곳에서도 사용 가능하도록 확장성을 고려해서 미리 분리해둠

#import <UIKit/UIKit.h>

#define kHEIGHTHF 32                                //관리자 헤쉬테그의 한 행의 높이
#define kRowPerCountHF 6                            //한 행당 헤쉬태그의 갯수
#define kMaxCountHF 6                               //총 헤쉬테그의 갯수

@interface SectionHFtypeSubView : UIView {

    NSArray *arrHashInfo;                                               //해쉬테그들 배열
    NSInteger idxSeleted;                                               //선택된 인덱스 값 , 필수
}

@property (nonatomic, weak) id targetHF;                                //클릭시 이벤트를 보낼 타겟

@property (nonatomic, strong) IBOutlet UIView *viewLineBottom;          //최하단 라인 , 중앙라인들과 외곽 라인들 칼라가 다름
@property (nonatomic, strong) IBOutlet UIView *viewLineLeading;         //좌측 첫 라인
@property (nonatomic, strong) IBOutlet UIView *viewLineVer01;           //세로 라인 1
@property (nonatomic, strong) IBOutlet UIView *viewLineVer02;           //세로 라인 2
@property (nonatomic, strong) IBOutlet UIView *viewLineVer03;           //세로 라인 3
@property (nonatomic, strong) IBOutlet UIView *viewLineVer04;           //세로 라인 4
@property (nonatomic, strong) IBOutlet UIView *viewLineVer05;           //세로 라인 5
@property (nonatomic, strong) IBOutlet UIView *viewLineTrailing;        //세로 라인 최 우측

@property (nonatomic, strong) NSString *strHighlightColor;              //카테고리 선택시 하이라이트 색상

-(void)setCateIndex:(NSInteger)indexHash;                               //선택된 헤쉬테그 하이라이트
-(void) setCellInfoNDrawData:(NSArray*)arrHash seletedIndex:(NSInteger)index;       //뷰 데이터 셋팅 , SectionHFtypeCell에서 호출

@end
