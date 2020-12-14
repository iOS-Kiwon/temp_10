//
//  SCH_PRO_TXT_DATETypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCH_PRO_TXT_DATETypeCell : UITableViewCell
{
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIView *viewTextBG;

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

@end
