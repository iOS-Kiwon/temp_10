//
//  HorizontalProductTBCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 19..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface HorizontalProductTBCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_horizontalTableView;
    NSArray *_articles;
    NSDictionary *_momdic;
    
}
@property (nonatomic, weak) id targettb;
@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *articles;
@property (nonatomic, retain) NSDictionary *momdic;

@property (nonatomic, strong)  UILabel *momtitleLabel;
@property (nonatomic, strong)  UIImageView *momthumbnail;


@property (nonatomic, strong) NSString* loadingImageURLString;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;


- (id)initWithFrame:(CGRect)frame withMomDic:(NSDictionary*)dic;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
@end
