//
//  SectionBAN_IMG_H000_GBAtypeCell.h
//  GSSHOP
//
//  Created by admin on 2017. 10. 17..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCSP_LOGIN_BAN_IMG_GBAtypeCell : UITableViewCell {
     BOOL apiUseYN;
}

@property (nonatomic, strong) IBOutlet UIImageView *imgBanner;
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터
@property (weak, nonatomic) MochaNetworkOperation *currentOperation1;
@property (nonatomic, weak) id targetTableView;
@property (nonatomic, assign) NSInteger idxRow;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lconstHeight;

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
- (void) callApisetCellInfoDrawData:(NSDictionary*) rowinfoDic;
- (IBAction)btnClick:(id)sender;

@end
