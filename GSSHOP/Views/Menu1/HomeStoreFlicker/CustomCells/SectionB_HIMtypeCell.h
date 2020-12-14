//
//  SectionB_HIMtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 23..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 탭에서만 사용
//  TV쇼핑 혜택 ,이미지 배너 2~3 장 노출

#define HeightB_HIMHBanner (APPFULLWIDTH / (320.0/38.0))
#define HeightB_HIM 179.0
#define HeightB_HIM_TOP 46.0
#import <UIKit/UIKit.h>
@interface SectionB_HIMtypeCell : UITableViewCell {
    CGFloat yPosHBanner;                            // 가로배너들의 시작점
}
@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIView *view_Default;                    //셀 베이스뷰
@property (nonatomic, strong) IBOutlet UIView *viewBanner01;                    //랜덤배너를 포함할 뷰 01
@property (nonatomic, strong) IBOutlet UIView *viewBanner02;                    //랜덤배너를 포함할 뷰 02
@property (nonatomic, strong) IBOutlet UIView *viewBanner03;                    //랜덤배너를 포함할 뷰 03
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner01;                //랜덤배너를 이미지 01
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner02;                //랜덤배너를 이미지 02
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner03;                //랜덤배너를 이미지 03
@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;                  //하단 라인
@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 구성 데이터
@property (nonatomic, strong) NSString* loadingImageURLString;                  //이미지 주소
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;                       //타이틀 라벨
@property (nonatomic, strong) IBOutlet UIImageView *imgTitleIcon;
@property (nonatomic, strong) IBOutlet UIView *viewHBanners;                    //세로배너뷰
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                       //셀 데이터 셋팅 , 테이블뷰에서 호출
- (IBAction)onBtnBanner:(id)sender;                                             //배너 버튼 클릭시 이벤트

@end
