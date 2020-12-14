//
//  SectionBAN_SLD_GBAtypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 1..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionBAN_SLD_GBABtypeView.h"

@interface SectionBAN_SLD_GBAtypeCell : UITableViewCell
@property (nonatomic, strong) SectionBAN_SLD_GBABtypeView *cell;
@property (nonatomic, weak) id target;

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr index:(NSInteger) position;

@end
