//
//  SCH_BAN_TXT_NEXTTypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCH_BAN_TXT_NEXTTypeCell : UITableViewHeaderFooterView
{
    NSDictionary* infoDic;
}
@property (nonatomic, weak) id target;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlus;
@property (nonatomic, weak) IBOutlet UIView *viewBG;

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;


- (IBAction)onClick:(id)sender;

@end
