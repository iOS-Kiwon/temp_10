//
//  SectionB_TSCtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장에서 주로 사용
//  배경흰색 볼드 텍스트 타이틀 only 라벨 셀

#import <UIKit/UIKit.h>

@interface SectionB_TSCtypeCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblTitle;                //타이틀라벨

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
@end
