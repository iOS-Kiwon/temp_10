//
//  SectionMAP_SLD_C3_GBAtypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 6..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_SLD_C3_GBAtypeCell.h"
#import "SectionTBViewController.h"

@interface SectionMAP_SLD_C3_GBAtypeCell() <iCarouselDataSource, iCarouselDelegate>

@end

@implementation SectionMAP_SLD_C3_GBAtypeCell
@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize target;
@synthesize carouselProduct = _carouselProduct;
@synthesize lblTotalPage = _lblTotalPage;
@synthesize lblCurrentPage = _lblCurrentPage;
@synthesize viewCount = _viewCount;



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.carouselProduct.type = iCarouselTypeLinear;
    self.carouselProduct.decelerationRate = 0.40f;
    if (self.row_arr == nil) {
        self.row_arr = [[NSMutableArray alloc] init];
    }
    
    
    
    
    if(self.viewCount == nil)
    {
        self.viewCount = [[UIView alloc] init];
    }
    if(self.lblTotalPage == nil)
    {
        self.lblTotalPage = [[UILabel alloc] init];
    }
    if(self.lblCurrentPage == nil)
    {
        self.lblCurrentPage = [[UILabel alloc] init];
    }
    if(self.lblBar == nil)
    {
        self.lblBar = [[UILabel alloc] init];
    }

    /*좌우 버튼*/
    // 최상단 1개만...//
    
    
    float btnClickWidth = APPFULLWIDTH / 10;
    
    //단품이동 버튼
    UIImageView* leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 14, 25)];
    leftImageView.center = CGPointMake((leftImageView.frame.size.width/2 + 10), [Common_Util DPRateOriginVAL:180] / 2);
    leftImageView.image = [UIImage imageNamed:@"gbarrow.png"];
    [self addSubview:leftImageView];
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //leftBtn.backgroundColor = [UIColor blueColor];
    [leftBtn setFrame:CGRectMake(0, 0, btnClickWidth, [Common_Util DPRateOriginVAL:218])];
    [leftBtn addTarget:self action:@selector(leftArrow:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    leftImageView.tag = 170201;
    leftBtn.tag = 170202;
    
    
    
    
    //단품이동 버튼
    UIImageView* rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(APPFULLWIDTH - 10 - 14, 0, 14, 25)];
    rightImageView.transform = CGAffineTransformMakeRotation(M_PI); //이미지 재활용.. < 이미지를 돌린다.
    rightImageView.center = CGPointMake(APPFULLWIDTH - (rightImageView.frame.size.width/2) - 10, [Common_Util DPRateOriginVAL:180] / 2);
    rightImageView.image = [UIImage imageNamed:@"gbarrow.png"];
    [self addSubview:rightImageView];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //rightBtn.backgroundColor = [UIColor blueColor];
    [rightBtn setFrame:CGRectMake(APPFULLWIDTH - btnClickWidth, 0, btnClickWidth, [Common_Util DPRateOriginVAL:218])];
    [rightBtn addTarget:self action:@selector(rightArrow:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    
    rightImageView.tag = 270201;
    rightBtn.tag = 270202;
    
    
    self.viewCount.frame = CGRectMake(APPFULLWIDTH - 45 - 10 , 10, 45, 23);
    self.viewCount.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //코너 모서리..
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewCount.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(30, 30)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.viewCount.bounds;
    maskLayer.path = maskPath.CGPath;
    self.viewCount.layer.mask = maskLayer;
    
    float lableMargin = 11;
    float twoDigitsMargin = 0;
    if([self.row_arr count] > 9) // 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
    {
        lableMargin = 3.8;
        twoDigitsMargin = 2.8;
    }
    
    float forWidth = (self.viewCount.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
    
    
    self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewCount.frame.size.height);
    self.lblCurrentPage.font = [UIFont systemFontOfSize:13.0f];
    self.lblCurrentPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
    self.lblCurrentPage.textAlignment = NSTextAlignmentRight;
    self.lblCurrentPage.lineBreakMode = NSLineBreakByClipping;
    
    
    self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewCount.frame.size.height);
    self.lblBar.font = [UIFont systemFontOfSize:13.0f];
    self.lblBar.textColor = [Mocha_Util getColor:@"FFFFFF"];
    self.lblBar.alpha = 0.4f;
    self.lblBar.textAlignment = NSTextAlignmentCenter;
    
    
    self.lblTotalPage.frame = CGRectMake(self.lblBar.frame.origin.x + self.lblBar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewCount.frame.size.height);
    self.lblTotalPage.font = [UIFont systemFontOfSize:13.0f];
    self.lblTotalPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
    self.lblTotalPage.alpha = 0.4f;
    self.lblTotalPage.textAlignment = NSTextAlignmentLeft;
    self.lblTotalPage.lineBreakMode = NSLineBreakByClipping;
    
    [self.viewCount addSubview:self.lblBar];
    [self.viewCount addSubview:self.lblCurrentPage];
    [self.viewCount addSubview:self.lblTotalPage];
    
    [self addSubview:self.viewCount];
    [self bringSubviewToFront:self.viewCount];
    
    self.lblCurrentPage.text = [NSString stringWithFormat:@"1"];//,(int)carousel.currentItemIndex + 1];
    self.lblBar.text = [NSString stringWithFormat:@"/"];
    self.lblTotalPage.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.row_arr count]];

   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    
    self.backgroundColor = [UIColor clearColor];
    [self.row_arr removeAllObjects];
    
    if( NCA([rowinfoArr objectForKey:@"subProductList"]) && [[rowinfoArr objectForKey:@"subProductList"] count] >= 1)
    {
        
        
        // 유효성 검사
        for (NSDictionary* banner in [rowinfoArr objectForKey:@"subProductList"])
        {
            if(![NCS([banner objectForKey:@"imageUrl"]) isEqualToString:@""] && NCA([banner objectForKey:@"subProductList"]) == YES)
            {
                // 둘다 유효한 경우에만 배열에 담는다.
                [self.row_arr addObject:banner];
            }
        }
        [self.carouselProduct reloadData];
        [self.carouselProduct scrollToItemAtIndex:0 animated:NO];
        
        if([self.row_arr count] == 1) //노출된 데이터가 1개면 스크롤 동작안하고 카운트 없애고, 좌우 클릭 버튼 제거
        {
            self.carouselProduct.scrollEnabled = NO;
            
            [self viewWithTag:170201].hidden = YES;
            [self viewWithTag:170202].hidden = YES;
            [self viewWithTag:270201].hidden = YES;
            [self viewWithTag:270202].hidden = YES;
            
            self.viewCount.hidden = YES;
            return;
        }
        
        /*사이즈 조정*/
        float lableMargin = 11;
        float twoDigitsMargin = 0;
        if([self.row_arr count] > 9) // 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
        {
            lableMargin = 3.8;
            twoDigitsMargin = 2.8;
        }
        
        float forWidth = (self.viewCount.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
        
        
        self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewCount.frame.size.height);
        self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewCount.frame.size.height);
        self.lblTotalPage.frame = CGRectMake(self.lblBar.frame.origin.x + self.lblBar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewCount.frame.size.height);
        
        /*사이즈 조정 끝*/
        
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.carouselProduct.currentItemIndex + 1];
        self.lblBar.text = [NSString stringWithFormat:@"/"];
        self.lblTotalPage.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.row_arr count]];

    }
}


-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    if(self.viewCount != nil)
    {
        self.viewCount.hidden = NO;
    }
    
    if(self.lblTotalPage != nil)
    {
        self.lblTotalPage.text = @"";
    }
    if(self.lblCurrentPage != nil)
    {
        self.lblCurrentPage.text = @"";
    }
    
    if([self viewWithTag:170201])
    {
        [self viewWithTag:170201].hidden = NO;
    }
    if([self viewWithTag:170202])
    {
        [self viewWithTag:170202].hidden = NO;
    }
    if([self viewWithTag:270202])
    {
        [self viewWithTag:270201].hidden = NO;
    }
    if([self viewWithTag:270202])
    {
        [self viewWithTag:270202].hidden = NO;
    }

    if(self.carouselProduct != nil)
    {
        self.carouselProduct.scrollEnabled = YES;
        [self.carouselProduct reloadData];
    }
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    SectionMAP_SLD_C3_GBAtypeview *subView = nil;
    
    if (view == nil)
    {
        subView = (SectionMAP_SLD_C3_GBAtypeview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeview" owner:self options:nil] firstObject];
        subView.frame = self.carouselProduct.frame;
        subView.target = self;
    }
    else
    {
        subView = (SectionMAP_SLD_C3_GBAtypeview *)view;
        [subView prepareForReuse];
    }
    
    NSDictionary *dicRow = [self.row_arr objectAtIndex:index];
    
    
    [subView setCellInfoNDrawData:dicRow];
    
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.carouselProduct.frame.size.height, self.carouselProduct.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    [self.carouselProduct.layer addSublayer:bottomBorder];
   

    
    return subView;
    
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionSpacing:
            return value * 1.0;
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return [self.row_arr count];
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex + 1];

}

-(void)carouselDidScroll:(iCarousel *)carousel{
    
}


-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
   // [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:index]  andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"MAP_SLD_C3_GBA"];
}


- (void)dellClick:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr
{
    [self.target dctypetouchEventTBCell:dic  andCnum:cnum withCallType:cstr];
}




- (void)leftArrow:(id)sender
{
    [self.carouselProduct scrollToItemAtIndex:self.carouselProduct.currentItemIndex - 1 animated:YES];
}
- (void)rightArrow:(id)sender
{
    [self.carouselProduct scrollToItemAtIndex:self.carouselProduct.currentItemIndex + 1 animated:YES];
}


@end
