//
//  SectionDefaultCell.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 3..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionDefaultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;

@property (nonatomic, strong) NSString* loadingImageURLString;
//@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
-(void) setCellInfoNDrawData:(NSDictionary*) thisFlickrImage;
@end
