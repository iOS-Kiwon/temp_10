//
//  RCMDCELL.h
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 6..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

@interface RCMDCELL  : UITableViewCell
{
}


@property (nonatomic, strong)  UIImageView *thumbnail;
@property (nonatomic, strong)  UILabel *titleLabel;

@property (nonatomic, strong)  UILabel *priceLabel;

@property (nonatomic, strong)  UILabel *wonLabel;

@property (nonatomic, strong) NSString* loadingImageURLString;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
