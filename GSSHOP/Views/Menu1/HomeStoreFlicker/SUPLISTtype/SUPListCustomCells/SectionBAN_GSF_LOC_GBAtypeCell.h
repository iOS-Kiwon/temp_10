//
//  SectionBAN_GSF_LOC_GBAtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 22..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_GSF_LOC_GBAtypeCell : UITableViewCell

@property (nonatomic, weak) id target;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lcontAddressWidth;

- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic;
@end
