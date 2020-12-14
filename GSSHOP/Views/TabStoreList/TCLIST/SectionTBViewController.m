//
//  SectionTBViewController.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 3..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "SectionTBViewController.h"
#import "TableHeaderDCtypeView.h"
#import "TableHeaderEItypeView.h"
#import "HorizontalTableCell.h"
#import "HztbGlobalVariables.h"
#import "SectionTBViewFooter.h"
#import "ViewMotherRequest.h"
//
#import <Apptimize/Apptimize.h>         // nami0342 : Apptimize

static CGFloat const kMDCScrollBarViewControllerDefaultFadeDelay = 0.3f;

@interface SectionTBViewController () {
}
@end


@implementation SectionTBViewController

@synthesize sectionarrdata;
@synthesize sectioninfodata;
@synthesize BottomCellInforow;
@synthesize apiResultDic;
@synthesize sectionType;
@synthesize delegatetarget;
@synthesize imageLoadingOperation;
@synthesize currentOperation1;
@synthesize cubeAnimation = _cubeAnimation;
@synthesize idxCSPbanner;
@synthesize scrollExpandingDelegate;
//@synthesize previewingContext;
@synthesize m_isABTest = _m_isABTest;


- (id)initWithSectionResult:(NSDictionary*)resultDic sectioninfo:(NSDictionary*)secinfo {
    self = [super init];
    if(self) {
        dicNeedsToCellClear = [[NSMutableDictionary alloc] init];
        dicMLCellPlayControl = [[NSMutableDictionary alloc] init];
        self.sectioninfodata = secinfo;
        self.sectionType = [secinfo objectForKey:@"sectionType"];
        self.apiResultDic = resultDic;
        isPagingComm = NO;
        tbviewrowmaxNum = 0;
        _scrollBarFadeDelay = kMDCScrollBarViewControllerDefaultFadeDelay;
        
        self.widthFixed = APPFULLWIDTH;
        // nami0342 - AB Test
        self.m_isABTest = YES;
        
        isCheckPRD_C_SQ = NO;
        
        [self performSelectorInBackground:@selector(getApptimizeABSetting) withObject:nil];
        
    }
    
    return self;
}

- (void) getApptimizeABSetting
{
    // nami0342 - Apptimize AB POC : 가격 노출 형태 변경
    dispatch_async(dispatch_get_main_queue(), ^{
        ApptimizeVariableString *dynamicVariable = [ApptimizeVariable stringWithName:@"PRICE_DISPLAY" andDefaultString:@""];
        ApplicationDelegate.m_strApptimize = [dynamicVariable stringValue];
    });
    
}

- (void)setApiResultDic:(NSDictionary *)resultDic {
    apiResultDic = resultDic;
    isPagingComm = NO;
    tbviewrowmaxNum = 0;
    if(sectionorigindata == nil) {
        sectionorigindata = [[NSMutableArray alloc] init];
    }
    else {
        [sectionorigindata removeAllObjects];
    }
    
    if([NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]) {
        sectionorigindata = [[resultDic objectForKey:@"productList"] mutableCopy];
    }
    else {
        sectionorigindata = [resultDic objectForKey:@"productList"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDEALVIDEOALLKILL object:nil userInfo:nil];
    if(self.sectionarrdata == nil) {
        self.sectionarrdata = [[NSMutableArray alloc] init];
    }
    else {
        [self.sectionarrdata removeAllObjects];
    }
    
    if(self.BottomCellInforow == nil) {
        self.BottomCellInforow = [[NSMutableArray alloc] init];
    }
    else {
        [self.BottomCellInforow removeAllObjects];
    }
    
    if(m_dicRPSs != nil) {
        [m_dicRPSs removeAllObjects];
    }
    
    //헤더 동영상 재생중인지 체크,테이블뷰에서 사라질경우 Pause위해 위치 기록
    self.isHeaderMoviePlaying = NO;
    self.frameMoviePlaying = CGRectZero;
    
    [self sectionarrdataNeedMoreData:ONLYDATASETTING];
    _scrollBarFadeDelay = kMDCScrollBarViewControllerDefaultFadeDelay;
    //더보기 처리
    ajaxPageUrl = NCS([self.apiResultDic objectForKey:@"ajaxPageUrl"]);
}



// 딜전용
- (void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype {
    NSMutableArray *fetchedArray = [NSMutableArray array];
    for (NSInteger i=0; i<[sectionorigindata count]; i++) {
        if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC"] || [NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC_S"] || [NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC_P"] ) {
            //베스트 매장 카테고리 존재 유무
            isFPC = YES;
            idxFPC = i;
            rectFPCCell = CGRectZero;
            if (dicFPCInfo == nil) {
                dicFPCInfo = [[NSMutableDictionary alloc] init];
            }
            [dicFPCInfo removeAllObjects];
            [dicFPCInfo addEntriesFromDictionary:[sectionorigindata objectAtIndex:i]];
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
#if APPSTORE
#else
#endif
        }
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"MAP_MUT_CATEGORY_GBA"]) {
            idxFlexCate = i;
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
        }
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"TCF"]) {
            NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
            idxTCF = i;
            NSLog(@"idxTCF = %lu",(long)idxTCF);
            if (NCA([dicRow objectForKey:@"subProductList"])) {
                [fetchedArray addObject:dicRow];
                if (NCA([[[dicRow objectForKey:@"subProductList"] objectAtIndex:idxTCFCate] objectForKey:@"subProductList"])) {
                    [fetchedArray addObjectsFromArray:[[[dicRow objectForKey:@"subProductList"] objectAtIndex:idxTCFCate] objectForKey:@"subProductList"]];
                }
            }
            
        }
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"RPS"]) {
            NSArray *arrWords = [[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"];
            [self calcRPSHeightSubListArr:arrWords andIndex:i];
            NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
            [fetchedArray addObject:dicRow];
        }
        // 20180319 parksegun - 더보기 있는 셀
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"MAP_CX_GBA"]) {
            //MAP_CX_GBA는 MAP_CX_GBA_1, MAP_CX_GBA_2, MAP_CX_GBA_3으로 나뉨 MAP_CX_GBA_2가 가변영역임.
            NSArray *dicCx = [[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"];
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
            [dic1 addEntriesFromDictionary:[dicCx objectAtIndex:0]];
            [dic1 removeObjectForKey:@"subProductList"];
            [dic1 setObject:@"MAP_CX_GBA_1" forKey:@"viewType"];
            [fetchedArray addObject:dic1];
            
            NSArray *arrSub = [[dicCx objectAtIndex:0] objectForKey:@"subProductList"];
            float viewCount = 0.0;
            if([arrSub count] > 0) {
                viewCount = [arrSub count]/3;
                viewCount += ([arrSub count]%3 != 0) ? 1 : 0;
                NSInteger lenPos = 0;
                for(NSInteger vCn = 0; vCn < viewCount ; vCn++) {
                    NSMutableDictionary *dicSub = [[NSMutableDictionary alloc] init];
                    [dicSub setObject:@"MAP_CX_GBA_2" forKey:@"viewType"];
                    [dicSub setObject:(vCn==0)?@"Y":@"N" forKey:@"isVisible"];
                    NSInteger cnt = (arrSub.count-lenPos)>3?3:(arrSub.count-lenPos);
                    [dicSub setObject:[arrSub subarrayWithRange:NSMakeRange(lenPos, cnt)] forKey:@"subProductList"];
                    lenPos += cnt;
                    [fetchedArray addObject:dicSub];
                }
            }
            
            //3
            NSMutableDictionary *dicEnd = [[NSMutableDictionary alloc] init];
            [dicEnd setObject:@"MAP_CX_GBA_3" forKey:@"viewType"];
            //1줄만 노출될경우 더보기 아닌 브랜드 바로가기
            [dicEnd setObject:(viewCount > 1)?@"Y":@"N" forKey:@"isOpen"];
            [dicEnd setObject:[NSString stringWithFormat:@"%ld",(long)viewCount] forKey:@"subPrdCount"];
            [dicEnd setObject:[dic1 objectForKey:@"linkUrl"] forKey:@"linkUrl"];
            [fetchedArray addObject:dicEnd];
        }
        
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"BAN_CX_SLD_CATE_GBA"]) {
            // 베스트 매장 카테고리 존재 유무
            if (atype != HOLDRELOADING) {
                if (self.CX_SLD_CATEView != nil) {
                    [self.CX_SLD_CATEView removeFromSuperview];
                    self.CX_SLD_CATEView = nil;
                }
                isCX_SLD = YES;
                idxCX_SLD = i;
                rectCX_SLDCell = CGRectZero;
                idxCX_SLDCate = 0;
                self.CX_SLD_CATEView = [[[NSBundle mainBundle] loadNibNamed:@"SectionBAN_CX_SLD_CATE_GBASubView" owner:self options:nil] firstObject];
                [self.CX_SLD_CATEView setCellInfo:[sectionorigindata objectAtIndex:i] index:idxCX_SLDCate target:self sectionName:NCS([self.sectioninfodata  objectForKey:@"sectionName"])];
                [self.CX_SLD_CATEView.iScrollCate scrollToItemAtIndex:0 animated:NO];
            }
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
        }
        
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"GR_PMO_T2"]) {
            NSDictionary *dicReorder = [sectionorigindata objectAtIndex:i];
            [self reorderGR_PMO_T2:dicReorder toAddArray:fetchedArray];
        }
        // 이벤트 카테
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"BAN_CX_CATE_GBA"]) {
            // 이벤트 매장 카테고리 존재 유무
            if (atype != HOLDRELOADING) {
                if (self.CX_CATEView != nil) {
                    [self.CX_CATEView removeFromSuperview];
                    self.CX_CATEView = nil;
                }
                isCX_CATE = YES;
                idxCX_CATE = i;
                rectCX_CATECell = CGRectZero;
                idxCX_SelectCate = 0;
                self.CX_CATEView = [[[NSBundle mainBundle] loadNibNamed:@"SectionBAN_CX_CATE_GBASubView" owner:self options:nil] firstObject];
                [self.CX_CATEView setCellInfo:[sectionorigindata objectAtIndex:i] index:idxCX_SelectCate target:self];
            }
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
            
        }
        else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"PRD_C_B1"]) {
            if ( NCA([[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"])
                && [[[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"] count] == 1 ) {
                
                NSMutableDictionary *title = [sectionorigindata objectAtIndex:i];
                [title setObject:@"BAN_TXT_IMG_LNK_GBA" forKey:@"viewType"];
                [title setObject:@"Y" forKey:@"bdrBottomYn"];
                NSMutableDictionary *prd_1 = [[[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"] objectAtIndex:0];
                [prd_1 setObject:@"PRD_1_640" forKey:@"viewType"];
                
                [fetchedArray addObject:title];
                [fetchedArray addObject:prd_1];
            }
            else {
                [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
            }
        }else {
            //NSLog(@"[sectionorigindata objectAtIndex:i] = %@",NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]));
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
        }
    }
    
    
    if(atype == (PAGEACTIONTYPE)FULLRELOADING) {
        self.sectionarrdata = fetchedArray;
        CGPoint offset = self.tableView.contentOffset;
        offset.y = 0.0f;
        [self.tableView setContentOffset:offset animated:NO];
        [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
        [self tableFooterDraw];
        animtbindex = -1;
        [self.tableView reloadData];
        isPagingComm = NO;
    }
    else if(atype == (PAGEACTIONTYPE)HOLDRELOADING) {
        [self.sectionarrdata addObjectsFromArray:fetchedArray];
        CGPoint offset = self.tableView.contentOffset;
        [self.tableView setContentOffset:offset animated:NO];
        [self.tableView reloadData];
    }
    else if(atype == (PAGEACTIONTYPE)ONLYDATASETTING) {
        
        self.sectionarrdata = fetchedArray;
        
        tvcdic = [self.apiResultDic objectForKey:@"tvLiveBanner"];
        tvcdicMyShop = [self.apiResultDic objectForKey:@"dataLiveBanner"];
        tvcdicMobileLive = [self.apiResultDic objectForKey:@"mobileLiveBanner"];
        
//        NSLog(@"self.apiResultDic = %@",self.apiResultDic);
    }
}

-(void)reorderGR_PMO_T2:(NSDictionary *)dicReorder toAddArray:(NSMutableArray *)arrAdd{
    //NSLog(@"dicReorderdicReorder = %@",dicReorder);
    
    NSMutableArray *arrReorder = [[NSMutableArray alloc] init];
    NSArray *arrSub = [dicReorder objectForKey:@"subProductList"];
    
    if (NCA(arrSub)) {
        for (NSDictionary *dicRow in arrSub) {

//            //찜 갯수 0 테스트
//            if ([[dicRow objectForKey:@"viewType"] isEqualToString:@"PMO_T2_A"]) {
//                NSMutableDictionary *dicTest = [[NSMutableDictionary alloc] initWithDictionary:dicRow];
//                [dicTest setObject:@"" forKey:@"wishCnt"];
//
//                [arrReorder addObject:dicTest];
//            }else{
//                [arrReorder addObject:dicRow];
//            }
            [arrReorder addObject:dicRow];
        }
    }
    NSString *strMoreUrl = NCS([dicReorder objectForKey:@"moreBtnUrl"]);
    if ([strMoreUrl length] > 0) {
        NSDictionary *dicGR_PMO_T2_More = [NSDictionary dictionaryWithObjectsAndKeys:@"GR_PMO_T2_More",@"viewType",strMoreUrl,@"linkUrl",nil];
        [arrReorder addObject:dicGR_PMO_T2_More];
    }
    
    [arrAdd addObjectsFromArray:arrReorder];
}


- (NSArray *)getCircleApproximationTimingFunctions {
    const double kappa = 4.0/3.0 * (sqrt(2.0)-1.0) / sqrt(2.0);
    CAMediaTimingFunction *firstQuarterCircleApproximationFuction = [CAMediaTimingFunction functionWithControlPoints:kappa /(M_PI/2.0f) :kappa :1.0-kappa :1.0];
    CAMediaTimingFunction * secondQuarterCircleApproximationFuction = [CAMediaTimingFunction functionWithControlPoints:kappa :0.0 :1.0-(kappa /(M_PI/2.0f)) :1.0-kappa];
    return @[firstQuarterCircleApproximationFuction, secondQuarterCircleApproximationFuction];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self tableViewRegisterNib];
    TVCapirequestcount = 0;
    animtbindex = -1;
    CGFloat viewHeight = 35;
    CABasicAnimation * cubeRotation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D rotation = CATransform3DIdentity;
    
    // Bottom to TOP 회전제외
    rotation = CATransform3DTranslate(rotation, 0.0f, viewHeight, - viewHeight);
    cubeRotation.fromValue = [NSValue valueWithCATransform3D:rotation];
    cubeRotation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    cubeRotation.duration = 0.5f;
    _cubeAnimation = cubeRotation;
    [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
    [self tableFooterDraw];
    self.tableView.backgroundColor = [UIColor getColor:@"EEEEEE" alpha:1 defaultColor:UIColor.grayColor];
    
    if (@available(iOS 11,*)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 틀고정 메뉴 노출 확인
- (void)checkFPCMenu {
    if (isFPC) {
        BOOL isShow = YES;
        if ([NCS([self.sectioninfodata objectForKey:@"viewType"]) isEqualToString:HOMESECTDFCLIST]) {
            isShow = NO;
        }
        if ([delegatetarget respondsToSelector:@selector(viewheaderFPCTitle:andIndex:andSubIndex:showCrown:)]) {
            [delegatetarget viewheaderFPCTitle:dicFPCInfo andIndex:idxFPCCate andSubIndex:idxFPCCateSub showCrown:isShow];
        }
        if (!CGRectEqualToRect(rectFPCCell, CGRectZero)) {
            if (self.tableView.contentOffset.y > rectFPCCell.origin.y) {
                [self.tableView setContentOffset:rectFPCCell.origin animated:NO];
            }
        }
    }
    
    if (isCX_SLD) {
        if ([delegatetarget respondsToSelector:@selector(viewheaderCX_SLD)]) {
            [delegatetarget viewheaderCX_SLD];
        }
        if (!CGRectEqualToRect(rectCX_SLDCell, CGRectZero)) {
            if (self.tableView.contentOffset.y > rectCX_SLDCell.origin.y) {
                [self.tableView setContentOffset:rectCX_SLDCell.origin animated:NO];
            }
        }
    }
    
    if (isCX_CATE) {
        if ([delegatetarget respondsToSelector:@selector(viewheaderCX_CATE)]) {
            [delegatetarget viewheaderCX_CATE];
        }
        if (!CGRectEqualToRect(rectCX_CATECell, CGRectZero)) {
            if (self.tableView.contentOffset.y > rectCX_CATECell.origin.y) {
                CGPoint pos = rectCX_CATECell.origin;
                pos.y -= 0.1;//0.1마진더줌... 그럼 셀이 노출되면서 스크롤액션 + 클릭액션이 동작함.
                [self.tableView setContentOffset:pos animated:NO];
            }
        }
    }
}



- (void) tvshoppingHeaderReload {
    if([NCS([self.sectioninfodata objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_HOME]) {
        if(self.tableView.tableHeaderView == nil) {
            [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
        }
        else {
            self.tableView.tableHeaderView.frame =  CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight);
            self.tableView.tableHeaderView.layer.masksToBounds = YES;
            self.tableView.tableHeaderView = self.tableView.tableHeaderView;
        }
    }
    else {
        [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
    }
    
    [self tableFooterDraw];
    //self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
    [self.tableView reloadData];
}


- (void) tableHeaderDraw :(TVCONTENTBASE)tvcbasesource {
    if(self.tableView.tableHeaderView != nil) {
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView  = nil;
    }
    
    tableheaderBANNERheight = 0;
    tableheaderTVCVheight = 0;
    //아래버튼높이는 공용으로 사용되어짐 - TV쇼핑과 베스트딜섹션등..
    tableheaderTDCTVCBTNVheight = 0;
    tableheaderTVCBOTTOMMARGIN = 0;
    tableheaderNo1DealListheight= 0;
    tableheaderNo1DealZoneheight = 0;
    tableheaderListheight = 0;
    UIView *tvhview = [[UIView alloc] initWithFrame:CGRectZero ];
    tvhview.autoresizesSubviews = NO;
    //배너
    if([self isExsitSectionBanner]) {
        NSInteger heightBanner = BANNERHEIGHT;
        if (NCO([self.apiResultDic objectForKey:@"banner"]) && [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) length] > 0) {
            heightBanner = [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) integerValue];
        }
        tableheaderBANNERheight = floor([Common_Util DPRateOriginVAL:heightBanner]);
        [tvhview addSubview:[self topBannerview]];
    }
    //이미지형태 광고
    if (NCA([self.apiResultDic objectForKey:@"headerList"] ) && [(NSArray *)[self.apiResultDic objectForKey:@"headerList"] count] > 0) {
        NSArray *arrHeader = (NSArray *)[self.apiResultDic objectForKey:@"headerList"];
        for (NSInteger i=0; i<[arrHeader count]; i++) {
            if(!NCO([arrHeader objectAtIndex:i])) {
                break;
            }
            NSString *viewType = NCS([[arrHeader objectAtIndex:i] objectForKey:@"viewType"]);
            
            if ([viewType  isEqualToString:@"B_IM"]) {
                TableHeaderEItypeView *cell = [[TableHeaderEItypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, [Common_Util DPRateOriginVAL:170])];
                [tvhview addSubview:cell];
                [cell setCellInfoNDrawData:[arrHeader objectAtIndex:i]];
                tableheaderListheight =  tableheaderListheight + [Common_Util DPRateOriginVAL:170];
            }
            else if ([viewType  isEqualToString:@"SE"]) {
                SectionSEtypeView  *cell = [[SectionSEtypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, [Common_Util DPRateVAL:152 withPercent:88])];
                [tvhview addSubview:cell];
                if(NCA([[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"])) {
                    [cell setCellInfoNDrawData:(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"]];
                }
                tableheaderListheight =  tableheaderListheight + [Common_Util DPRateVAL:152 withPercent:88];
            }
            else if ([viewType isEqualToString:@"BAN_SLD_GBA"]) { // 헤더
                SectionBAN_SLD_GBABtypeView *cell = [[SectionBAN_SLD_GBABtypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN) Type:@"BAN_SLD_GBA"];
                [tvhview addSubview:cell];
                if(NCA([[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"])) {
                    [cell setCellInfoNDrawData:(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"]];
                }
                tableheaderListheight =  tableheaderListheight + [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN;
            }
            else if ([viewType  isEqualToString:@"BAN_SLD_GBB"]) { // 헤더
                SectionBAN_SLD_GBABtypeView *cell = [[SectionBAN_SLD_GBABtypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN) Type:@"BAN_SLD_GBB"];
                [tvhview addSubview:cell];
                if(NCA([[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"])) {
                    [cell setCellInfoNDrawData:(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"]];
                }
                tableheaderListheight =  tableheaderListheight + [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN;
            }
            else {
            }
        }
        
        
        
    }
    //TVC View
    if([NCS([self.sectioninfodata objectForKey:@"viewType"]) isEqualToString:HOMESECTTCLIST]) {
        
        //!!!!!리로드 로직 2개로 늘어나면 손봐야함
        /*
         if(tvcbasesource == TVLiveContentsBase) {
         NSString *itemString = [Mocha_Util strReplace:@"#" replace:@"" string:[self.sectioninfodata objectForKey:@"sectionCode"] ];
         NSURL *turl = [NSURL URLWithString:TV_LIVE_URLWITHCODE(itemString )];
         NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
         
         //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
         NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
         [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
         
         NSError *error;
         NSURLResponse *response;
         NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];
         
         if (! result || [result isKindOfClass:[NSNull class]] == YES) {
         tvcdic = nil;
         return;
         }
         else {
         // Return results
         // nami0342 - JSON
         tvcdic = [[result JSONtoValue] objectForKey:@"appTvLiveBanner"];
         }
         
         }
         else if (tvcbasesource == TVLiveContentReload) {
         NSLog(@"tvcdic 그대로 사용");
         }
         else {
         tvcdic = [self.apiResultDic objectForKey:@"tvLiveBanner"];
         NSLog(@"section TVC Dic: %@", [self.apiResultDic objectForKey:@"tvLiveBanner"] );
         }
         */
        
        
        if (self.viewHeaderLive != nil) {
            //[self.viewHeaderLive stopMoviePlayer];
            [self.viewHeaderLive stopTimer];
            [self.viewHeaderLive removeFromSuperview];
            self.viewHeaderLive = nil;
            NSLog(@"");
        }
        
        if (self.viewHeaderMyShop != nil) {
            //[self.viewHeaderMyShop stopMoviePlayer];
            [self.viewHeaderMyShop stopTimer];
            [self.viewHeaderMyShop removeFromSuperview];
            self.viewHeaderMyShop = nil;
            NSLog(@"");
        }
        
        if (self.viewHeaderMobileLive != nil) {
            [self.viewHeaderMobileLive stopTimer];
            [self.viewHeaderMobileLive removeFromSuperview];
            self.viewHeaderMobileLive = nil;
            NSLog(@"");
        }
        
        
        
        
        if ( ([NCS([tvcdic objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdic objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdic objectForKey:@"imageUrl"]) isEqualToString:@""] == NO)
            || ([NCS([tvcdicMyShop objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdicMyShop objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdicMyShop objectForKey:@"imageUrl"]) isEqualToString:@""] == NO) ) {
            //생방송과 데이터 방송 둘중에 하나라도 유효할경우 진행
            
           
            
            if (([NCS([tvcdic objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdic objectForKey:@"linkUrl"]) isEqualToString:@""] == NO) && ([NCS([tvcdic objectForKey:@"imageUrl"]) isEqualToString:@""] == NO)) {
                
                
                if (self.viewHeaderLive == nil) {
                    NSLog(@"");
                    self.viewHeaderLive = [[[NSBundle mainBundle] loadNibNamed:@"HomeMainBroadView" owner:self options:nil] firstObject];
                }
                NSLog(@"");
                
                self.viewHeaderLive.clipsToBounds = YES;
                self.viewHeaderLive.target = self;
                self.viewHeaderLive.strSectionName = [self.sectioninfodata  objectForKey:@"sectionName"];
                self.viewHeaderLive.strSectionCode = NCS([self.sectioninfodata  objectForKey:@"sectionCode"]);
                self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + tableheaderTVCVheight, APPFULLWIDTH, heightHomeMainBroadView);
                
                [tvhview addSubview:self.viewHeaderLive];
                [self.viewHeaderLive setCellInfoNDrawData:tvcdic isShopLive:YES];
                
                
                tableheaderTVCVheight = tableheaderTVCVheight+heightHomeMainBroadView+10.0;
                
            }
            
            if (([NCS([tvcdicMyShop objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdicMyShop objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdicMyShop objectForKey:@"imageUrl"]) isEqualToString:@""] == NO)) {
                
                if (self.viewHeaderMyShop == nil) {
                    NSLog(@"");
                    self.viewHeaderMyShop = [[[NSBundle mainBundle] loadNibNamed:@"HomeMainBroadView" owner:self options:nil] firstObject];
                }
                NSLog(@"");
                
                
                self.viewHeaderMyShop.clipsToBounds = YES;
                self.viewHeaderMyShop.target = self;
                self.viewHeaderMyShop.strSectionName = NCS([self.sectioninfodata  objectForKey:@"sectionName"]);
                self.viewHeaderMyShop.strSectionCode = NCS([self.sectioninfodata  objectForKey:@"sectionCode"]);
                self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + tableheaderTVCVheight, APPFULLWIDTH, heightHomeMainBroadView);
                
                [tvhview addSubview:self.viewHeaderMyShop];
                [self.viewHeaderMyShop setCellInfoNDrawData:tvcdicMyShop isShopLive:NO];
                
                tableheaderTVCVheight = tableheaderTVCVheight+heightHomeMainBroadView+10.0;
                
            }
            
            /*}*/
            
        }
        
        
        
        NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
        [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
        //종료시간
        NSDate *startTime = [dateformat dateFromString:NCS([tvcdicMobileLive objectForKey:@"broadStartTime"])];
        int startStamp = [startTime timeIntervalSince1970];
        //남은방송시간
        double leftTimeSec = startStamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
        
        
        if ([NCS([tvcdicMobileLive objectForKey:@"broadStartTime"]) length] > 13 && [NCS([tvcdicMobileLive objectForKey:@"broadCloseTime"]) length] > 13) {
            
            if (self.viewHeaderMobileLive == nil) {
                NSLog(@"");
                self.viewHeaderMobileLive = [[[NSBundle mainBundle] loadNibNamed:@"HomeMainBroadMobileLive" owner:self options:nil] firstObject];
            }
            NSLog(@"");
            
            self.viewHeaderMobileLive.clipsToBounds = YES;
            self.viewHeaderMobileLive.target = self;
            self.viewHeaderMobileLive.strSectionName = NCS([self.sectioninfodata  objectForKey:@"sectionName"]);
            self.viewHeaderMobileLive.strSectionCode = NCS([self.sectioninfodata  objectForKey:@"sectionCode"]);
            self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + tableheaderTVCVheight, APPFULLWIDTH, heightHomeMainBroadMobileLiveView);
            
            if (leftTimeSec > 0.0) {
                //방송 준비중
                self.viewHeaderMobileLive.hidden = YES;
                self.viewHeaderMobileLive.isPreparingBroad = YES;
                [tvhview addSubview:self.viewHeaderMobileLive];
                [self.viewHeaderMobileLive setCellInfoNDrawData:tvcdicMobileLive];
                
                NSLog(@"self.viewHeaderMobileLive = %@",self.viewHeaderMobileLive);
                
            }else{
                
                if (([NCS([tvcdicMobileLive objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdicMobileLive objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdicMobileLive objectForKey:@"imageUrl"]) isEqualToString:@""] == NO)) {
                    
                    /*
                     if (self.viewHeaderLive == nil && self.viewHeaderMyShop == nil) {
                     tableheaderTVCVheight = 10; //최상단 10 여백
                     }
                     */
                    
                    self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + tableheaderTVCVheight, APPFULLWIDTH, heightHomeMainBroadMobileLiveView);
                    
                    //방송중
                    self.viewHeaderMobileLive.hidden = NO;
                    self.viewHeaderMobileLive.isPreparingBroad = NO;
                    tableheaderTVCVheight = tableheaderTVCVheight+heightHomeMainBroadMobileLiveView + 10.0;
                    
                    [tvhview addSubview:self.viewHeaderMobileLive];
                    [self.viewHeaderMobileLive setCellInfoNDrawData:tvcdicMobileLive];
                    NSLog(@"self.viewHeaderMobileLive = %@",self.viewHeaderMobileLive);
                    
                }else{
                    
                    
                }
                
                
            }
        }else{
            //방송시작시간 없음 판단기준 없음으로 안그림
            
            
            self.viewHeaderMobileLive = nil;
        }
        
        
        
        
        
        //No1DealList product
        if(NCA([self.apiResultDic objectForKey:@"no1DealList"])) {
            //이미지형태 광고
            if( [NCS([[[self.apiResultDic objectForKey:@"no1DealList"] objectAtIndex:0] objectForKey:@"productType"])  isEqualToString:@"AD"] && [NCS([[[self.apiResultDic objectForKey:@"no1DealList"] objectAtIndex:0] objectForKey:@"viewType"])  isEqualToString:@"I"] ) {
                tableheaderNo1DealListheight = [Common_Util DPRateOriginVAL:170];
                TableHeaderEItypeView  *cell = [[TableHeaderEItypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight + tableheaderTVCBOTTOMMARGIN, APPFULLWIDTH, tableheaderNo1DealListheight)];
                [tvhview addSubview:cell];
                [cell setCellInfoNDrawData:[[self.apiResultDic objectForKey:@"no1DealList"] objectAtIndex:0]];
            }
            else {
                tableheaderNo1DealListheight = [Common_Util DPRateVAL:225 withPercent:72];
                TableHeaderDCtypeView  *cell = [[TableHeaderDCtypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight + tableheaderTVCBOTTOMMARGIN, APPFULLWIDTH, tableheaderNo1DealListheight)];
                [tvhview addSubview:cell];
                [cell setCellInfoNDrawData:[[self.apiResultDic objectForKey:@"no1DealList"] objectAtIndex:0]];
            }
        }
        
        //No1DealZone product
        if(NCA([self.apiResultDic objectForKey:@"no1DealZone"])) {
            tableheaderNo1DealZoneheight = [Common_Util DPRateVAL:172 withPercent:88];
            SectionNO1typeView *tcell = [[SectionNO1typeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight + tableheaderTVCBOTTOMMARGIN+tableheaderNo1DealListheight, APPFULLWIDTH, tableheaderNo1DealZoneheight)];
            [tvhview addSubview:tcell];
            [tcell setCellInfoNDrawData:[self.apiResultDic objectForKey:@"no1DealZone"] ];
        }
    }
    
    tvhview.frame = CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight + tableheaderTVCBOTTOMMARGIN+tableheaderNo1DealListheight+tableheaderNo1DealZoneheight);
    self.tableView.tableHeaderView = tvhview;
    
    NSLog(@"tvhview.frame = %@",NSStringFromCGRect(tvhview.frame));
    
    if( [NCS([self.sectioninfodata  objectForKey:@"viewType"])  isEqualToString:HOMESECTTCLIST] ) {
        //in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
        
        //HOMESECTTCLIST 일때만 작동해야함
        //[self procGraphAnimation:(TVCONTENTBASE)SectionContentsBase];
        
        //layer 위치 변경 필수
        if(self.scrollBarLabel != nil) {
            [self.scrollBarLabel removeFromSuperview];
            self.scrollBarLabel  = nil;
        }
        self.scrollBarLabel = [[MDCScrollBarLabel alloc] initWithScrollView:self.tableView];
        [self.tableView addSubview:self.scrollBarLabel];
        [self.view bringSubviewToFront:self.scrollBarLabel];
        [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay: self.scrollBarFadeDelay];
        [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:self.scrollBarFadeDelay];
    }
    //self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
}


- (BOOL)isExsitSectionBanner {
    @try {
        if( NCO([self.apiResultDic objectForKey:@"banner"]) && NCO([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"])) {
            if( ![NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"]) isEqualToString:@""]) {
                return YES;
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return  NO;
    }
}



-(void) tableFooterDraw {
    
    if(self.tableView.tableFooterView != nil) {
        self.tableView.tableFooterView  = nil;
    }
    
    if( self.sectionarrdata == nil || self.sectionarrdata.count < 1){
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return;
    }
    
    tablefooterLoginVheight = 220;
    self.tableView.tableFooterView =  [self footerLoginView];
    if( [NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTTCLIST] ) {
        [self.view bringSubviewToFront:self.scrollBarLabel];
    }
}


-(double)leftLiveTVTime {
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:[tvcdic objectForKey:@"broadCloseTime"]];
    int closestamp = [closeTime timeIntervalSince1970];
    
    //남은방송시간
    double leftTimeSec = closestamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    return leftTimeSec;
}

// 사용하지 않는 메서드로 추정됨.
- (UIView*)footerHotLinkLoginView {
    tablefooterLoginVheight = 573;
    UIView *footercontainview = [[UIView alloc] initWithFrame:CGRectMake(0,   0, APPFULLWIDTH, tablefooterLoginVheight)] ;
    UIView *footerLoginView = [[UIView alloc] initWithFrame:CGRectMake(0,   400, APPFULLWIDTH, tablefooterLoginVheight)] ;
    [footerLoginView addSubview:[self footerLoginView]];
    UIButton* cbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn2 setFrame:CGRectMake(86,6,71,32)];
    [cbtn2 addTarget:self action:@selector(TopCategoryTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cbtn2 setBackgroundImage:[UIImage imageNamed:@"6_footer_bt_bg.png"] forState:UIControlStateNormal] ;
    [cbtn2 setTitle:@"이용약관" forState:UIControlStateNormal];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"444444"] forState:UIControlStateNormal];
    [cbtn2 setTitle:@"이용약관"  forState:UIControlStateHighlighted];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"444444"] forState:UIControlStateHighlighted];
    cbtn2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    cbtn2.tag = 3;
    [footercontainview addSubview:cbtn2];
    [footercontainview addSubview:footerLoginView];
    footercontainview.alpha = 1.0f;
    return footercontainview;
}





- (UIView*)footerLoginView {
    tablefooterLoginVheight = 300;
    SectionTBViewFooter *footercontainview = [[SectionTBViewFooter alloc] initWithTarget:self Nframe:CGRectMake(0.0,0.0, APPFULLWIDTH, tablefooterLoginVheight)] ;
    return footercontainview;
}



- (UIView*)topBannerview {
    UIView *bannercontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight)];
    UIImageView* basebgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight)];
    basebgimgview.image = [UIImage imageNamed:@"noimg_100.png"];
    [bannercontainview addSubview:basebgimgview];
    bannerimg = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, APPFULLWIDTH, tableheaderBANNERheight)];
    [bannercontainview addSubview:bannerimg];
    bannercontainview.alpha = 1.0f;
    UIButton* btn_gucell = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_gucell setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    [btn_gucell setFrame:CGRectMake(0, 0, APPFULLWIDTH, tableheaderBANNERheight)];
    [btn_gucell addTarget:self action:@selector(BannerCellPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    // nami0342 - Accessibility
    btn_gucell.accessibilityTraits = UIAccessibilityTraitButton;
    NSString *strALB = NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"title"]);
    
    if(strALB.length > 0)
    {
        btn_gucell.accessibilityLabel = strALB;
    }
    else
    {
        btn_gucell.accessibilityLabel = @"이미지 베너 입니다.";
    }
    [bannercontainview addSubview:btn_gucell];
    if(NCO([self.apiResultDic objectForKey:@"banner"]) == NO) {
        return [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, 0)];
    }
    
    NSString *imageURL = NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil  && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache) {
                    bannerimg.image = fetchedImage;
                }
                else {
                    bannerimg.image = fetchedImage;
                }
            });
            
        }
        
    }];
    return bannercontainview;
}





- (UIView*)listBottomview {
    UIView *bttombtncontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, 45)] ;
    UIButton* btn_leftcell = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_leftcell.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    btn_leftcell.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [btn_leftcell setFrame:CGRectMake(8, 5, 255, 35)];
    [btn_leftcell addTarget:self action:@selector(btntouchWithDic:) forControlEvents:UIControlEventTouchUpInside];
    [btn_leftcell setBackgroundImage:[UIImage imageNamed:@"btn_main_event_05.png"] forState:UIControlStateNormal] ;
    [btn_leftcell setBackgroundImage:[UIImage imageNamed:@"btn_main_event_05_sel.png"] forState:UIControlStateHighlighted];
    btn_leftcell.alpha = 0.9;
    btn_leftcell.tag = 2007;
    [bttombtncontainview addSubview:btn_leftcell];
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 170.0f, 18.0f)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textAlignment = NSTextAlignmentRight;
    titlelabel.font = [UIFont systemFontOfSize:15];
    titlelabel.textColor = [Mocha_Util getColor:@"FFFFFF"];
    titlelabel.text = [self.sectioninfodata objectForKey:@"listBottomTiltle"];
    titlelabel.adjustsFontSizeToFitWidth = YES;
    titlelabel.minimumScaleFactor = 0.5f;
    [bttombtncontainview addSubview:titlelabel];
    UIImageView* iconimg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_event_arrow.png"] ];
    [iconimg1 setFrame:CGRectMake(185, 17, 10, 10)];
    [bttombtncontainview addSubview:iconimg1];
    UIButton* btn_rightcell = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_rightcell setFrame:CGRectMake(266, 5, 44, 35)];
    [btn_rightcell addTarget:self action:@selector(btngoTop) forControlEvents:UIControlEventTouchUpInside];
    [btn_rightcell setBackgroundImage:[UIImage imageNamed:@"btn_main_event_06.png"] forState:UIControlStateNormal] ;
    [btn_rightcell setBackgroundImage:[UIImage imageNamed:@"btn_main_event_06_sel.png"] forState:UIControlStateHighlighted];
    btn_rightcell.alpha = 0.9;
    [bttombtncontainview addSubview:btn_rightcell];
    UIImageView* iconimg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_totop.png"] ];
    [iconimg2 setFrame:CGRectMake(283, 17, 10, 10)];
    [bttombtncontainview addSubview:iconimg2];
    return bttombtncontainview;
}

- (void)btntouchAction:(id)sender {
    if([((UIButton *)sender) tag] == 1005) {
        //사업자정보
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSCOMPANYINFOTURL]];
        return;
    }
    else if([((UIButton *)sender) tag] == 1006) {
        //채무지급보증
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSCOMPANYGUARANTEEURL]];
        return;
    }
    else {
        [delegatetarget btntouchAction:sender];
    }
}


//맨위로
- (void)btngoTop {
    [delegatetarget sectiongoTop];
}


- (void)btntouchWithLinkStr:(id)sender {
    [delegatetarget touchEventTBCellJustLinkStr: NCA(self.sectionarrdata) &&  self.sectionarrdata.count > (int)[((UIButton *)sender) tag]?[[self.sectionarrdata objectAtIndex:(int)[((UIButton *)sender) tag]] objectForKey:@"no1ScheduleUrl" ] : @"" ];
}


//넘베딜 & TV쇼핑 TVC영역 Link처리공통 + TV쇼핑 편성표보기 최우측버튼 링크처리공통
- (void)btntouchWithLinkStrBD:(id)sender {
    //오늘추천 생방송영역클릭
    if([((UIButton *)sender) tag] == 3007) {
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_Main_Live", [self.sectioninfodata  objectForKey:@"sectionName"] ]
                                   withLabel:    [NSString stringWithFormat:@"0_%@", [tvcdic objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        [delegatetarget touchEventTBCellJustLinkStr: [tvcdic objectForKey:@"linkUrl"] ];
    }
    
    //TV쇼핑
    else if([((UIButton *)sender) tag] == 3008) {
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live", [self.sectioninfodata  objectForKey:@"sectionName"], ([[NSString stringWithFormat:@"%s",   object_getClassName(self)] isEqualToString:@"TDCDataTBViewController"])?@"데이터 홈쇼핑":@"생방송" ]
                                   withLabel:    [NSString stringWithFormat:@"0_%@", [tvcdic objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        [delegatetarget touchEventTBCellJustLinkStr: [tvcdic objectForKey:@"linkUrl"] ];
    }
    else if([((UIButton *)sender) tag] == 3009) {
        //적립신청 에서 라이브톡 참여로 변경됨 2017.03.30 배포버전
        if ([NCS([tvcdic objectForKey:@"liveTalkUrl"]) length] > 0) {
            [delegatetarget touchEventTBCellJustLinkStr: NCS([tvcdic objectForKey:@"liveTalkUrl"])];
        }
    }
    else if([((UIButton *)sender) tag] == 3010) {
        [delegatetarget touchEventTBCellJustLinkStr: [[self.apiResultDic objectForKey:@"tvLiveBanner"] objectForKey:@"broadScheduleLinkUrl"] ];
    }
    else if([((UIButton *)sender) tag] == 3011) {
        //바로구매
        //20151201부터 rightNowBuyUrl 적용 v.3.2.7.26 기준
        //2016.04.12 배포용 바로구매
        if(NCO([tvcdic objectForKey:@"btnInfo3"])) {
            if (NCS([[tvcdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"]) && [[[tvcdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                
                NSString *linkstr = [[[tvcdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] substringFromIndex:11];
                NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                [self.tableView setContentOffset:CGPointMake(0.0, tableheaderBANNERheight + tableheaderListheight) animated:YES];
                [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
            }
            else {
                NSString *linkstr = [[tvcdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"];
                [delegatetarget touchEventTBCellJustLinkStr:linkstr];
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd", [self.sectioninfodata  objectForKey:@"sectionName"]]
                                       withLabel:[NSString stringWithFormat:@"%@",[[tvcdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
            
        }
        else {
            [delegatetarget touchEventTBCellJustLinkStr: [tvcdic objectForKey:@"rightNowBuyUrl"] ];
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd", [self.sectioninfodata  objectForKey:@"sectionName"]]
                                       withLabel:[NSString stringWithFormat:@"%@",[tvcdic objectForKey:@"rightNowBuyUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
        }
    }
    else if([((UIButton *)sender) tag] == 10000) {
        //tv쇼핑 - 편성표 목록 최우측 버튼
        [delegatetarget touchEventTBCellJustLinkStr: [[[self.apiResultDic objectForKey:@"tvLiveBannerList"]  lastObject]  objectForKey:@"broadScheduleLinkUrl"] ];
    }
    else {
        [delegatetarget touchEventTBCellJustLinkStr: [[[self.apiResultDic objectForKey:@"no1DealList"] objectAtIndex:0] objectForKey:@"no1ScheduleUrl"] ];
    }
    
}



- (void)btntouchWithDic:(id)sender {
    if([((UIButton *)sender) tag] == 2007) {
        [self btntouchWithDicAction:self.sectioninfodata tagint:(int)[((UIButton *)sender) tag]];
    }
    else {
        [self btntouchWithDicAction:tvcdic tagint:(int)[((UIButton *)sender) tag]];
        
        if([((UIButton *)sender) tag] == 2001) {
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_Sec_TodayDeal", [self.sectioninfodata  objectForKey:@"sectionName"] ]
                                       withLabel:  [NSString stringWithFormat:@"%@_0_%@", [DataManager sharedManager].abBulletVer ,   [tvcdic  objectForKey:@"productName"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
            }
            @finally {
                
            }
        }
        
    }
}

- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint {
    [delegatetarget btntouchWithDicAction:tdic tagint:tint];
}

-(void)touchEventTBCellJustLinkStr:(NSString *)strLink{
    if ([self.delegatetarget respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [self.delegatetarget touchEventTBCellJustLinkStr:strLink];
    }
}

//듀얼플레이어 클릭
-(void)touchEventDualPlayerJustLinkStr:(NSString *)strLink{
    if ([self.delegatetarget respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [self.delegatetarget touchEventTBCellJustLinkStr:strLink];
    }
}

- (void) dealloc {
    sectionorigindata = nil;
    self.sectionarrdata = nil;
    self.sectioninfodata = nil;
    self.BottomCellInforow = nil;
    self.sectionType = nil;
    self.apiResultDic = nil;
    if(m_dicRPSs != nil){
        [m_dicRPSs removeAllObjects];
        m_dicRPSs = nil;
    }
    
    NSLog(@"SectionTBViewController deallocdeallocdealloc");
}

-(void)checkDealloc{
    sectionorigindata = nil;
    self.sectionarrdata = nil;
    self.sectioninfodata = nil;
    self.BottomCellInforow = nil;
    self.sectionType = nil;
    self.apiResultDic = nil;
    if(m_dicRPSs != nil){
        [m_dicRPSs removeAllObjects];
        m_dicRPSs = nil;
    }

    if (self.scrollBarLabel != nil) {
        [self.scrollBarLabel removeFromSuperview];
        self.scrollBarLabel = nil;
    }
    
    if(self.CX_SLD_CATEView != nil){
        [self.CX_SLD_CATEView removeFromSuperview];
        self.CX_SLD_CATEView = nil;
    }

    if(self.CX_CATEView != nil){
        [self.CX_CATEView removeFromSuperview];
        self.CX_CATEView = nil;
    }
    if(self.viewHeaderLive != nil){
        [self.viewHeaderLive stopTimer];
        [self.viewHeaderLive removeFromSuperview];
        self.viewHeaderLive = nil;
    }
    if(self.viewHeaderMyShop != nil){
        [self.viewHeaderMyShop stopTimer];
        [self.viewHeaderMyShop removeFromSuperview];
        self.viewHeaderMyShop = nil;
    }
    if(self.viewHeaderMobileLive != nil){
        [self.viewHeaderMobileLive stopTimer];
        [self.viewHeaderMobileLive removeFromSuperview];
        self.viewHeaderMobileLive = nil;
    }
}


#pragma mark - Table view data source
- (void)tableViewRegisterNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionDCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DCtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionDCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DCtypeIdentifier_S];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionPItypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PItypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionEItypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:EItypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionDStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionDefaultCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Defaultdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBIMtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BIMtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBIM440StypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BIM440typeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBIXStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BIXStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBIStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BIStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBILtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BILtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBIXLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BIXLtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBMIAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BMIAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBSIStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BSIStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionPSLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PSLtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBTStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BTStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionTSLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TSLtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionDSLAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DSLAtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionDSLBtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DSLBtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionSS_LINEtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SS_LINEtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DataTVCategoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SUBSECtypeIdentifier];
    //[self.tableView registerNib:[UINib nibWithNibName:@"SectionSRLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SRLtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionSPLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SPLtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionSPCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SPCtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionPCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PCtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_HIMtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_HIMtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_IG4XNtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_IG4XNtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionTAB_SLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TAB_SLtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBTLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BTLtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBFPtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BFPtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBTS2typeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BTS2typedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionTCFtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TCFtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionRPStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RPStypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionFPCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FPCtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionTPStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TPStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBP_OtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BPOtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_INStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_INStypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionPDVtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PDVtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_TSCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_TSCtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_ITtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_ITtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_DHStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_DHStypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionNHPtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NHPtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_ISStypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_ISStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionHFtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HFtypedentifier];
    //숏방
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionSBTtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SBTtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionSSLtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SSLtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionNTCHeaderBroadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NTCHeaderBroadIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionNTCHeaderBannerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_NIStypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionSCFtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCFtypedentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionB_CMtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:B_CMtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_SLD_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_SLD_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_SLD_GBBtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_SLD_GBBtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_SLD_C3_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_SLD_C3_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionTPSAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TPSAtypeIdentifier];
    //AI
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_MUT_CATEGORY_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_MUT_CATEGORY_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_MUT_H55_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_MUT_H55_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_H000_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_H000_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_H000_GBBtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_H000_GBBtypeIdentifier];
    //AD
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_IMG_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_IMG_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_SLD_GBCtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_SLD_GBCtypeIdentifier];
    //프로모션
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBA_1typeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBA_1typeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBA_2typeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBA_2typeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBA_3typeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBA_3typeIdentifier];
    //데이터없음
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionNODATAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NODATAtypeIdentifier];
    //TV쇼핑 2단
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_C2_GBATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_C2_GBAtypeIdentifier];
    //TV쇼핑 3단 테마키워드쇼핑
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_C3_GBATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_C3_GBAtypeIdentifier];
    //적립금
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_IMG_COLOR_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_IMG_COLOR_GBAtypeIdentifier];
    //GS X Brand 카테고리
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_CX_SLD_CATE_GBATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_CX_SLD_CATE_GBAtypeIdentifier];
    //이벤트 탭
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_CX_CATE_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_CX_CATE_GBAtypeIdentifier];
    //홈
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_TXT_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_TXT_GBAtypeIdentifier];
    //지금BEST 상단 텍스트 설명
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_CHK_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_CHK_GBAtypeIdentifier];
    //지금 BEST C2_GBB : Kiwon
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_C2_GBBTypeBaseCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_C2_GBBtypeBaseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_EXP_GBATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_EXP_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_EXP_GBA_OTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_EXP_GBA_OtypeIdentifier];
    
    
    //CSP 배너
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCSP_LOGIN_BAN_IMG_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CSP_LOGIN_BAN_IMG_GBAtypeIdentifier];
    
    // 서비스 매장 바로가기 영역
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_C5_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_C5_GBAtypeIdentifier];
    //베너
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_IMG_LNK_GBBtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_IMG_LNK_GBBtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_TXT_IMG_LNK_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_TXT_IMG_LNK_GBAtypeIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_1Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_1Cell"];
    
    /// kiwon : PRD_2
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_2Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_2Cell"];
    /// kiwon : PRD_C_B1Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_C_B1Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_C_B1Cell"];
    /// kiwon : PRD_C_SQCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_C_SQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_C_SQCell"];
    /// kiwon : PMO_T1_IMGCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T1_IMGCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T1_IMGCell"];
    /// kiwon : PMO_T1_PREVIEW_DCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T1_PREVIEW_DCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T1_PREVIEW_DCell"];
    /// kiwon : PMO_T1_PREVIEW_BCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T1_PREVIEW_BCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T1_PREVIEW_BCell"];
    /// kiwon : PRD_1_LISTCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_1_LISTCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_1_LISTCell"];
    /// kiwon : PMO_T2_IMGCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T2_IMGCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T2_IMGCell"];
    /// kiwon : PMO_T3_IMGCell
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T3_IMGCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T3_IMGCell"];
    /// kiwon : PMO_T2_PREVIEW
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T2_PREVIEWCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T2_PREVIEWCell"];
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T2_IMG_CCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T2_IMG_CCell"];
    //핑퐁 -> 홈매장 이사옴
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_SLD_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_SLD_GBAtypeIdentifier];
    /// kiwon : BAN_TXT_IMG_SLD_GBATypeCell
    [self.tableView registerNib:[UINib nibWithNibName:@"BAN_TXT_IMG_SLD_GBATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BAN_TXT_IMG_SLD_GBATypeCell"];
    /// kiwon : PRD_PAS_SQ (브랜드 개인화매장)
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_PAS_SQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_PAS_SQCell"];
    /// kiwon : BAN_MORE_GBA (브랜드 개인화매장 - 브랜드 더보기)
    [self.tableView registerNib:[UINib nibWithNibName:@"BAN_MORE_GBACell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BAN_MORE_GBACell"];
    /// kiwon : BAN_NO_PRD (브랜드 개인화매장 - 상품없음)
    [self.tableView registerNib:[UINib nibWithNibName:@"BAN_NO_PRDCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BAN_NO_PRDCell"];
    
    
    //GS X 브랜드 추천 그룹상단
    [self.tableView registerNib:[UINib nibWithNibName:@"PMO_T2_A_Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PMO_T2_A_Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GR_PMO_T2_MoreCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GR_PMO_T2_MoreCell"];
    
    
    //copy paste 시 주의 아래2개 셀 아님 HeaderFooterView 임 주의주의!
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionNSTFCMoreView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:NSTFCMoreIdentifier];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionarrdata count];
}

- (float) checkDivider:(NSString *) currentViewType nextIndexPos:(NSInteger) row {
    //divider 가변식 처리 로직 대상 : PRD_1_*, PRD_2, BRD_VOD
    float divider = 0;
    if(currentViewType.length > 0 && self.sectionarrdata.count > row) {
        NSString *nextViewType = NCS([[self.sectionarrdata objectAtIndex:row] objectForKey:@"viewType"]);
        if( ![currentViewType.uppercaseString isEqualToString:nextViewType.uppercaseString]) {
            divider = 10;
        }
    }
    return divider;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionarrdata.count <= indexPath.row ) {
        return [[UITableViewCell alloc] init];
    }
    
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    if([viewType  isEqualToString:@"I"]) {
        SectionEItypeCell *cell = [tableView dequeueReusableCellWithIdentifier:EItypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"TSL"]) {
        
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionTSLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TSLtypedentifier];
        
        cell.target = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"DSL_A"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionDSLAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:DSLAtypedentifier];
        cell.target = self;
        cell.isAutoRolling = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"DSL_A2"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionDSLAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:DSLAtypedentifier];
        cell.target = self;
        cell.isAutoRolling = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //텍스트가 있으면 높이 45 없으면 비율에 따라 변경(이미지) //cell내에서 하면.. reuse때 반영되어 초기에 깨지는 이문제가 있어 여기에서 처리함.
        cell.topHeight = [NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) length] > 0 ? 45 : [Common_Util DPRateOriginVAL:45.0] ;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"DSL_B"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionDSLBtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:DSLBtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"SUB_SEC"]) {
        DataTVCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBSECtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"SUB_SEC_LINE"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionSS_LINEtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SS_LINEtypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        return  cell;
        //B_IS 베너 형 이미지 1개 셀 기본 이미지 높이 50
    }
    else if([viewType  isEqualToString:@"B_IXS"]) {
        SectionBIXStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BIXStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        //B_IS 베너 형 이미지 1개 셀 기본 이미지 높이 50
    }
    else if([viewType  isEqualToString:@"B_IS"]) {
        SectionBIStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BIStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        //B_IM 베너 형 이미지 1개 셀 기본 이미지 높이 160
    }
    //    else if([viewType isEqualToString:@"B_IM"]) {
    //        SectionBIMtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BIMtypeIdentifier];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
    //        //NSLog(@"cellcellcellcell = %@",cell);
    //        return  cell;
    //        //B_IM440 베너 형 이미지 1개 셀 기본 이미지 높이 220
    //    }
    else if([viewType  isEqualToString:@"B_IM440"]) {
        SectionBIM440StypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BIM440typeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        //B_IL 베너 형 이미지 1개 셀 기본 이미지 높이
    }
    //    else if([viewType  isEqualToString:@"B_IL"]) {
    //        SectionBILtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BILtypeIdentifier];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
    //        return  cell;
    //        //B_IXL 베너 형 이미지 1개 셀 기본 이미지 높이
    //    }
    else if([viewType  isEqualToString:@"B_IXL"]) {
        SectionBIXLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BIXLtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        //B_IXL 베너 형 이미지 3개 셀 기본 첫번쨰 이미지 높이 240,116,116
    }
    else if([viewType  isEqualToString:@"B_MIA"]) {
        SectionBMIAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BMIAtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_SIS"]) {
        SectionBSIStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BSIStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        cell.autoRollingValue = [[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rollingDelay"] floatValue];
        [cell setCellInfoNDrawData:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"SL"]) {
        SectionPSLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:PSLtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]];
        return  cell;
    }
//    else if([viewType  isEqualToString:@"B_TS"]) {
//        SectionBTStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BTStypeIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
//        return  cell;
//    }
    else if([viewType  isEqualToString:@"ML"]) {
        NSString *strMyIdentifier = [NSString stringWithFormat:@"MLCellBestDeal_%lu",(long)indexPath.row];
        SectionDCMLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:strMyIdentifier];
        if ([dicNeedsToCellClear objectForKey:strMyIdentifier] != nil ) {
            if ([[dicNeedsToCellClear objectForKey:strMyIdentifier] isEqualToString:@"YES"]) {
                cell.isPlayed = NO;
                [dicNeedsToCellClear setObject:@"NO" forKey:strMyIdentifier];
                [cell stopMoviePlayer];
            }
        }
        
        if (cell == nil) {
            //재생중이던 동영상을 pause 하길 원함 reuse 하면 답안나와서 ReuseIdentifier 를 각각 생성및 관리 시도
            cell = [[SectionDCMLtypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMyIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //20171010 혜택태그를 표시하려면 높이값 25를 추가한다.
            if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"] count] <= 3)) {
                cell.benefitHeigth = BENEFITTAG_HEIGTH;
            }
            else {
                cell.benefitHeigth = 0;
            }
            [cell cellScreenDefine];
            [dicNeedsToCellClear setObject:@"NO" forKey:strMyIdentifier];
        }
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        //ML셀 스크롤 위치에따라 플레이 여부 컨트롤을 위한 또다른 저장
        [dicMLCellPlayControl setObject:indexPath forKey:strMyIdentifier];
        return  cell;
    }
    else if([viewType  isEqualToString:@"SPL"]) {
        SectionSPLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SPLtypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"SPC"]) {
        SectionSPCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SPCtypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"PC"]) {
        
        SectionPCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:PCtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        cell.hidden = NO;
        return  cell;
        
    }
    else if( [viewType  isEqualToString:@"B_HIM"]) {
        SectionB_HIMtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_HIMtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        NSArray *arrSubPrdList = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        if (NCA(arrSubPrdList) == YES && [arrSubPrdList count] > 0) {
            cell.hidden = NO;
        }
        else { //데이터가 없으니.. 안그림!!
            cell.hidden = YES;
        }
        
        return cell;
    }
    else if( [viewType  isEqualToString:@"B_IG4XN"]) {
        SectionB_IG4XNtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_IG4XNtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"TAB_SL"]) {
        SectionTAB_SLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TAB_SLtypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"BTL"]) {
        SectionBTLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BTLtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        
    }
    else if([viewType  isEqualToString:@"TCF"]) {
        SectionTCFtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TCFtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] andSeletedIndex:idxTCFCate];
        return  cell;
    }
    //20160501 parksegun
    else if( [viewType  isEqualToString:@"BFP"]) {
        SectionBFPtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BFPtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isBanImgC2GBB = NO;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        
    }
    else if( [viewType  isEqualToString:@"BAN_IMG_C2_GBB"]) {
        SectionBAN_IMG_C2_GBBTypeBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_C2_GBBtypeBaseIdentifier];
        baseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        baseCell.aTarget = self;
        if ([self.sectionarrdata count] - 1 == indexPath.row) {
            baseCell.isLastLine = YES;
        }else{
            baseCell.isLastLine = NO;
        }
        [baseCell setCellInfoNDrawData: [self.sectionarrdata objectAtIndex:indexPath.row]];
        return baseCell;
    }
    else if([viewType  isEqualToString:@"RPS"]) {
        SectionRPStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:RPStypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType isEqualToString:@"FPC"] || [viewType isEqualToString:@"FPC_P"] ) {
        SectionFPCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:FPCtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTDFCLIST]) {
            [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] andSeletedIndex:idxFPCCate andSeletedSubIndex:idxFPCCateSub andBgColor:@"FFFFFF" andItemViewColorOn:@"A4DE00" andItemViewColorOff:@"F4F4F4" andLineColor:@"FFFFFF"];
        }
        else {
            [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] andSeletedIndex:idxFPCCate andSeletedSubIndex:idxFPCCateSub andBgColor:@"FFFFFF" andItemViewColorOn:@"A4DE00" andItemViewColorOff:@"F4F4F4" andLineColor:@"FFFFFF"];
            
        }
        
        if (isFPC && CGRectEqualToRect(rectFPCCell, CGRectZero)) {
            
            if ([NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTDFCLIST]) {
                
                rectFPCCell = [self.tableView rectForRowAtIndexPath:indexPath];
                
                //셀이 최 상단이 아닐경우 기존의 타이틀 영역까지 스크롤
                if (indexPath.row != 0) {
                    rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y - 40.0, rectFPCCell.size.width, rectFPCCell.size.height - 10);
                }
                else {
                    //셀이 최상단 인덱스 0 일경우 리로드시 자기위치
                    rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y, rectFPCCell.size.width, rectFPCCell.size.height);
                }
            }
            else{
                rectFPCCell = [self.tableView rectForRowAtIndexPath:indexPath];
                rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y, rectFPCCell.size.width, rectFPCCell.size.height + 30.0);
            }
        }
        return  cell;
    }
    else if([viewType  isEqualToString:@"FPC_S"]) {
        SectionFPCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:FPCtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //FPC_S 타입 2016/11 추가됨
        cell.sectionViewTarget = (SectionView *)self.delegatetarget;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] andSeletedIndex:idxFPCCate andSeletedSubIndex:idxFPCCateSub andBgColor:@"FFFFFF" andItemViewColorOn:@"A4DE00" andItemViewColorOff:@"F4F4F4" andLineColor:@"FFFFFF"];
        
        if (isFPC && CGRectEqualToRect(rectFPCCell, CGRectZero)) {
            if ([NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTDFCLIST]) {
                rectFPCCell = [self.tableView rectForRowAtIndexPath:indexPath];
                //셀이 최 상단이 아닐경우 기존의 타이틀 영역까지 스크롤
                if (indexPath.row != 0) {
                    rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y - 40.0, rectFPCCell.size.width, rectFPCCell.size.height - 10);
                }
                else {
                    //셀이 최상단 인덱스 0 일경우 리로드시 자기위치
                    rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y, rectFPCCell.size.width, rectFPCCell.size.height);
                }
            }
            else {
                rectFPCCell = [self.tableView rectForRowAtIndexPath:indexPath];
                rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y, rectFPCCell.size.width, rectFPCCell.size.height + 30.0);
            }
        }
        return  cell;
    }
    else if( [viewType  isEqualToString:@"B_TS2"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionBTS2typeCell *cell = [tableView dequeueReusableCellWithIdentifier:BTS2typedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"TP_S"]) {
        SectionTPStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TPStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if( [viewType  isEqualToString:@"BP_O"]) {
        SectionBP_OtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BPOtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_INS"]) {
        SectionB_INStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_INStypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"PDV"]) {
        SectionPDVtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:PDVtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_TSC"]) {
        SectionB_TSCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_TSCtypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_IT"]) {
        SectionB_ITtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_ITtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_DHS"]) {
        SectionB_DHStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_DHStypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"HF"]) {
        SectionHFtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:HFtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] andSeletedIndex:idxHFCate andSearchResult:dicHFResult];
        if (isHFCell && CGRectEqualToRect(rectHFCell, CGRectZero)) {
            rectHFCell = [self.tableView rectForRowAtIndexPath:indexPath];
        }
        return  cell;
    }
    else if([viewType  isEqualToString:@"NHP"]) {
        SectionNHPtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NHPtypedentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellClick.tag = indexPath.row;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_ISS"]) {
        SectionB_ISStypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_ISStypeIdentifier];
        cell.target = self;
        cell.cellClick.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"B_CM"]) {
        SectionB_CMtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:B_CMtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if([viewType  isEqualToString:@"BAN_SLD_GBA"] ) {
        //BAN_SLD_GBA
        SectionBAN_SLD_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_SLD_GBAtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] index:indexPath.row];
        return  cell;
    }
    else if([viewType  isEqualToString:@"BAN_SLD_GBB"]) {
        //BAN_SLD_GBA
        SectionBAN_SLD_GBBtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_SLD_GBBtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] index:indexPath.row];
        return  cell;
    }
    else if([viewType  isEqualToString:@"MAP_SLD_C3_GBA"]) {
        //MAP_SLD_C3_GBA
        SectionMAP_SLD_C3_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_SLD_C3_GBAtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"TP_SA"] ) {
        SectionTPSAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TPSAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targettb = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_MUT_H55_GBA"] ) {
        SectionBAN_MUT_H55_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_MUT_H55_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if( [viewType isEqualToString:@"MAP_MUT_CATEGORY_GBA"] ) {
        SectionMAP_MUT_CATEGORY_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_MUT_CATEGORY_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] seletedIndex:idxFlexCateSelected];
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_SQUARE_GBA"] ) {
        SectionDCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:DCtypeIdentifier_S];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //20171010 혜택태그를 표시하려면 높이값 25를 추가한다.
        if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"] count] <= 3)) {
            cell.benefitHeigth = BENEFITTAG_HEIGTH;
        }
        else {
            cell.benefitHeigth = 0;
        }
        [cell cellScreenDefine];
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType] ) {
        SectionBAN_IMG_H000_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_H000_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] position:indexPath];
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_H000_GBB"] ) {
        SectionBAN_IMG_H000_GBBtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_H000_GBBtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] position:indexPath];
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_TXT_IMG_GBA"] ) {
        SectionBAN_TXT_IMG_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_TXT_IMG_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.path = indexPath;
        cell.target = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_SLD_GBC"] ) {
        SectionBAN_SLD_GBCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_SLD_GBCtypeIdentifier];
        cell.target = self;
        //cell.isAutoRolling = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBA_1"] ) {
        SectionMAP_CX_GBA_1typeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_GBA_1typeIdentifier];
        cell.target = self;
        cell.idxRow = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBA_2"] ) {
        SectionMAP_CX_GBA_2typeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_GBA_2typeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"isVisible"] isEqualToString:@"Y"]) {
            [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
            cell.hidden = NO;
        }
        else{
            cell.hidden = YES;
        }
        return  cell;
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBA_3"] ) {
        SectionMAP_CX_GBA_3typeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_GBA_3typeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"isOpen"] isEqualToString:@"Y"]) {
            [cell setOpen:YES];
        }
        else {
            [cell setOpen:NO];
        }
        cell.row_dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        cell.idxPath = indexPath;
        return  cell;
    }
    else if( [viewType isEqualToString:@"BAN_TXT_NODATA"] ){
        SectionNODATAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NODATAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_C2_GBA"] ) {
        SectionBAN_IMG_C2_GBATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_C2_GBAtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    else if( [viewType  isEqualToString:@"BAN_IMG_C3_GBA"]) {
        SectionBAN_IMG_C3_GBATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_C3_GBAtypeIdentifier];
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_TXT_IMG_COLOR_GBA"] ) {
        SectionBAN_TXT_IMG_COLOR_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_TXT_IMG_COLOR_GBAtypeIdentifier];
        //cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }
    // 이벤트 카테
    else if( [viewType isEqualToString:@"BAN_CX_CATE_GBA"] ) {
        SectionBAN_CX_CATE_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_CX_CATE_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (isCX_CATE && CGRectEqualToRect(rectCX_CATECell, CGRectZero)) {
            rectCX_CATECell = [self.tableView rectForRowAtIndexPath:indexPath];
            [cell addSubview:self.CX_CATEView];
        }
        return cell;
    }
    else if([viewType isEqualToString:@"BAN_CX_SLD_CATE_GBA"]) {
        SectionBAN_CX_SLD_CATE_GBATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_CX_SLD_CATE_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (isCX_SLD && CGRectEqualToRect(rectCX_SLDCell, CGRectZero)) {
            rectCX_SLDCell = [self.tableView rectForRowAtIndexPath:indexPath];
            [cell addSubview:self.CX_SLD_CATEView];
        }
        
        return  cell;
    }
    //개인화
    else if( [viewType isEqualToString:@"API_LOGIN_BAN_TXT_IMG_COLOR_GBA"] ) {
        //로그인이 아니면 노출 안함.
        SectionBAN_TXT_IMG_COLOR_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_TXT_IMG_COLOR_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targetTableView = self;
        cell.idxRow = indexPath.row;
        if(ApplicationDelegate.islogin) {
            cell.hidden = NO;
            [cell callApisetCellInfoDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
            return cell;
        }
        else {
            cell.hidden = YES;
            return cell;
        }
    }
    //개인화
    else if( [viewType isEqualToString:@"API_SUB_SEC_LINE"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionSS_LINEtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SS_LINEtypedentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell callApisetCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    }
    //CSP 배너
    else if([viewType isEqualToString:@"CSP_LOGIN_BAN_IMG_GBA"]) {
        SectionCSP_LOGIN_BAN_IMG_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CSP_LOGIN_BAN_IMG_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targetTableView = self;
        //cell.idxRow = indexPath.row;
        self.idxCSPbanner = indexPath.row;
        if(ApplicationDelegate.islogin) {
            cell.hidden = NO;
            if(ApplicationDelegate.objectCSP != nil && [ApplicationDelegate.objectCSP count] > 0) {
                //데이터 설정
                [cell setCellInfoNDrawData:ApplicationDelegate.objectCSP];
            }
            else {
                //트리거
                [cell callApisetCellInfoDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
            }
            return cell;
        }
        else {
            cell.hidden = YES;
            UITableViewCell *cellEmpty = [[UITableViewCell alloc] initWithFrame:CGRectZero];
            cellEmpty.backgroundColor = [UIColor clearColor];
            return cellEmpty;
        }
    }
    else if([viewType isEqualToString:@"MAP_CX_TXT_GBA"]) {
        SectionMAP_CX_TXT_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_TXT_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (NCA([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]) && [(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"] count] > 0) {
            cell.cardViewHeigth.constant = 76.0;
        }
        else {
            cell.cardViewHeigth.constant = 0.0;
        }
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        
        
        return cell;
    }
    else if([viewType isEqualToString:@"BAN_TXT_CHK_GBA"]) {
        SectionBAN_TXT_CHK_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_TXT_CHK_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] andIndex:indexPath.row];
        return cell;
    }
    else if([viewType isEqualToString:@"BAN_TXT_EXP_GBA"]) {
        if ( [NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"randomYn"]) isEqualToString:@"OPN"] ) {
            SectionBAN_TXT_EXP_GBA_OTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_TXT_EXP_GBA_OtypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.aTarget = self;
            cell.cellIndexPath = indexPath;
            [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
            
            return cell;
        }
        else {// 닫힌 기본형.
            SectionBAN_TXT_EXP_GBATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_TXT_EXP_GBAtypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.aTarget = self;
            cell.cellIndexPath = indexPath;
            [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
            
            return cell;
            
        }
    }
    else if([viewType isEqualToString:@"L"]) {
        SectionDCtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:DCtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //20171010 혜택태그를 표시하려면 높이값 25를 추가한다.
        if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"] count] <= 3)) {
            cell.benefitHeigth = BENEFITTAG_HEIGTH;
        }
        else {
            cell.benefitHeigth = 0;
        }
        // nami0342 - AB Test
        if(self.m_isABTest == YES)
        {
            cell.m_isApptimizeON = YES;
        }
        
        [cell cellScreenDefine];
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        cell.targettb = self;
        return cell;
        
    }
    else if([viewType isEqualToString:@"BAN_IMG_C5_GBA"]) {
        // 서비스 매장 바로가기
        SectionBAN_IMG_C5_GBAtypeCell * cell = [tableView dequeueReusableCellWithIdentifier: BAN_IMG_C5_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if([viewType isEqualToString:@"BAN_TXT_IMG_LNK_GBB"]) {
        SectionBAN_TXT_IMG_LNK_GBBtypeCell * cell = [tableView dequeueReusableCellWithIdentifier: BAN_TXT_IMG_LNK_GBBtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if([viewType isEqualToString:@"BAN_TXT_IMG_LNK_GBA"] || [viewType isEqualToString:@"B_TS"] ) {
        SectionBAN_TXT_IMG_LNK_GBAtypeCell * cell = [tableView dequeueReusableCellWithIdentifier: BAN_TXT_IMG_LNK_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.aTarget = self;
        [cell setCellInfoNDrawData_Product:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    // new UI
    else if([viewType isEqualToString:@"PRD_1_640"] || [viewType isEqualToString:@"PRD_1_550"]) {
        PRD_1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_1Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mTarget = self;        
        [cell setDivider:[self checkDivider:viewType nextIndexPos:indexPath.row+1] ];
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] mPath:indexPath];
        return cell;
    }
    else if ([viewType isEqualToString:@"PRD_1_LIST"]) {
        PRD_1_LISTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_1_LISTCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath: indexPath];
        [cell setDivider:[self checkDivider:viewType nextIndexPos:indexPath.row+1] ];
        return cell;
    }
    else if ([viewType isEqualToString:@"PRD_2"]) {
        PRD_2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_2Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        
        NSString *strNextViewType = @"";
        if ([self.sectionarrdata count] > indexPath.row+1) {
            NSDictionary *dicNext = [self.sectionarrdata objectAtIndex:indexPath.row+1];
            strNextViewType = NCS([dicNext objectForKey:@"viewType"]);
        }
        
        if ([strNextViewType isEqualToString:@"GR_PMO_T2_More"] == NO) {
            [cell setDivider: [self checkDivider:viewType nextIndexPos:indexPath.row+1]];
        }
        
        if (NCA([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"])) {
            [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath: indexPath];
        }
        return cell;
    }
    else if ([viewType isEqualToString:@"PRD_C_B1"]) {
        // PRD_C_B1Cell
        PRD_C_B1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_C_B1Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setDataList:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    }
    //개인화
    else if([viewType isEqualToString:@"API_SRL"] ||
            [viewType isEqualToString:@"PRD_C_SQ"] ||
            [viewType  isEqualToString:@"SRL"]) {
        PRD_C_SQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_C_SQCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        if ([viewType  isEqualToString:@"SRL"] || [viewType isEqualToString:@"PRD_C_SQ"]) {
            [cell setDataList:[self.sectionarrdata objectAtIndex:indexPath.row] ];
        } else {
            [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        }
        return cell;
    }
    else if ([viewType isEqualToString:@"PMO_T1_PREVIEW_B"]) {
        PMO_T1_PREVIEW_BCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMO_T1_PREVIEW_BCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath isNFXCType:NO];
        return cell;
    }
    else if ([viewType isEqualToString:@"PMO_T2_PREVIEW"]) {
        PMO_T2_PREVIEWCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PMO_T2_PREVIEWCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    }
    else if([viewType  isEqualToString:@"PMO_T2_IMG_C"] ) {
        //PMO_T2_IMG_C
        PMO_T2_IMG_CCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMO_T2_IMG_CCell"];
        cell.atarget = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
//        BAN_TXT_IMG_SLD_GBATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BAN_TXT_IMG_SLD_GBATypeCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath target:self];
        return  cell;
    }
    else if([viewType  isEqualToString:@"PMO_T2_A"] ) {
        //PMO_T2_A
        PMO_T2_A_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMO_T2_A_Cell"];
        cell.aTarget = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath isNFXCType:NO];
        return  cell;
    }
    else if([viewType  isEqualToString:@"GR_PMO_T2_More"] ) {
        GR_PMO_T2_MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GR_PMO_T2_MoreCell"];
        cell.aTarget = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        return  cell;
    }
    

    else if([viewType isEqualToString:@"BAN_IMG_SLD_GBA"]) {
        
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionBAN_IMG_SLD_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_SLD_GBAtypeIdentifier];
        cell.isAccessibilityElement = NO;
        cell.aTarget = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
        
    } else if([viewType containsString:@"BAN_MORE_GBA"]) {
        
        BAN_MORE_GBACell *cell = [tableView dequeueReusableCellWithIdentifier:@"BAN_MORE_GBACell"];
        cell.isAccessibilityElement = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        cell.aTarget = self;
        return cell;
        
    } else if([viewType isEqualToString:@"PRD_PAS_SQ"]) {
        PRD_PAS_SQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_PAS_SQCell"];
        cell.isAccessibilityElement = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        cell.aTarget = self;
        return cell;
        
    } else if([viewType isEqualToString:@"BAN_NO_PRD"]) {
        BAN_NO_PRDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BAN_NO_PRDCell"];
        cell.isAccessibilityElement = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else {
        NSLog(@"ViewType: %@", viewType)
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SListCell"];
        cell.frame = CGRectZero;
        return cell;
    }
}

- (void)tableCellRemove:(NSInteger)position {
    @try {
        @synchronized (self.sectionarrdata) {
            if ([self.sectionarrdata count] > position) {
            [self.sectionarrdata removeObjectAtIndex:position];
            NSIndexPath *path = [NSIndexPath indexPathForRow:position inSection:0];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: path] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"tableCellRemove Error: %@", exception);
        [ApplicationDelegate SendExceptionLog:exception];
    }
}

//데이터를 갱신
- (void)tableCellReload:(NSInteger)position {
    @try {
        @synchronized (self.sectionarrdata) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:position inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: path] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"tableCellRemove Error: %@", exception);
        [ApplicationDelegate SendExceptionLog:exception];
    }
}

//해당 위치에 높이를 갱신한다.
- (void)tableCellReloadForHeight:(NSString*)h indexPath:(NSIndexPath*)indexPath {
    NSInteger position = indexPath.row;
    @synchronized(self.sectionarrdata) {
        if([self.sectionarrdata isKindOfClass:NSMutableArray.class] && [self.sectionarrdata count] > position) {
                NSMutableDictionary *mut = [[self.sectionarrdata objectAtIndex:position] mutableCopy];
                [mut setObject:h forKey:CALCCELLHEIGHT];
                [self.sectionarrdata removeObjectAtIndex:position];
                [self.sectionarrdata insertObject:mut atIndex:position];
            [self tableCellReload:position];
        }
        
        //틀고정 매뉴들이 존재 할경우 위치 재조정 해준다
        if (isCX_SLD) {
            rectCX_SLDCell = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCX_SLD inSection:0]];
        }
        
        if (idxCX_CATE) {
            rectCX_CATECell = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCX_CATE inSection:0]];
        }
        
        if (isFPC) {
            if ([NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTDFCLIST]) {
                rectFPCCell = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxFPC inSection:0]];
                //셀이 최 상단이 아닐경우 기존의 타이틀 영역까지 스크롤
                if (idxFPC != 0) {
                    rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y - 40.0, rectFPCCell.size.width, rectFPCCell.size.height - 10);
                }
                else {
                    //셀이 최상단 인덱스 0 일경우 리로드시 자기위치
                    rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y, rectFPCCell.size.width, rectFPCCell.size.height);
                }
            }
            else{
                rectFPCCell = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxFPC inSection:0]];
                rectFPCCell = CGRectMake(rectFPCCell.origin.x, rectFPCCell.origin.y, rectFPCCell.size.width, rectFPCCell.size.height + 30.0);
            }
        }
        
        if (isHFCell) {
            rectHFCell = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxHF inSection:0]];
        }
    }
}

- (void)tableCellReloadForDic:(NSDictionary *)dic cellIndex:(NSIndexPath *)position {
    @synchronized (self.sectionarrdata) {
         if([self.sectionarrdata isKindOfClass:NSMutableArray.class] && [self.sectionarrdata count] > position.row) {
             [self.sectionarrdata removeObjectAtIndex:position.row];
             [self.sectionarrdata insertObject:dic atIndex:position.row];
             [self tableCellReload:position.row];
         }
    }    
}


//해당 위치의 데이터에 값을 변경한다.
- (void)tableDataUpdate:(NSObject *)value key:(NSString*)rkey cellIndex:(NSInteger)position {
    @synchronized(self.sectionarrdata) {
        if([self.sectionarrdata isKindOfClass:NSMutableArray.class] && [self.sectionarrdata count] > position) {
            NSMutableDictionary *mut = [[self.sectionarrdata objectAtIndex:position] mutableCopy];
            [mut setObject:value forKey:rkey];
            [self.sectionarrdata removeObjectAtIndex:position];
            [self.sectionarrdata insertObject:mut atIndex:position];
        }
    }
}
//찜? 전용
- (void)tableDataUpdateBool:(BOOL)value key:(NSString*)rkey cellIndex:(NSInteger)position viewType:(NSString *) type {
    @synchronized(self.sectionarrdata) {
        if([self.sectionarrdata isKindOfClass:NSMutableArray.class] && [self.sectionarrdata count] > position) {
            NSMutableDictionary *mut = [[self.sectionarrdata objectAtIndex:position] mutableCopy];
            NSNumber *numValue = [[NSNumber alloc] initWithBool:value];
            if( [type isEqualToString:@"PMO_T1_PREVIEW_B"] && NCA([mut objectForKey:@"subProductList"])) {
                [[((NSArray*)[mut objectForKey:@"subProductList"]) firstObject] setObject:numValue forKey:rkey];
            }
            else {
                [mut setObject:numValue forKey:rkey];
            }
            [self.sectionarrdata removeObjectAtIndex:position];
            [self.sectionarrdata insertObject:mut atIndex:position];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.sectioninfodata objectForKey:@"viewType"] == [NSNull null] || self.sectionarrdata.count <= indexPath.row) {
        return 0;
    }
    
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    
    if([viewType isEqualToString:@"I"]) {
        return [Common_Util DPRateOriginVAL:170];
    }
    else if([viewType  isEqualToString:@"B_IXS"]) {
        return [Common_Util DPRateOriginVAL:35] + 8.0;
    }
    else if([viewType  isEqualToString:@"B_IS"]) {
        return [Common_Util DPRateOriginVAL:50] + 8.0;
    }
    //    else if([viewType  isEqualToString:@"B_IM"]) { // 동적이미지 배너로 변경
    //        return [Common_Util DPRateOriginVAL:160] + 8.0;
    //    }
    else if([viewType  isEqualToString:@"E_W1"]) {
        return [Common_Util DPRateOriginVAL:160] + 8.0;
    }
    else if([viewType  isEqualToString:@"B_IM440"]) {
        return [Common_Util DPRateOriginVAL:220] + 8.0;
    }
    //    else if([viewType  isEqualToString:@"B_IL"]) { // 동적이미지 배너로 변경
    //        return [Common_Util DPRateOriginVAL:240] + 8.0;
    //    }
    else if([viewType  isEqualToString:@"B_IXL"]) {
        return [Common_Util DPRateOriginVAL:270] + 8.0;
    }
    else if([viewType  isEqualToString:@"B_MIA"]) {
        return 30.0 + [Common_Util DPRateOriginVAL:240] + 8.0;
    }
    else if([viewType  isEqualToString:@"B_SIS"]) {
        return [Common_Util DPRateOriginVAL:220] + 8.0;
    }
    else if([viewType  isEqualToString:@"SL"]){
        return 32 + [Common_Util DPRateVAL:172 withPercent:88];
    }
    else if([viewType  isEqualToString:@"B_TS"]) {
        return 56.0;
    }
    //TSL 타입 추가
    else if( [viewType  isEqualToString:@"TSL"]) {
        return [Common_Util DPRateOriginVAL:72.0] + [Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH + 10 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"DSL_A"]) {
        return [Common_Util DPRateOriginVAL:45.0] + [Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH + 10 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"DSL_A2"]) {
        
        //이미지 여부 체크
        CGFloat top = 45;
        NSString *productName = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"];
        //20180110 텍스트가 있으면 이미지보다 우선순위가 높이 노출됨. DSL_A일경우만.
        
        if([NCS(productName) length] > 0) {
            top = 45;
        }
        else {
            top = [Common_Util DPRateOriginVAL:45.0];
        }
        
        return top + [Common_Util DPRateOriginVAL:135.0] + 58.0 + 10 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"DSL_B"]) {
        return[Common_Util DPRateOriginVAL:45.0]+ [Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH + 10 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"SUB_SEC_LINE"]) {
        return 160 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"ML"]) {
        //20171010 혜택태그를 표시하려면 높이값 25를 추가한다.
        float benefitHeigth = 0;
        if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"] count] <= 3)) {
            benefitHeigth = BENEFITTAG_HEIGTH;
        }
        return [Common_Util DPRateOriginVAL:160] + 92 + benefitHeigth + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"SPL"]) {
        return [Common_Util DPRateOriginVAL:85.0] + 195 + 12 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"SPC"]) {
        return 220.0 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"PC"]) {
        return 185.0 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"B_HIM"]) {
        NSArray *arrSubPrdList = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        CGFloat heightDefault = HeightB_HIM_TOP;
        
        if (NCA(arrSubPrdList) == YES && [arrSubPrdList count] > 0) {
            NSDictionary *dicSubBanners = [arrSubPrdList objectAtIndex:0];
            NSArray *arrBanners = [dicSubBanners objectForKey:@"subProductList"];
            if (NCA(arrBanners)) {
                if ([arrBanners count] > 0) {
                    heightDefault = HeightB_HIM;
                }
            }
        }
        
        CGFloat heightBanners = 0.0;
        if (NCA(arrSubPrdList) == YES && [arrSubPrdList count] > 1) {
            NSDictionary *dicSubBanners = [arrSubPrdList objectAtIndex:1];
            NSArray *arrBanners = [dicSubBanners objectForKey:@"subProductList"];
            if (NCA(arrBanners)) {
                if ([arrBanners count] > 5) {
                    heightBanners = HeightB_HIMHBanner * 5;
                }
                else {
                    heightBanners = HeightB_HIMHBanner * ([arrBanners count]);
                }
            }
        }
        return heightDefault + heightBanners +kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"B_IG4XN"]) {
        @try {
            if(!NCO([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"])) {
                return 0;
            }
            
            NSArray *arrPrd = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
            CGFloat bottomHeight = 0.0;
            
            if (NCO([arrPrd objectAtIndex:0]) && [NCS([[arrPrd objectAtIndex:0] objectForKey:@"linkUrl"]) length]) {
                bottomHeight = 40.0;
            }
            
            NSInteger intMultifier = 0;
            if ([arrPrd count]-1 > 12) {
                intMultifier = 3;
            }
            else {
                intMultifier = ([arrPrd count]-1)/4;
            }
            return [Common_Util DPRateOriginVAL:60.0] + [Common_Util DPRateOriginVAL:86.0] *(([arrPrd count]-1)/4) + bottomHeight +kTVCBOTTOMMARGIN;
        }
        @catch (NSException *exception) {
            return 0.0;
        }
    }
    else if( [viewType  isEqualToString:@"TAB_SL"]) {
        return [Common_Util DPRateOriginVAL:65.0] + 195 + 12 +kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"BTL"]) {
        return ([Common_Util DPRateOriginVAL:62.0] + 20)*2 +kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"TCF"]) {
        NSArray *arrFPC = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        CGFloat heightViewDefault = kHEIGHTFPC * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
        return 35 + heightViewDefault +kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"RPS"]) {
        if(NCO(m_dicRPSs)) {
            NSString *strKey = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            if([NCS([m_dicRPSs objectForKey:strKey]) length] > 0) {
                return [NCS([m_dicRPSs objectForKey:strKey]) floatValue];
            }
        }
        else {
            NSArray *arrWords = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
            CGFloat widthLimit = APPFULLWIDTH - 20;
            CGFloat widthSum = 0.0;
            CGFloat heightReturn = 0.0;
            
            for (NSInteger i=0; i<[arrWords count]; i++) {
                if (i == 0) {
                    heightReturn = heightOneLine;
                }
                NSString *strWord = [NSString stringWithFormat:@"#%@",[[arrWords objectAtIndex:i] objectForKey:@"productName"]];
                CGSize totsize = [strWord MochaSizeWithFont: [UIFont systemFontOfSize:fontSizeRPS] constrainedToSize:CGSizeMake(APPFULLWIDTH - 20.0, heightOneLine) lineBreakMode:NSLineBreakByClipping];
                
                if ((widthSum+totsize.width+insideSearchWord*2.0) <= widthLimit) {
                    widthSum = widthSum +totsize.width+insideSearchWord*2.0;
                }
                else {
                    if ((totsize.width >= (APPFULLWIDTH - 20.0)) && widthSum == 0.0) {
                        widthSum = totsize.width;
                    }
                    else {
                        widthSum = totsize.width+insideSearchWord*2.0;
                        heightReturn = heightReturn + heightOneLine;
                    }
                }
                widthSum += intervalSearchWord;
            }
            return heightReturn + 43.0 + 15.0 + 5.0 + 10.0;
        }
    }
    else if([viewType isEqualToString:@"FPC"] || [viewType isEqualToString:@"FPC_P"]) {
        NSArray *arrFPC = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        CGFloat heightViewDefault = kHEIGHTFPC_S * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
        BOOL isValidSubSubList = NO;
        
        //베스트 매장의 대분류 아래의 서브 매장의 데이터와 ,promotionName 텍스트가 유효한지 검증
        if (NCA(arrFPC) && NCO([arrFPC objectAtIndex:idxFPCCate]) && NCA([[arrFPC objectAtIndex:idxFPCCate] objectForKey:@"subProductList"])) {
            NSArray *arrSubSubList = [[arrFPC objectAtIndex:idxFPCCate] objectForKey:@"subProductList"];
            if ([arrSubSubList count] > idxFPCCateSub) {
                if (NCO([arrSubSubList objectAtIndex:idxFPCCateSub]) && [NCS([(NSDictionary *)[arrSubSubList objectAtIndex:idxFPCCateSub] objectForKey:@"promotionName"]) length] > 0) {
                    isValidSubSubList = YES;
                }
            }
        }
        
        if (isValidSubSubList) {
            return 10 + heightViewDefault + 55.0 + kTVCBOTTOMMARGIN;
        }
        else {
            return 10 + heightViewDefault + 11.0 + kTVCBOTTOMMARGIN;
        }
    }
    else if([viewType  isEqualToString:@"FPC_S"]) {
        NSArray *arrFPC = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        CGFloat heightViewDefault = kHEIGHTFPC_S * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
        BOOL isValidSubSubList = NO;
        
        //베스트 매장의 대분류 아래의 서브 매장의 데이터와 ,promotionName 텍스트가 유효한지 검증
        if (NCA(arrFPC) && NCO([arrFPC objectAtIndex:idxFPCCate]) && NCA([[arrFPC objectAtIndex:idxFPCCate] objectForKey:@"subProductList"])) {
            NSArray *arrSubSubList = [[arrFPC objectAtIndex:idxFPCCate] objectForKey:@"subProductList"];
            if ([arrSubSubList count] > idxFPCCateSub) {
                if (NCO([arrSubSubList objectAtIndex:idxFPCCateSub]) && [NCS([(NSDictionary *)[arrSubSubList objectAtIndex:idxFPCCateSub] objectForKey:@"promotionName"]) length] > 0) {
                    isValidSubSubList = YES;
                }
            }
        }
        
        if (isValidSubSubList) {
            return 10 + heightViewDefault + 55.0 + kTVCBOTTOMMARGIN;
        }
        else {
            return 10 + heightViewDefault + 11.0 + kTVCBOTTOMMARGIN;
        }
    }
    
    
    //20160501 parksegun
    else if([viewType  isEqualToString:@"BFP"]) {
        return ((APPFULLWIDTH/2.0) - 15.0) + 109 + 4 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"BAN_IMG_C2_GBB"]) {
        return BAN_IMG_C2_GBB_HEIGHT;
    }
    
    else if([viewType  isEqualToString:@"B_TS2"]) {
        return 40.0;
    }
    else if([viewType  isEqualToString:@"TP_S"]) {
        return 282+kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"BP_O"]) {
        if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"] count] > 0)) {
            return [Common_Util DPRateOriginVAL:160] + 130 +kTVCBOTTOMMARGIN;
        }
        else {
            return [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN;
        }
    }
    else if([viewType  isEqualToString:@"B_INS"]) {
        return  [Common_Util DPRateOriginVAL:28.0];
    }
    else if([viewType  isEqualToString:@"PDV"]) {
        
        NSDictionary *dicRow = [self.sectionarrdata objectAtIndex:indexPath.row];
        NSArray *arrPDV = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        CGFloat calHeight;
        NSInteger rowCount = [arrPDV count];
        if (rowCount > 0) {
            CGFloat heightTitle = 10.0;
            if ([NCS([dicRow objectForKey:@"imageUrl"]) length] > 0 && [[dicRow objectForKey:@"imageUrl"] hasPrefix:@"http"]) {
                heightTitle = [Common_Util DPRateOriginVAL:40.0];
            }
            CGFloat fixedValue = (APPFULLWIDTH - 20.0)/2.0;
            calHeight = heightTitle+(fixedValue*rowCount) + 10.0 + kTVCBOTTOMMARGIN;
        }
        else {
            calHeight = 0.0;
        }
        return  calHeight;
    }
    else if([viewType  isEqualToString:@"B_TSC"]) {
        return  40.0;
    }
    else if([viewType  isEqualToString:@"B_IT"]) {
        if( NCO( [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"] ) == NO) {
            return 0;
        }
        
        NSArray *arrBIT = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        CGFloat heightTitle = 0.0;
        
        if([NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) length] > 0) {
            heightTitle = 40.0;
        }
        
        CGFloat calHeight;
        NSInteger rowCount = [arrBIT count]/2;
        
        if (rowCount > 0) {
            calHeight = heightTitle + 10 + ( (int)(((APPFULLWIDTH - 30.0)/2.0) * (27.0/29.0) + 10.0) * rowCount) + kTVCBOTTOMMARGIN;
        }
        else {
            calHeight = 0.0;
        }
        return  calHeight;
    }
    else if([viewType  isEqualToString:@"B_DHS"]) {
        return  20 + [Common_Util DPRateOriginVAL:38.0] + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"HF"]) {
        
        if( NCO( [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"] ) == NO) {
            return 0;
        }
        NSArray *arrHF = [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"];
        NSInteger limit = ([arrHF count]<kMaxCountHF)?[arrHF count]:kMaxCountHF;
        CGFloat heightViewDefault = kHEIGHTHF * (limit/kRowPerCountHF + ((limit%kRowPerCountHF>0)?1.0:0.0));
        if([dicHFResult count] > 0) {
            heightViewDefault = heightViewDefault + 32;
        }
        return 5+heightViewDefault +kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"NHP"]) {
        return  129 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"B_ISS"]) {
        return  40 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"B_CM"]) {
        return  45 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"BAN_SLD_GBA"] || [viewType isEqualToString:@"PMO_T2_IMG_C"]) {
        return  [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN;
//        return (264.0/375.0  * APPFULLWIDTH) + 10.0;
    }
    else if([viewType  isEqualToString:@"BAN_SLD_GBB"]) {
        return  [Common_Util DPRateOriginVAL:160] + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"MAP_SLD_C3_GBA"]) {
        return floor([Common_Util DPRateOriginVAL:218])+ floor([Common_Util DPRateOriginVAL:93]) + 100 + kTVCBOTTOMMARGIN;
    }
    else if([viewType  isEqualToString:@"TP_SA"]) {
        return 263 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"BAN_MUT_H55_GBA"] ) {
        return 55;
    }
    else if([viewType  isEqualToString:@"MAP_MUT_CATEGORY_GBA"]) {
        return 52 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType  isEqualToString:@"BAN_IMG_SQUARE_GBA"]) {
        //20171010 혜택태그를 표시하려면 높이값 25를 추가한다.
        float benefitHeigth = 0;
        if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"] count] <= 3)) {
            benefitHeigth = BENEFITTAG_HEIGTH;
        }
        //섹션디씨타입 정사각형 확장
        return (CGFloat)(roundf(APPFULLWIDTH*(2.0/3.0)) + 92.0 + benefitHeigth + kTVCBOTTOMMARGIN);
        
    }
    else if([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [viewType isEqualToString:@"BAN_IMG_H000_GBB"] || [self isPMOIMG:viewType]) {
        //높이값을 받아온다.// 가변형 이미지 베너
        float bannerHeigth = 0;
        NSDictionary *item = [self.sectionarrdata objectAtIndex:indexPath.row];
        //계산된 CALCCELLHEIGHT 가 있으면 이 값을 사용한다.
        if(NCO([item objectForKey:CALCCELLHEIGHT]) && ![NCS([item objectForKey:CALCCELLHEIGHT]) isEqualToString:@""]) {
            
            float h = [[item objectForKey:CALCCELLHEIGHT] floatValue];
            if(h <= 0) {
                h = [Common_Util DPRateOriginVAL:160];
            }
            return h + ( ([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType]) ? kTVCBOTTOMMARGIN : 0);
        }
        else {
            if(NCO([item objectForKey:@"height"]) && ![NCS([item objectForKey:@"height"]) isEqualToString:@""]) {
                bannerHeigth = [[item objectForKey:@"height"] floatValue] / 2;
                if(bannerHeigth <= 0) {
                    bannerHeigth = [Common_Util DPRateOriginVAL:160];
                }
            }
            else {
                bannerHeigth =  [Common_Util DPRateOriginVAL:160]; //20190423 parksegun QA요청으로 이미지가 없을경우 기본 높이 노출 - Android기본 너비 160에 비례
            }
            return  [Common_Util DPRateOriginVAL:bannerHeigth] + (([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType]) ? kTVCBOTTOMMARGIN : 0);
        }
    }
    else if( [viewType isEqualToString:@"BAN_TXT_IMG_GBA"] ) {
        // kiwon : 19. 11. 20 변경됨
        return 36.0;
    }
    else if( [viewType isEqualToString:@"BAN_SLD_GBC"] ) {
        return [Common_Util DPRateOriginVAL:135.0] + 58.0 + 18 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBA_1"] ) {
        return floor([Common_Util DPRateOriginVAL:160.0]);
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBA_2"] ) {
        if ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"isVisible"] isEqualToString:@"Y"]) {
            return floor([Common_Util DPRateOriginVAL:93] + 100);
        }
        else{
            return 0.0;
        }
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBA_3"] ) {
        return 5+45+kTVCBOTTOMMARGIN;
    }
    
    else if( [viewType isEqualToString:@"BAN_TXT_NODATA"] ) {
        return 170+60+56;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_C2_GBA"] ) {
        return ((APPFULLWIDTH/2.0) - 15.0) + 162 + 3 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_C3_GBA"] ) {
        return 196.0 + kTVCBOTTOMMARGIN;
    }
    else if( [viewType isEqualToString:@"BAN_TXT_IMG_COLOR_GBA"] ) {
        return 50.0 - kTVCBOTTOMMARGIN;
    }
    else if([viewType isEqualToString:@"BAN_CX_SLD_CATE_GBA"]) {
        
//        NSString *viewTypeNext = nil;
//
//        if ([self.sectionarrdata count] > indexPath.row +1) {
//            viewTypeNext = NCS([[self.sectionarrdata objectAtIndex:indexPath.row+1] objectForKey:@"viewType"]);
//        }
//
//        if ([viewTypeNext isEqualToString:@"BAN_TXT_CHK_GBA"]
//            || [viewTypeNext isEqualToString:@"BAN_IMG_C2_GBB"]
//            || [viewTypeNext isEqualToString:@"BAN_TXT_IMG_GBA"]) {
//            return 44.0;
//        }else {
            return 44.0;
//        }
        
    }
    // 이벤트 카테
    else if( [viewType isEqualToString:@"BAN_CX_CATE_GBA"] ) {
        return CX_CATE_HEIGHT + kTVCBOTTOMMARGIN;
    }
    //개인화
    else if( [viewType isEqualToString:@"API_LOGIN_BAN_TXT_IMG_COLOR_GBA"] ) {
        //로그인이 아니면 노출 안함.
        if(ApplicationDelegate.islogin) {
            CGFloat heightMod = 0.0;
            if (self.tableView.tableHeaderView.frame.size.height == 0.0) {
                heightMod = 10.0;
            }
            return heightMod + 50.0 - kTVCBOTTOMMARGIN;
        }
        else {
            return 0.0;
        }
    }
    //개인화
    else if( [viewType isEqualToString:@"API_SUB_SEC_LINE"]) {
        return 208 + 10;
    }
    else if([viewType isEqualToString:@"MAP_CX_TXT_GBA"]) {
        if (NCA([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]) && [(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"] count] > 0) {
            return 143 + kTVCBOTTOMMARGIN;
        }
        else {
            return 66 + kTVCBOTTOMMARGIN;
        }
    }
    else if([viewType isEqualToString:@"BAN_TXT_CHK_GBA"]) {
        return 36.0;
    }
    else if([viewType isEqualToString:@"BAN_TXT_EXP_GBA"]) {
        if ( [NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"randomYn"]) isEqualToString:@"OPN"] ) {
            return 53 + 240 + 44 + kTVCBOTTOMMARGIN ;
        }
        else {
            return 56 + 48 + kTVCBOTTOMMARGIN;
        }
    }
    //CSP 배너
    else if([viewType isEqualToString:@"CSP_LOGIN_BAN_IMG_GBA"]) {
        //로그인이 아니면 노출 안함.
        if(ApplicationDelegate.islogin) {
            //데이터를 가지고 있는가? 그렇다면 노출됨.
            if(ApplicationDelegate.objectCSP != nil && [ApplicationDelegate.objectCSP count] > 0) {
                //동적 이미지 적용, 이미지 다운로드 위치가 다름.
                UIImage *img = [ApplicationDelegate.objectCSP objectForKey:@"image"];
                if(NCO(img)) {
                    return [Common_Util imageRatioForHeight:img.size fullWidthSize:APPFULLWIDTH] + kTVCBOTTOMMARGIN;
                }
                else {
                    return 0.0;
                }
            }
            else {
                return 0.0;
            }
        }
        else {
            return 0.0;
        }
    }
    //else {
    else if([viewType isEqualToString:@"L"]) {
        //20171010 혜택태그를 표시하려면 높이값 25를 추가한다.
        float benefitHeigth = 0;
        if (NCA((NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"]) && ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"rwImgList"] count] <= 3)) {
            benefitHeigth = BENEFITTAG_HEIGTH;
        }
        //섹션디씨타입 SectionDCtypeCell
        return [Common_Util DPRateOriginVAL:160] + 92 + benefitHeigth + kTVCBOTTOMMARGIN;
    }
    else if([viewType isEqualToString:@"BAN_IMG_C5_GBA"]) {
        CGFloat titleHeight = 56.0;
        CGFloat bottomMargin = 10.0;
        //타이틀 노출조건 추가
        NSString *prdName = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]);
        NSString *prmName = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"promotionName"]);
        NSString *imgUrl = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"imageUrl"]);
        if(prdName.length > 0 || prmName.length > 0 || imgUrl.length > 0) {
            titleHeight = 56.0;
        }
        else {
            titleHeight = 0;
        }
        
        if (NCA([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"])) {
            if ([(NSArray *)[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"] count] == 2) {
                // 서비스 매장 바로가기 - 2개일때
                // 타이틀 56 + body 96 + 하단여백 10
                return titleHeight + 96.0 + bottomMargin;
            }
        }
        
        // 타이틀 56 + body 110.0 + 하단여백 10
        return titleHeight + 110.0 + bottomMargin;
    }
    else if([viewType isEqualToString:@"BAN_TXT_IMG_LNK_GBB"] || [viewType isEqualToString:@"BAN_TXT_IMG_LNK_GBA"]) {
        return 56;
    }
    // new UI
    else if([viewType isEqualToString:@"PRD_1_640"] || [viewType isEqualToString:@"PRD_1_550"]) {
        float bannerHeigth = 0;
        
        if([viewType isEqualToString:@"PRD_1_640"]) {
            bannerHeigth = (APPFULLWIDTH-32)/2;
        }
        else { //550대응
            bannerHeigth = APPFULLWIDTH-100;
        }
        
        NSDictionary *item = [self.sectionarrdata objectAtIndex:indexPath.row];

        
        
        // 12 + 24 + 4 + 24 + 8 + 20
        float infoHeigth = 91;
        NSArray *allBenefitArr = [item objectForKey:@"allBenefit"];
        bool isHaveBenefitText = NO;
        for (NSDictionary *benefit in allBenefitArr) {
            if (NCS([benefit objectForKey:@"text"]) && [[benefit objectForKey:@"text"] length] > 0) {
                isHaveBenefitText = true;
                break;
            }
        }
        
        if ( isHaveBenefitText || (NCO([item objectForKey:@"source"]) && [NCS([[item objectForKey:@"source"] objectForKey:@"text"]) length] > 0)) {
            //infoHeigth = 113;
            CGFloat cheigth = [[Common_Util attributedBenefitString:item widthLimit:APPFULLWIDTH-32 lineLimit:1] boundingRectWithSize:CGSizeMake(APPFULLWIDTH-32, 300) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            infoHeigth += cheigth;
        } else {
            // 혜택 없을때 20 + 8 - 16 = 12만큼 줄이기
            infoHeigth -= 12;
        }
        // 상단여백 16 + 배너높이 + infor높이 + 하단여백
        return ceil( 16 + bannerHeigth + infoHeigth + [self checkDivider:viewType nextIndexPos:indexPath.row+1] );
    }
    else if ([viewType isEqualToString:@"PRD_1_LIST"]) {
        
        // 기본높이 160 (159 + 하단라인 1포함)
        CGFloat height = 160;
        NSDictionary *dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        // 가격+할인율 위치에 따른 높이 판단
        CGFloat priceHeight = [[[UILabel alloc] setSalePriceAndRateWithDic:dic] size].height;
        
        // 혜택 유무 판단
        // 라벨 넚이 = 전체길이 - 이미지넓이 - 양쪽 여백 - 이미지/라벨간 여백
        CGFloat labelWidth = APPFULLWIDTH - 127 - (16 * 2) - 12;
        CGFloat benefitHeight = [[Common_Util attributedBenefitString:dic widthLimit:labelWidth lineLimit:2] size].height;
        
        // cell 높이가 기본높이보다 큰 경우 -> 가격높이가 2줄 (37값)이고, 혜택이 2줄(36값)일때,
        // 혜택높이가 1줄일때는 18pt , 2줄일때는 36pt
        if (benefitHeight > 0 && benefitHeight < 18.0) {
            benefitHeight = 18.0;
        }
        
        if (benefitHeight > 18 && benefitHeight < 36.0) {
            benefitHeight = 36.0;
        }
        
        if (priceHeight > 30 && benefitHeight > 18) {
            // 가격도 2줄, 혜택도 2줄인경우
            // 고정높이로 183 (182 + 하단라인 1포함)
            return 183 + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
        } else if (benefitHeight > 18) {
            NSString * addTextLeft = NCS([dic objectForKey:@"addTextLeft"]);
            NSString * addTextRight = NCS([dic objectForKey:@"addTextRight"]);
            if ([addTextLeft length] > 0 || [addTextRight length] > 0) {
                return height + 8 + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
            }
            return height + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
        }
        return height + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
    }
    else if ([viewType isEqualToString:@"PRD_2"]) {
        // 이미지 높이(전체 넓이 - 양쪽 side 32 - 중앙 margin 11)/2
        CGFloat imgHeight = (APPFULLWIDTH - (16 * 2) - 11) / 2;
        // 이미지 상단 16 + 이미지 하단 12 + 가격 23 + 할인율 14 + 여백 5 + 상품명 36 + 여백 8 + (상품평 20과 + 하단여백 17은 아래 로직에서 처리함 )
        CGFloat contentHeight = 16 + 12 + 23 + 14 + 5 + 36 + 8;
        CGFloat height = imgHeight + contentHeight + 1;
        // 혜택 유무 판단
        NSDictionary *dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        NSArray *subPrdList = [dic objectForKey:@"subProductList"];
        CGFloat benefitHeight = 0.0;
        CGFloat reviewHeight = 0.0;
        BOOL isHaveReview = false;
        
        if (NCA(subPrdList) && [subPrdList count] > 0) {
            for(NSDictionary *prdDic in subPrdList) {
                
                CGFloat tempHeight = 0.0;
                NSAttributedString *benefitAttributedStr = [Common_Util attributedBenefitString:prdDic widthLimit:imgHeight lineLimit:2];
                if (benefitAttributedStr.length > 0) {
                    tempHeight = benefitAttributedStr.size.height;
                }
                
                if (benefitHeight < tempHeight) {
                    benefitHeight = tempHeight;
                }
                
                NSString * addTextLeft = NCS([prdDic objectForKey:@"addTextLeft"]);
                NSString * addTextRight = NCS([prdDic objectForKey:@"addTextRight"]);
                if ([addTextLeft length] > 0 || [addTextRight length] > 0) {
                    isHaveReview = true;
                }
            }
        }
        
        // 혜택높이가 1줄일때는 18pt , 2줄일때는 36pt
        if (benefitHeight > 0 && benefitHeight < 18.0) {
            benefitHeight = 18.0;
        }
        
        if (benefitHeight > 18 && benefitHeight < 36.0) {
            benefitHeight = 36.0;
        }
        
        if (benefitHeight <= 0.0) {
            // 혜택뷰 하단이 9이며, 상품명 하단여백 8에서 1을 더해줘야 함.
            benefitHeight += 1;
        } else {
            // 혜택뷰 하단이 9
            benefitHeight += 9.0;
        }
        
        // 상품평 여부에 따른 높이 계산
        if (isHaveReview == true) {
             // (상품평 20과 + 하단여백 17 로직 )
            reviewHeight = 20.0 + 17.0;
        } else {
            // 하단여백 17.0 으로 맞춰야해서, 기본 8.0에다가 9.0을 더해줘야 함
            reviewHeight = 9.0;
        }
        
        NSString *strNextViewType = @"";
        if ([self.sectionarrdata count] > indexPath.row+1) {
            NSDictionary *dicNext = [self.sectionarrdata objectAtIndex:indexPath.row+1];
            strNextViewType = NCS([dicNext objectForKey:@"viewType"]);
        }
        if ([strNextViewType isEqualToString:@"GR_PMO_T2_More"]) {
            return height + benefitHeight + reviewHeight;
        }else{
            return height + benefitHeight + reviewHeight + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
        }
        
        
    }
    else if ([viewType isEqualToString:@"PRD_C_B1"]) {
        // 상단 Top 높이 + 캐로셀 상단여백 16  + 캐로셀 높이 251 + 하단여백 16 + 라인 1
        CGFloat titleHeight = 16.0;
        NSDictionary *dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        NSString *imgUrl = NCS([dic objectForKey:@"imageUrl"]);
        NSString *titleStr = NCS([dic objectForKey:@"productName"]);
        NSString *rtTypeStr = NCS([dic objectForKey:@"badgeRTType"]);
        NSString *moreBtnUrl = NCS([dic objectForKey:@"moreBtnUrl"]);
        // 타이틀 / 광고 / 더보깅에 따른 높이 변화...
        if ([titleStr length] > 0 || [imgUrl length] > 0) {
            // 상단여백 24, 라벨높이 24, 하단여백 16
            titleHeight = 56.0;
        }
        
        if ( ([rtTypeStr isEqualToString:@"MORE"] && [moreBtnUrl length] > 0) || [rtTypeStr isEqualToString:@"AD"] ) {
            titleHeight = 56.0;
        }
        
        
        // 상단 Top 높이 + 캐로셀 높이 249 + 하단여백 10
        CGFloat height = titleHeight + 249 + 10;
        return height;
    }
    else if ([viewType isEqualToString:@"PRD_C_SQ"]
             || [viewType isEqualToString:@"API_SRL"]
             || [viewType  isEqualToString:@"SRL"]) {
        // 타이틀도 있고, 하단 캐로셀 고정 고정값임
        // 상단 Top 높이 56 + 캐로셀 229
        return 56+247+10;
    }
    else if ([viewType isEqualToString:@"PMO_T1_PREVIEW_B"]) {
        // 화면 가로길이가 곧 높이 + 하단여백 10
        // 최대 값설정
        if(APPFULLWIDTH > 375) {
            return 375 + 10;
        }
        else {
            return APPFULLWIDTH + 10;
        }
    }
    else if ([viewType isEqualToString:@"PMO_T2_PREVIEW"]) {
        // 이미지 높이 + 캐로셀 87 + 하단여백 10
        return ((188.0 / 375.0) * APPFULLWIDTH) + 87.0 + 10.0;
    }
    else if ([viewType isEqualToString:@"PMO_T2_A"]) {
        // 이미지 높이
        return ((188.0 / 375.0) * APPFULLWIDTH);
    }
    else if ([viewType isEqualToString:@"GR_PMO_T2_More"]) {
        return 58.0;
    }
    
    else if([viewType  isEqualToString:@"BAN_IMG_SLD_GBA"]) {
        /// 타이틀 + 하단뷰 + 10 여백
        return 56 + 179 + 10;
    }
    else if([viewType  isEqualToString:@"PRD_PAS_SQ"]) {
        CGFloat titleHeight = 56.0;
        
         // 20.07.23 배포버전에서는 선호도 영역 제외
        NSDictionary *dicRow = [self.sectionarrdata objectAtIndex:indexPath.row];
        
        NSString *wishCntStr = NCS([dicRow objectForKey:@"wishCnt"]);
        if ([wishCntStr length] > 0) {
            titleHeight = 80.0;
        }
        
        return titleHeight + 247;
    }
    
    else if([viewType  containsString:@"BAN_MORE_GBA"]) {
        /// 기본높이 48 + 하단여백 10
        return 48 + 10;
    }
    
    else if([viewType  containsString:@"BAN_NO_PRD"]) {
        /// 기본높이 208 + 하단여백 10
        return 208 + 10;
    }
    else {
        return CGFLOAT_MIN;
    }
}

//PMO + B_IM, B_IL 이미지 베너인지 판단.
- (BOOL)isPMOIMG:(NSString *) veiwType {
    return ([veiwType isEqualToString:@"PMO_T1_IMG"] || [veiwType isEqualToString:@"PMO_T2_IMG"] || [veiwType isEqualToString:@"PMO_T3_IMG"] || [veiwType isEqualToString:@"B_IM"] || [veiwType isEqualToString:@"B_IL"]);
}


//DealCell 터치 전용
//tb delegate
- (void)touchEventDealCell:(NSDictionary *)dic {
    [delegatetarget touchEventTBCell:dic];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.sectionarrdata count] == 0 || self.sectionarrdata == nil || [self.sectionarrdata count] < indexPath.row) {
        return;
    }
    
    NSDictionary *secdic = [self.sectionarrdata objectAtIndex:indexPath.row];
    NSString *viewType = NCS([secdic objectForKey:@"viewType"]);
    
    
    // nami0342 - 2018.09.20 - API_SRL 추가 (타이틀 영역 클릭 시 제외처리)
    if ([viewType isEqualToString:@"DSL_A"] || [viewType isEqualToString:@"DSL_B"] ||
        [viewType isEqualToString:@"DSL_A2"] || [viewType isEqualToString:@"RPS"] ||
        [viewType isEqualToString:@"FPC"] || [viewType isEqualToString:@"BFP"] || [viewType isEqualToString:@"FPC_S"] ||
        [viewType isEqualToString:@"TCF"] || [viewType isEqualToString:@"B_INS"] ||
        [viewType isEqualToString:@"PDV"] ||
        [viewType isEqualToString:@"B_TSC"] || [viewType isEqualToString:@"B_IT"] ||
        [viewType isEqualToString:@"NHP"] ||  [viewType isEqualToString:@"B_ISS"] ||
        [viewType isEqualToString:@"API_SRL"] ||
        [viewType isEqualToString:@"API_SUB_SEC_LINE"] ||
        [viewType isEqualToString:@"MAP_CX_GBB_TITLE"] ||
        [viewType isEqualToString:@"MAP_CX_GBB_PRD"] ||
        [viewType isEqualToString:@"BAN_IMG_GSF_GBA"] ||
        [viewType isEqualToString:@"BAN_GSF_LOC_GBA"] ||
        [viewType isEqualToString:@"MAP_C8_SLD_GBA"] ||
        [viewType isEqualToString:@"BAN_TXT_EXP_GBA"]
        
        ) {
        return;
    }
    
    NSLog(@"연관추천AB : %@", [DataManager sharedManager].abBestdealVer);
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SectionDCMLtypeCell class]]) {
        if ([cell respondsToSelector:@selector(stopMoviePlayer)]) {
            SectionDCMLtypeCell *cellMv = (SectionDCMLtypeCell*)cell;
            [cellMv stopMoviePlayer];
        }
    }
    [delegatetarget touchEventTBCell:secdic];
    @try {
        NSString *prdno = nil;
        NSString *linkUrl = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]);
        if ([linkUrl length] == 0) {
            return;
        }
        URLParser *parser = [[URLParser alloc] initWithURLString:linkUrl];
        if([parser valueForVariable:@"dealNo"] != nil) {
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"dealNo"]];
        }
        else if([parser valueForVariable:@"prdid"] != nil) {
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"prdid"]];
        }
        else {
            prdno = @"";
        }
        
        if( [NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]) {
            BOOL isforevent  =   ([NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) length] > 1);
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@",[self.sectioninfodata objectForKey:@"sectionName"], prdno]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)indexPath.row ],  (isforevent)?[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"] ]  ];
        }
        else {
            BOOL isforevent  =   ([NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) length] > 1);
            NSLog(@"event productName nonExist: %i", isforevent);
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@%@", [self.sectioninfodata objectForKey:@"sectionName"],prdno]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", (int)indexPath.row ],  (isforevent)?[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"] ]  ];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
        
    }
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[SectionDCMLtypeCell class]]) {
        if ([cell respondsToSelector:@selector(stopMoviePlayer)]) {
            SectionDCMLtypeCell *cellMv = (SectionDCMLtypeCell*)cell;
            [cellMv stopMoviePlayer];
        }
        NSString *strMyIdentifier = [NSString stringWithFormat:@"MLCellBestDeal_%lu",(long)indexPath.row];
        [dicMLCellPlayControl removeObjectForKey:strMyIdentifier];
    }
    
    if( [NCS([self.sectioninfodata  objectForKey:@"navigationId"]) isEqualToString:@"54"] ) {
        if (self.sectionarrdata.count > indexPath.row) {
            NSString *strViewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
            if ([strViewType  isEqualToString:@"SRL"] || [strViewType isEqualToString:@"PRD_C_SQ"]) {
                isCheckPRD_C_SQ = NO;
                [self invaildatePRD_C_SQ];
            }
        }
    }
    
    
    //20160926 -타임딜의 타이머를 종료 시킨다. parksegun
    if ([cell isKindOfClass:[SectionDCtypeCell class]]) {
        if ([cell respondsToSelector:@selector(stopTimeDealTimer)]) {
            SectionDCtypeCell *cellDc = (SectionDCtypeCell*)cell;
            [cellDc stopTimeDealTimer];
        }
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //중복GA발송 막기 중복GTM허용 정책으로 fixmaxnum 사용하지 않음
    if(tbviewrowmaxNum <= indexPath.row) {
        tbviewrowmaxNum = (int)indexPath.row;
    }
    //GTM tracker 상하 스크롤중
    if( indexPath.row != 0 && (indexPath.row%25) == 0) {
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_App_%@_Impression", [self.sectioninfodata objectForKey:@"sectionName"] ]
                               withLabel:[NSString stringWithFormat:@"%ld", (long)indexPath.row]     ];
    }
    //20180220 페이징 처리 추가
    if( ajaxPageUrl.length > 0 ) {
        NSInteger idxLast = [self.sectionarrdata count] - 1;
        if(idxLast == 0 || (idxLast == indexPath.row && indexPath.row != 0) ) { // 끝지점 도착!!
            // 데이터 추가요청
            [self loadMoreDataUrl];
        }
    }
    
    if (self.sectionarrdata.count > indexPath.row) {
        NSString *strViewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
        if( [NCS([self.sectioninfodata  objectForKey:@"navigationId"]) isEqualToString:@"54"] ) {
            if ([strViewType  isEqualToString:@"SRL"] || [strViewType isEqualToString:@"PRD_C_SQ"]) {
                isCheckPRD_C_SQ = YES;
            }
        }
    }
    
    
    if ([@"Y" isEqualToString:PRD_NATIVE_YN] && [self.sectionarrdata count] > indexPath.row) {
       
        NSString *strLinkUrl = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]);
        
        if ([strLinkUrl hasPrefix:@"http"]) {
            NSURL *urlCheck = [NSURL URLWithString:strLinkUrl];
            URLParser *parser = [[URLParser alloc] initWithURLString:strLinkUrl];
            NSString *strId = @"";
            
            if ([urlCheck.path containsString:@"/prd/prd.gs"] && [urlCheck.query containsString:@"prdid="]) {
                strId = NCS([parser valueForVariable:@"prdid"]);
            }
            
            if ([NCS(strId) length] > 4){
                NSString *strPreloadPrdImageUrl = [Common_Util productImageUrlWithPrdid:strId withType:@"L1"];
                
                [ImageDownManager blockImageDownWithURL:strPreloadPrdImageUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if (error == nil) {
                        
                    }
                }];
            }
        }
    }
    
}

- (void)loadMoreDataUrl {
    NSString *apiURL = [Mocha_Util strReplace:[NSString stringWithFormat:@"%@/",SERVERURI] replace:@"" string:NCS(ajaxPageUrl)];
    apiURL =  [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
    [ApplicationDelegate onloadingindicator];
    if(self.currentOperation1 != nil){
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    
    // nami0342 - urlsession
    //치명
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              dispatch_async( dispatch_get_main_queue(),^{
                                                                                  if (result != nil) {
                                                                                      if(NCA([result objectForKey:@"productList"])) {
                                                                                          [sectionorigindata removeAllObjects];
                                                                                          sectionorigindata = [result objectForKey:@"productList"];
                                                                                          ajaxPageUrl = NCS([result objectForKey:@"ajaxfullUrl"]);
                                                                                          [self sectionarrdataNeedMoreData:HOLDRELOADING];
                                                                                      }
                                                                                      else {
                                                                                          // 더이상 로딩 하지 않음.
                                                                                          ajaxPageUrl = @"";
                                                                                      }
                                                                                  }
                                                                                  else {
                                                                                      // 더이상 로딩 하지 않음.
                                                                                      ajaxPageUrl = @"";
                                                                                  }
                                                                                  [ApplicationDelegate offloadingindicator];
                                                                              }
                                                                                             );
                                                                          }
                                                                               onError:^(NSError *error) {
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                               }];
}


- (void)BannerCellPress {
    @try {
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_%@_Banner", [self.sectioninfodata  objectForKey:@"sectionName"] ]
                               withLabel:  [ [self.apiResultDic objectForKey:@"banner"] objectForKey:@"linkUrl" ]
         ];
    }
    @catch (NSException *exception) {
        NSLog(@"BannerCellPress Exception: %@", exception);
    }
    @finally {
        
    }
    [delegatetarget touchEventBannerCell:[self.apiResultDic objectForKey:@"banner"] ];
}


-(void)TopCategoryTabButtonClicked:(id)sender {
    [delegatetarget  TopCategoryTabButtonClicked:sender];
}


- (void)dctypetouchEventTBCell:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr {
    //브랜드관, 넘베딜, 그룹매장 상단 쩜쩜쩜 셀 클릭시
    [delegatetarget touchEventTBCell:dic];
    if( [cstr isEqualToString:@"LiveBroad"]  || [cstr isEqualToString:@"DataBroad"] ) {
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_NextTV",
                                              [self.sectioninfodata  objectForKey:@"sectionName"],
                                              ([cstr isEqualToString:@"LiveBroad"] )?@"생방송":@"데이터 홈쇼핑" ]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", [cnum intValue]],  [dic  objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    else if(  [cstr isEqualToString:@"SUB_SEC"] ) {
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_데이터 홈쇼핑_Category", [self.sectioninfodata objectForKey:@"sectionName"]]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@",   [NSString stringWithFormat:@"%d", [cnum intValue]], [dic objectForKey:@"linkUrl" ] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    else if( [cstr isEqualToString:@"TSLBACKGROUND"] ) { //
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], @"TSL" ]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@",  [NSString stringWithFormat:@"%d", [cnum intValue]],  [dic  objectForKey:@"linkUrl"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    else if( [cstr isEqualToString:@"TSL"] ) { //테마딜셀 개별
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    else if(  [cstr isEqualToString:@"SRL"] ) { //추천셀 개별
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    else if([cstr isEqualToString:@"SPLBACKGROUND"]) { //슬라이드 프로그램 배경
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_생방송_%@", [self.sectioninfodata  objectForKey:@"sectionName"], @"SPL" ]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@",  [NSString stringWithFormat:@"%d", [cnum intValue]],  [dic  objectForKey:@"linkUrl"]  ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    else if( [cstr isEqualToString:@"SPL"] ) {//슬라이드 프로그램 상품
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_생방송_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    //추천셀 개별
    else if(  [cstr isEqualToString:@"SPC"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_생방송_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    //추천셀 개별
    else if(  [cstr isEqualToString:@"PC"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_생방송_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"B_HIM"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_생방송_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"DSL_A2"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"B_IG4XN"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [DataManager sharedManager].abBulletVer , [dic  objectForKey:@"productName"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"BTL"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr hasPrefix:@"TAB_SL"]){ // 전달값이 하나 모자라서 hasPrefix 체크후 파싱
        NSArray *arrParam = [cstr componentsSeparatedByString:@"||"];
        @try {
            
            NSString *strLable = nil;
            
            if ([cnum integerValue]> 0) {
                strLable = [NSString stringWithFormat:@"%@_%@_%@_%@", [DataManager sharedManager].abBulletVer ,[arrParam objectAtIndex:1], [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ];
            }else{
                strLable = [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer ,[arrParam objectAtIndex:1], [dic  objectForKey:@"productName"] ];
            }
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], [arrParam objectAtIndex:0] ]
             
                                   withLabel:strLable];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr hasPrefix:@"RPS"]){ // 실시간 인기 검색어
        
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    
    
    else if(  [cstr isEqualToString:@"BFP"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"NHP"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], [dic  objectForKey:@"prdid"]  ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"productName"] ]
             ];
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"B_ISS"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr  ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    
    else if(  [cstr isEqualToString:@"NALBANG_LIVE"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], @"Main_Live" ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [DataManager sharedManager].abBulletVer , NCS([dic  objectForKey:@"promotionName"]) ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    else if(  [cstr isEqualToString:@"NALBANG_LIVE_TALK"]){
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"], @"Main_Live_NalTalk" ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], [dic  objectForKey:@"linkUrl"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
    }
    
    
    else {
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_Main_%@", [self.sectioninfodata  objectForKey:@"sectionName"], cstr ]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", [cnum intValue]], ([cstr isEqualToString:@"Main_WeeklyBestDealNo1"])?[dic  objectForKey:@"linkUrl"]:[dic  objectForKey:@"productName"] ]
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
        
    }
    
    
    
    
}



//화면 전환시 CELL 컨트롤

- (void)reconfigureVisibleCells
{
    NSLog(@"DSL_A 타입 셀 다시 autoScroll");
    
    NSInteger sectionCount = [self numberOfSectionsInTableView:self.tableView];
    for (NSInteger section = 0; section < sectionCount; ++section) {
        NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:section];
        
        for (NSInteger row = 0; row < rowCount; ++row) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell != nil) {
                
                if ([cell isKindOfClass:[SectionDSLAtypeCell class]]) {
                    SectionDSLAtypeCell *autoScrollCell = (SectionDSLAtypeCell *)cell;
                    [autoScrollCell autoScrollCarousel];
                }
                /* 자동롤링 */
                else if ([cell isKindOfClass:[SectionDSLBtypeCell class]]) {
                    SectionDSLBtypeCell *autoScrollCell = (SectionDSLBtypeCell *)cell;
                    [autoScrollCell autoScrollCarousel];
                }
                else if ([cell isKindOfClass:[SectionTSLtypeCell class]]) {
                    SectionTSLtypeCell *autoScrollCell = (SectionTSLtypeCell *)cell;
                    [autoScrollCell autoScrollCarousel];
                }
                else if ([cell isKindOfClass:[SectionBAN_SLD_GBBtypeCell class]]) {
                    SectionBAN_SLD_GBBtypeCell *autoScrollCell = (SectionBAN_SLD_GBBtypeCell *)cell;
                    [autoScrollCell.cell autoScrollCarousel];
                }
                
                else if ([cell isKindOfClass:[SectionDCMLtypeCell class]]) {
                    
                    if ([cell respondsToSelector:@selector(checkPlayStateAndResume)]) {
                        SectionDCMLtypeCell *cellMv = (SectionDCMLtypeCell*)cell;
                        
                        CGRect onlyMovieRect = CGRectMake(cellMv.frame.origin.x, cellMv.frame.origin.y, cellMv.frame.size.width,cellMv.productImageView.frame.size.height);
                        
                        CGRect cellRect = [self.tableView convertRect:onlyMovieRect toView:self.tableView.superview];
                        
                        if (CGRectContainsRect(self.tableView.frame, cellRect)){
                            if ([cellMv nowPlayingRate] != 1.0 && cellMv.isSendPlay==NO) {
                                cellMv.isSendPlay = YES;
                                [cellMv checkPlayStateAndResume];
                            }
                        }
                    }
                    
                    
                }
                //20160926 parksegun 화면에 다시 그려질때 다시 타이머를 실행한다.
                else if ([cell isKindOfClass:[SectionDCtypeCell class]]) {
                    if ([cell respondsToSelector:@selector(startTimeDealTimer)])
                    {
                        SectionDCtypeCell *cellDc = (SectionDCtypeCell*)cell;
                        [cellDc startTimeDealTimer];
                    }
                    
                }
                
                //                else if (self.isExistADCategory == YES && [cell isKindOfClass:[SectionBAN_TXT_IMG_GBAtypeCell class]]) {
                //                    if ([cell respondsToSelector:@selector(onBtnHideToolTips)])
                //                    {
                //                        SectionBAN_TXT_IMG_GBAtypeCell *cellDc = (SectionBAN_TXT_IMG_GBAtypeCell*)cell;
                //                        [cellDc onBtnHideToolTips];
                //                    }
                //                }
                //20190402 parksegun 그룹코드 있으면 갱신
                else if ([NCS(ApplicationDelegate.groupCode) length] > 0 && ([cell isKindOfClass:[SectionBAN_CX_SLD_CATE_GBATypeCell class]] || self.CX_SLD_CATEView != nil)) {
                    [self.CX_SLD_CATEView subCategoryMoveWithGroupCode];
                    [self.tableView scrollsToTop];
                }//else if
            }
        }
    }
}



//홈메인에서 색션이 바뀔 경우 자동 재생중이던 베딜 동영상을 무조건 pause
- (void)homeSectionChangedPauseDealVideo {
    NSInteger sectionCount = [self numberOfSectionsInTableView:self.tableView];
    for (NSInteger section = 0; section < sectionCount; ++section) {
        NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:section];
        
        for (NSInteger row = 0; row < rowCount; ++row) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell != nil) {
                
                if ([cell isKindOfClass:[SectionDCMLtypeCell class]]) {
                    
                    if ([cell respondsToSelector:@selector(stopMoviePlayer)]) {
                        SectionDCMLtypeCell *cellMv = (SectionDCMLtypeCell*)cell;
                        [cellMv stopMoviePlayer];
                    }
                    
                }
                
                //20160926 -타임딜의 타이머를 종료 시킨다. parksegun
                /*
                 적용 예정
                 */
                if ([cell isKindOfClass:[SectionDCtypeCell class]]) {
                    if ([cell respondsToSelector:@selector(stopTimeDealTimer)]) {
                        SectionDCtypeCell *cellDc = (SectionDCtypeCell*)cell;
                        [cellDc stopTimeDealTimer];
                    }
                }
                
            }
        }
    }
}


- (void)onBtnFPCCate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr{
    
    NSString *strFPCApiUrl = nil;
    NSArray *arrApi = [[dic objectForKey:@"linkUrl"] componentsSeparatedByString:@".gsshop.com/"];
    
    if ([arrApi count]> 1) {
        strFPCApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strFPCApiUrl = [arrApi objectAtIndex:0];
    }
    //카테고리를 누르면 페이징URL 초기화
    ajaxPageUrl = @"";
    [ApplicationDelegate onloadingindicator];
    //NSDictionary *result = [NSDictionary dictionary];
    //FPC_P이면 기존 FPC를 그냥 유지한다.
    //새로 받아온 데이터의 productList에 FPC_P를 추가한다.
    if( [NCS([dicFPCInfo objectForKey:@"viewType"]) isEqualToString:@"FPC_P"] ) {
        // nami0342 - urlsession
        self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:strFPCApiUrl
                                                                           isForceReload:YES
                                                                            onCompletion:^(NSDictionary *result) {
                                                                                ajaxPageUrl = NCS([result objectForKey:@"ajaxfullUrl"]); //페이징 처리
                                                                                [self selectFPCCategory:[cnum integerValue] withDic:result];
                                                                                [ApplicationDelegate offloadingindicator];
                                                                            }
                                                                                 onError:^(NSError* error) {
                                                                                     NSLog(@"COMM ERROR");
                                                                                     [ApplicationDelegate offloadingindicator];
                                                                                 }];
        
    }
    else {
        // nami0342 - urlsession
        self.currentOperation1 =  [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:strFPCApiUrl
                                                                            isForceReload:YES
                                                                             onCompletion:^(NSDictionary *result) {
                                                                                 NSLog(@"result = %@",result);
                                                                                 [self selectFPCCategory:[cnum integerValue] withDic:result];
                                                                                 [ApplicationDelegate offloadingindicator];
                                                                             }
                                                                                  onError:^(NSError* error) {
                                                                                      NSLog(@"COMM ERROR");
                                                                                      [ApplicationDelegate offloadingindicator];
                                                                                  }];
    }
}


- (void)selectFPCCategory:(NSInteger)index withDic:(NSDictionary *)dicAll {
    if(idxFPCCate == index) {
        return;
    }
    idxFPCCateSub = 0;
    NSArray *arrProduct = [dicAll objectForKey:@"productList"];
    BOOL isFoundFPC = NO;
    
    if(NCA(arrProduct)) {
        idxFPCCate = index;
        [sectionorigindata removeAllObjects];
        sectionorigindata = [arrProduct mutableCopy];
        //FPC를 유지한채로 삭제
        if([self.sectionarrdata count] > idxFPC+1) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange(idxFPC+1, [self.sectionarrdata count] -idxFPC -1 )];
        }
        
        for(NSInteger i=0; i<[arrProduct count]; i++) {
            NSDictionary *dicRow = [arrProduct objectAtIndex:i];
            //FPC_P의 데이터에는 FPC_P의 뷰타입을 포함하지 않으니 기존유지된 값을 그대로 사용한다. FPC의 이름이 바뀌어도 갱신할수 없다.
            if([NCS([dicFPCInfo objectForKey:@"viewType"]) isEqualToString:@"FPC_P"]) {
                [self.sectionarrdata addObject:dicRow];
            }
            else {
                if (isFoundFPC) {
                    [self.sectionarrdata addObject:dicRow];
                }
                //가지고온 데이터에 FPC가 있으면 갱신한다.
                if([NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC"] || [NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC_S"]) {
                    //베스트 매장 카테고리 존재 유무
                    [dicFPCInfo removeAllObjects];
                    [dicFPCInfo addEntriesFromDictionary:dicRow];
                    isFoundFPC = YES;
                }
                else if([NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"RPS"]) {
                    NSArray *arrWords = [[arrProduct objectAtIndex:i] objectForKey:@"subProductList"];
                    [self calcRPSHeightSubListArr:arrWords andIndex:i];
                }
            }
        }
    }
    
    [self.tableView reloadData];
    [self checkFPCMenu];
}



- (void)onBtnFPCCateSub:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr {
    
    NSString *strFPCApiUrl = nil;
    NSArray *arrApi = [[dic objectForKey:@"linkUrl"] componentsSeparatedByString:@".gsshop.com/"];
    if ([arrApi count]> 1) {
        strFPCApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strFPCApiUrl = [arrApi objectAtIndex:0];
    }
    
    [ApplicationDelegate onloadingindicator];
    //무조건 새로고침
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:strFPCApiUrl
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              NSLog(@"result = %@",result);
                                                                              [self selectFPCSubCategory:[cnum integerValue] withDic:result];
                                                                              [ApplicationDelegate offloadingindicator];
                                                                          }
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                               }];
}

//이벤트 매장에서 사용할 한줄짜리 틀고정 탭메뉴
- (void)onBtnCX_Cate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr {
    NSString *strCX_ApiUrl = nil;
    NSArray *arrApi = [[dic objectForKey:@"linkUrl"] componentsSeparatedByString:@".gsshop.com/"];
    if ([arrApi count]> 1) {
        strCX_ApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strCX_ApiUrl = [arrApi objectAtIndex:0];
    }
    
    [ApplicationDelegate onloadingindicator];
    
    //무조건 새로고침
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:strCX_ApiUrl
                                                                       isForceReload:YES
                                                                        onCompletion:^(NSDictionary *result) {
                                                                            NSLog(@"result = %@",result);
                                                                            //ajaxPageUrl = NCS([result objectForKey:@"ajaxfullUrl"]); //페이징 처리
                                                                            idxCX_SelectCate = [cnum integerValue];
                                                                            [self selectCXCategory:[cnum integerValue] withDic:result];
                                                                            [ApplicationDelegate offloadingindicator];
                                                                        }
                                                                             onError:^(NSError* error) {
                                                                                 NSLog(@"COMM ERROR");
                                                                                 [ApplicationDelegate offloadingindicator];
                                                                             }];
}

- (void)selectCXCategory:(NSInteger)index withDic:(NSDictionary *)dicAll {
    idxCX_SelectCate = index;
    NSArray *arrProduct = [dicAll objectForKey:@"productList"];
    if(NCA(arrProduct)) {
        [sectionorigindata removeAllObjects];
        sectionorigindata = [arrProduct mutableCopy];
        //제거
        if([self.sectionarrdata count] > (idxCX_CATE + 1) ) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange( idxCX_CATE + 1, [self.sectionarrdata count] - idxCX_CATE - 1 )];
        }
        
        for (NSInteger i=0; i<[sectionorigindata count]; i++) {
            if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"RPS"]) {
                NSArray *arrWords = [[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"];
                [self calcRPSHeightSubListArr:arrWords andIndex:i];
                NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
                [self.sectionarrdata addObject:dicRow];
            }
            // 20180319 parksegun - 더보기 있는 셀
            else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"MAP_CX_GBA"]) {
                //MAP_CX_GBA는 MAP_CX_GBA_1, MAP_CX_GBA_2, MAP_CX_GBA_3으로 나뉨 MAP_CX_GBA_2가 가변영역임.
                NSArray *dicCx = [[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"];
                NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
                [dic1 addEntriesFromDictionary:[dicCx objectAtIndex:0]];
                [dic1 removeObjectForKey:@"subProductList"];
                [dic1 setObject:@"MAP_CX_GBA_1" forKey:@"viewType"];
                [self.sectionarrdata addObject:dic1];
                NSArray *arrSub = [[dicCx objectAtIndex:0] objectForKey:@"subProductList"];
                float viewCount = 0.0;
                if([arrSub count] > 0) {
                    viewCount = [arrSub count]/3;
                    viewCount += ([arrSub count]%3 != 0) ? 1 : 0;
                    NSInteger lenPos = 0;
                    for(NSInteger vCn = 0; vCn < viewCount ; vCn++) {
                        NSMutableDictionary *dicSub = [[NSMutableDictionary alloc] init];
                        [dicSub setObject:@"MAP_CX_GBA_2" forKey:@"viewType"];
                        [dicSub setObject:(vCn==0)?@"Y":@"N" forKey:@"isVisible"];
                        NSInteger cnt = (arrSub.count-lenPos)>3?3:(arrSub.count-lenPos);
                        [dicSub setObject:[arrSub subarrayWithRange:NSMakeRange(lenPos, cnt)] forKey:@"subProductList"];
                        lenPos += cnt;
                        [self.sectionarrdata addObject:dicSub];
                    }
                }
                //3
                NSMutableDictionary *dicEnd = [[NSMutableDictionary alloc] init];
                [dicEnd setObject:@"MAP_CX_GBA_3" forKey:@"viewType"];
                //1줄만 노출될경우 더보기 아닌 브랜드 바로가기
                [dicEnd setObject:(viewCount > 1)?@"Y":@"N" forKey:@"isOpen"];
                [dicEnd setObject:[NSString stringWithFormat:@"%ld",(long)viewCount] forKey:@"subPrdCount"];
                [dicEnd setObject:[dic1 objectForKey:@"linkUrl"] forKey:@"linkUrl"];
                [self.sectionarrdata addObject:dicEnd];
            }
            
            else {
                [self.sectionarrdata addObject:[sectionorigindata objectAtIndex:i]];
            }
        }
    }//if
    else { //0개인가..
        //제거
        if([self.sectionarrdata count] > (idxCX_CATE + 1) ) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange( idxCX_CATE + 1, [self.sectionarrdata count] - idxCX_CATE - 1 )];
        }
    }
    [self checkFPCMenu];
    [self.tableView reloadData];
    //check 필요여부 확인
    SectionBAN_CX_CATE_GBAtypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCX_CATE inSection:0]];
    if (![[[cell subviews] lastObject] isKindOfClass:[SectionBAN_CX_CATE_GBASubView class]]) {
        [cell addSubview:self.CX_CATEView];
    }
}



- (void)onBtnCX_SLDCate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr{
    
    NSString *strCX_SLDApiUrl = nil;
    NSArray *arrApi = [[dic objectForKey:@"linkUrl"] componentsSeparatedByString:@".gsshop.com/"];
    if ([arrApi count]> 1) {
        strCX_SLDApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strCX_SLDApiUrl = [arrApi objectAtIndex:0];
    }
    
    NSLog(@"strCX_SLDApiUrlstrCX_SLDApiUrl = %@",strCX_SLDApiUrl);
    
    [ApplicationDelegate onloadingindicator];
    //무조건 새로고침
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:strCX_SLDApiUrl
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              NSLog(@"result = %@",result);
                                                                              
                                                                              
                                                                              ajaxPageUrl = NCS([result objectForKey:@"ajaxfullUrl"]); //페이징 처리
                                                                              idxCX_SLDCate = [cnum integerValue];
                                                                              [self selectCX_SLDCategory:[cnum integerValue] withDic:result];
                                                                              
                                                                              [ApplicationDelegate offloadingindicator];
                                                                          }
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                               }];
    
}




- (void)selectCX_SLDCategory:(NSInteger)index withDic:(NSDictionary *)dicAll {
    
    NSLog(@"[self.sectionarrdata count] = %ld",(long)[self.sectionarrdata count]);
    
    if([self.sectionarrdata count] > idxCX_SLD+1) {
        
        
        [self.sectionarrdata removeObjectsInRange:NSMakeRange(idxCX_SLD + 1, [self.sectionarrdata count] - idxCX_SLD -1 )];
        
        
        //[self.sectionarrdata removeAllObjects];
    }
    
    
    if(NCA([dicAll objectForKey:@"productList"])) {
        
        NSArray *arrProduct = [dicAll objectForKey:@"productList"];
        
        idxCX_SLDCate = index;
        [sectionorigindata removeAllObjects];
        sectionorigindata = [arrProduct mutableCopy];
        
        NSLog(@"self.sectionarrdata  count =%ld",(long)[self.sectionarrdata count]);
        for (NSInteger i=0; i<[sectionorigindata count]; i++) {
            if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"MAP_MUT_CATEGORY_GBA"]) {
                idxFlexCate = i;
                [self.sectionarrdata addObject:[sectionorigindata objectAtIndex:i]];
            }
            else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"RPS"]) {
                NSArray *arrWords = [[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"];
                [self calcRPSHeightSubListArr:arrWords andIndex:i];
                NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
                [self.sectionarrdata addObject:dicRow];
            }
            // 20180319 parksegun - 더보기 있는 셀
            else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"MAP_CX_GBA"]) {
                //MAP_CX_GBA는 MAP_CX_GBA_1, MAP_CX_GBA_2, MAP_CX_GBA_3으로 나뉨 MAP_CX_GBA_2가 가변영역임.
                NSArray *dicCx = [[sectionorigindata objectAtIndex:i] objectForKey:@"subProductList"];
                NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
                [dic1 addEntriesFromDictionary:[dicCx objectAtIndex:0]];
                [dic1 removeObjectForKey:@"subProductList"];
                [dic1 setObject:@"MAP_CX_GBA_1" forKey:@"viewType"];
                [self.sectionarrdata addObject:dic1];
                
                NSArray *arrSub = [[dicCx objectAtIndex:0] objectForKey:@"subProductList"];
                float viewCount = 0.0;
                if([arrSub count] > 0) {
                    viewCount = [arrSub count]/3;
                    viewCount += ([arrSub count]%3 != 0) ? 1 : 0;
                    NSInteger lenPos = 0;
                    for(NSInteger vCn = 0; vCn < viewCount ; vCn++) {
                        NSMutableDictionary *dicSub = [[NSMutableDictionary alloc] init];
                        [dicSub setObject:@"MAP_CX_GBA_2" forKey:@"viewType"];
                        [dicSub setObject:(vCn==0)?@"Y":@"N" forKey:@"isVisible"];
                        NSInteger cnt = (arrSub.count-lenPos)>3?3:(arrSub.count-lenPos);
                        [dicSub setObject:[arrSub subarrayWithRange:NSMakeRange(lenPos, cnt)] forKey:@"subProductList"];
                        lenPos += cnt;
                        [self.sectionarrdata addObject:dicSub];
                    }
                }
                
                //3
                NSMutableDictionary *dicEnd = [[NSMutableDictionary alloc] init];
                [dicEnd setObject:@"MAP_CX_GBA_3" forKey:@"viewType"];
                //1줄만 노출될경우 더보기 아닌 브랜드 바로가기
                [dicEnd setObject:(viewCount > 1)?@"Y":@"N" forKey:@"isOpen"];
                [dicEnd setObject:[NSString stringWithFormat:@"%ld",(long)viewCount] forKey:@"subPrdCount"];
                [dicEnd setObject:[dic1 objectForKey:@"linkUrl"] forKey:@"linkUrl"];
                [self.sectionarrdata addObject:dicEnd];
            }
            
            else if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"GR_PMO_T2"]) {
                NSDictionary *dicReorder = [sectionorigindata objectAtIndex:i];
                [self reorderGR_PMO_T2:dicReorder toAddArray:self.sectionarrdata];
            }
            else {
                [self.sectionarrdata addObject:[sectionorigindata objectAtIndex:i]];
            }
            
        }
        
        
        NSLog(@"self.sectionarrdata  count =%ld",(long)[self.sectionarrdata count]);
    }
    
    [self checkFPCMenu];
    [self.tableView reloadData];
    
    SectionBAN_CX_SLD_CATE_GBATypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCX_SLD inSection:0]];
    if (![[[cell subviews] lastObject] isKindOfClass:[SectionBAN_CX_SLD_CATE_GBASubView class]]) {
        [cell addSubview:self.CX_SLD_CATEView];
    }
}

- (void)selectFPCSubCategory:(NSInteger)index withDic:(NSDictionary *)dicAll {
    
    NSArray *arrProduct = [dicAll objectForKey:@"productList"];
    BOOL isFoundFPC = NO;
    if(NCA(arrProduct)) {
        idxFPCCateSub = index;
        [sectionorigindata removeAllObjects];
        sectionorigindata = [arrProduct mutableCopy];
        if([self.sectionarrdata count] > idxFPC+1) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange(idxFPC + 1, [self.sectionarrdata count] - idxFPC -1 )];
        }
        
        for (NSInteger i=0; i<[arrProduct count]; i++) {
            NSDictionary *dicRow = [arrProduct objectAtIndex:i];
            
            if (isFoundFPC) {
                [self.sectionarrdata addObject:dicRow];
            }
            
            if([NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC"] || [NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC_S"] || [NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"FPC_P"]) {
                //베스트 매장 카테고리 존재 유무
                [dicFPCInfo removeAllObjects];
                [dicFPCInfo addEntriesFromDictionary:dicRow];
                isFoundFPC = YES;
            }
            else if([NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"RPS"]) {
                NSArray *arrWords = [[arrProduct objectAtIndex:i] objectForKey:@"subProductList"];
                [self calcRPSHeightSubListArr:arrWords andIndex:i];
            }
        }
    }
    
    [self.tableView reloadData];
    [self checkFPCMenu];
}


- (void)setFPCSubCateView:(SectionBestSubCate *)viewSubCate {
    [viewSubCate setCellInfoNDrawData:dicFPCInfo andSeletedIndex:idxFPCCate andSeletedSubIndex:idxFPCCateSub];
}


- (void)selectLiveBestCategory:(NSInteger)index {
    
    if (idxTCFCate == index) {
        return;
    }
    idxTCFCate = index;
    NSDictionary *dicRow = [sectionorigindata objectAtIndex:idxTCF];
    if ([self.sectionarrdata count] > idxTCF+1) {
        [self.sectionarrdata removeObjectsInRange:NSMakeRange(idxTCF+1, [self.sectionarrdata count] -idxTCF -1 )];
    }
    
    if (NCA([dicRow objectForKey:@"subProductList"])) {
        if (NCA([[[dicRow objectForKey:@"subProductList"] objectAtIndex:idxTCFCate] objectForKey:@"subProductList"])) {
            [self.sectionarrdata addObjectsFromArray:[[[dicRow objectForKey:@"subProductList"] objectAtIndex:idxTCFCate] objectForKey:@"subProductList"]];
        }
    }
    [self.tableView reloadData];
}


/*AI매장 틀고정 없는 하위만 변하는 한줄짜리 카테고리*/
- (void)onBtnFlexCate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr {
    
    NSString *strApiUrl = nil;
    NSArray *arrApi = [[dic objectForKey:@"linkUrl"] componentsSeparatedByString:@".gsshop.com/"];
    if ([arrApi count]> 1) {
        strApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strApiUrl = [arrApi objectAtIndex:0];
    }
    [ApplicationDelegate onloadingindicator];
    //무조건 새로고침
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:strApiUrl
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              [self selectFlexCategory:[cnum integerValue] withDic:result];
                                                                              [ApplicationDelegate offloadingindicator];
                                                                          }
                                                                               onError:^(NSError* error) {
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                               }];
}




- (void)selectFlexCategory:(NSInteger)index withDic:(NSDictionary *)dicAll {
    
    if (idxFlexCateSelected == index) {
        return;
    }
    idxFlexCateSelected = index;
    BOOL isFoundFlex = NO;
    NSArray *arrProduct = [dicAll objectForKey:@"productList"];
    if(NCA(arrProduct)) {
        [sectionorigindata removeAllObjects];
        sectionorigindata = [arrProduct mutableCopy];
        //제거
        if([self.sectionarrdata count] > (idxFlexCate + 1) ) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange( idxFlexCate + 1, [self.sectionarrdata count] - idxFlexCate - 1 )];
        }
        
        for (NSInteger i = 0; i < [arrProduct count]; i++) {
            NSDictionary *dicRow = [arrProduct objectAtIndex:i];
            if(isFoundFlex) {
                [self.sectionarrdata addObject:dicRow];
            }
            if([NCS([[arrProduct objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"MAP_MUT_CATEGORY_GBA"] ) {
                //베스트 매장 카테고리 존재 유무
                isFoundFlex = YES;
            }
        }
    }//if
    [self.tableView reloadData];
}

- (void)onBtnBAN_TXT_CHK_GBA:(NSDictionary *)dic andIndex:(NSInteger)index{
    
    NSString *strApiUrl = nil;
    NSString *strLinkUrl = nil;
    NSArray *arrStrLinkUrl = [NCS([dic objectForKey:@"linkUrl"]) componentsSeparatedByString:@"isAllView="];
    
    if ([arrStrLinkUrl count] > 1) {
        NSMutableString *strAllView = [[NSMutableString alloc] initWithString:[arrStrLinkUrl objectAtIndex:1]];
        if ([strAllView hasPrefix:@"false"]) {
            [strAllView setString:[strAllView stringByReplacingOccurrencesOfString:@"false" withString:@"true"]];
        }else if ([strAllView hasPrefix:@"true"]) {
            [strAllView setString:[strAllView stringByReplacingOccurrencesOfString:@"true" withString:@"false"]];
        }
        strLinkUrl = [NSString stringWithFormat:@"%@isAllView=%@",[arrStrLinkUrl objectAtIndex:0],strAllView];
    }
    
    NSArray *arrApi = [strLinkUrl componentsSeparatedByString:@".gsshop.com/"];
    
    if ([arrApi count]> 1) {
        strApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strApiUrl = [arrApi objectAtIndex:0];
    }
    
    [ApplicationDelegate onloadingindicator];
    
    
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:strApiUrl
                                                                       isForceReload:YES
                                                                        onCompletion:^(NSDictionary *result) {
                                                                            
                                                                            [ApplicationDelegate offloadingindicator];
                                                                            
                                                                            
                                                                            
                                                                            [self changeBAN_TXT_CHK_GBA:index withDic:result];
                                                                            
                                                                            
                                                                            
                                                                        }
                                                                             onError:^(NSError* error) {
                                                                                 NSLog(@"COMM ERROR");
                                                                                 [ApplicationDelegate offloadingindicator];
                                                                             }];
    
    
}

- (void)changeBAN_TXT_CHK_GBA:(NSInteger)index withDic:(NSDictionary *)dicAll {
    
    if([self.sectionarrdata count] > index+1) {
        [self.sectionarrdata removeObjectsInRange:NSMakeRange(index+1, [self.sectionarrdata count] -index -1 )];
    }
    
    
    if (NCA([dicAll objectForKey:@"productList"]) == YES) {
        
        NSArray *arrProduct = [dicAll objectForKey:@"productList"];
        
        NSMutableDictionary *dicToChange = [[NSMutableDictionary alloc] init];
        [dicToChange addEntriesFromDictionary:[self.sectionarrdata objectAtIndex:index]];
        
        NSArray *arrStrLinkUrl = [NCS([dicToChange objectForKey:@"linkUrl"]) componentsSeparatedByString:@"isAllView="];
        
        if ([arrStrLinkUrl count] > 1) {
            NSMutableString *strAllView = [[NSMutableString alloc] initWithString:[arrStrLinkUrl objectAtIndex:1]];
            if ([strAllView hasPrefix:@"false"]) {
                [strAllView setString:[strAllView stringByReplacingOccurrencesOfString:@"false" withString:@"true"]];
            }else if ([strAllView hasPrefix:@"true"]) {
                [strAllView setString:[strAllView stringByReplacingOccurrencesOfString:@"true" withString:@"false"]];
            }
            
            NSString *strLinkUrl =[NSString stringWithFormat:@"%@isAllView=%@",[arrStrLinkUrl objectAtIndex:0],strAllView] ;
            
            [dicToChange setObject:strLinkUrl forKey:@"linkUrl"];
        }
        
        [self.sectionarrdata replaceObjectAtIndex:index withObject:dicToChange];
        
        if(NCA(arrProduct)) {
            [self.sectionarrdata addObjectsFromArray:arrProduct];
        }
    }
    
    
    
    [self.tableView reloadData];
    
}

#pragma mark - Table refresh action


- (void)refresh {
    TVCapirequestcount = 0;

    NSLog(@"self.viewHeaderMobileLive = %@",self.viewHeaderMobileLive);
    
    if (self.viewHeaderMobileLive !=nil) {
        [self.viewHeaderMobileLive stopTimer];
        //        [self.viewHeaderMobileLive removeFromSuperview];
        //        self.viewHeaderMobileLive = nil;
    }
    
    if (self.viewHeaderLive !=nil) {
        //[self.viewHeaderLive stopMoviePlayer];
        [self.viewHeaderLive stopTimer];
        //        [self.viewHeaderLive removeFromSuperview];
        //        self.viewHeaderLive = nil;
    }
    
    if (self.viewHeaderMyShop !=nil) {
        //[self.viewHeaderMyShop stopMoviePlayer];
        [self.viewHeaderMyShop stopTimer];
        //        [self.viewHeaderMyShop removeFromSuperview];
        //        self.viewHeaderMyShop = nil;
    }
    
    idxFPCCate = 0;
    idxFPCCateSub = 0;
    idxTCFCate = 0;
    idxFlexCate = 0;
    idxFlexCateSelected = 0;
    rectFPCCell = CGRectZero;
    
    [delegatetarget tablereloadAction];
    
    
    
}

- (void)reloadAction {
    
    [self invaildatePRD_C_SQ];
    
    [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
    [self tableFooterDraw];
    //self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
    NSArray *allKeys = [dicNeedsToCellClear allKeys];
    for (NSInteger i=0; i<[allKeys count]; i++) {
        [dicNeedsToCellClear setObject:@"YES" forKey:[allKeys objectAtIndex:i]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDEALVIDEOALLKILL object:nil userInfo:nil];
    animtbindex = -1;
    [self.tableView reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0f];
}





//검색필터용 mutableCopy 사용하자

- (void)filteredApiResultDicforHome:(NSInteger)cateindex {
    if(self.apiResultDic == nil) {
        return;
    }
    
    if(sectionorigindata == nil) {
        sectionorigindata = [[NSMutableArray alloc] init];
    }
    else {
        [sectionorigindata removeAllObjects];
    }
    sectionorigindata  = [[self.apiResultDic  objectForKey:@"productList"] mutableCopy];
    NSDictionary* tdcs;
    
    if(cateindex == CURRENT_SECTION_INDEXDNUM) {
        tdcs = [[[self.apiResultDic  objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] objectAtIndex: ((SectionView*)delegatetarget).currentCateinfoindex];
        cateindex = ((SectionView*)delegatetarget).currentCateinfoindex;
    }
    else {
        tdcs = [[[self.apiResultDic  objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] objectAtIndex:cateindex];
    }
    
    if(self.sectionarrdata == nil) {
        self.sectionarrdata = [[NSMutableArray alloc] init];
    }
    else {
        [self.sectionarrdata removeAllObjects];
    }
    
    
    //전체일경우
    if(cateindex == 0) {
        animtbindex = -1;
        tbviewrowmaxNum = 0;
        [self sectionarrdataNeedMoreData:FULLRELOADING];
    }
    else {
        NSArray* trr = [tdcs objectForKey:@"categoryNo"];
        NSString* tmppredstr;
        for (int i=0; i<[trr count]; i++) {
            
            if(i == 0) {
                tmppredstr = [NSString stringWithFormat:@"cateGb MATCHES[c] \"%@\"", [trr objectAtIndex:i ] ];
            }
            else {
                tmppredstr = [NSString stringWithFormat:@"%@ or cateGb MATCHES[c] \"%@\"", tmppredstr, [trr objectAtIndex:i ] ];
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:tmppredstr ];
        [sectionorigindata filterUsingPredicate:predicate];
        
        animtbindex = -1;
        tbviewrowmaxNum = 0;
        
        [self sectionarrdataNeedMoreData:FULLRELOADING];
    }
}



//그룹매장 - 메인딜용
- (NSMutableArray*)orderprocforfilter:(NSMutableArray*)dataSet ordertype:(SECTIONORDERTYPE)otype subcateidx:(NSInteger)cateindex {
    
    //전체일경우
    if(cateindex == 0) {
        
        if((SECTIONORDERTYPE)otype == NEWEST) {
            NSSortDescriptor *publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"startDtm"  ascending:NO];
            [dataSet sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];
        }
        else if((SECTIONORDERTYPE)otype == POPULARHIGH) {
            
            if ([self.sectionType isEqualToString:@"L"]) {
                return [[self.apiResultDic objectForKey:@"largeSectDealList"]   objectForKey:@"groupDealList" ];
            }
            else if ([self.sectionType isEqualToString:@"D"]) {
                return [[self.apiResultDic objectForKey:@"groupDealInfo"]   objectForKey:@"groupDealList"];
            }
        }
    }
    else {
        
        //dataset 총 array에서 먼저 섹션정보매칭 추출 후 필터적용
        NSDictionary* tdcs;
        
        if(cateindex== CURRENT_SECTION_INDEXDNUM) {
            tdcs = [[[self.apiResultDic  objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] objectAtIndex: ((SectionView*)delegatetarget).currentCateinfoindex];
        }
        else {
            tdcs = [[[self.apiResultDic  objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] objectAtIndex:cateindex];
        }
        
        NSArray* trr = [tdcs objectForKey:@"categoryNo"];
        NSString* tmppredstr;
        for (int i=0; i<[trr count]; i++) {
            if(i==0) {
                tmppredstr = [NSString stringWithFormat:@"categoryNo MATCHES[c] \"%@\"", [trr objectAtIndex:i ] ];
            }
            else {
                tmppredstr = [NSString stringWithFormat:@"%@ or categoryNo MATCHES[c] \"%@\"", tmppredstr, [trr objectAtIndex:i ] ];
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:tmppredstr ];
        [dataSet filterUsingPredicate:predicate];
        
        if((SECTIONORDERTYPE)otype == NEWEST) {
            NSSortDescriptor *publishedSorter;
            publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"startDtm"  ascending:NO];
            [dataSet sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];
        }
        else if((SECTIONORDERTYPE)otype == POPULARHIGH) {
            return dataSet;
        }
    }
    
    return dataSet;
}




-(void)transform:(float)angle x:(float)x y:(float)y z:(float)z inView:(UIView*)View {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angle * M_PI / 2, x, y, z);
    View.layer.transform = rotationAndPerspectiveTransform;
    View.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
}


//
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [scrollExpandingDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [super scrollViewDidScroll:scrollView];
    [delegatetarget customscrollViewDidScroll:(UIScrollView *)scrollView];
    [scrollExpandingDelegate scrollViewDidScroll:scrollView];
    
    if( [NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTTCLIST] ) {
        NSIndexPath *trri = [self.tableView indexPathForRowAtPoint:CGPointMake(0, self.scrollBarLabel.frame.origin.y+22) ];
        if( (long)trri.row == 0.0f ) {
            self.scrollBarLabel.strdata1 =[NSString stringWithFormat:@""];
            self.scrollBarLabel.strdata2 =[NSString stringWithFormat:@""];
            //layer 위치 변경 필수
            [self.view bringSubviewToFront:self.scrollBarLabel];
            [self.scrollBarLabel setDisplayed:NO animated:NO afterDelay:0.0f];
            
            if(scrollView.contentOffset.y < (scrollView.frame.size.height/4)) {
                [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:0.0f];
            }
            else {
                [self.delegatetarget setbtnTopDisplayed:YES  animated:YES afterDelay:0.0f];
            }
        }
        else {
            self.scrollBarLabel.strdata1 = [NSString stringWithFormat:@"%ld", (long)trri.row + 2];
            self.scrollBarLabel.strdata2 = [NSString stringWithFormat:@"%ld", (unsigned long)[sectionorigindata count] + 1];
            //layer 위치 변경 필수
            [self.view bringSubviewToFront:self.scrollBarLabel];
            
            if(scrollView.contentOffset.y < (scrollView.frame.size.height/4)) {
                [self.scrollBarLabel setDisplayed:NO animated:NO afterDelay:0.0f];
                [self.delegatetarget setbtnTopDisplayed:NO  animated:NO afterDelay:0.0f];
            }
            else {
                [self.scrollBarLabel setDisplayed:YES animated:YES afterDelay:0.0f];
                [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:0.0f];
            }
        }
        [self.scrollBarLabel adjustPositionForScrollView:scrollView];
        
    }
    
    if( [NCS([self.sectioninfodata  objectForKey:@"navigationId"]) isEqualToString:@"54"] ) {
        if (isCheckPRD_C_SQ) {
            NSArray *arrVisibleCells = [self.tableView visibleCells];
            for (NSInteger i=0; i<[arrVisibleCells count]; i++) {
                if ([[arrVisibleCells objectAtIndex:i] isKindOfClass:[PRD_C_SQCell class]]) {
                    PRD_C_SQCell *cell = (PRD_C_SQCell *)[arrVisibleCells objectAtIndex:i];
                    
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
                    if (CGRectContainsRect(self.tableView.bounds,cellRect)) {
                        NSLog(@"포함함함함");
                        if ([timerPRD_C_SQ isValid] == NO) {
                            [self firePRD_C_SQ];
                            NSLog(@"fire 포함함함함");
                        }
                    }else{
                        [cell impressionValid:NO];
                        [self invaildatePRD_C_SQ];
                        NSLog(@"안 포함함함함");
                    }
                }
            }//for 끝
        }
    }
    
    if ([dicMLCellPlayControl count] > 0) {
        NSArray *allKeys = [dicMLCellPlayControl allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[dicMLCellPlayControl objectForKey:[allKeys objectAtIndex:i]]];
            if ([cell respondsToSelector:@selector(nowPlayingRate)]) {
                SectionDCMLtypeCell *cellMv = (SectionDCMLtypeCell*)cell;
                CGRect onlyMovieRect = CGRectMake(cellMv.frame.origin.x, cellMv.frame.origin.y, cellMv.frame.size.width,cellMv.productImageView.frame.size.height);
                CGRect cellRect = [scrollView convertRect:onlyMovieRect toView:scrollView.superview];
                if (CGRectContainsRect(scrollView.frame, cellRect)) {
                    if ([cellMv nowPlayingRate] != 1.0 && cellMv.isSendPlay==NO) {
                        cellMv.isSendPlay = YES;
                        [cellMv checkPlayStateAndResume];
                    }
                }
                else {
                    if ([cellMv nowPlayingRate] != 0.0) {
                        [cellMv stopMoviePlayer];
                    }
                }
            }
        }
    }
    
    
    if (isFPC && !CGRectEqualToRect(rectFPCCell, CGRectZero)) {
        CGRect cellRect = [scrollView convertRect:rectFPCCell toView:scrollView.superview];
        CGFloat yposFPC = cellRect.origin.y + cellRect.size.height;
        
        if (yposFPC < 0) {
            [delegatetarget FPCDisplayView:YES];
        }
        else {
            [delegatetarget FPCDisplayView:NO];
        }
    }
    
    if (isCX_SLD && !CGRectEqualToRect(rectCX_SLDCell, CGRectZero)) {
        CGRect cellRect = [scrollView convertRect:rectCX_SLDCell toView:scrollView.superview];
        CGFloat yposCX_SLD = 0.0;
        yposCX_SLD = cellRect.origin.y;
        if (yposCX_SLD < 0) {
            [delegatetarget CX_SLDDisplayView:YES cateView:self.CX_SLD_CATEView];
        }
        else {
            SectionBAN_CX_SLD_CATE_GBATypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCX_SLD inSection:0]];
            if (![[[cell subviews] lastObject] isKindOfClass:[SectionBAN_CX_SLD_CATE_GBASubView class]]) {
                [cell addSubview:self.CX_SLD_CATEView];
            }
            [delegatetarget CX_SLDDisplayView:NO cateView:self.CX_SLD_CATEView];
        }
    }
    
    // 이벤트 카테
    if (isCX_CATE && !CGRectEqualToRect(rectCX_CATECell, CGRectZero)) {
        CGRect cellRect = [scrollView convertRect:rectCX_CATECell toView:scrollView.superview];
        CGFloat yposCX_CATE = 0.0;
        yposCX_CATE = cellRect.origin.y;
        if (yposCX_CATE < 0) {
            [delegatetarget CX_CATEDisplayView:YES cateView:self.CX_CATEView];
        }
        else {
            SectionBAN_CX_CATE_GBAtypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxCX_CATE inSection:0]];
            if (![[[cell subviews] lastObject] isKindOfClass:[SectionBAN_CX_CATE_GBASubView class]]) {
                [cell addSubview:self.CX_CATEView];
            }
            [delegatetarget CX_CATEDisplayView:NO cateView:self.CX_CATEView];
        }
    }
    
    //상단 헤더 동영상이 화면에서 사라질경우 정지
    if(self.isHeaderMoviePlaying && (scrollView.contentOffset.y > self.frameMoviePlaying.origin.y+self.frameMoviePlaying.size.height)){
        //[[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_DUAL_AB_PAUSE object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONLIVEVIDEOALLKILL object:nil userInfo:nil];
        
        self.frameMoviePlaying = CGRectZero;
    }
    
    //상단 헤더 동영상중 3G 알럿이 있는경우 초기화
    if(self.isHeader3GAlert && (scrollView.contentOffset.y > self.frame3GAlert.origin.y+self.frame3GAlert.size.height)){
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_MOVIE_3G_ALERT object:nil userInfo:nil];
        self.frame3GAlert = CGRectZero;
        self.isHeader3GAlert = NO;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    [scrollExpandingDelegate scrollViewWillBeginDragging:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //스크롤바라벨
    if (!decelerate) {
        if(scrollView.contentOffset.y < (scrollView.frame.size.height/4)) {
            [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
            [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:self.scrollBarFadeDelay];
        }
        else {
            [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
            [self.delegatetarget setbtnTopDisplayed:YES  animated:YES afterDelay:self.scrollBarFadeDelay];
        }
    }
    
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    /* 필터복원 20141208 */
    [delegatetarget customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate];
    [scrollExpandingDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < (scrollView.frame.size.height/4)) {
        [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
        [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:self.scrollBarFadeDelay];
    }
    else {
        [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
        [self.delegatetarget setbtnTopDisplayed:YES  animated:YES afterDelay:self.scrollBarFadeDelay];
    }
    /* 필터복원 20141208 */
    [delegatetarget customscrollViewDidEndDecelerating:(UIScrollView *)scrollView];
    [scrollExpandingDelegate scrollViewDidEndDecelerating:scrollView];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [scrollExpandingDelegate scrollViewShouldScrollToTop:scrollView];
    [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
    [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:self.scrollBarFadeDelay];
    return YES;
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
    [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:self.scrollBarFadeDelay];
    [scrollExpandingDelegate scrollViewDidScrollToTop:scrollView];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < (scrollView.frame.size.height/4)) {
        [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
        [self.delegatetarget setbtnTopDisplayed:NO  animated:YES afterDelay:self.scrollBarFadeDelay];
    }
    else {
        [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
        [self.delegatetarget setbtnTopDisplayed:YES  animated:YES afterDelay:self.scrollBarFadeDelay];
    }
}



- (void) calcRPSHeightSubListArr:(NSArray *)arrSubProductList andIndex:(NSInteger)index {
    
    if(m_dicRPSs == nil) {
        m_dicRPSs = [[NSMutableDictionary alloc] init];
    }
    else {
        [m_dicRPSs removeAllObjects];
    }
    
    CGFloat m_iRPSHeight =0.0f;
    NSArray *arrWords = arrSubProductList;
    CGFloat widthLimit = APPFULLWIDTH - 20;
    CGFloat widthSum = 0.0;
    CGFloat heightReturn = 0.0;
    
    for (NSInteger j = 0; j<[arrWords count]; j++) {
        if (j == 0) {
            heightReturn = heightOneLine;
        }
        NSString *strWord = [NSString stringWithFormat:@"#%@",[[arrWords objectAtIndex:j] objectForKey:@"productName"]];
        CGSize totsize = [strWord MochaSizeWithFont: [UIFont systemFontOfSize:fontSizeRPS] constrainedToSize:CGSizeMake(APPFULLWIDTH - 20.0, heightOneLine) lineBreakMode:NSLineBreakByClipping];
        if ((widthSum+totsize.width+insideSearchWord*2.0) <= widthLimit) {
            widthSum = widthSum +totsize.width+insideSearchWord*2.0;
        }
        else {
            if ((totsize.width >= (APPFULLWIDTH - 20.0)) && widthSum == 0.0) {
                widthSum = totsize.width;
            }
            else {
                widthSum = totsize.width+insideSearchWord*2.0;
                heightReturn = heightReturn + heightOneLine;
            }
        }
        widthSum += intervalSearchWord;
    }
    
    m_iRPSHeight = heightReturn + 43.0 + 15.0 + 5.0 + 10.0;
    NSString *strKey = [NSString stringWithFormat:@"%ld",(long)index];
    NSString *strHeight = [NSString stringWithFormat:@"%f",m_iRPSHeight];
    [m_dicRPSs setObject:strHeight forKey:strKey];
}



- (NSDictionary *)loadTestApiUrl:(NSString *)strUrl {
    NSURL *turl = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:30 error:&error];
    return [result JSONtoValue];
}

//더보기 처리용
- (void)touchSubProductStatus:(BOOL)isShowMore andIndexPath:(NSIndexPath*)idxPath {
    NSMutableArray *arrIndexPaths = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicMore = [[NSMutableDictionary alloc] init];
    
    [dicMore addEntriesFromDictionary:[self.sectionarrdata objectAtIndex:idxPath.row]];
    if ([NCS([dicMore objectForKey:@"subPrdCount"]) length] > 0) {
        NSInteger cntSub = [[dicMore objectForKey:@"subPrdCount"] integerValue];
        //내 위의 상품을 대상으로 한다.
        for (NSInteger i = idxPath.row - 1 ; cntSub > 1; cntSub--,i--) {
            NSMutableDictionary *dicSubMod = [[NSMutableDictionary alloc] init];
            [dicSubMod addEntriesFromDictionary:[[self.sectionarrdata objectAtIndex:i] copy]];
            NSLog(@"idxPath.row = %ld",(long)idxPath.row);
            NSLog(@"NSInteger i = %ld",(long)i);
            if ([[dicSubMod objectForKey:@"viewType"] isEqualToString:@"MAP_CX_GBA_2"]) {
                NSString *strYN = (isShowMore)?@"Y":@"N";
                [dicSubMod setObject:strYN forKey:@"isVisible"];
                [self.sectionarrdata replaceObjectAtIndex:i withObject:dicSubMod];
                [arrIndexPaths insertObject:[NSIndexPath indexPathForRow:i inSection:0] atIndex:0];
                NSLog(@"dicSubModdicSubModdicSubMod = %@",dicSubMod);
            }
        }
        NSString *strYN = (isShowMore)?@"N":@"Y";
        [dicMore setObject:strYN forKey:@"isOpen"];
        [self.sectionarrdata replaceObjectAtIndex:idxPath.row withObject:dicMore];
        [arrIndexPaths insertObject:idxPath atIndex:arrIndexPaths.count];//더보기는 맨마지막 버튼이다.
        [self.tableView reloadRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


//CSP데이터 를 요청하며 수신 받는쪽/ 수신하는 쪽에서 동시 요청될수 있다.
- (void)callCSP {
    NSLog(@"callCSP");
    SectionView *svCSP = ((SectionView *)self.delegatetarget);
    
    if(svCSP == nil || NCO(svCSP.m_dicMsg) == NO ||  [@"N" isEqualToString:[svCSP.m_dicMsg objectForKey:@"VI"]] ) {
        return;
    }
    
    //sectionview와 cell에서 동시 호출될 가능성이 있어 @synchronized 처리
    @synchronized(ApplicationDelegate.objectCSP) {
        if([svCSP isKindOfClass:[SectionView class]] == YES && NCO(svCSP.m_dicMsg)) {
            NSString *strImg = [svCSP.m_dicMsg objectForKey:@"I"];
            NSString *strLink = [svCSP.m_dicMsg objectForKey:@"LN"];
            NSString *strAid = [svCSP.m_dicMsg objectForKey:@"AID"];
            
            
            // nami0342 - 최초 뷰 로딩이나 / 탭 이동으로 복귀한 경우에는 View event를 전송한다.
            if([strAid isEqualToString:[ApplicationDelegate.objectCSP objectForKey:@"AID"]] == NO)
            {
                // nami0342 - Viewing 시 이벤트 전달.
                [ApplicationDelegate CSP_SendEventWithView:YES];
            }
            
            //중복호출 방지
            if([strImg isEqualToString:[ApplicationDelegate.objectCSP objectForKey:@"imageUrl"]] && [strLink isEqualToString:[ApplicationDelegate.objectCSP objectForKey:@"linkUrl"] ]) {
                return;
            }
            //지우고 다시?
            [ApplicationDelegate.objectCSP removeAllObjects];
            [ImageDownManager blockImageDownWithURL:strImg responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if(error == nil && [strImg isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ApplicationDelegate.objectCSP setObject:strLink forKey:@"linkUrl"];
                        [ApplicationDelegate.objectCSP setObject:strImg forKey:@"imageUrl"];
                        [ApplicationDelegate.objectCSP setObject:fetchedImage forKey:@"image"];
                        [ApplicationDelegate.objectCSP setObject:strAid forKey:@"AID"];
                        
                        // 이 블럭은 메인스레드(UI)에서 실행된다.
                        // 테이블뷰 갱신!!
                        [self tableCellReload:self.idxCSPbanner];
                    });
                }
            }];
        }
        else {
            NSLog(@"callCSP = %@",ApplicationDelegate.objectCSP);
        }
    }
}


#pragma mark  3D TOUCH
/*
 // nami0342 - 간혹 self.view.superview 와 연결이 비 정상적일 경우 처리하기 위해 넣음. 이게 되야 3D 터치를 위한 view가 마련됨. (우리꺼는 연결 안됨을 확인해서 추가)
 - (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
 [super traitCollectionDidChange:previousTraitCollection];
 
 if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
 if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
 if (!self.previewingContext) {
 self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
 }
 }
 else {
 [self unregisterForPreviewingWithContext:self.previewingContext];
 self.previewingContext = nil;
 }
 }
 // nami0342 - 연결이 되야 초기화도 가능.
 [self forceTouchIntialize];
 }
 
 
 -(void)forceTouchIntialize {
 // 이거 배포할 때, 타겟이 9.0이 아니면, 이 부분이 문제가 아니라. header에서 없는 델리게이트 넣어서 크래쉬 날듯.
 if(SYSTEM_VERSION_LESS_THAN(@"9.0") == YES) {
 return;
 }
 
 if ([self isForceTouchAvailable]) {
 self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
 }
 }
 
 - (BOOL)isForceTouchAvailable {
 BOOL isForceTouchAvailable = NO;
 if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
 isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
 }
 return isForceTouchAvailable;
 }
 
 
 // nami0342 - Click while deep pressing.
 -(void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
 // 상품상세 이동 처리
 [ApplicationDelegate.HMV moveWebViewStrUrl:((ResultWebViewController *)viewControllerToCommit).urlString];
 }
 
 // nami0342 - Deep pressing..
 - (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
 CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
 NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
 NSDictionary *secdic;
 NSString *strURL;
 NSString *viewType;
 if ([self.sectionarrdata count] > 0 && path.row <= [self.sectionarrdata count]-1 ) {
 secdic = [self.sectionarrdata objectAtIndex:path.row];
 strURL = [secdic objectForKey:@"linkUrl"];
 viewType = [secdic objectForKey:@"viewType"];
 }
 //NSDictionary *secdic = [self.sectionarrdata objectAtIndex:path.row];
 //NSString *strURL = [secdic objectForKey:@"linkUrl"];
 //NSString *viewType = [secdic objectForKey:@"viewType"];
 
 // 2줄 짜리는 어떤 셀인지 모르겠음. 슬라이드 뷰타입은 처리 안 함. 나중에 처리.
 if(NCS(strURL).length == 0) {
 return nil;
 }
 
 //링크는 있으나 동작하면안되는 뷰타입의 prefix 필터
 if([NCS(viewType) hasPrefix:@"API_"] || [NCS(viewType) hasPrefix:@"CSP_"] || [NCS(viewType) hasPrefix:@"BAN_IMG_GSF_"]) {
 return nil;
 }
 
 if (path) {
 // 일단 기본형만 처리 - 해당 셀 영역에서 커지면서 노출 처리
 // 여기서 Native도 호출 가능.
 UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
 ResultWebViewController *wcResutl = [[ResultWebViewController alloc] initWithUrlString:strURL];
 previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView: self.tableView];
 return wcResutl;
 }
 return nil;
 }
 
 */

-(void)showMotherRequest:(NSDictionary *)dicRequest{
    
    ViewMotherRequest *viewMR = [[[NSBundle mainBundle] loadNibNamed:@"ViewMotherRequest" owner:self options:nil] firstObject];
    viewMR.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    [ApplicationDelegate.window addSubview:viewMR];
    [viewMR showPopupWithDic:dicRequest];
}

-(void) makeBrdZzimPopup {
    if(dimmView == nil) {
        dimmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        dimmView.backgroundColor = UIColor.clearColor;
        
        UIButton *dimmCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        dimmCloseBtn.backgroundColor = UIColor.clearColor;
        [dimmCloseBtn addTarget:self action:@selector(brdZzimPopupClose:) forControlEvents:UIControlEventTouchUpInside];
        
        brdZzimImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zzim_layer_02.png"] highlightedImage:[UIImage imageNamed:@"zzim_layer_01.png"]  ];
        brdZzimImg.frame = CGRectMake(0, 0, 150.0, 150.0);
        brdZzimImg.center = dimmView.center;
        
        brdZzimBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, brdZzimImg.frame.size.width, brdZzimImg.frame.size.height)];
        brdZzimBtn.center = brdZzimImg.center;
        brdZzimBtn.accessibilityLabel = @"찜한 브랜드 보기";
        brdZzimBtn.backgroundColor = UIColor.clearColor;
        [brdZzimBtn addTarget:self action:@selector(brdZzimTargetUrl:) forControlEvents:UIControlEventTouchUpInside];
        
        brdZzimClose = [[UIButton alloc] initWithFrame:CGRectMake(brdZzimBtn.frame.size.width - 40.0, 0, 40.0, 40.0)];
        brdZzimClose.backgroundColor = UIColor.clearColor;
        brdZzimClose.accessibilityLabel = @"브랜드 찜 팝업 닫기";
        [brdZzimClose setImage:[UIImage imageNamed:@"super_close_cart.png"] forState:UIControlStateNormal];
        [brdZzimClose setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 14, 0)];
        [brdZzimClose addTarget:self action:@selector(brdZzimPopupClose:) forControlEvents:UIControlEventTouchUpInside];
        
        [dimmView addSubview:dimmCloseBtn];
        [dimmView addSubview:brdZzimImg];
        [dimmView addSubview:brdZzimBtn];
        [brdZzimBtn addSubview:brdZzimClose];
    }
}

//브랜드 찜 팝업 노출
-(void)brandZzimShowPopup:(NSString *)targetUrl add:(BOOL) isAdd {
    
    brdZzimBtn.accessibilityLabel = isAdd ? @"찜한 브랜드 보기" : @"브랜드 팝업 닫기";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self makeBrdZzimPopup];
        brdZzimImg.highlighted = isAdd;
        brdZzimClose.hidden = !isAdd;
        brdZzimTargetUrl = targetUrl;  // 브랜드찜 이동 URL
        
        if ([self.delegatetarget isKindOfClass:[UIView class]]) {//sectionview
            UIView *viewDT = (UIView *)self.delegatetarget;
            dimmView.center = viewDT.center;
            [viewDT addSubview:dimmView];
            
            if ([self.timerBrdZzimPopup isValid]) {
                [self.timerBrdZzimPopup invalidate];
            }
            
            dimmView.alpha = 0.0;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^{
                                 dimmView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 self.timerBrdZzimPopup = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(brdZzimPopupClose:) userInfo:nil repeats:NO];
                             }];
            
        }
    });
}

- (IBAction)brdZzimPopupClose:(id)sender {
    
    //뷰를 닫는다.
    if ([self.timerBrdZzimPopup isValid]) {
        [self.timerBrdZzimPopup invalidate];
    }
    brdZzimTargetUrl = @""; // 찜 이동 URL 초기화
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         dimmView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [dimmView removeFromSuperview];
                     }];
    
}

-(IBAction)brdZzimTargetUrl:(id)sender {
    //해당 URL로 이동함
    if([NCS(brdZzimTargetUrl) length] > 0) {
        [ApplicationDelegate.HMV moveWebViewStrUrl:brdZzimTargetUrl];
    }
}


#pragma marks - tableView Header Resize
-(void)tableHeaderChangeSizeDual:(CGSize)sizeChange{
    /*
     NSLog(@"");
     NSLog(@"self.tableView.contentSize = %@",NSStringFromCGSize(self.tableView.contentSize));
     
     tableheaderTVCVheight = sizeChange.height;
     
     float space = (tableheaderTVCVheight+tableheaderTDCTVCBTNVheight) > 0 ? 10 : 0;
     
     CGRect closedFrame = CGRectMake(0, 0, APPFULLWIDTH, tableheaderBANNERheight+tableheaderTVCVheight+tableheaderTDCTVCBTNVheight+ space );
     CGRect newFrame = closedFrame;
     
     UIView *viewHeader = self.tableView.tableHeaderView;
     //
     
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.3];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     self.viewHomeDual.frame = CGRectMake(0, tableheaderBANNERheight, APPFULLWIDTH, tableheaderTVCVheight);
     viewHeader.frame = newFrame;
     [self.tableView setTableHeaderView:viewHeader];
     [UIView commitAnimations];
     
     self.frameMoviePlaying = self.viewHomeDual.frame;
     
     NSLog(@"self.tableView.contentSize = %@",NSStringFromCGSize(self.tableView.contentSize));
     */
}

-(void)tableHeaderChangeSizeBTypeIsSpread:(BOOL)isSpread isLiveBroad:(HEADER_BROAD_TYPE)headerBrdType mobileLiveBroadStart:(BOOL)isMLStart{
    
    NSLog(@"");
    
    //전체화면보기로 진입할경우 가로세로가 시간차로인해 뒤바뀌는 경우가 발생함으로 메크로 안쓰고 처리하도록 수정
    CGFloat fullWidth = self.widthFixed;
    CGFloat heightSpread = heightHomeMainBroadView;//floor(40.0 + ((fullWidth - 20.0)/(16.0/9.0)) + 80.0+ 10.0);
    CGFloat heightClosed = heightHomeMainBroadView;//floor(40.0 + ((fullWidth - 20.0)/(2.0/1.0)) + 80.0 +10.0);
    
    CGFloat heightMobileLiveSpread = heightHomeMainBroadView;//floor(40.0 + fullWidth/(375.0/252.0) + 40.0 + 80.0 + 10.0);
    CGFloat heightMobileLiveClosed = heightHomeMainBroadView;//floor(40.0 + ((fullWidth - 20.0)/(2.0/1.0)) + 40.0 + 80.0  +10.0);
    
    NSInteger cntViewHeader = 0; //생방 또는 마이샵 둘중 하나만 있을수도 있음으로 체크
    
    tableheaderTVCVheight = 10.0 ;
    
    if ( [NCS([tvcdic objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdic objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdic objectForKey:@"imageUrl"]) isEqualToString:@""] == NO) {
        cntViewHeader++;
        if (headerBrdType == HEADER_BTYPE_LIVE && isSpread == YES) {
            tableheaderTVCVheight = tableheaderTVCVheight + heightSpread;
        }else{
            tableheaderTVCVheight = tableheaderTVCVheight + heightClosed;
        }
    }
    
    if ( [NCS([tvcdicMyShop objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdicMyShop objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdicMyShop objectForKey:@"imageUrl"]) isEqualToString:@""] == NO) {
        cntViewHeader++;
        
        if (headerBrdType == HEADER_BTYPE_MYSHOP && isSpread == YES) {
            tableheaderTVCVheight = tableheaderTVCVheight + heightSpread;
        }else{
            tableheaderTVCVheight = tableheaderTVCVheight + heightClosed;
        }
    }
    
    if ( [NCS([tvcdicMobileLive objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([tvcdicMobileLive objectForKey:@"linkUrl"]) isEqualToString:@""] == NO && [NCS([tvcdicMobileLive objectForKey:@"imageUrl"]) isEqualToString:@""] == NO) {
        cntViewHeader++;
        
        if (headerBrdType == HEADER_BTYPE_MOBILELIVE && isSpread == YES) {
            tableheaderTVCVheight = tableheaderTVCVheight + heightMobileLiveSpread;
        }else{
            if (self.viewHeaderMobileLive.isPreparingBroad == NO) {
                tableheaderTVCVheight = tableheaderTVCVheight + heightMobileLiveClosed;
            }else{
                //방송준비중 일때에는 히든처리
                cntViewHeader--;
            }
        }
    }
    
    
    
    CGRect newFrame = CGRectMake(0, 0, fullWidth, tableheaderBANNERheight+tableheaderTVCVheight+tableheaderTDCTVCBTNVheight);;
    UIView *viewHeader = self.tableView.tableHeaderView;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (cntViewHeader == 3) { //셋다 있음
        if (headerBrdType == HEADER_BTYPE_LIVE) {
            self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth, ((isSpread==YES)?heightSpread:heightClosed));
            
            //[self.viewHeaderMyShop stopMoviePlayer];
            //[self.viewHeaderMobileLive stopMoviePlayer];
            
            self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + ((isSpread==YES)?heightSpread:heightClosed), fullWidth, heightClosed);
            self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + ((isSpread==YES)?heightSpread:heightClosed) + heightClosed, fullWidth, heightMobileLiveClosed);
            
        }else if (headerBrdType == HEADER_BTYPE_MYSHOP) {
            //[self.viewHeaderLive stopMoviePlayer];
            //[self.viewHeaderMobileLive stopMoviePlayer];
            
            self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,heightClosed );
            self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + heightClosed, fullWidth,((isSpread==YES)?heightSpread:heightClosed) );
            self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + ((isSpread==YES)?heightSpread:heightClosed) + heightClosed, fullWidth, heightMobileLiveClosed);
            
        }else{
            //모바일 라이브
            
            if (isMLStart == NO) {
                //[self.viewHeaderLive stopMoviePlayer];
                //[self.viewHeaderMyShop stopMoviePlayer];
            }
            
            self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,heightClosed );
            self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + heightClosed, fullWidth, heightClosed);
            
            self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 + heightClosed + heightClosed , fullWidth,((isSpread==YES)?heightMobileLiveSpread:heightMobileLiveClosed) );
            
        }
        
    }else if (cntViewHeader == 2) { //둘 있음..
        
        //둘 있는데 그중하나가 모바일 라이브
        if (self.viewHeaderMobileLive != nil && self.viewHeaderMobileLive.isPreparingBroad == NO) {
            
            if (headerBrdType == HEADER_BTYPE_MOBILELIVE) {
                
                if (self.viewHeaderLive != nil) {
                    if (isMLStart == NO) {
                        //[self.viewHeaderLive stopMoviePlayer];
                    }
                    
                    self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,heightClosed);
                }else if(self.viewHeaderMyShop != nil){
                    if (isMLStart == NO) {
                        //[self.viewHeaderMyShop stopMoviePlayer];
                    }
                    self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,heightClosed);
                }
                
                self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 + heightClosed, fullWidth,((isSpread==YES)?heightMobileLiveSpread:heightMobileLiveClosed) );
                
                
            }else{
                
                if (headerBrdType == HEADER_BTYPE_LIVE) {
                    self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,((isSpread==YES)?heightSpread:heightClosed));
                }else if(headerBrdType == HEADER_BTYPE_MYSHOP){
                    self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,((isSpread==YES)?heightSpread:heightClosed));
                }
                
                //[self.viewHeaderMobileLive stopMoviePlayer];
                self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 + ((isSpread==YES)?heightSpread:heightClosed), fullWidth,heightMobileLiveClosed );
                
            }
            
            
            
        }else{
            //둘 있는데 모바일 라이브 없음
            if (headerBrdType == HEADER_BTYPE_LIVE) {
                self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth, ((isSpread==YES)?heightSpread:heightClosed));
                
                //[self.viewHeaderMyShop stopMoviePlayer];
                self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + ((isSpread==YES)?heightSpread:heightClosed), fullWidth, heightClosed);
            }else if (headerBrdType == HEADER_BTYPE_MYSHOP) {
                //마이샵
                //[self.viewHeaderLive stopMoviePlayer];
                self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth,heightClosed );
                self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10.0 + heightClosed, fullWidth,((isSpread==YES)?heightSpread:heightClosed) );
            }else{
                //둘있는데 모바일 라이브 방송준비중 상태로 진입?
                
            }
        }
        
    }else{
        //하나만 있음
        if (headerBrdType == HEADER_BTYPE_LIVE) {
            self.viewHeaderLive.frame = CGRectMake(0, tableheaderBANNERheight + 10 , fullWidth, ((isSpread==YES)?heightSpread:heightClosed));
        }else if(headerBrdType == HEADER_BTYPE_MYSHOP){
            self.viewHeaderMyShop.frame = CGRectMake(0, tableheaderBANNERheight + 10.0, fullWidth,((isSpread==YES)?heightSpread:heightClosed) );
        }else{
            self.viewHeaderMobileLive.frame = CGRectMake(0, tableheaderBANNERheight + 10.0, fullWidth,((isSpread==YES)?heightMobileLiveSpread:heightMobileLiveClosed) );
        }
    }
    
    if (isSpread == YES) {
        if (headerBrdType == HEADER_BTYPE_LIVE) {
            self.frameMoviePlaying = self.viewHeaderLive.frame;
        } else if (headerBrdType == HEADER_BTYPE_MYSHOP){
            self.frameMoviePlaying = self.viewHeaderMyShop.frame;
        }else{
            self.frameMoviePlaying = self.viewHeaderMobileLive.frame;
        }
        
        
    }
    
    viewHeader.frame = newFrame;
    [self.tableView setTableHeaderView:viewHeader];
    [UIView commitAnimations];
    
    //NSLog(@"self.tableView.contentSize = %@",NSStringFromCGSize(self.tableView.contentSize));
    
}


-(void)updateHeaderDicInfo:(NSDictionary*)dicToUpdate broadType:(HEADER_BROAD_TYPE)headerBrdType{
    
    NSLog(@"dicToUpdate = %@",dicToUpdate);
    NSLog(@"headerBrdType = %ld",(long)headerBrdType);
    
    
    if(headerBrdType == HEADER_BTYPE_LIVE){
        tvcdic = [dicToUpdate copy];
    }else if (headerBrdType == HEADER_BTYPE_MYSHOP){
        tvcdicMyShop = [dicToUpdate copy];
    }else if (headerBrdType == HEADER_BTYPE_MOBILELIVE){
        tvcdicMobileLive = [dicToUpdate copy];
    }else{
        return;
    }
    
    //완전 널이거나 문제 있을때에만 하단 호출
    if ([NCS([dicToUpdate objectForKey:@"broadType"]) isEqualToString:@""] == YES ||
        [NCS([dicToUpdate objectForKey:@"imageUrl"]) isEqualToString:@""] == YES ||
        [NCS([dicToUpdate objectForKey:@"linkUrl"]) isEqualToString:@""] == YES
        ) {
        
        [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
        [self tableFooterDraw];
        [self.tableView reloadData];
        
    }
    
}

-(void)updateHeaderMoviePlaying:(BOOL)isPlaying{
    self.isHeaderMoviePlaying = isPlaying;
}

-(void)updateHeader3GAlert:(BOOL)isShow3GAlert andHeaderType:(HEADER_BROAD_TYPE)headerBrdType{
    self.isHeader3GAlert = isShow3GAlert;
    
    if (headerBrdType == HEADER_BTYPE_LIVE) {
        self.frame3GAlert = self.viewHeaderLive.frame;
    } else if (headerBrdType == HEADER_BTYPE_MYSHOP){
        self.frame3GAlert = self.viewHeaderMyShop.frame;
    }else{
        self.frame3GAlert = self.viewHeaderMobileLive.frame;
    }
    
}

#pragma mark - PRD_C_SQ
- (void)reCheckPRD_C_SQ{
    
    
    NSArray *arrVisibleCells = [self.tableView visibleCells];
    for (NSInteger i=0; i<[arrVisibleCells count]; i++) {
        if ([[arrVisibleCells objectAtIndex:i] isKindOfClass:[PRD_C_SQCell class]]) {
            
            
            PRD_C_SQCell *cell = (PRD_C_SQCell *)[arrVisibleCells objectAtIndex:i];
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            NSString *strViewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
            
            if ([strViewType  isEqualToString:@"SRL"] || [strViewType isEqualToString:@"PRD_C_SQ"]) {
                isCheckPRD_C_SQ = YES;
                
                CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
                if (CGRectContainsRect(self.tableView.bounds,cellRect)) {
                    NSLog(@"포함함함함");
                    if ([timerPRD_C_SQ isValid] == NO) {
                        [self firePRD_C_SQ];
                        NSLog(@"fire 포함함함함");
                    }
                }else{
                    [self invaildatePRD_C_SQ];
                    NSLog(@"안 포함함함함");
                }
            }
            
            break;
        }
    }//for 끝
    
}

-(void)invaildatePRD_C_SQ{
    if ([timerPRD_C_SQ isValid] == YES) {
        [timerPRD_C_SQ invalidate];
        timerPRD_C_SQ = nil;
        
        NSLog(@"invaildatePRD_C_SQ 포함함함함")
    }
}

-(void)firePRD_C_SQ{
    timerPRD_C_SQ = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(sendPRD_C_SQ_MSeq) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:timerPRD_C_SQ forMode:NSRunLoopCommonModes];
    
    NSLog(@"firePRD_C_SQ 포함함함함")
}

-(void)sendPRD_C_SQ_MSeq{
    NSLog(@"sendPRD_C_SQ_MSeq 포함함함함")
    [ApplicationDelegate wiseLogRestRequestNoCancel: WISELOGCOMMONURL(@"?mseq=419669")];
    [self invaildatePRD_C_SQ];
    isCheckPRD_C_SQ = NO;
    
    NSArray *arrVisibleCells = [self.tableView visibleCells];
    for (NSInteger i=0; i<[arrVisibleCells count]; i++) {
        if ([[arrVisibleCells objectAtIndex:i] isKindOfClass:[PRD_C_SQCell class]]) {
            PRD_C_SQCell *cell = (PRD_C_SQCell *)[arrVisibleCells objectAtIndex:i];
            [cell impressionValid:YES];
            break;
        }
    }//for 끝
}
@end
