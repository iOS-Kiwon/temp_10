//
//  SectionBAN_CX_SLD_CATE_GBASubView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 5. 16..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_CX_SLD_CATE_GBASubView.h"
#import "SectionTBViewController.h"

@interface SectionBAN_CX_SLD_CATE_GBASubView () <iScrollDelegate,iScrollDataSource>
@property (nonatomic, strong) IBOutlet UIView *viewDefault;
@property (nonatomic, strong) IBOutlet UIView *viewHighlightLine;
@property (nonatomic, strong) NSMutableArray *arrCate;
@property (nonatomic, assign) NSInteger idxLastiScrollTab;
@property (nonatomic, strong) NSString *strSectionName;
@end

@implementation SectionBAN_CX_SLD_CATE_GBASubView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = CGRectMake(0.0,0.0, APPFULLWIDTH, SECTIONCX_SLDVIEWHEIGHT);
    
    self.arrCate = [[NSMutableArray alloc] init];

    self.iScrollCate = [[iScroll alloc] initWithFrame:CGRectMake(0.0,0.0, APPFULLWIDTH, SECTIONCX_SLDVIEWHEIGHT)];
    self.iScrollCate.backgroundColor = [UIColor clearColor];
    self.iScrollCate.dataSource = self;
    self.iScrollCate.delegate = self;
    self.iScrollCate.type = iScrollTypeLinear;
    self.iScrollCate.decelerationRate = 0.80f;
    self.iScrollCate.contentScrollView.contentInset = UIEdgeInsetsMake(0, 8.0, 0, 8.0);
    
    [self.viewDefault addSubview:self.iScrollCate];
    
    self.idxLastiScrollTab = -1;
    self.viewHighlightLine = [[UIView alloc] initWithFrame:    CGRectMake(0, SECTIONCX_SLDVIEWHEIGHT - 1.0, 50, 1)];
    self.viewHighlightLine.backgroundColor = [Mocha_Util getColor:@"444444"];
    
}


- (void) setCellInfo:(NSDictionary*)infoDic index:(NSInteger)idxSelected target:(id)targetId sectionName:(NSString *)strSName {
    NSLog(@"infoDic = %@",infoDic);
    NSLog(@"idxSelectedidxSelected = %ld",(long)idxSelected);
    NSArray *arrList = [infoDic objectForKey:@"subProductList"];
    if (NCA(arrList)) {
        [self.arrCate addObjectsFromArray:arrList];
    }
    
    self.target = targetId;
    //2018.08.16 앰플리튜드 narava
    self.strSectionName = NCS(strSName);
    [self.iScrollCate reloadData];
    
    [self subCategoryMoveWithGroupCode];
}

- (void) subCategoryMoveWithGroupCode {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //만약.. groupCd가 존재하면 이동
        if([NCS(ApplicationDelegate.groupCode) length] > 0) {
            NSInteger iPositon = 0;
            for(NSDictionary *dic in self.arrCate) {
                NSString *gc = [[dic objectForKey:@"dealNo"] stringValue];
                if([gc isEqualToString:ApplicationDelegate.groupCode]) {
                    if ([self.target respondsToSelector:@selector(onBtnCX_SLDCate:andCnum:withCallType:)]) {
                        [self.target onBtnCX_SLDCate:dic andCnum:[NSNumber numberWithInteger:iPositon] withCallType:@""]; //하위 셀 호출
                        [self.iScrollCate setCurrentItemIndex:iPositon];//위치 잡기
                        [ApplicationDelegate setGroupCode:@""];// 그룹코드 초기화
                    }
                    break;
                }
                iPositon++;
            }
            //예외처리- 만약 하위 매장을 못찾았다면? 아무짓도 안함. 즉, 첫번째 하위매장노출 혹은 기존 열려있던 매장 노출
            if([NCS(ApplicationDelegate.groupCode) length] > 0) {
                [ApplicationDelegate setGroupCode:@""];// 그룹코드 초기화
            }
        }
    });
}

#pragma mark -
#pragma mark iScroll methods

- (NSUInteger)numberOfItemsInCarousel:(iScroll *)carousel
{
    //return the total number of items in the carousel
    return  [self.arrCate count];
}

- (UIView *)carousel:(iScroll *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    if (view == nil)
    {
        
        UILabel *label = nil;
        
        //NSDictionary *dicRow = [self.arrCate objectAtIndex:index];
        NSString *strText = NCS([[self.arrCate objectAtIndex:index] objectForKey:@"productName"]);
        
        NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
        //CGSize textSize =  [NCS([dicRow objectForKey:@"sectionName"])   sizeWithAttributes:fontWithAttributes];
        CGSize textSize =  [NCS(strText)   sizeWithAttributes:fontWithAttributes];
        
        NSInteger widthMenuMax = 0;
        
        if(textSize.width > 0)
            widthMenuMax = textSize.width + 25;
        else
            widthMenuMax = 0;
        
        
        //UI
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthMenuMax, SECTIONCX_SLDVIEWHEIGHT)];
        view.backgroundColor = [UIColor clearColor];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0 ,   0, widthMenuMax, SECTIONCX_SLDVIEWHEIGHT - 1.0)];
        label.backgroundColor = [UIColor clearColor];
        
        label.textAlignment =  NSTextAlignmentCenter;
        label.textColor = [Mocha_Util getColor:@"111111"];
        label.font = [UIFont systemFontOfSize:16];
        label.accessibilityLabel = strText;
        label.accessibilityTraits = UIAccessibilityTraitButton;
        
        //title 키 수정
        //label.text = NCS([dicRow objectForKey:@"sectionName"]);
        label.text = NCS(strText);
        label.minimumScaleFactor = 0.5f;
        label.adjustsFontSizeToFitWidth = YES;
        label.tag = 9998;
        [view addSubview:label];
        
        
    }
    
    return view;
    
}

- (CGFloat)carousel:(iScroll *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    switch (option)
    {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return [self.arrCate count];
        default:
            return value;
    }
    
    
}

- (CGFloat)getSLD_CATE_YPostion{
    return self.iScrollCate.contentScrollView.contentOffset.x;
}

//클릭
- (void)carousel:(iScroll *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"");
    //416049-카테고리 노출 인덱스(1부터 시작)
    NSString *strCommonClick = [NSString stringWithFormat:@"?mseq=416049-%ld",(long)index+1];
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strCommonClick)];
    
    NSDictionary *dicRow = [self.arrCate objectAtIndex:index];
    if ([self.target respondsToSelector:@selector(onBtnCX_SLDCate:andCnum:withCallType:)]) {
        [self.target onBtnCX_SLDCate:dicRow andCnum:[NSNumber numberWithInteger:index] withCallType:@""];
    }
    
    NSLog(@"dicRowdicRow = %@",dicRow);
   
}
- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel {
    
    //2018.08.16 앰플리튜드 narava
    NSString *eventString = [NSString stringWithFormat:@"View-메인매장-%@",NCS(self.strSectionName)];
    NSDictionary *dicRow = [self.arrCate objectAtIndex:carousel.currentItemIndex];
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:NCS([dicRow objectForKey:@"productName"]),@"cateName", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:eventString properties:dicProp];
    
    // 2020. 07.03 kiwon: GS X 브랜드 관심브랜드인 경우 추가 wiseLog전송
    NSString * prdId = [NSString stringWithFormat:@"%@", [dicRow  objectForKey:@"prdid"]];
    if ([prdId isEqualToString:@"419124"]) {
        // 관심 브랜드 인 경우
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=419124")];
    }
}


//하단 컨텐츠 섹션 이동시 상단 메뉴 x offset 실시간 교정을 위한
-(void)carouselMenuItemOffsetDidChange:(UIScrollView *)scrollView
{
    
}

-(void)carouselCurrentItemIndexDidChange:(iScroll *)carousel{
    
    if ([self.viewHighlightLine superview] == nil) {
        [self.iScrollCate.contentScrollView addSubview:self.viewHighlightLine];
        [self.iScrollCate.contentScrollView bringSubviewToFront:self.viewHighlightLine];
    }
    
    NSArray* drr = [carousel visibleItemViews];
    
    for (UIView *eachview in drr) {
        ((UILabel*)([eachview viewWithTag:9998])).textColor = [Mocha_Util getColor:@"878787"];
        ((UILabel*)([eachview viewWithTag:9998])).font = [UIFont systemFontOfSize:16];
    }
    
    UILabel *lblCurrent = (UILabel*)([[carousel itemViewAtIndex:carousel.currentItemIndex ] viewWithTag:9998]);
    
    if(self.idxLastiScrollTab == -1){
        self.viewHighlightLine.frame = CGRectMake(([carousel itemViewAtIndex:carousel.currentItemIndex ] ).frame.origin.x + 12, SECTIONCX_SLDVIEWHEIGHT - 1.0, lblCurrent.frame.size.width - 24.0, 1);
        
        self.idxLastiScrollTab =  0;
        lblCurrent.font = [UIFont boldSystemFontOfSize:16];
        lblCurrent.textColor = [Mocha_Util getColor:@"111111"];
        NSLog(@"self.viewHighlightLine.frame = %@",NSStringFromCGRect(self.viewHighlightLine.frame));
        NSLog(@"self.viewHighlightLine = %@",self.viewHighlightLine);
        NSLog(@"self.viewHighlightLine super = %@",[self.viewHighlightLine superview]);
        
    }else if(self.idxLastiScrollTab == [drr count]-1 && (unsigned int)carousel.currentItemIndex == 0) {
        self.viewHighlightLine.frame = CGRectMake(([carousel itemViewAtIndex:carousel.currentItemIndex ] ).frame.origin.x + 12, SECTIONCX_SLDVIEWHEIGHT - 1.0, lblCurrent.frame.size.width - 24.0, 1);
        
        self.idxLastiScrollTab =  (unsigned int)carousel.currentItemIndex  ;
        lblCurrent.font = [UIFont boldSystemFontOfSize:16];
        lblCurrent.textColor = [Mocha_Util getColor:@"111111"];
        NSLog(@"self.viewHighlightLine.frame = %@",NSStringFromCGRect(self.viewHighlightLine.frame));
        
    }else if( (unsigned int)carousel.currentItemIndex  == [drr count]-1 && self.idxLastiScrollTab  == 0) {
        self.viewHighlightLine.frame = CGRectMake(([carousel itemViewAtIndex:carousel.currentItemIndex ] ).frame.origin.x + 12, SECTIONCX_SLDVIEWHEIGHT - 1.0, lblCurrent.frame.size.width - 24.0, 1);
        
        self.idxLastiScrollTab =  (unsigned int)carousel.currentItemIndex  ;
        lblCurrent.font = [UIFont boldSystemFontOfSize:16];
        lblCurrent.textColor = [Mocha_Util getColor:@"111111"];
        NSLog(@"self.viewHighlightLine.frame = %@",NSStringFromCGRect(self.viewHighlightLine.frame));
        
    }else {
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             self.viewHighlightLine.frame = CGRectMake(([carousel itemViewAtIndex:carousel.currentItemIndex ] ).frame.origin.x + 12, SECTIONCX_SLDVIEWHEIGHT - 1.0, lblCurrent.frame.size.width - 24.0, 1);
                         }
                         completion:^(BOOL finished){
                             lblCurrent.font = [UIFont boldSystemFontOfSize:16];
                             lblCurrent.textColor = [Mocha_Util getColor:@"111111"];
                             
                             self.idxLastiScrollTab =  (unsigned int)carousel.currentItemIndex  ;
                             NSLog(@"self.viewHighlightLine.frame = %@",NSStringFromCGRect(self.viewHighlightLine.frame));
                         }];
    }
}

-(void)carouselDidScroll:(iCarousel *)carousel{
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
}



- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    
}



- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    
}
@end
