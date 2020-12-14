//
//  SectionPCtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 23..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 탭에서만 사용
//  TV쇼핑 탭 인기프로그램 셀 이미지배너 5개 표현 ,우측 하단에 이미지 뷰

#import <UIKit/UIKit.h>

@interface SectionPCtypeCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id target;
@property (nonatomic, strong) IBOutlet UIView *view_Default;
@property (nonatomic, strong) IBOutlet UIView *viewProgram;

@property (nonatomic, strong) NSDictionary *row_dic;                        //셀을 구성하는 데이터
@property (nonatomic, strong) NSString* loadingImageURLString;              //이미지 url
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation; //이미지 로딩 오퍼레이션

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;                   //상단 타이틀 라벨
@property (nonatomic, strong) IBOutlet UIImageView *imgTitleIcon;           //상단 타이틀 아이콘
@property (nonatomic, strong) UITableView *tableProgram;
@property (nonatomic, strong) NSMutableArray *arrProgram;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                    //셀 구성정보를 포함하고있는 딕셔너리 셋팅
-(IBAction)onBtnBanner:(id)sender;                                          //배너 클릭

@end
