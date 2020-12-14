//
//  SectionSCFtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 20..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHFtypeSubView.h"                                //관리자 헤쉬테그 값이 들어가는 모눈형 뷰

@interface SectionSCFtypeCell : UITableViewCell

@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;            //셀 베이스뷰
@property (nonatomic, strong) NSArray *arrSCF;                           //헤쉬테그 리스트가 들어가는 배열


//셀 데이터 셋팅 , 테이블뷰에서 호출
-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index;

//관리자 헤쉬테그 클릭
-(void)onBtnHashTags:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic;

@end
