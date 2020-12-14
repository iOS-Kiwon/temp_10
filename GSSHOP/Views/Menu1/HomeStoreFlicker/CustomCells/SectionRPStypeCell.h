//
//  SectionRPStypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  지금BEST 매장 항상 노출중
//  실시간 인기 검색어

#import <UIKit/UIKit.h>

#define heightOneLine 38.0                          //검색어 1줄당 위,아래 마진을 포함한 높이
#define insideSearchWord 6.0                        //검색어와 검색어테두리 뷰의 여백
#define intervalSearchWord 10.0                     //검색어와 검색어의 간격 (터치영역을 확보하기위해 실제 검색어 영역은 마진값이 조금 있음)
#define fontSizeRPS 16.0                            //검색어의 폰트 사이즈

@interface SectionRPStypeCell : UITableViewCell

@property (nonatomic, weak) id target;                              //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *viewDefault;         //베이스뷰
@property (nonatomic, strong) IBOutlet UIView *viewWords;           //검색어가 표시될 뷰 , 줄바꿈 계산을 위해 따로 빼놨음
@property (nonatomic, strong) IBOutlet UIView *viewTopLine;         //상단 라인
@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;      //하단 라인
@property (nonatomic, strong) NSArray *arrRow;                      //검색어 리스트
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;         //타이틀. 기본값은 실시간 인기 검색어

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;               //셀 구성정보를 포함하고있는 딕셔너리 셋팅

@end