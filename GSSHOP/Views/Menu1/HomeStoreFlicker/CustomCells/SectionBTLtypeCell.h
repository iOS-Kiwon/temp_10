//
//  SectionBTLtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 12. 9..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 탭에서 , 지금은 거의 사용 안함 
//  상품 2개 표현 

#import <UIKit/UIKit.h>

@interface SectionBTLtypeCell : UITableViewCell {
    
}
@property (nonatomic, weak) id target;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;         //이미지 통신 오퍼레이션

@property (nonatomic, strong) IBOutlet UIView *view_Default;                        //셀 베이스뷰

@property (nonatomic, strong) IBOutlet UIImageView *imgProduct01;                   //첫번째 상품 이미지
@property (nonatomic, strong) IBOutlet UIImageView *imgProduct02;                   //두번째 상품 이미지

@property (nonatomic, strong) IBOutlet UILabel *lblProgramTitle01;                  //첫번째 상품 제목
@property (nonatomic, strong) IBOutlet UILabel *lblProgramTitle02;                  //두번째 상품 제목

@property (nonatomic, strong) IBOutlet UILabel *lblSubject01;                       //첫번째 상품 부 제목
@property (nonatomic, strong) IBOutlet UILabel *lblSubject02;                       //두번째 상품 부 제목

@property (nonatomic, strong) IBOutlet UILabel *lblDesc01;                          //첫번째 상품 설명
@property (nonatomic, strong) IBOutlet UILabel *lblDesc02;                          //두번째 상품 부 제목

@property (nonatomic, strong) NSDictionary *row_dic;                                //셀 전채를 구성할 데이터

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imgHeight;                 //autolayout 이미지높이

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                            //셀 데이터 셋팅 , 테이블뷰에서 호출

-(IBAction)onBtnContents:(id)sender;                                                //탭 버튼클릭 이벤트

@end
