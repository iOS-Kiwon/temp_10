//
//  SCH_MAP_ONLY_TITLETypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 25..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCH_MAP_ONLY_TITLETypeCell : UITableViewCell{
    
}
@property (nonatomic,weak) IBOutlet UILabel *lblTime;
@property (nonatomic,weak) IBOutlet UILabel *lblTitle;
@property (nonatomic,weak) IBOutlet UIButton *btnLink;
@property (nonatomic,weak) id target;
@property (nonatomic,weak) NSDictionary *dicAll;
@property (nonatomic,weak) IBOutlet UIView *viewWhiteBG;
@property (nonatomic, strong) IBOutlet UIView *viewTopPromotion;

-(IBAction)onBtnLink:(id)sender;
- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
