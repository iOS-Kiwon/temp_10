//
//  SectionPIypeCell.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 7..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//
 
#import <UIKit/UIKit.h>

@interface SectionPItypeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;


@property (nonatomic, strong) NSString* loadingImageURLString;
//@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
