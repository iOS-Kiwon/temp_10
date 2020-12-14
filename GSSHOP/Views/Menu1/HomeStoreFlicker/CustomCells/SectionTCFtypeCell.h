//
//  SectionTCFtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 LIVE , 항상 노출중
//  TV쇼핑 추천상품 셀

#import <UIKit/UIKit.h>

@interface SectionTCFtypeCell : UITableViewCell

@property (nonatomic, weak) id target;                                      //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;                //베이스뷰

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;                   //"TV쇼핑 추천상품" 타이틀

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index;   //셀 구성정보를 포함하고있는 딕셔너리 셋팅


//!!!!!!!!!!!중요~~ 카테고리 클릭시 테이블뷰에서 TCF 셀 아래로 보이는 모든 셀 데이터 재정의 , 하위 모든 데이터값이 TCF셀에 있음
-(void)onBtnCateTag:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic;
@end
