//
//  SectionBAN_IMG_C3_GBATypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 4. 26..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_IMG_C3_GBATypeCell : UITableViewCell
@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;                    //셀 베이스뷰

@property (nonatomic, strong) IBOutlet UIView *viewBanner01;                    //랜덤배너를 포함할 뷰 01
@property (nonatomic, strong) IBOutlet UIView *viewBanner02;                    //랜덤배너를 포함할 뷰 02
@property (nonatomic, strong) IBOutlet UIView *viewBanner03;                    //랜덤배너를 포함할 뷰 03

@property (nonatomic, strong) IBOutlet UIImageView *imgBanner01;                //랜덤배너 이미지 01
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner02;                //랜덤배너 이미지 02
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner03;                //랜덤배너 이미지 03

@property (nonatomic, strong) IBOutlet UILabel *lblBanner01;                    //랜덤배너 타이틀 01
@property (nonatomic, strong) IBOutlet UILabel *lblBanner02;                    //랜덤배너 타이틀 02
@property (nonatomic, strong) IBOutlet UILabel *lblBanner03;                    //랜덤배너 타이틀 03

@property (nonatomic, strong) IBOutlet UIButton *btnBanner01;                    //랜덤배너 버튼 01
@property (nonatomic, strong) IBOutlet UIButton *btnBanner02;                    //랜덤배너 버튼 02
@property (nonatomic, strong) IBOutlet UIButton *btnBanner03;                    //랜덤배너 버튼 03


@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 구성 데이터

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;                       //타이틀 라벨
@property (nonatomic, strong) IBOutlet UIImageView *imgTitleIcon;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                        //셀 데이터 셋팅 , 테이블뷰에서 호출
-(IBAction)onBtnBanner:(id)sender;                                              //배너 버튼 클릭시 이벤트
@end
