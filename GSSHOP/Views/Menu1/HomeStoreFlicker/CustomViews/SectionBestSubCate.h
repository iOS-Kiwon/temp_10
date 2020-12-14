//
//  SectionBestSubCate.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 11. 23..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SectionBestSubCate : UIView <iCarouselDataSource, iCarouselDelegate>{
    NSMutableArray *arrSubCateInfo;
}

@property (nonatomic, weak) id target;
@property (nonatomic, strong) IBOutlet iCarousel *carouselSubCate;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constViewOrigin;
@property (nonatomic, strong) IBOutlet UIView *viewBg;

@property (nonatomic, assign) NSInteger indexSeletedSub;


//셀 데이터 셋팅 , 테이블뷰에서 호출
-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index andSeletedSubIndex:(NSInteger)indexSub;
-(IBAction)onBtnCate:(id)sender;

-(void)bestSubCateShow:(BOOL)isShow andCateHeaderShow:(BOOL)isHeaderShow;

@end