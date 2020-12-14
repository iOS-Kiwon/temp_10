//
//  SectionBAN_MUT_H55_GBAtypeCell.h
//  GSSHOP
//
//  Created by admin on 2017. 8. 10..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_MUT_H55_GBAtypeCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblTitle;                //타이틀라벨
@property (nonatomic,strong) IBOutlet UIImageView *imgArrow;                //링크 화살표

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
@end
