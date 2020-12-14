//
//  SectionB_DHStypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장에서만 사용
//  백화점 매장 최하단 롯데백화점,현대백화점 이미지 2개 배너

#import <UIKit/UIKit.h>

@interface SectionB_DHStypeCell : UITableViewCell

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;         //이미지 통신 오퍼레이션
@property (nonatomic, weak) id target;                                              //클릭시 이벤트를 보낼 타겟
@property (nonatomic,strong) IBOutlet UIView *viewBorderImage01;                    //이미지01 보더뷰
@property (nonatomic,strong) IBOutlet UIImageView *imgProductBG01;                  //이미지01 노이미지 배경 이미지뷰
@property (nonatomic,strong) IBOutlet UIView *viewBorderImage02;                    //이미지01 보더뷰
@property (nonatomic,strong) IBOutlet UIImageView *imgProductBG02;                  //이미지02 노이미지 배경 이미지뷰
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct01;                    //이미지01
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct02;                    //이미지02
@property (nonatomic, strong) NSArray *row_arr;                                     //이미지 정보가 들어가는 배열

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;                               //셀 데이터 셋팅 , 테이블뷰에서 호출
-(IBAction)onBtnBanner:(id)sender;                                                  //배너 클릭시 이벤트

@end
