//
//  SCH_BAN_MUT_SPETypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 24..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCH_BAN_MUT_SPETypeCell : UITableViewCell {
    NSDictionary *celldic;
    
}
@property (nonatomic, weak) id target;

@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
- (IBAction)bannerClick:(id)sender;
- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
