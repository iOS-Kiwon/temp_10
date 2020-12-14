//
//  SectionBAN_TXT_CHK_GBAtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 9. 13..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_TXT_CHK_GBAtypeCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UILabel *lblAll;
@property (nonatomic,strong) IBOutlet UIButton *btnAll;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) id target;
@property (nonatomic,strong) NSMutableDictionary *dicRow;

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoDic andIndex:(NSInteger)indexCell;
@end
