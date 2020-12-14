//
//  TDCLiveTBViewController.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "TDCLiveTBViewController.h"
#import "SectionBIStypeCell.h"
#import "SectionBIMtypeCell.h"
#import "SectionBILtypeCell.h"
#import "SectionBIXLtypeCell.h"
#import "DataTVCategoryCell.h"
#import "SectionBIM440StypeCell.h"

#define SPECIAL_BANNER_HEIGHT (160 + 20)
#define TDC_NORMAL_BANNERHEIGHT 50
#define TDC_TVCDIC_BANNERHEIGHT 50

@implementation TDCLiveTBViewController

@synthesize apiResultDic;
@synthesize sectionType;
@synthesize arrTvLiveBannerList;

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo {
    self = [super init];
    if(self) {
        dicNeedsToCellClear = [[NSMutableDictionary alloc] init];
        dicMLCellPlayControl = [[NSMutableDictionary alloc] init];
        self.sectioninfodata = secinfo;
        self.sectionType = [resultDic objectForKey:@"layoutType"];
        self.apiResultDic = resultDic;
        isPagingComm = NO;
        tbviewrowmaxNum = 0;
        TVCapirequestcount = 0;
        self.arrTvLiveBannerList = [resultDic objectForKey:@"tvLiveBannerList"];
        
    }
    return self;
}


- (void)setApiResultDic:(NSDictionary *)resultDic {
    
    self.sectionType = [resultDic objectForKey:@"layoutType"];
    apiResultDic = resultDic;
    isPagingComm = NO;
    tbviewrowmaxNum = 0;
    
    self.arrTvLiveBannerList = [resultDic objectForKey:@"tvLiveBannerList"];
    
    if(sectionorigindata == nil) {
        sectionorigindata = [[NSMutableArray alloc] init];
    }
    else {
        [sectionorigindata removeAllObjects];
    }
    
    if ([[resultDic objectForKey:@"productList"] isKindOfClass:[NSArray class]]) {
        [sectionorigindata addObjectsFromArray:[resultDic objectForKey:@"productList"]];
    }
    else {
        sectionorigindata = [resultDic objectForKey:@"productList"];
    }
    
    
    if(self.sectionarrdata == nil) {
        self.sectionarrdata = [[NSMutableArray alloc] init];
    }
    else {
        [self.sectionarrdata removeAllObjects];
    }
    
    
    if([[resultDic objectForKey:@"productList"] isKindOfClass:[NSArray class]]) {
        for (int i=0; i<[sectionorigindata count]; i++) {
            NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
            if ([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"TCF"]) {
                idxTCF = i;
                if(NCA([dicRow objectForKey:@"subProductList"])) {
                    [self.sectionarrdata addObject:dicRow];
                    if (NCA([[[dicRow objectForKey:@"subProductList"] objectAtIndex:idxTCFCate] objectForKey:@"subProductList"])) {
                        [self.sectionarrdata addObjectsFromArray:[[[dicRow objectForKey:@"subProductList"] objectAtIndex:idxTCFCate] objectForKey:@"subProductList"]];
                    }
                }
            }
            else {
                [self.sectionarrdata addObject:dicRow];
            }
        }
    }
    
    //더보기 처리
    ajaxPageUrl = NCS([self.apiResultDic objectForKey:@"ajaxPageUrl"]);
}


- (BOOL)isExsitSectionBanner {
    @try {
        if(NCO([self.apiResultDic objectForKey:@"banner"]) && NCO( [[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"]) && NCO([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"])) {
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




- (void) dealloc {
    self.sectionType = nil;
    self.apiResultDic = nil;
    self.sectioninfodata = nil;
    self.sectionarrdata = nil;

}



#pragma mark - Header

- (void) tableHeaderDraw :(TVCONTENTBASE)tvcbasesource {
    
    if(self.tableView.tableHeaderView != nil) {
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView  = nil;
    }
    
    tableheaderBANNERheight = 0;
    tableheaderTVCDICBANNERheight = 0;
    tableheaderTVCVheight = 0;
    tableheaderTDCTVCBTNVheight = 0;
    //편성표
    tableheadertvlivebannerListheight = 0;
    
    UIView *tvhview = [[UIView alloc] initWithFrame:CGRectZero ];
    tvhview.autoresizesSubviews = NO;
    //배너
    if([self isExsitSectionBanner]) {
        tableheaderBANNERheight = [Common_Util DPRateOriginVAL:BANNERHEIGHT];
        [tvhview addSubview:[self topBannerview]];
    }
    
    NSDictionary *dicTvLive = [self.apiResultDic objectForKey:@"tvLiveBanner"];
    NSDictionary *dicMyShop = [self.apiResultDic objectForKey:@"dataLiveBanner"];
    
    if([NCS([dicTvLive objectForKey:@"broadType"]) isEqualToString:@""] && [NCS([dicTvLive objectForKey:@"linkUrl"]) isEqualToString:@""] && [NCS([dicMyShop objectForKey:@"broadType"]) isEqualToString:@""] && [NCS([dicMyShop objectForKey:@"linkUrl"]) isEqualToString:@""]) {
        tableheaderTVCVheight = 0;
    }
    else {
        
        NSLog(@"tvhview.subviews = %@",tvhview.subviews);
        //기본
        
       
        
       
    }
    
    
    //TV쇼핑탭 상단 띠 베너만 있는 상황에서 아래 무조건 9 여백이 생김. 그래서 나머지 값들이 있어야만 여백나오도록 수정   
    float space = (tableheaderTVCVheight+tableheadertvlivebannerListheight+tableheaderTDCTVCBTNVheight+tableheaderTVCDICBANNERheight) > 0 ? 9 : 0;
    
    tvhview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight+tableheaderTVCVheight+tableheadertvlivebannerListheight+tableheaderTDCTVCBTNVheight+ space +tableheaderTVCDICBANNERheight);
    self.tableView.tableHeaderView = tvhview;
    
    
    
    //[self procGraphAnimation:(TVCONTENTBASE)SectionContentsBase];
}

-(void)tableHeaderChangeSize:(CGSize)sizeChange{
    
    NSLog(@"");
    NSLog(@"self.tableView.contentSize = %@",NSStringFromCGSize(self.tableView.contentSize));
    
    tableheaderTVCVheight = sizeChange.height;
    
    float space = (tableheaderTVCVheight+tableheadertvlivebannerListheight+tableheaderTDCTVCBTNVheight+tableheaderTVCDICBANNERheight) > 0 ? 9 : 0;
    
    CGRect closedFrame = CGRectMake(0, 0, APPFULLWIDTH, tableheaderBANNERheight+tableheaderTVCVheight+tableheadertvlivebannerListheight+tableheaderTDCTVCBTNVheight+ space +tableheaderTVCDICBANNERheight);
    CGRect newFrame = closedFrame;
    
    UIView *viewHeader = self.tableView.tableHeaderView;
    //
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    viewHeader.frame = newFrame;
    [self.tableView setTableHeaderView:viewHeader];
    [UIView commitAnimations];
    
    NSLog(@"self.tableView.contentSize = %@",NSStringFromCGSize(self.tableView.contentSize));
    
}


-(void)homeSectionReloadTDCView{
    [self homeSectionChangedPauseDealVideo];
    
    
}



- (void)BannerCellPress {
    
    @try {
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_%@_생방송_Banner", [self.sectioninfodata  objectForKey:@"sectionName"] ]
                               withLabel:  [ [self.apiResultDic objectForKey:@"banner"] objectForKey:@"linkUrl"]];
    }
    @catch (NSException *exception) {
        NSLog(@"TDC BannerCellPress Exception: %@", exception);
    }
    @finally {
        
    }
    [delegatetarget touchEventBannerCell:[self.apiResultDic objectForKey:@"banner"] ];
}





- (void)bannerButtonClicked:(id)sender {
    [delegatetarget btntouchGroupTBWithApiInfo:self.apiResultDic sectionInfo:self.sectioninfodata sender:sender];
}

-(void)touchEventDualPlayerJustLinkStr:(NSString *)strLink{
    if ([self.delegatetarget respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [self.delegatetarget touchEventTBCellJustLinkStr:strLink];
    }
}


#pragma mark - Footer

- (void) tableFooterDraw{
    
    if (self.tableView.tableFooterView != nil) {
        [self.tableView.tableFooterView removeFromSuperview];
        self.tableView.tableFooterView  = nil;
    }
    
    // 리스트 데이터 없으면 푸터 표시 안하도록
    if ([self.sectionarrdata count] < 1) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return;
    }
    
    float tablefooterheight = 0;
    
    UIView *tvfview = [[UIView alloc] initWithFrame:CGRectZero];
    
    {
        if( [self.sectionType  isEqualToString:SPECIALSECTIONLEFTSTYPE] ) {
            if ([self.sectionarrdata count] == 1) {
                UIView *categoryView = [self footerTextCommentView];
                float offset = 4;
                categoryView.frame = CGRectMake(0, offset, APPFULLWIDTH, categoryView.frame.size.height);
                tablefooterheight = categoryView.frame.origin.y + categoryView.frame.size.height;
                [tvfview addSubview:categoryView];
                tvfview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tablefooterheight);
                self.tableView.tableFooterView= tvfview;
            }
        }// if
        
        {
            self.tableView.tableFooterView= [self footerLoginView];
            return;
        }
    }
}


- (UIView*)footerTextCommentView {
    
    UIView *bannercontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH,  TDC_NORMAL_BANNERHEIGHT )] ;
    bannercontainview.backgroundColor = [UIColor clearColor];
    UIImageView* basebgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(APPFULLWIDTH/2 - 15,  0, 35,  39)] ;
    basebgimgview.image = [UIImage imageNamed:@"spimg_info.png"];
    [bannercontainview addSubview:basebgimgview];
    UILabel *titleLabel;
    UILabel *subtitle1Label;
    UILabel *subtitle2Label;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, APPFULLWIDTH, 20)];
    subtitle1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, APPFULLWIDTH, 20)];
    subtitle2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, APPFULLWIDTH, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[Mocha_Util getColor:@"999999"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = GSSLocalizedString(@"section_cs_special_tableview_footer_text01");
    [bannercontainview addSubview:titleLabel];
    subtitle1Label.font = [UIFont boldSystemFontOfSize:13];
    subtitle1Label.textAlignment = NSTextAlignmentCenter;
    [subtitle1Label setTextColor:[Mocha_Util getColor:@"999999"]];
    [subtitle1Label setBackgroundColor:[UIColor clearColor]];
    subtitle1Label.text = GSSLocalizedString(@"section_cs_special_tableview_footer_text02");
    [bannercontainview addSubview:subtitle1Label];
    subtitle2Label.font = [UIFont boldSystemFontOfSize:13];
    subtitle2Label.textAlignment = NSTextAlignmentCenter;
    [subtitle2Label setTextColor:[Mocha_Util getColor:@"999999"]];
    [subtitle2Label setBackgroundColor:[UIColor clearColor]];
    subtitle2Label.text = GSSLocalizedString(@"section_cs_special_tableview_footer_text03");
    [bannercontainview addSubview:subtitle2Label];
    return bannercontainview;
}


- (void)categoryButtonClicked:(id)sender {
    [delegatetarget btntouchGroupTBWithApiInfo:self.apiResultDic sectionInfo:self.sectioninfodata sender:sender];
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionarrdata count];
}


//tb delegate
- (void)touchEventTBCell:(NSDictionary *)dic {
    [delegatetarget touchEventTBCell:dic];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.sectionarrdata count] == 0 || self.sectionarrdata == nil) {
        return;
    }
    
    NSDictionary *secdic = [self.sectionarrdata objectAtIndex:indexPath.row];
    NSString *viewType = NCS([secdic objectForKey:@"viewType"]);
    
    if ([viewType isEqualToString:@"DSL_A"] || [viewType isEqualToString:@"DSL_B"] ||
        [viewType isEqualToString:@"DSL_A2"] || [viewType isEqualToString:@"RPS"] ||
        [viewType isEqualToString:@"FPC"] || [viewType isEqualToString:@"BFP"] ||
        [viewType isEqualToString:@"TCF"] || [viewType isEqualToString:@"B_INS"] ||
        [viewType isEqualToString:@"B_SIC"] || [viewType isEqualToString:@"PDV"] ||
        [viewType isEqualToString:@"B_TSC"] || [viewType isEqualToString:@"B_IT"] ||
        [viewType isEqualToString:@"B_DHS"] || [viewType isEqualToString:@"HF"] ||
        [viewType isEqualToString:@"NHP"]  || [viewType isEqualToString:@"API_SRL"] )
    {
        return;
    }
    
    [delegatetarget touchEventTBCell:secdic];
    
    @try {
        NSString *prdno = nil;
        URLParser *parser = [[URLParser alloc] initWithURLString:[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]];
        if([parser valueForVariable:@"dealNo"] != nil) {
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"dealNo"]];
        }
        else if([parser valueForVariable:@"prdid"] != nil) {
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"prdid"]];
            
        }
        else {
            prdno = @"";
        }
        
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_%@_생방송_%@", [self.sectioninfodata objectForKey:@"sectionName"],prdno]
                               withLabel:  [NSString stringWithFormat:@"%@_%@",   [NSString stringWithFormat:@"%d", (int)indexPath.row ], [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]]];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
        
    }
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tbviewrowmaxNum <= indexPath.row) {
        tbviewrowmaxNum = (int)indexPath.row;
    }
    
    //20180823 페이징 처리 추가
    if( ajaxPageUrl.length > 0 ) {
        NSInteger idxLast = [self.sectionarrdata count] - 1;
        if(idxLast == 0 || (idxLast == indexPath.row && indexPath.row != 0) ) { // 끝지점 도착!!
            // 데이터 추가요청
            [self loadMoreDataUrl];
        }
    }
}





-(void)TopCategoryTabButtonClicked:(id)sender {
    [delegatetarget  TopCategoryTabButtonClicked:sender];
}



#pragma mark - Table refresh action
- (void)refreshTCFCateStay {
    
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    isTimer = NO;
    [delegatetarget tablereloadAction];
}

- (void)refreshTDCLiveContents {
    
    NSString *itemString = [Mocha_Util strReplace:@"#" replace:@"" string:[self.sectioninfodata objectForKey:@"sectionCode"] ];
    NSURL *turl = [NSURL URLWithString:TVSHOP_LIVE_URLWITHCODE(itemString )];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f];
    
    NSInteger randNum = arc4random_uniform(11);
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // Submit & retrieve results
    // NSError *error;
    // NSHTTPURLResponse *response;
    NSLog(@"Contacting Server....");
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"resultString =%@",resultString);
                                      if ([NCS(resultString) length] == 0) {
                                          
                                          NSLog(@"[NCS(resultString) length] == 0");
                                          NSLog(@"TVCapirequestcount = %ld",(long)TVCapirequestcount);
                                          NSLog(@"TVCREQUESTMAXCOUNT = %ld",(long)TVCREQUESTMAXCOUNT);
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                                  TVCapirequestcount ++;
                                                  NSLog(@"테스트");
                                                  [self performSelector:@selector(refreshTDCLiveContents)  withObject:nil afterDelay:5.0f + (double)randNum];
                                              }
                                          });
                                          
                                      }
                                      else {
                                          NSDictionary *result = [resultString JSONtoValue];
                                          
                                          if (NCO(result) && NCO([result objectForKey:@"tvLiveBanner"])) {
                                              
                                              tvcdic = [result objectForKey:@"tvLiveBanner"];
                                              
                                              self.arrTvLiveBannerList = [result objectForKey:@"tvLiveBannerList"];
                                              
                                              NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
                                              [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
                                              [dateformat setDateFormat:@"yyyyMMddHHmmss"];
                                              NSDate *closeTime = [dateformat dateFromString:NCS([tvcdic objectForKey:@"broadCloseTime"])];
                                              int closestamp = [closeTime timeIntervalSince1970];
                                              NSString * dbstr =   [NSString stringWithFormat:@"%d", closestamp ];
                                              double left = [dbstr doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
                                              
                                              dispatch_async( dispatch_get_main_queue(),^{
                                                  if (left <= 0) {
                                                      if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                                          TVCapirequestcount ++;
                                                          [self performSelector:@selector(refreshTDCLiveContents)  withObject:nil afterDelay:5.0f + (double)randNum];
                                                      }
                                                  }
                                                  else {
                                                      //TVLiveContentReload 새로 만듬 위에서 통신성공한 tvcdic 그대로 사용하기위함
                                                      //[self refreshTCFCateStay];
                                                      
                                                      if ([timer isValid]) {
                                                          [timer invalidate];
                                                      }
                                                      timer = nil;
                                                      isTimer = NO;
                                                      
                                                      NSLog(@"refreshTDCLiveContentsrefreshTDCLiveContents");
                                                      
                                                      [self tableHeaderDraw:TVLiveContentReload];
                                                      //TVLiveContentReload 새로 만듬 위에서 통신성공한 tvcdic 그대로 사용하기위함
                                                      [self tableFooterDraw];
                                                      self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
                                                      [self.tableView reloadData];
                                                      
                                                  }
                                              });
                                          }
                                      }
                                  }];
    [task resume];
    
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultString =%@",resultString);
        if ([NCS(resultString) length] == 0) {
            
            NSLog(@"[NCS(resultString) length] == 0");
            NSLog(@"TVCapirequestcount = %ld",(long)TVCapirequestcount);
            NSLog(@"TVCREQUESTMAXCOUNT = %ld",(long)TVCREQUESTMAXCOUNT);
            
            if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                TVCapirequestcount ++;
                NSLog(@"테스트");
                [self performSelector:@selector(refreshTDCLiveContents)  withObject:nil afterDelay:5.0f + (double)randNum];
            }
            
        }
        else {
            NSDictionary *result = [resultString JSONtoValue];
            
            if (NCO(result) && NCO([result objectForKey:@"tvLiveBanner"])) {
                
                tvcdic = [result objectForKey:@"tvLiveBanner"];
                
                self.arrTvLiveBannerList = [result objectForKey:@"tvLiveBannerList"];
                
                NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
                [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
                [dateformat setDateFormat:@"yyyyMMddHHmmss"];
                NSDate *closeTime = [dateformat dateFromString:NCS([tvcdic objectForKey:@"broadCloseTime"])];
                int closestamp = [closeTime timeIntervalSince1970];
                NSString * dbstr =   [NSString stringWithFormat:@"%d", closestamp ];
                double left = [dbstr doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
                
                dispatch_async( dispatch_get_main_queue(),^{
                    if (left <= 0) {
                        if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                            TVCapirequestcount ++;
                            [self performSelector:@selector(refreshTDCLiveContents)  withObject:nil afterDelay:5.0f + (double)randNum];
                        }
                    }
                    else {
                        //TVLiveContentReload 새로 만듬 위에서 통신성공한 tvcdic 그대로 사용하기위함
                        //[self refreshTCFCateStay];
                        
                        if ([timer isValid]) {
                            [timer invalidate];
                        }
                        timer = nil;
                        isTimer = NO;
                        
                        NSLog(@"refreshTDCLiveContentsrefreshTDCLiveContents");
                        
                        [self tableHeaderDraw:TVLiveContentReload];
                        //TVLiveContentReload 새로 만듬 위에서 통신성공한 tvcdic 그대로 사용하기위함
                        [self tableFooterDraw];
                        self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
                        [self.tableView reloadData];
                        
                    }
                });
            }
        }
        [queue waitUntilAllOperationsAreFinished];
    }];
     */
}


- (void)reloadAction {
    [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
    [self tableFooterDraw];
    self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
    animtbindex = -1;
    [self.tableView reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0f];
}




- (void)categoryOpenButtonClicked:(id)sender {
    [delegatetarget btntouchGroupTBWithApiInfo:self.apiResultDic sectionInfo:self.sectioninfodata sender:sender];
}



#pragma mark - Favorite Button

// 찜 버튼 처리
- (void)favoriteButtonClickedWithCell:(UITableViewCell *)cell sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([self.sectionType isEqualToString:@"L"]) {
        [delegatetarget touchEventGroupTBCellWithRowInfo:[self.sectionarrdata objectAtIndex:indexPath.row]
                                             sectionInfo:self.sectioninfodata
                                                  sender:sender];
    }
}

@end
