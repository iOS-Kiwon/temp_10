//
//  DealCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
 
@interface DealCell : UITableViewCell
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
