//
//  TVSCDHeaderView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 13..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "TVSCDHeaderView.h"
#import "AppDelegate.h"


@interface TVSCDHeaderView () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation TVSCDHeaderView

@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  aniarrow, target;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe {
    self = [super init];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TVSCDHeaderView" owner:self options:nil];
        self = [nibs objectAtIndex:0];
        target = sender;
        self.frame = tframe;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
}


-(void) setCellInfoNDrawData:(NSArray*) rowinfoArr  withMode:(NSNumber*)intnype {
    isthisMYSHOP = intnype;
    self.row_arr =  rowinfoArr;
    if([self.subviews count] < 1) {
        self.row_arr =  rowinfoArr;
        [self  addSubview:[self scrollcontainView]];
    }
}


- (UIView*)scrollcontainView {
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, 208 + BENEFITTAG_HEIGTH)];
    {
        iScroll *pageView = [[iScroll alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH,  208 + BENEFITTAG_HEIGTH)];
        pageView.backgroundColor = [UIColor clearColor];
        pageView.dataSource = self;
        pageView.delegate = self;
        pageView.type = iScrollTypeTVSectionStyle;
        [crcontainview addSubview:pageView];
    }
    return crcontainview;
}


#pragma mark iCarousel methods

- (void)bannerButtonClicked:(id)sender {
    if([((UIButton *)sender) tag]== 10000) {
        [target btntouchWithLinkStrBD:sender];
    }
    else {
        
        if(NCA(self.row_arr)) {
            [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType: ([isthisMYSHOP intValue] == 2)?@"DataBroad":@"LiveBroad" ];
        }
        else {
            
        }
    }
}



#pragma mark -
#pragma mark iScroll methods

- (NSUInteger)numberOfItemsInCarousel:(iScroll *)carousel {
    return [self.row_arr count];
}


- (UIView *)carousel:(iScroll *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UIView *containerView =nil;
    if(index == [self.row_arr  count]-1) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 348  , carousel.frame.size.height)];
    }
    else {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TVSectionStyleHight   , carousel.frame.size.height)];
    }
    
    TVSCDHeaderCellView* tdview = [[TVSCDHeaderCellView alloc] initWithTarget:self Nframe:CGRectMake(10, 0, 258,  208 + BENEFITTAG_HEIGTH)];
    [containerView addSubview:tdview];
    [tdview setCellInfoNDrawData:[self.row_arr objectAtIndex:index ]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = tdview.bounds;
    [button addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    [containerView addSubview:button];
    
    if(index == [self.row_arr  count]-1) {
        
        aniarrow = [[UIImageView alloc] initWithFrame:CGRectMake( 294, 70 + 13, 25, 25)];
        
        aniarrow.image = [UIImage imageNamed:@"tvshop_arrowr.png"];
        [containerView addSubview:aniarrow];
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake( 282, 96 + 13, 50, 25)];
        lblTitle.textColor = [Mocha_Util getColor:@"a3a3a3"];
        lblTitle.font = [UIFont systemFontOfSize:14.0];
        lblTitle.text = GSSLocalizedString(@"section_customview_tvscdheader_schedule");
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.adjustsFontSizeToFitWidth = YES;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:lblTitle];
        UILabel* llblTitle = [[UILabel alloc] initWithFrame:CGRectMake( 282, 112 + 13, 50, 25)];
        llblTitle.textColor = [Mocha_Util getColor:@"a3a3a3"];
        llblTitle.font = [UIFont systemFontOfSize:14.0];
        llblTitle.text = GSSLocalizedString(@"section_customview_tvscdheader_see");
        llblTitle.backgroundColor = [UIColor clearColor];
        llblTitle.adjustsFontSizeToFitWidth = YES;
        llblTitle.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:llblTitle];
        UIButton *tbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        tbutton.frame = CGRectMake( 270, 0, 100, carousel.frame.size.height);
        tbutton.backgroundColor = [UIColor clearColor];
        tbutton.alpha = 0.7f;
        [tbutton addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        tbutton.tag = 10000;
        
        [containerView addSubview:tbutton];
    }
    return containerView;
}


//클릭
- (void)carousel:(iScroll *)carousel didSelectItemAtIndex:(NSInteger)index {
    
}


- (void)carouselCurrentItemIndexUpdated:(iScroll *)carousel {
    
    
}


// add by shawn
- (void)carouselMenuItemOffsetDidChange:(UIScrollView *)scrollView {
    return;
}



- (void)carouselMenuItemOffsetDidChangeforEvent:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x >  ([self.row_arr count] * TVSectionStyleHight -APPFULLWIDTH + 160)) {
        UIButton* tgbtn = [[UIButton alloc] init];
        tgbtn.tag = 10000;
        [target btntouchWithLinkStrBD:tgbtn];
        aniarrow.frame = CGRectMake( 294 , aniarrow.frame.origin.y, aniarrow.frame.size.width, aniarrow.frame.size.height);
    }
}


@end
