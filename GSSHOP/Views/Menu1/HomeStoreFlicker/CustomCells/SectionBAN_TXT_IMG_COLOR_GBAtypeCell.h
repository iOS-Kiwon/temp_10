//
//  SectionBAN_TXT_IMG_COLOR_GBAtypeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 4. 24..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_TXT_IMG_COLOR_GBAtypeCell : UITableViewCell {
    BOOL apiUseYN;
}
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터
@property (weak, nonatomic) NSURLSessionDataTask *currentOperation1;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (nonatomic, weak) id targetTableView;
@property (nonatomic, assign) NSInteger idxRow;
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;
- (void) callApisetCellInfoDrawData:(NSDictionary*) rowinfoDic;
- (IBAction)onClickLink:(id)sender;
@end

