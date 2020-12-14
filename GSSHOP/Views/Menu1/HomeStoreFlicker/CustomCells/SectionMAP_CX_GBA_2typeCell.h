//
//  SectionMAP_CX_GBA_2typeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 3. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionMAP_SLD_C3_GBAtypeSubview.h"

@interface SectionMAP_CX_GBA_2typeCell : UITableViewCell
@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic,strong) IBOutlet UIView *viewThreeDeal;                    // 상품 3개 뷰
@property (nonatomic, strong) SectionMAP_SLD_C3_GBAtypeSubview *sub1;
@property (nonatomic, strong) SectionMAP_SLD_C3_GBAtypeSubview *sub2;
@property (nonatomic, strong) SectionMAP_SLD_C3_GBAtypeSubview *sub3;
@property (nonatomic, strong) NSArray<SectionMAP_SLD_C3_GBAtypeSubview*> *subArray;

- (void)dealButtonClicked:(id)sender;
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
@end
