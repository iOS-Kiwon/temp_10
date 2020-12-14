//
//  SectionTAB_SLtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 12. 8..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 탭에서 , 지금은 거의 사용 안함
//  최상단 2~3 버튼이 존재하고 , 버튼 선택시 하단 테이블뷰의 컨텐츠가 바뀌는 셀

#import <UIKit/UIKit.h>

@interface SectionTAB_SLtypeCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>{
    NSInteger idxTab;                                                               //선택된 탭의 인덱스값
}

@property (nonatomic, weak) id targettb;                                            //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;                        //셀 베이스뷰
@property (nonatomic, strong) IBOutlet UIImageView *imageBackGround;                //탭버튼 뒤로 깔리는 이미지 뷰

@property (nonatomic, strong) IBOutlet UIImageView *imgArrow;                       //선택된 탭을 지시하는 화살표 이미지
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *arrowCenter;               //autolayout 화살표 이미지의 센터값

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *btn01Leading;              //autolayout 기준이 되는 첫번째 버튼의 leading 값
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *btn02Center;               //autolayout 버튼2의 중앙값 , 화살표 이미지의 초기값

@property (nonatomic, strong) IBOutlet UIView *viewHorizontal;                      //가로스크롤링 테이블 뷰가 올라갈 뷰
@property (nonatomic, strong) IBOutlet UITableView *horizontalTableView;            //가로스크롤 테이블 뷰
@property (nonatomic, strong) IBOutlet UIButton *btnTab01;                          //상단 탭 버튼01
@property (nonatomic, strong) IBOutlet UIButton *btnTab02;                          //상단 탭 버튼02
@property (nonatomic, strong) IBOutlet UIButton *btnTab03;                          //상단 탭 버튼03


@property (nonatomic, strong) NSArray *articles;                                    //탭이 선텍될때마다 테이블뷰에서 바라볼 배열값
@property (nonatomic, strong) NSDictionary *row_dic;                                //셀 전채를 구성할 데이터
@property (nonatomic, strong) NSString* loadingImageURLString;                      //이미지 url
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;         //이미지 통신 오퍼레이션



-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                            //셀 데이터 셋팅 , 테이블뷰에서 호출
-(IBAction)onBtnTabButton:(id)sender;                                               //탭 버튼클릭 이벤트

@end
