//
//  SectionNODATAtypeCell.h
//  GSSHOP
//  BAN_TXT_NODATA 실제 뷰타입은 이거다.
//  Created by admin on 2018. 4. 16..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionNODATAtypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infomationLabel;
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터

- (void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic;

@end
