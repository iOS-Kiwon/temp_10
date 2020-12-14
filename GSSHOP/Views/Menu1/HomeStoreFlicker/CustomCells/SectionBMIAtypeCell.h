//
//  SectionBMIAtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 24..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 탭에서 최초사용 -> 지금은 거의사용안함
//  이미지 3분할 셀 왼쪽 240 , 오른쪽 120 두개 , 또한 3분할 화면을 여러개 플리킹 가능하도록 구성

#import <UIKit/UIKit.h>

@interface SectionBMIAtypeCell : UITableViewCell

@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSMutableArray *row_arr;                          //carousel 로 표현할 전체뷰 데이터, 배열 속에 다시 3분할 이미지 존재
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                        //이미지 경로를 포함하고있는 딕셔너리 셋팅

@end
