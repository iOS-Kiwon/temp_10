//
//  SectionBTS2typeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  지금BEST 매장에서 도입
//  타이틀과 시간을 노출하려고 제작되었으나 시간값은 안들어옴..

#import <UIKit/UIKit.h>
#import "Common_Util.h"

@interface SectionBTS2typeCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;           //타이틀
@property (nonatomic, strong) IBOutlet UILabel *lblTime;            //시간

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

@end

