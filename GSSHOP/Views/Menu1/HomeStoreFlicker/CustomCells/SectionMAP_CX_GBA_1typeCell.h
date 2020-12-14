//
//  SectionMAP_CX_GBAtypeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 3. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionMAP_CX_GBA_1typeCell : UITableViewCell {
    NSString *zzimAddUrl;
    NSString *zzimDelUrl;
}
@property (nonatomic, weak) id target;                                  //클릭시 이벤트를 보낼 타겟
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UIImageView *zzimImg;
@property (nonatomic, assign) NSInteger idxRow;
@property (weak, nonatomic) IBOutlet UIButton *btnZzim;

- (IBAction)zzimAction:(id)sender;
- (void) setCellInfoNDrawData:(NSDictionary*)rowinfoDic;
@end
