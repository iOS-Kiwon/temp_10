//
//  SectionB_ISStypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 6. 1..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionB_ISStypeCell : UITableViewCell
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner;
@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic, strong) IBOutlet UIButton *cellClick;
@property (nonatomic, strong) NSDictionary *infoDic;

@property (nonatomic, weak) id target;
- (IBAction)onClick:(id)sender;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
@end
