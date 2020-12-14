//
//  EIListPSCViewController.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 25..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "EIListPSCViewController.h"
#import "SectionView.h"
#import "PSCollectionViewCell.h"
#import "SectionEItypePSCell.h"
#import "EICategoryView.h"
#import "SectionSEtypeView.h"

#import "SectionView+EILIST.h"
#import "PSCollectionViewCell.h"
#import "SectionEItypePSCell.h"
#import "SectionDCtypeCell.h"
#import "SectionBIStypeCell.h"
#import "SectionBIMtypeCell.h"
#import "SectionBILtypeCell.h"
#import "SectionBIM440StypeCell.h"
#import "SectionBIXLtypeCell.h"
#import "SectionBMIAtypeCell.h"
#import "SectionBSIStypeCell.h"
#import "SectionPSLtypeCell.h"
//#import "SectionBTStypeCell.h"

#import "TableHeaderEItypeView.h"

#import "SectionTBViewFooter.h"

@interface EIListPSCViewController ()

@end

@implementation EIListPSCViewController
@synthesize apiResultDic;
@synthesize sectionType;

@synthesize sectionarrdata;
@synthesize sectioninfodata;

@synthesize BottomCellInforow;

@synthesize pscView;
@synthesize eiTableView;
@synthesize tableViewType;

@synthesize delegatetarget;
@synthesize imageLoadingOperation;
@synthesize currentOperation1;
@synthesize cubeAnimation;

@synthesize leftPSC;

@synthesize scrollExpandingDelegate;

@synthesize refreshHeaderView, refreshGSSHOPCircle;

@synthesize indexEIC;
@synthesize sectionView;

- (id)initWithSectioninfo:(NSDictionary*)secinfo
{
    self = [super init];
    if(self)
    {
        
        self.leftPSC = 0.0;
        
        self.indexEIC = 0;
        
        NSLog(@"");
        self.pscView = [[PSCollectionView alloc] initWithFrame:CGRectMake(self.leftPSC, 0.0, APPFULLWIDTH-(self.leftPSC*2.0), self.view.frame.size.height)];
        self.pscView.delegate = self; // This is for UIScrollViewDelegate
        self.pscView.collectionViewDelegate = self;
        self.pscView.collectionViewDataSource = self;
        self.pscView.autoresizingMask = ~UIViewAutoresizingNone;
        self.pscView.autoresizesSubviews = NO;
        
        self.pscView.backgroundColor = [UIColor clearColor];
        self.pscView.numColsPortrait = 2;
        self.pscView.numColsLandscape = 4;
        self.pscView.kMargin = 8.0;
        self.pscView.clipsToBounds = YES;
        
        [self.view addSubview:self.pscView];
        self.view.backgroundColor = [UIColor clearColor];
        
        NSLog(@"self.pscView.frame = %@",NSStringFromCGRect(self.pscView.frame));
        
        self.sectioninfodata = secinfo;
        self.sectionType = [secinfo objectForKey:@"sectionType"];
        
        
        
        self.eiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, self.view.frame.size.height)];
        self.eiTableView.delegate = self;
        self.eiTableView.dataSource = self;
        self.eiTableView.backgroundColor = [UIColor clearColor];
        self.eiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.eiTableView.autoresizingMask = ~UIViewAutoresizingNone;
        
        [self.view addSubview:self.eiTableView];
        
        
        NSLog(@"self.eiTableView.frame = %@",NSStringFromCGRect(self.eiTableView.frame));
        
    }
    return self;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
     
     
    
    
}


#pragma mark - Setting

-(void)onBtnEICategory:(NSNumber*)tnum{
    self.indexEIC = [tnum intValue];
    SectionView *sView =  (SectionView *)delegatetarget;
    sView.currentCateinfoindex = [tnum intValue];
    
    
    
    
    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_이벤트_Tab" withLabel:  [NSString stringWithFormat: @"%d_%@",[tnum intValue],   [[[self.apiResultDic objectForKey:@"productList"] objectAtIndex:self.indexEIC] objectForKey:@"productName"]   ]];
    
    if(NCO([self.apiResultDic objectForKey:@"productList"]) && NCO([[self.apiResultDic objectForKey:@"productList"] objectAtIndex:self.indexEIC]) && [NCS([[[self.apiResultDic objectForKey:@"productList"] objectAtIndex:self.indexEIC] objectForKey:@"viewType"]) isEqualToString:@"SUB_EVT_HOME"]){
        self.tableViewType = collectionType;
    }else{
        self.tableViewType = tableType;
    }
    
    [self.sectionarrdata removeAllObjects];
    [self.sectionarrdata addObjectsFromArray:[[[self.apiResultDic objectForKey:@"productList"] objectAtIndex:self.indexEIC] objectForKey:@"subProductList"]];
    
    NSLog(@"arrrr = %@",[[[self.apiResultDic objectForKey:@"productList"] objectAtIndex:self.indexEIC] objectForKey:@"subProductList"]);
    
    [self tableHeaderDraw];
    [self tableFooterDraw];

    
    if (self.tableViewType == collectionType) {
        
        [self.pscView reloadData];
        [self.pscView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
        
    }else{ 
        if ([self.sectionarrdata count] > 0) {
            
            [self.eiTableView reloadData];
            [self.eiTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            
        }else{
            [self.eiTableView reloadData];
        }
    }
 
}




-(void) tableHeaderDraw {
    
    if (self.tableViewType == collectionType) {
        
        if(self.pscView.headerView != nil) {
            [self.pscView.headerView removeFromSuperview];
            self.pscView.headerView  = nil;
        }
    }else{
        if(self.eiTableView.tableHeaderView != nil) {
            [self.eiTableView.tableHeaderView removeFromSuperview];
            self.eiTableView.tableHeaderView  = nil;
        }
    }
    
    
    if (eicView != nil) {
        [eicView removeFromSuperview];
        eicView = nil;
        
    }
    
    
    pscViewheaderBANNERheight = 0;
    pscViewheaderNo1DealZoneheight = 0;
    pscViewheaderCateViewHeight = 0;
    pscViewheaderListheight= 0;
    
    UIView *tvhview = [[UIView alloc] initWithFrame:CGRectZero ];
    
    //배너
    if([self isExsitSectionBanner]){
        NSInteger heightBanner = BANNERHEIGHT;
        if (NCO([self.apiResultDic objectForKey:@"banner"]) && [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) length] > 0) {
            heightBanner = [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) integerValue];
        }
        pscViewheaderBANNERheight = [Common_Util DPRateOriginVAL:heightBanner];
        [tvhview addSubview:[self topBannerview]];
        NSLog(@"tvhview = %@",tvhview);
    }
    

    
    if (pscViewheaderBANNERheight == 0 && pscViewheaderNo1DealZoneheight == 0) {
        
    }
    
    
    NSLog(@"self.apiResultDic = %@",self.apiResultDic);
    NSLog(@"[self.apiResultDic objectForKey:@headerList] = %@",[self.apiResultDic objectForKey:@"headerList"]);
    

    if (NCA([self.apiResultDic objectForKey:@"headerList"] ) && [(NSArray *)[self.apiResultDic objectForKey:@"headerList"] count] > 0) {

        NSArray *arrHeader = (NSArray *)[self.apiResultDic objectForKey:@"headerList"];
        for (NSInteger i=0; i<[arrHeader count]; i++) {
            
            if (NCO([arrHeader objectAtIndex:i]) && [NCS([[arrHeader objectAtIndex:i] objectForKey:@"viewType"])  isEqualToString:@"B_IM"]) {
                
                //중간크기 배너가 있을경우 + 8
                if([self isExsitSectionBanner]){
                    pscViewheaderBANNERheight = pscViewheaderBANNERheight + 8;
                }
                
                TableHeaderEItypeView  *cell = [[TableHeaderEItypeView alloc] initWithTarget:self Nframe:CGRectMake(0, pscViewheaderBANNERheight + pscViewheaderListheight, APPFULLWIDTH, [Common_Util DPRateOriginVAL:170])];
                
                
                [tvhview addSubview:cell];
                
                [cell setCellInfoNDrawData:[arrHeader objectAtIndex:i]];
                
                pscViewheaderListheight =  pscViewheaderListheight + [Common_Util DPRateOriginVAL:170];
                
                
            }else if (NCO([arrHeader objectAtIndex:i]) && [NCS([[arrHeader objectAtIndex:i] objectForKey:@"viewType"])  isEqualToString:@"SE"]) {
               
                if (NCA([[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"] ) && [(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"] count] > 0) {
                    
                    CGFloat oneHeight = [Common_Util DPRateVAL:152 withPercent:88];
                    if ([(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"] count] == 1) {
                        oneHeight = [Common_Util DPRateOriginVAL:160.0];
                    }
                    
                    //중간크기 배너가 있을경우 + 8
                    if([self isExsitSectionBanner]){
                        pscViewheaderBANNERheight = pscViewheaderBANNERheight + 8;
                    }
                    
                    
                    SectionSEtypeView  *cell = [[[NSBundle mainBundle] loadNibNamed:@"SectionSEtypeView" owner:self options:nil] firstObject];
                    cell.target = self;
                    cell.frame = CGRectMake(0, pscViewheaderBANNERheight + pscViewheaderListheight, APPFULLWIDTH, oneHeight);
                    
                    [tvhview addSubview:cell];
                    
                    [cell setCellInfoNDrawData:(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"]];
                    
                    pscViewheaderListheight =  pscViewheaderListheight + oneHeight;
                    
                }
                

            }else{
                
            }
            
        }
        
    }

    if (NCA([self.apiResultDic objectForKey:@"productList"]) && [(NSArray *)[self.apiResultDic objectForKey:@"productList"] count] > 0) {
        
        
        NSLog(@"indexCategory = %lu",(long)self.indexEIC);

        eicView = [[[NSBundle mainBundle] loadNibNamed:@"EICategoryView" owner:self options:nil] firstObject];
        eicView.target = self;
        [eicView setCellInfoNDrawData:[self.apiResultDic objectForKey:@"productList"] seletedIndex:self.indexEIC];
        
        if (self.tableViewType == collectionType) {
            
            
            pscViewheaderCateViewHeight = eicView.frame.size.height;
            eicView.frame = CGRectMake(0, pscViewheaderBANNERheight + pscViewheaderNo1DealZoneheight + pscViewheaderListheight, APPFULLWIDTH, eicView.frame.size.height);
            [tvhview addSubview:eicView];
        }else{
            
            pscViewheaderCateViewHeight = eicView.frame.size.height;
            
            eicView.frame = CGRectMake(0, pscViewheaderBANNERheight + pscViewheaderNo1DealZoneheight + pscViewheaderListheight, APPFULLWIDTH, eicView.frame.size.height);
            eicView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
            
        }
    }

    
    if (self.tableViewType == collectionType) {
        
        tvhview.frame =  CGRectMake(-self.leftPSC,  0, APPFULLWIDTH, pscViewheaderBANNERheight + pscViewheaderNo1DealZoneheight + pscViewheaderCateViewHeight + pscViewheaderListheight);
        
        heightfloatingHeaderView =pscViewheaderBANNERheight + pscViewheaderNo1DealZoneheight + pscViewheaderListheight;
        
        self.pscView.headerView = tvhview;
        
    }else{
        tvhview.frame =  CGRectMake(0,  0, APPFULLWIDTH, pscViewheaderBANNERheight + pscViewheaderNo1DealZoneheight + pscViewheaderListheight);
        
        self.eiTableView.tableHeaderView = tvhview;
    }
    
    
}

-(void) tableFooterDraw {
    
    
    
    if (self.tableViewType == collectionType) {
        
        if(self.pscView.footerView != nil) {
            [self.pscView.footerView removeFromSuperview];
            self.pscView.footerView  = nil;
            
        }
        
        pscViewfooterLoginVheight = 300;
        self.pscView.footerView = [self footerLoginView];
        
        if([self.sectionarrdata count] < 1){
            NSLog(@"");
            
            self.pscView.footerView.frame = CGRectMake(self.pscView.footerView.frame.origin.x, 0, self.pscView.footerView.frame.size.width, self.pscView.footerView.frame.size.height);
            
        }else{
            
            self.pscView.footerView.frame = CGRectMake(self.pscView.footerView.frame.origin.x, 0, self.pscView.footerView.frame.size.width, self.pscView.footerView.frame.size.height);
            
        }
        
    }else{
        
        
        if(self.eiTableView.tableFooterView != nil) {
            [self.eiTableView.tableFooterView removeFromSuperview];
            self.eiTableView.tableFooterView  = nil;
            
        }
        
        pscViewfooterLoginVheight = 300;
        
        self.eiTableView.tableFooterView = [self footerLoginView];
        
    }
    
    
    
}

-(UIView*)footerLoginView {
    
    SectionTBViewFooter *footercontainview = [[SectionTBViewFooter alloc] initWithTarget:self Nframe:CGRectMake(0.0,0.0, APPFULLWIDTH, pscViewfooterLoginVheight)] ;
    
    return footercontainview;
}

- (void)btntouchAction:(id)sender {
    if([((UIButton *)sender) tag] == 1005)  {
        //사업자정보
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSCOMPANYINFOTURL]];
        
        
        return;
    }else if([((UIButton *)sender) tag] == 1006)  {
        //채무지급보증
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSCOMPANYGUARANTEEURL]];
        
        
        return;
        
    }
    
    
    else {
        [delegatetarget btntouchAction:sender];
    }
}

- (BOOL)isExsitSectionBanner {
    @try {
        if( NCO([self.apiResultDic objectForKey:@"banner"]) ){
            if( ![NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"]) isEqualToString:@""]){
                return YES;
            }else {
                return NO;
            }
            
        }else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return  NO;
    }
    
}

-(UIView*)topBannerview {
    
    UIView *bannercontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:BANNERHEIGHT])] ;
    
    UIImageView* basebgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:BANNERHEIGHT])] ;
    basebgimgview.image = [UIImage imageNamed:@"noimg_100.png"];
    [bannercontainview addSubview:basebgimgview];
    
    bannerimg = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, APPFULLWIDTH,[Common_Util DPRateOriginVAL:BANNERHEIGHT])];
    [bannercontainview addSubview:bannerimg];
    bannercontainview.alpha = 1.0f;    //
    
    
    
    UIButton* btn_gucell = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_gucell setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    [btn_gucell setFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:BANNERHEIGHT])];
    [btn_gucell addTarget:self action:@selector(BannerCellPress) forControlEvents:UIControlEventTouchUpInside];
    btn_gucell.accessibilityLabel = NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"title"]);
    [bannercontainview addSubview:btn_gucell];
    
    if(NCO([self.apiResultDic objectForKey:@"banner"]) == NO)
       return [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, 0)];

    NSString *strURL = NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"]);
    NSLog(@"배너 URL : %@", [[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"] );
    [ImageDownManager blockImageDownWithURL:strURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [strURL isEqualToString:strInputURL]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache) {
                                                                              NSLog(@"Data from cache Image");
                                                                              bannerimg.image = fetchedImage;
                                                                          } else {
                                                                              NSLog(@"Data from None Cached Image");
                                                                              bannerimg.image = fetchedImage;
                                                                          }
            });
                                                                          
        }
                                                                          
                                                                      }];
    
    
    

    return bannercontainview;
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




-(void)setTableViewType:(TABLEVIEWTYPE)myType{
    NSLog(@"myType = %d",myType);
    tableViewType = myType;
    if (tableViewType == collectionType) {
        
        self.eiTableView.hidden = YES;
        self.pscView.hidden = NO;
        scrRefresh = self.pscView;
        
        [self addPullToRefreshHeader:pscView];
        
    }else{
        self.pscView.hidden = YES;
        self.eiTableView.hidden = NO;
        scrRefresh = self.eiTableView;
        
        
        [self addPullToRefreshHeader:eiTableView];
    }
}

- (void)setApiResultDic:(NSDictionary *)resultDic
{
    
    apiResultDic = resultDic;
    
    if(sectionorigindata == nil){
        sectionorigindata = [[NSMutableArray alloc] init];
        
    }else {
        [sectionorigindata removeAllObjects];
    }
    
    NSLog(@"indexEICindexEIC = %lu",(long)indexEIC);
    
    
    if(NCA([resultDic objectForKey:@"productList"]) && [(NSArray*)[resultDic objectForKey:@"productList"] count] > indexEIC)
        sectionorigindata = [[[resultDic objectForKey:@"productList"] objectAtIndex:indexEIC] objectForKey:@"subProductList"];
    
    
    if(self.sectionarrdata == nil){
        self.sectionarrdata = [[NSMutableArray alloc] init];
        
    }else {
        [self.sectionarrdata removeAllObjects];
    }
    
    
    if(self.BottomCellInforow == nil){
        self.BottomCellInforow = [[NSMutableArray alloc] init];
        
    }else {
        [self.BottomCellInforow removeAllObjects];
    }
    
    
    [self sectionarrdataNeedMoreData:ONLYDATASETTING];
    
    [self tableHeaderDraw];
    [self tableFooterDraw];
    
}

- (void)reloadAction{
    
    NSLog(@"");
    
    [self tableHeaderDraw];
    [self tableFooterDraw];
    [self.pscView reloadData];
    [self.eiTableView reloadData];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0f];
}


-(void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype{

    [self.sectionarrdata addObjectsFromArray:sectionorigindata];
    
}

#pragma mark - PS CollectionView

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [SectionEItypePSCell class];
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    
    if (tableViewType == collectionType) {
        return [self.sectionarrdata count];
    }else{
        return 0;
    }
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    SectionEItypePSCell *cell = (SectionEItypePSCell *)[self.pscView dequeueReusableViewForClass:[SectionEItypePSCell class]];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionEItypePSCell" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[SectionEItypePSCell class]]) {
                cell = (SectionEItypePSCell *)oneObject;
            }
        
    }
    NSLog(@"draw collection cell index = %lu",(long)index);
    //20160212 parksegun index 예외발생!! 방어코드 추가
    if(self.sectionarrdata.count > index)
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:index]];
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    
    if(self.sectionarrdata.count <= index)
        return 0;
    
    NSDictionary *dicRow = [self.sectionarrdata objectAtIndex:index];
    
    if ([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"E_N1"]) {
        NSLog(@"E_N1 type height = %f",[Common_Util DPRateOriginVAL:128.0]);
        return (int)[Common_Util DPRateOriginVAL:128.0];
        
    }else if ([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"E_N2"]) {
        NSLog(@"E_N2 type height = %f",[Common_Util DPRateOriginVAL:128.0]*2 + 8.0);
        
        return ((int)[Common_Util DPRateOriginVAL:128.0])*2 + 8.0;
    }else{
        return 0;
    }
    
    
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index{
    NSLog(@"indexindex = %lu",(long)index);
    
    if(!NCA(self.sectionarrdata)) return;
    
    if(self.sectionarrdata.count <= index)
        return;

    
    NSDictionary *secdic = [self.sectionarrdata objectAtIndex:index];
    
    
    NSLog(@"연관추천AB : %@", [DataManager sharedManager].abBestdealVer);
    
    [delegatetarget touchEventTBCell:secdic];
    
    @try {
        
        NSString *prdno = nil;
        URLParser *parser = [[URLParser alloc] initWithURLString:[[self.sectionarrdata objectAtIndex:index] objectForKey:@"linkUrl"]];
        if([parser valueForVariable:@"dealNo"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"dealNo"]];
        }else if([parser valueForVariable:@"prdid"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"prdid"]];
            
        }else {
            prdno = @"";
        }
        
        if( [NCS([self.sectioninfodata  objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]){
            
            
            BOOL isforevent  =   ([[[self.sectionarrdata objectAtIndex:index] objectForKey:@"productName"] length] > 1);
            
            
            
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@",[self.sectioninfodata objectForKey:@"sectionName"], prdno]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)index ],  (isforevent)?[[self.sectionarrdata objectAtIndex:index] objectForKey:@"productName"]:[[self.sectionarrdata objectAtIndex:index] objectForKey:@"linkUrl"] ]  ];
            
        }else {
            
            
            
            BOOL isforevent  =   ([[[self.sectionarrdata objectAtIndex:index] objectForKey:@"productName"] length] > 1);
            
            NSLog(@"event productName nonExist: %i", isforevent);
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@%@", [self.sectioninfodata objectForKey:@"sectionName"],prdno]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", (int)index ],  (isforevent)?[[self.sectionarrdata objectAtIndex:index] objectForKey:@"productName"]:[[self.sectionarrdata objectAtIndex:index] objectForKey:@"linkUrl"] ]  ];
            
            
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
        
    }
    
    
    
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableViewType == tableType) {
        NSLog(@"tableViewType %d",tableViewType);
        return 1;
    }else{
        NSLog(@"tableViewType %d",tableViewType);
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableViewType == tableType) {
        NSLog(@"[self.sectionarrdata count] = %lu",(long)[self.sectionarrdata count]);
        
        return [self.sectionarrdata count];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return eicView.frame.size.height;
    }else {
        return  1;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section == 0){
        return  eicView;
    }else {
        return  nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BIMtypeIdentifier = @"SectionBIMtypeCell";
    static NSString *BIM440typeIdentifier = @"SectionBIM440StypeCell";
    
    static NSString *DCtypeIdentifier = @"SectionDCtypeCell";
    static NSString *BIStypeIdentifier = @"SectionBIStypeCell";
    static NSString *BILtypeIdentifier = @"SectionBILtypeCell";
    static NSString *BIXLtypeIdentifier = @"SectionBIXLtypeCell";
    static NSString *BMIAtypeIdentifier = @"SectionBMIAtypeCell";
    static NSString *BSIStypeIdentifier = @"SectionBSIStypeCell";
    static NSString *PSLtypeIdentifier = @"SectionPSLtypeCell";
    static NSString *BTStypeIdentifier = @"SectionBTStypeCell";

    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    
    
    //B_IS 베너 형 이미지 1개 셀 기본 이미지 높이 50
    if([viewType isEqualToString:@"B_IS"]){
        SectionBIStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIStypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionEItypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBIStypeCell class]]) {
//                    cell = (SectionBIStypeCell *)oneObject;
//                }
//
            cell = (SectionBIStypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBIStypeCell" owner:self options:nil] firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return  cell;
        
        //B_IM 베너 형 이미지 1개 셀 기본 이미지 높이 160
    }else if([viewType  isEqualToString:@"B_IM"] ||
             [viewType  isEqualToString:@"I"] ||
             [viewType  isEqualToString:@"E_W1"]
             
             ){
        SectionBIMtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIMtypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBIMtypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBIMtypeCell class]]) {
//                    cell = (SectionBIMtypeCell *)oneObject;
//                    
//                    
//                    
//                }

            cell = (SectionBIMtypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBIMtypeCell" owner:self options:nil] firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return  cell;
        
        //B_IM440 베너 형 이미지 1개 셀 기본 이미지 높이 220
    }else if([viewType  isEqualToString:@"B_IM440"] ||
             [viewType  isEqualToString:@"I"]){
        SectionBIM440StypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIM440typeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBIM440StypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBIM440StypeCell class]]) {
//                    cell = (SectionBIM440StypeCell *)oneObject;
//                }

            cell = (SectionBIM440StypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBIM440StypeCell" owner:self options:nil] firstObject];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return  cell;
        
        //B_IL 베너 형 이미지 1개 셀 기본 이미지 높이
    }else if([viewType  isEqualToString:@"B_IL"]){
        SectionBILtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BILtypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBILtypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBILtypeCell class]]) {
//                    cell = (SectionBILtypeCell *)oneObject;
//                }
            
            cell = (SectionBILtypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBILtypeCell" owner:self options:nil] firstObject];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return  cell;
        
        //B_IXL 베너 형 이미지 1개 셀 기본 이미지 높이
    }else if([viewType  isEqualToString:@"B_IXL"]){
        SectionBIXLtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIXLtypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBIXLtypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBIXLtypeCell class]]) {
//                    cell = (SectionBIXLtypeCell *)oneObject;
//                }
            cell = (SectionBIXLtypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBIXLtypeCell" owner:self options:nil] firstObject];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return  cell;
        
        //B_IXL 베너 형 이미지 3개 셀 기본 첫번쨰 이미지 높이 240,116,116
    }else if([viewType  isEqualToString:@"B_MIA"]){
        SectionBMIAtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BMIAtypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBMIAtypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBMIAtypeCell class]]) {
//                    cell = (SectionBMIAtypeCell *)oneObject;
//                }

            cell = (SectionBMIAtypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBMIAtypeCell" owner:self options:nil] firstObject];
            
        }
        
        cell.target = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]];
        
        return  cell;
        
    }else if([viewType  isEqualToString:@"B_SIS"]){
        SectionBSIStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BSIStypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBSIStypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBSIStypeCell class]]) {
//                    cell = (SectionBSIStypeCell *)oneObject;
//                }
            cell = (SectionBSIStypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBSIStypeCell" owner:self options:nil] firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.target = self;
        
        [cell setCellInfoNDrawData:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]];
        
        return  cell;
        
    }else if([viewType  isEqualToString:@"SL"]){
        SectionPSLtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:PSLtypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionPSLtypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionPSLtypeCell class]]) {
//                    cell = (SectionPSLtypeCell *)oneObject;
//                }

            cell = (SectionPSLtypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionPSLtypeCell" owner:self options:nil] firstObject];
            
        }
        
        cell.target = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"]];
        
        return  cell;
        
    }else if([viewType  isEqualToString:@"B_TS"]){
        SectionBTStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BTStypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBTStypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBTStypeCell class]]) {
//                    cell = (SectionBTStypeCell *)oneObject;
//                }

            cell = (SectionBTStypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBTStypeCell" owner:self options:nil] firstObject];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        return  cell;
        
    }else{
        
        
        
        
        SectionDCtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:DCtypeIdentifier];
        
        if (cell == nil)
        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionDCtypeCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionDCtypeCell class]]) {
//                    cell = (SectionDCtypeCell *)oneObject;
//                }
            cell = (SectionDCtypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionDCtypeCell" owner:self options:nil] firstObject];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        
        
        
        
        
        
        
        return  cell;
        
        
    }
    
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //loadingcell height
    if(indexPath.row >= [self.sectionarrdata  count] ){
        return 60;
    }
    
    if([self.sectioninfodata  objectForKey:@"viewType"]  == [NSNull null]) {
        return 0;
    }
    
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
   

    
    
    if([viewType  isEqualToString:@"B_IS"]){
        return [Common_Util DPRateOriginVAL:50] + 8.0;
    }else if([viewType  isEqualToString:@"B_IM"]){
        return [Common_Util DPRateOriginVAL:160] + 8.0;
    }else if([viewType  isEqualToString:@"E_W1"]){
        return [Common_Util DPRateOriginVAL:160] + 8.0;
    }else if([viewType  isEqualToString:@"B_IM440"]){
        return [Common_Util DPRateOriginVAL:220] + 8.0;
    }else if([viewType  isEqualToString:@"B_IL"]){
        return [Common_Util DPRateOriginVAL:240] + 8.0;
    }else if([viewType  isEqualToString:@"B_IXL"]){
        return [Common_Util DPRateOriginVAL:270] + 8.0;
    }else if([viewType  isEqualToString:@"B_MIA"]){
        return 30.0 + [Common_Util DPRateOriginVAL:240] + 8.0;
    }else if([viewType  isEqualToString:@"B_SIS"]){
        return [Common_Util DPRateOriginVAL:220] + 8.0;
    }else if([viewType  isEqualToString:@"SL"]){
        return 32 + [Common_Util DPRateVAL:172 withPercent:88];//[Common_Util DPRateOriginVAL:208];
    }else if([viewType  isEqualToString:@"B_TS"]){
        return 40.0;//[Common_Util DPRateOriginVAL:40];
    }else if([viewType  isEqualToString:@"L"]){
        
        
        return [Common_Util DPRateVAL:246 withPercent:66]+kTVCBOTTOMMARGIN;
        
    }else{
        return 0;
    }
    
    
}



//DealCell 터치 전용
//tb delegate
- (void)touchEventDealCell:(NSDictionary *)dic {
    [delegatetarget touchEventTBCell:dic];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(NCA(self.sectionarrdata) && self.sectionarrdata.count > indexPath.row)
    {
        NSDictionary *secdic = [self.sectionarrdata objectAtIndex:indexPath.row];
        [delegatetarget touchEventTBCell:secdic];
    }
    else
    {
        return;
    }
    
    
    @try {
        
        NSString *prdno = nil;
        URLParser *parser = [[URLParser alloc] initWithURLString:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]];
        if([parser valueForVariable:@"dealNo"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"dealNo"]];
        }else if([parser valueForVariable:@"prdid"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"prdid"]];
            
        }else {
            prdno = @"";
        }
        
        if( [NCS([self.sectioninfodata objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]){
            
            
            BOOL isforevent  =   ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"] length] > 1);
            
            
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@",[self.sectioninfodata objectForKey:@"sectionName"], prdno]
             
                                   withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)indexPath.row ],  (isforevent)?[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"] ]  ];
            
        }else {
            
            
            
            BOOL isforevent  =   ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"] length] > 1);
            
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







- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //GTM tracker 상하 스크롤중
    if( indexPath.row != 0 && (indexPath.row%25)==0){
        
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_App_%@_Impression", [self.sectioninfodata objectForKey:@"sectionName"] ]
                               withLabel:[NSString stringWithFormat:@"%ld", (long)indexPath.row]     ];
    }
    
    
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"indexPath = %lu",(long)indexPath.row);
}



#pragma mark - PullToRefresh

- (void)addPullToRefreshHeader:(UIView *)target {
    if (refreshHeaderView == nil) {
        refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, APPFULLWIDTH, REFRESH_HEADER_HEIGHT)];
        refreshHeaderView.backgroundColor = [UIColor clearColor];
        
        
        
        refreshGSSHOPCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png"]];
        refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                               (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                               40, 40);
        
        [refreshHeaderView addSubview:refreshGSSHOPCircle];
    }
    
    [target addSubview:refreshHeaderView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    [scrollExpandingDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollExpandingDelegate scrollViewWillBeginDragging:scrollView];
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.delegatetarget customscrollViewDidScroll:(UIScrollView *)scrollView];
    [self.scrollExpandingDelegate scrollViewDidScroll:scrollView];
    
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            scrRefresh.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            scrRefresh.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                
                refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                                       (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                                       40, 40);
            } else {
                float i = fabs(scrollView.contentOffset.y);
                if(i>40) { i=40; }
                refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- i) / 2), (floorf(REFRESH_HEADER_HEIGHT - i) / 2),  i, i);
                
                
            }
        }];
    }
    
    if (self.tableViewType == collectionType) {
        
        
        if (scrollView.contentOffset.y >= heightfloatingHeaderView) {
            if ([eicView superview] != self.view) {
                eicView.frame = CGRectMake(eicView.frame.origin.x, 0.0, APPFULLWIDTH, eicView.frame.size.height);
                
                [self.view addSubview:eicView];
            }
        }else{
            if ([eicView superview] != self.pscView.headerView) {
                
                eicView.frame = CGRectMake(eicView.frame.origin.x, heightfloatingHeaderView, APPFULLWIDTH, eicView.frame.size.height);
                
                [self.pscView.headerView addSubview:eicView];
            }
            
        }
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    /* 필터복원 20141208 */
    [delegatetarget customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate];
    [scrollExpandingDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -REFRESH_HEADER_HEIGHT);
        // Released above the header
        [self startLoading];
    }
}


//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    /* 필터복원 20141208 */
    [delegatetarget customscrollViewDidEndDecelerating:(UIScrollView *)scrollView];
    [scrollExpandingDelegate scrollViewDidEndDecelerating:scrollView];
}


//
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [scrollExpandingDelegate scrollViewShouldScrollToTop:scrollView];
    return YES;
}


//
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [scrollExpandingDelegate scrollViewDidScrollToTop:scrollView];
}


- (void)startLoading {
    isLoading = YES;
    // Show the header
    NSLog(@"scrRefresh = %@",scrRefresh);
    scrRefresh.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                           (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                           40, 40);
    
    refreshGSSHOPCircle.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_02.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_03.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_04.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_05.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_06.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_07.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_08.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_09.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_10.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_11.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_12.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_13.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_14.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_15.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_16.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_17.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_18.png"],
                                           nil];
    
    refreshGSSHOPCircle.animationDuration = 1.0;
    [refreshGSSHOPCircle startAnimating];
    
    
    [(SectionView *)delegatetarget RELOADEICATEGORYWITHTAG:[NSNumber numberWithInt:(int)self.indexEIC]];
    
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        scrRefresh.contentInset = UIEdgeInsetsZero;
        
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    [refreshGSSHOPCircle stopAnimating];
    
    
    
}

- (void)dctypetouchEventTBCell:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr {
    
    //브랜드관, 넘베딜, 그룹매장 상단 쩜쩜쩜 셀 클릭시
    
    [delegatetarget  touchEventTBCell:dic];
    
    NSLog(@"중요한타입 %@", dic);
    
    
    if (NCA([self.sectioninfodata objectForKey:@"subMenuList"]) && [(NSArray *)[self.sectioninfodata objectForKey:@"subMenuList"] count] > 0) {
        @try {
            
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_%@", [self.sectioninfodata  objectForKey:@"sectionName"],
                                              [[[self.sectioninfodata objectForKey:@"subMenuList"] objectAtIndex:self.indexEIC  ] objectForKey:@"sectionName"]  ,
                                              [dic objectForKey:@"viewType"] ]
             
                                   withLabel: cstr
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
                                  withAction:[NSString stringWithFormat:@"MC_%@", [self.sectioninfodata  objectForKey:@"sectionName"] ]
             
             
                                   withLabel: cstr
             ];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"  GTMsendLog Error : %@", exception);
        }
        @finally {
            
        }
        
    }
    
    
}

@end
