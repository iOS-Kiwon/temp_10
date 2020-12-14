//
//  AppPushNoneImgCellTableViewCell.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 10. 20..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppPushImgCellTableViewCell : UITableViewCell {
    BOOL                                isRead;
    
    IBOutlet UILabel *lblMap1;
    IBOutlet UILabel *lblMap2;
    IBOutlet UILabel *lblDate;
}


@property (nonatomic,strong) IBOutlet UIImageView *imagebannerView;

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *indicatorImage;

- (void)setData:(NSDictionary *)argData;
@end
