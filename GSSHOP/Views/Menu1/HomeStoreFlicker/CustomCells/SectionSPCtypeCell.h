//
//  SectionSPCtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 20..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 탭에서만 사용 , 지금은 거의 사용안함
//  TV쇼핑탭에서 사용하는 셀 , 상단에 이미지 , 셀 안에 가로스크롤 테이블뷰 존재 -> 방송편성 정보가 들어감

#import <UIKit/UIKit.h>

@interface SectionSPCtypeCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>{
    
}

@property (nonatomic, weak) id targettb;                                        //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;                    //베이스뷰
@property (nonatomic, strong) IBOutlet UIButton *btnBackGround;                 //백그라운드 이미지 버튼
@property (nonatomic, strong) IBOutlet UIView *viewHorizontal;                  //가로스크롤 테이블뷰 가 올라가는 뷰
@property (nonatomic, strong) IBOutlet UITableView *horizontalTableView;        //가로스크롤 테이블뷰

@property (nonatomic, strong) NSArray *articles;                                //가로스크롤 테이블뷰 datasource
@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic, strong) NSString* loadingImageURLString;                  //이미지 주소
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 로딩 오퍼레이션

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                        //셀 구성정보를 포함하고있는 딕셔너리 셋팅
-(IBAction)onBtnBackGroundImage:(id)sender;                                     //백그라운드 배너 버튼 클릭

@end
