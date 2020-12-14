//
//  SectionNTCHeaderBannerCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionNTCHeaderBannerCell : UITableViewCell{
    NSDictionary *dicRow;
}

@property (nonatomic, weak) id target;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner;
@property (nonatomic, strong) IBOutlet UIButton *btnBanner;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;

@end
