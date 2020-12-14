//
//  SectionBCCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 18..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//
 

#import <UIKit/UIKit.h>

@interface SectionBCCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;

@property (nonatomic, strong) NSString* loadingImageURLString;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
