//
//  SectionB_CMtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 11. 23..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionB_CMtypeCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblCate;
@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) IBOutlet UIView *viewDefault;

//셀 데이터 셋팅 , 테이블뷰에서 호출
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
- (IBAction)onClick:(id)sender;

@end
