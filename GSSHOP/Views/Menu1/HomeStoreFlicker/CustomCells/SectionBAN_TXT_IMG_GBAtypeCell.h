//
//  SectionBAN_TXT_IMG_GBAtypeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 2. 7..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_TXT_IMG_GBAtypeCell : UITableViewCell
@property (weak, nonatomic) id target;
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adImgHeigth;
@property (strong, nonatomic) NSIndexPath *path;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *countText;

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfo;

@end
