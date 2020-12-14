//
//  SCH_BAN_TXT_TIMETypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 18..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCH_BAN_TXT_TIMETypeCell : UITableViewCell
{
    NSDictionary *celldic;

}
@property (nonatomic, weak) id target;

@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UILabel *infoText1;
@property (weak, nonatomic) IBOutlet UILabel *infoText2;

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;


@end
