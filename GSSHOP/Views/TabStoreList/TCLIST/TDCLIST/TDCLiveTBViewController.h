//
//  TDCLiveTBViewController.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//
 

#import <UIKit/UIKit.h>

#import "SectionTBViewController.h"
#import "iScroll.h"
#import "FXImageView.h"



@interface TDCLiveTBViewController : SectionTBViewController {
    
    int tableheadertvlivebannerListheight;
    int tableheaderTVCDICBANNERheight;
    
    NSMutableArray *datatvCategoryarr;
    NSTimer *timer;
    BOOL isTimer;
}


@property (strong, nonatomic) NSArray *arrTvLiveBannerList;


 
//- (BOOL)isExsitTDCBanner;
//-(UIView*)tdcBannerview;
//- (void)tdcBannerCellPress;
- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo;
//- (void) drawliveBroadlefttime;
//- (void)refreshCheckNDrawTVC;

UIImage* ImageMasked(UIImage* image, UIImage* maskImage);

-(void)homeSectionReloadTDCView;
-(void)tableHeaderChangeSize:(CGSize)sizeChange;

-(void)touchEventDualPlayerJustLinkStr:(NSString *)strLink;
@end
