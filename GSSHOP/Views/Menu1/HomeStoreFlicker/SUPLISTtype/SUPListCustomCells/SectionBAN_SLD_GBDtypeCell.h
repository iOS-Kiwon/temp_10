//
//  SectionBAN_SLD_GBDtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 22..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface SectionBAN_SLD_GBDtypeCell : UITableViewCell
@property (nonatomic, weak) id target;
- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic;
@end

