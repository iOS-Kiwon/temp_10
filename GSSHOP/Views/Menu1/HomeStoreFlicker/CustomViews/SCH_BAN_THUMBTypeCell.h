//
//  SCH_BAN_THUMBTypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 5..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCH_BAN_THUMBTypeCell : UITableViewCell
{
    NSDictionary* celldic;
    NSString* onAirDateTime;
    NSDateFormatter *dateformat;
}

@property (nonatomic, weak) id target;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView *onAirImg;
@property (weak, nonatomic) IBOutlet UILabel *onAirTime;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UIView *onAirLine;
@property (weak, nonatomic) IBOutlet UIView *selectLine;

@property (nonatomic, strong) NSTimer *onAirLeftTimer;                                   //OnAir 타이머
@property (nonatomic, strong) NSString* loadingImageURLString;

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
- (void)setOnAir:(BOOL) isOnair;


@end
