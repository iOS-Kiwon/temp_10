//
//  SectionHFtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 1..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  날방에서만 사용
//  날방 해쉬테그 필터 셀

#import <UIKit/UIKit.h>
#import "SectionHFtypeSubView.h"                                //관리자 헤쉬테그 값이 들어가는 모눈형 뷰

#define kHFSEARCHTAG @"kHFSEARCHTAG"                            //일반 헤쉬테그 검색시 쓰는 검색어 키 값
#define kHFSEARCHCOUNT @"kHFSEARCHCOUNT"                        //일반 헤쉬테그 검색시 쓰는 검색어 카운트 키 값

@interface SectionHFtypeCell : UITableViewCell {
    
}

@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;            //셀 베이스뷰
@property (nonatomic, strong) NSArray *arrHF;                           //헤쉬테그 리스트가 들어가는 배열


//셀 데이터 셋팅 , 테이블뷰에서 호출 , tagResult 값이 존재 할경우 뷰 확장후 검색어와 카운트 표시
-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index andSearchResult:(NSDictionary *)tagResult;

//관리자 헤쉬테그 클릭
-(void)onBtnHashTags:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic;

@end
