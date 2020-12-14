//
//  SectionBAN_SLD_GBDtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 22..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_SLD_GBDtypeCell.h"
#import "SUPListTableViewController.h"

@interface SectionBAN_SLD_GBDtypeCell ()
@property (nonatomic, strong) NSMutableArray *arrSubProductList;
@property (nonatomic, strong) IBOutlet UIView *viewDefault;
@property (nonatomic, strong) IBOutlet iCarousel *carouselMainBanner;
@property (nonatomic, strong) IBOutlet UIView *viewPager;
@property (nonatomic, strong) IBOutlet UILabel *lblCurrentPage;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalPage;
@property (nonatomic, strong) IBOutlet UIButton *btnAutoScroll;
@property (nonatomic, assign) BOOL isOnlyTwoItem;
@property (nonatomic, assign) NSTimeInterval autoRollingValue;
@property (nonatomic, strong) NSTimer *timerScroll;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lcontPagerWidth;
@end



@implementation SectionBAN_SLD_GBDtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.arrSubProductList = [[NSMutableArray alloc] init];
    
    self.carouselMainBanner.type = iCarouselTypeLinear;
    self.carouselMainBanner.decelerationRate = 0.40f;
    self.carouselMainBanner.isAccessibilityElement = NO;
    
    self.viewPager.layer.cornerRadius = 11.5;
    self.viewPager.layer.shouldRasterize = YES;
    self.viewPager.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAutoScroll) name:BAN_SLD_GBD_CHECK object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.lblCurrentPage.text = @"";
    self.lblTotalPage.text = @"";
    self.btnAutoScroll.selected = NO;
    [self.carouselMainBanner scrollToItemAtIndex:0 animated:NO];
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic{
    NSLog(@"");
    if (NCO(rowInfoDic) && NCA([rowInfoDic objectForKey:@"subProductList"])) {
        
        [self.arrSubProductList removeAllObjects];
        
        if ([(NSArray *)[rowInfoDic objectForKey:@"subProductList"] count] == 2) {
            self.isOnlyTwoItem = YES;
            [self.arrSubProductList addObjectsFromArray:[rowInfoDic objectForKey:@"subProductList"]];
            [self.arrSubProductList addObjectsFromArray:[rowInfoDic objectForKey:@"subProductList"]];
        }
        else {
            self.isOnlyTwoItem = NO;
            [self.arrSubProductList addObjectsFromArray:[rowInfoDic objectForKey:@"subProductList"]];
        }
        
        /*
        self.isOnlyTwoItem = YES;
        [self.arrSubProductList removeAllObjects];
        [self.arrSubProductList addObject:[[rowInfoDic objectForKey:@"subProductList"] objectAtIndex:0]];
        [self.arrSubProductList addObject:[[rowInfoDic objectForKey:@"subProductList"] objectAtIndex:1]];
        [self.arrSubProductList addObject:[[rowInfoDic objectForKey:@"subProductList"] objectAtIndex:0]];
        [self.arrSubProductList addObject:[[rowInfoDic objectForKey:@"subProductList"] objectAtIndex:1]];
        */
        
        if ([self.arrSubProductList count] >= 10) {
            self.lcontPagerWidth.constant = 68.0 + 12.0;
        }else{
            self.lcontPagerWidth.constant = 68.0;
        }
        
        self.lblCurrentPage.text = @"1";
        
        if (self.isOnlyTwoItem) {
            self.lblTotalPage.text = @"/ 2";
        }else{
            self.lblTotalPage.text = [NSString stringWithFormat:@"/ %ld",(long)self.arrSubProductList.count];
        }
        
        
        [self.viewPager layoutIfNeeded];
    
        
        [self.carouselMainBanner reloadData];
    }
    
    self.autoRollingValue = 3.0;//[NCS([rowinfoDic objectForKey:@"rollingDelay"]) floatValue];
    
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
    
    [self.viewDefault layoutIfNeeded];
}

-(IBAction)onBtnPrevNext:(id)sender{
    NSLog(@"");
    
    [self stopTimer];
    
    if ([((UIButton *)sender) tag] == 11) {
        NSInteger idxPrev = self.carouselMainBanner.currentItemIndex - 1;;
        if (idxPrev < 0 ) {
            idxPrev = [self.arrSubProductList count] - 1;
        }
        [self.carouselMainBanner scrollToItemAtIndex:idxPrev animated:YES];
    }else{
        NSInteger idxNext = self.carouselMainBanner.currentItemIndex + 1;
        if (idxNext > [self.arrSubProductList count] - 1 ) {
            idxNext = 0;
        }
        [self.carouselMainBanner scrollToItemAtIndex:idxNext animated:YES];
        
    }
    
}

-(IBAction)onBtnShowALL:(id)sender{
    if ([self.target respondsToSelector:@selector(onBtnSLD_GBD_ShowAll:)]) {
        
//        if (self.btnAutoScroll.selected == NO) {
//            self.btnAutoScroll.selected = YES;
//            [self stopTimer];
//        }
        
        if (self.isOnlyTwoItem == YES) {
            NSMutableArray *arrShowAll = [[NSMutableArray alloc] init];
            [arrShowAll addObjectsFromArray:self.arrSubProductList];
            [arrShowAll removeLastObject];
            [arrShowAll removeLastObject];
            
            [self.target onBtnSLD_GBD_ShowAll:arrShowAll];
        }else{
            [self.target onBtnSLD_GBD_ShowAll:self.arrSubProductList];
        }
        
        
    }
}

-(IBAction)onBtnPauseAndPlay:(id)sender{
    UIButton *btnPlay = (UIButton *)sender;
    btnPlay.selected = !btnPlay.selected;
    
    if (btnPlay.selected == YES) {
        [self stopTimer];
        self.btnAutoScroll.accessibilityLabel = @"자동스크롤 실행";
    }else{
        [self autoScrollCarousel];
        self.btnAutoScroll.accessibilityLabel = @"자동스크롤 정지";
    }
    
}

-(void)stopTimer{
    if ([self.timerScroll isValid]) {
        [self.timerScroll invalidate];
        self.timerScroll = nil;
    }
}

-(void)checkAutoScroll{
    if (self.btnAutoScroll.selected == NO) {
        [self autoScrollCarousel];
    }
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.arrSubProductList count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    UIImageView *imgBanner;
    
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, ceil((187.0/375.0) * APPFULLWIDTH))];
        view.backgroundColor = [UIColor clearColor];
        imgBanner = [[UIImageView alloc] initWithFrame:view.frame];
        imgBanner.tag = 99;
        imgBanner.clipsToBounds = YES;
        [view addSubview:imgBanner];
    }
    else {
        imgBanner = (UIImageView *)[view viewWithTag:99];
    }

    NSDictionary *dicRowInfo = [self.arrSubProductList objectAtIndex:index];
    NSString *imageURL = NCS([dicRowInfo objectForKey:@"imageUrl"]);
    view.isAccessibilityElement = YES;
    view.accessibilityLabel = NCS([dicRowInfo objectForKey:@"productName"]);
    
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if(error == nil && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isInCache) {
                    //imgBanner.image = fetchedImage;
                    imgBanner.image = [fetchedImage aspectFillToSize:CGSizeMake(imgBanner.frame.size.width, imgBanner.frame.size.height)];
                }
                else {
                    imgBanner.alpha = 0;
                    imgBanner.image = [fetchedImage aspectFillToSize:CGSizeMake(imgBanner.frame.size.width, imgBanner.frame.size.height)];
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         imgBanner.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }
                     ];
                }
            });
        }
    }];
    
    return view;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return 3;
            //return [self.row_arr count];
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    if (self.isOnlyTwoItem && carousel.currentItemIndex > 1) {
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex-1];
    }
    else {
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex+1];
    }
}


-(void)carouselDidScroll:(iCarousel *)carousel {
    if (self.btnAutoScroll.selected == NO) {
        [self autoScrollCarousel];
    }
}


-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    [self stopTimer];
    
    NSString *strLink = NCS([[self.arrSubProductList objectAtIndex:index] objectForKey:@"linkUrl"]);
    if ([self.target respondsToSelector:@selector(onBtnSUPCellJustLinkStr:)] && [strLink length] > 0) {
        [self.target onBtnSUPCellJustLinkStr:strLink];
    }
}


-(void)runMethod {
    if(self.carouselMainBanner.currentItemIndex + 1 == [self.arrSubProductList count]) {
        [self.carouselMainBanner scrollToItemAtIndex:0 animated:YES];
    }
    else {
        [self.carouselMainBanner scrollToItemAtIndex:self.carouselMainBanner.currentItemIndex+1 animated:YES];
    }
}


-(void)autoScrollCarousel {
    [self stopTimer];
    
    if (self.autoRollingValue > 0) {
        self.timerScroll = [NSTimer scheduledTimerWithTimeInterval:self.autoRollingValue target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    }
}
@end
