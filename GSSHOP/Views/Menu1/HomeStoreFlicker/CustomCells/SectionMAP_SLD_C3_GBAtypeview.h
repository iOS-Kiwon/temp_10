//
//  SectionMAP_SLD_C3_GBAtypeview.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 9..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionMAP_SLD_C3_GBAtypeSubview.h"

@interface SectionMAP_SLD_C3_GBAtypeview : UIView

@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic, weak) id target;
@property (nonatomic,strong) IBOutlet UIImageView *bImage;                      // 메인 이미지
@property (nonatomic,strong) IBOutlet UIView *viewThreeDeal;                    // 상품 3개 뷰
@property (nonatomic, strong) SectionMAP_SLD_C3_GBAtypeSubview *sub1;
@property (nonatomic, strong) SectionMAP_SLD_C3_GBAtypeSubview *sub2;
@property (nonatomic, strong) SectionMAP_SLD_C3_GBAtypeSubview *sub3;
@property (nonatomic, strong) NSArray<SectionMAP_SLD_C3_GBAtypeSubview*> *subArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeDealViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeDealViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bImageHeigth;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
-(IBAction) topBannerButtonClicked:(id)sender;                                   //배너 버튼 클릭
-(void) dealButtonClicked:(id)sender;                                            //상품 버튼 클릭
-(void) prepareForReuse;

@end
