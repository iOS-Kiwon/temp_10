//
//  SectionDSTypeCell.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 3. 13..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionDStypeCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *thumbnailImage;


@property (nonatomic, retain) NSString* loadingImageURLString;
//@property (nonatomic, retain) MochaNetworkOperation* imageLoadingOperation;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
