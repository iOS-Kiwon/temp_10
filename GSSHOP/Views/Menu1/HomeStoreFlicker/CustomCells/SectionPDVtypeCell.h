//
//  SectionPDVtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장
//  백화점 매장 특가상품 , 기본적으로는 2개이지만 무한대로 대응 가능하도록 SectionPDVtypeSubLeft,SectionPDVtypeSubRight 로 처리

#import <UIKit/UIKit.h>

#define kPDVWidthLimit 375.0

@interface SectionPDVtypeCell : UITableViewCell

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;                 //이미지 통신 오퍼레이션
@property (nonatomic, weak) id target;                                                      //클릭시 이벤트를 보낼 타겟
@property (nonatomic,strong) IBOutlet UIView *viewDefault;                                  //셀 베이스뷰
@property (nonatomic,strong) IBOutlet UIView *viewImgTitle;                                 //상단 이미지 타이틀이 들어갈 뷰
@property (nonatomic,strong) IBOutlet UIView *viewProductAll;                               //상품 과 라인을 담을 뷰 , 가변적임
@property (nonatomic,strong) IBOutlet UIView *viewProductHolder;                            //실제 모든 상품이 들어갈 뷰 , 가변적임
@property (nonatomic,strong) IBOutlet UIImageView *imgTitle;                                //상단 타이틀 이미지 뷰

@property (nonatomic, strong) NSArray *row_arr;                                             //상품 정모들이 모인 배열

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;                                       //셀 데이터 셋팅 , 테이블뷰에서 호출

-(IBAction)onBtnBrandBanner:(NSDictionary *)dicSend andIndex:(NSInteger)index;              //상품 정보 클릭 하위 상품 셀들이 호출함

@end
