//
//  SectionB_ITtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장만 사용 , 브랜드 매장이랑 별개 취급
//  브랜드샵 셀, 이미지 4장을 다운로드 받아서 모눈형으로 표현

#import <UIKit/UIKit.h>

@interface SectionB_ITtypeCell : UITableViewCell

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;         //이미지 통신 오퍼레이션

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *defaultHeight;            //autolayout 용 셀 높이 조절값

@property (nonatomic, weak) id target;                                              //클릭시 이벤트를 보낼 타겟
@property (nonatomic,strong) IBOutlet UIView *viewDefault;                          //셀 베이스뷰
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightTitle;             //autolayout 용 타이틀영역 높이값,타이틀 텍스트 없으면 미표시
@property (nonatomic,strong) IBOutlet UIView *viewTopLine;                          //상단 라인
@property (nonatomic,strong) IBOutlet UILabel *lblTitle;                            //타이틀 라벨

@property (nonatomic,strong) IBOutlet UIView *viewProduct01;                        //브랜드 샵 이미지올라갈 뷰 01
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct01;                    //브랜드 샵 이미지 01
@property (nonatomic,strong) IBOutlet UILabel *lblBrand01;                          //브랜드 샵 텍스트 01 미사용

@property (nonatomic,strong) IBOutlet UIView *viewProduct02;                        //브랜드 샵 이미지올라갈 뷰 02
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct02;                    //브랜드 샵 이미지 02
@property (nonatomic,strong) IBOutlet UILabel *lblBrand02;                          //브랜드 샵 텍스트 02 미사용

@property (nonatomic,strong) IBOutlet UIView *viewProduct03;                        //브랜드 샵 이미지올라갈 뷰 03
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct03;                    //브랜드 샵 이미지 03
@property (nonatomic,strong) IBOutlet UILabel *lblBrand03;                          //브랜드 샵 텍스트 03 미사용

@property (nonatomic,strong) IBOutlet UIView *viewProduct04;                        //브랜드 샵 이미지올라갈 뷰 04
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct04;                    //브랜드 샵 이미지 04
@property (nonatomic,strong) IBOutlet UILabel *lblBrand04;                          //브랜드 샵 텍스트 04 미사용

@property (nonatomic, strong) NSArray *row_arr;                                     //브랜드 샵 데이터 들이 들어갈 배열

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;                               //셀 데이터 셋팅 , 테이블뷰에서 호출

-(IBAction)onBtnBrandBanner:(id)sender;                                             //배너 클릭시 이벤트

@end
