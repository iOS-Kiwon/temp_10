//
//  NTCListTBViewController.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "NTCListTBViewController.h"
#import "TableHeaderEItypeView.h"
#import "TableHeaderDCtypeView.h"
#import "NTCBroadCastHeaderView.h"

@interface NTCListTBViewController ()

@end

@implementation NTCListTBViewController

@synthesize sectionView;
@synthesize nalHeaderView;

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo
{
    self = [super init];
    if(self)
    {
        
        
        dateformat = [[NSDateFormatter alloc]init];
        [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
        
        self.sectioninfodata = secinfo;
        self.apiResultDic = resultDic;
        isPagingComm =NO;
        tbviewrowmaxNum =0;
        
    }
    return self;
}


//데이터 셋팅
-(void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype{

    if (arrHashFilter == nil) {
        arrHashFilter = [[NSMutableArray alloc] init];
    }else{
        [arrHashFilter removeAllObjects];
    }

    isHFCell = NO;
    idxHFCate = 0;
    
    
    for (NSInteger i=0; i<[sectionorigindata count]; i++) {

        
        if([NCS([[sectionorigindata objectAtIndex:i] objectForKey:@"viewType"]) isEqualToString:@"HF"]){
            NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
            
            idxHF = i;
            isHFCell = YES;
            rectHFCell = CGRectZero;
            if (dicHFResult == nil) {
                dicHFResult = [[NSMutableDictionary alloc] init];
            }
            [dicHFResult removeAllObjects];
            
            
            if (NCA([dicRow objectForKey:@"subProductList"])) {
            
                NSArray *arrSubPrdList = [dicRow objectForKey:@"subProductList"];
                
                [self.sectionarrdata addObject:[sectionorigindata objectAtIndex:i]];
                
                if ([arrSubPrdList count] > idxHFCate) {
                    NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxHFCate];
                    
                    if (NCA([dicSub objectForKey:@"subProductList"])) {
                        
                        //해당 카테고리의 날방 리스트를 추가
                        [self.sectionarrdata addObjectsFromArray:[dicSub objectForKey:@"subProductList"]];
                        
                        //해시 필터 검색을 위해 0배열인 "몽땅" 에 해당하는 데이터 추가
                        [arrHashFilter addObjectsFromArray:[[arrSubPrdList objectAtIndex:0] objectForKey:@"subProductList"]];
                    }
                }
                
                
            }
            
            
            
        }else{
            
            
            [self.sectionarrdata addObject:[sectionorigindata objectAtIndex:i]];
        }
        
        
    }
    
            
    
}


//테이블뷰 해더 그리기
-(void) tableHeaderDraw :(TVCONTENTBASE)tvcbasesource {
    
    
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
    tableheaderListheight=0;
    
    if (self.tvhview == nil) {
        self.tvhview = [[UIView alloc] initWithFrame:CGRectZero ];
    }else{
        for (UIView *views in self.tvhview.subviews) {
            [views removeFromSuperview];
        }
        self.tvhview.frame = CGRectZero;
    }
    
    
    
    //배너
    if([self isExsitSectionBanner]){
        NSInteger heightBanner = NALBANNERHEIGHT;
        if (NCO([self.apiResultDic objectForKey:@"banner"]) && [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) length] > 0) {
            heightBanner = [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) integerValue];
        }
        tableheaderBANNERheight = [Common_Util DPRateOriginVAL:heightBanner];
        [self.tvhview addSubview:[self topNalBangBannerview]];
    }
    
    //이미지형태 광고
    if (NCA([self.apiResultDic objectForKey:@"headerList"] ) && [(NSArray *)[self.apiResultDic objectForKey:@"headerList"] count] > 0) {
        
        NSArray *arrHeader = (NSArray *)[self.apiResultDic objectForKey:@"headerList"];
        
        NSLog(@"arrHeaderarrHeader = %@",arrHeader);
        for (NSInteger i=0; i<[arrHeader count]; i++) {
            NSString *viewType = NCS([[arrHeader objectAtIndex:i] objectForKey:@"viewType"]);
            
            if ([viewType isEqualToString:@"B_IM"]) {
                
                TableHeaderEItypeView  *cell = [[TableHeaderEItypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, [Common_Util DPRateOriginVAL:170])];
                
                
                [self.tvhview addSubview:cell];
                
                [cell setCellInfoNDrawData:[arrHeader objectAtIndex:i]];
                
                tableheaderListheight =  tableheaderListheight + [Common_Util DPRateOriginVAL:170];
                
            }else if ([viewType isEqualToString:@"SE"]) {
                
                SectionSEtypeView  *cell = [[SectionSEtypeView alloc] initWithTarget:self Nframe:CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, [Common_Util DPRateVAL:152 withPercent:88])];
                
                [self.tvhview addSubview:cell];
                
                [cell setCellInfoNDrawData:(NSArray *)[[arrHeader  objectAtIndex:i] objectForKey:@"subProductList"]];
                
                tableheaderListheight =  tableheaderListheight + [Common_Util DPRateVAL:152 withPercent:88];
            }else{
                
            }
            
        }
        
        
    }
    
    //날방 생방송영역
    if([NCS([self.sectioninfodata objectForKey:@"viewType"]) isEqualToString:HOMESECTNTCLIST]) {
        
        // 생방송 영역만 리로드 할때 호출됨
        if(tvcbasesource== TVLiveContentsBase){
            
            NSURL *turl = [NSURL URLWithString:NALBANG_LIVE_URL];
            
            NSLog(@"날방 liveUrl api: %@",NALBANG_LIVE_URL);
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
            
            //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
            NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
            [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
            
            NSError *error;
            NSURLResponse *response;
            
            NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];
            
            if (! result || [result isKindOfClass:[NSNull class]] == YES)
            {
                
                NSLog(@"error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                      [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                tvcdic = nil;
                tableheaderTVCVheight = 0;
                
            }
            else {
                
                // Return results
                // nami0342 - JSON
                
                tvcdic = [[result JSONtoValue] objectForKey:@"tvLiveDealBanner"];
                NSLog(@"section NTC JDic: %@",tvcdic);
            }
            
            
        }else {
            
            tvcdic = [self.apiResultDic objectForKey:@"tvLiveDealBanner"];
            
            NSLog(@"section NTC Dic: %@", [self.apiResultDic objectForKey:@"tvLiveDealBanner"] );
        }
        
        
#if APPSTORE
#else
//        if(tvcdic != nil){
//            NSMutableDictionary *testDic = [[NSMutableDictionary alloc] initWithDictionary:[self.apiResultDic objectForKey:@"tvLiveDealBanner"]];
//            //[testDic setObject:@"20160616172100" forKey:@"liveBroadStartTime"];
//            //[testDic setObject:@"20160616173000" forKey:@"broadCloseTime"];
//            tvcdic = [NSDictionary dictionaryWithDictionary:testDic];
//        }
#endif
        
        if(tvcdic != nil) {
            
            NSLog(@"tvcdic:: %@",  tvcdic);
            
            self.nalHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NTCBroadCastHeaderView" owner:self options:nil] firstObject];
            self.nalHeaderView.target = self;
            
            isOnAir = ([NCS([tvcdic objectForKey:@"onAirYn"]) isEqualToString:@"Y"])?YES:NO;
            
            
            if(isOnAir){
                
                //생방송일때
                if ([NCS([tvcdic objectForKey:@"promotionName"]) length] > 0) {
                    //상단 공지 문구 있을경우 높이 조절
                    
                    tableheaderTVCVheight = 35.0 + (APPFULLWIDTH-20.0)*(169.0/300.0)  + 10.0;
                    
                    [self.nalHeaderView showViewTop:YES];
                    
                    
                }else{
                    //공지 문구 없을경우
                    tableheaderTVCVheight = (APPFULLWIDTH-20.0)*(169.0/300.0) + 10.0;
                    
                    [self.nalHeaderView showViewTop:NO];
                }
                
                
                if (NCO([tvcdic objectForKey:@"nalTalkBanner"]) && NCA([[tvcdic objectForKey:@"nalTalkBanner"] objectForKey:@"talkList"])){
                    //날톡 array 가 들어올경우에만 날톡 영역 노출
                    tableheaderTVCVheight = tableheaderTVCVheight + 50.0;
                }
                
                
                self.nalHeaderView.frame = CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, tableheaderTVCVheight);
                
                
                //생방송일경우 종료시간 표시후 카운팅 타이머
                [self drawliveBroadlefttime];
                
                isTimer = YES;
                timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(timerProc)
                                                       userInfo:nil
                                                        repeats:YES];
            }else{
                //vod 일때
                
                tableheaderTVCVheight = (APPFULLWIDTH-20.0)*(169.0/300.0) + 10.0;
                
                if (NCO([tvcdic objectForKey:@"product"])) {
                    //상품정보가 있을경우에만 해당 영역 노출
                    
                    //상품 조건따라 높이 다름
                    if ([NCS([[tvcdic objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VP"]) { //상품 있음
                        tableheaderTVCVheight = tableheaderTVCVheight + 50.0;
                    }else if ([NCS([[tvcdic objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VNP"]) { //상품없이 제목만
                        tableheaderTVCVheight = tableheaderTVCVheight + 32.0;
                    }
                    
                    
                }
                
                //방송 시작시간
                long long startStamp = [[dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])] timeIntervalSince1970];
                long long nowStamp = [[NSDate date] timeIntervalSince1970];
                //다음 방송까지 남은시간
                long long leftTimeSec = startStamp - nowStamp;
                
                NSLog(@"leftTimeSec = %lld",(long long)leftTimeSec);
                NSLog(@"leftTimeSec - 3600*3 = %lld",(long long)leftTimeSec - 3600*3);
                if ((leftTimeSec > 0) && (leftTimeSec - 3600*3 <= 0)) {
                    //방송시작 3 시간전 일경우 공시사항 영역에서 남은 시간 카운팅
                    [self.nalHeaderView showViewTop:YES];
                    
                    tableheaderTVCVheight = 35.0 + tableheaderTVCVheight;
                    
                    [self drawliveBroadtimeToStart];
                    
                }else{
                    //방송시작 3 시간전이 아닐경우 비노출
                    [self.nalHeaderView showViewTop:NO];
                }
                
                self.nalHeaderView.frame = CGRectMake(0, tableheaderBANNERheight + tableheaderListheight, APPFULLWIDTH, tableheaderTVCVheight);
                
                //시작 시간이 지금 시간보다 작을경우
                if ((double)[[dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])] timeIntervalSince1970] < (double)[[NSDate date] timeIntervalSince1970]) {
                    
                }else{
                    
                    isTimer = YES;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:self
                                                           selector:@selector(timerProc)
                                                           userInfo:nil
                                                            repeats:YES];
                }
            }
            
            [self.nalHeaderView setCellInfoNDrawData:tvcdic];
            
            [self.tvhview addSubview:self.nalHeaderView];
            
            //하단 마진 여백 추가
            tableheaderTVCBOTTOMMARGIN =  kTVCBOTTOMMARGIN;
            UIView* dummyv = [[UIView alloc] initWithFrame: CGRectMake(0,  tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight, APPFULLWIDTH, tableheaderTVCBOTTOMMARGIN)];
            
            [self.tvhview addSubview:dummyv];
        }
        
    }
    
    self.tvhview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight + tableheaderTVCBOTTOMMARGIN+tableheaderNo1DealListheight+tableheaderNo1DealZoneheight);
    
    
    self.tableView.tableHeaderView = self.tvhview;
    
    self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
    
}




-(void)timerProc
{
    
    
    if(!isTimer){
        [timer invalidate];
        timer = nil;
    }
    
    if(isOnAir){
        //생방송일경우 방송중인 시간 업데이트
        [self drawliveBroadlefttime];
        
        
    }else{
        
        //다음방송 시작시간
        NSDate *startTime = [dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])];
        NSLog(@"startTime = %@",startTime);
        long long startStamp = [startTime timeIntervalSince1970];
        
        NSLog(@"startStamp = %lld",startStamp);
        
        //다음 방송까지 남은시간
        long long leftTimeSec = startStamp - (long long)[[NSDate date] timeIntervalSince1970];
        
        NSLog(@"leftTimeSec = %lld",(long long)leftTimeSec);
        if ((leftTimeSec > 0) && (leftTimeSec - 3600*3 <= 0)) {
            //방송시작 3 시간전 상단 타이틀 업데이트
            [self drawliveBroadtimeToStart];
            
        }else{
            //방송시간까지 3시간 이상 남은경우돌림
            [self checkStartTime];
        }
    }
    
    
    
    
    
    
    
}

-(void)removeSectionTimer {
    if ([timer isValid] == YES) {
        [timer invalidate];
        timer = nil;
    }
    
    isTimer = NO;
}

- (void) drawliveBroadlefttime {
    //방송 남은시간
    
    if(TVCapirequestcount >= TVCREQUESTMAXCOUNT){
        
        
        [self removeSectionTimer];
        self.nalHeaderView.lblLiveTime.text = GSSLocalizedString(@"home_tv_live_view_close_text");
        return;
    }
    
    // NSLog(@"null 확인 %@",[tvcdic objectForKey:@"broadEndTime"]);
    if([NCS([tvcdic objectForKey:@"broadCloseTime"]) isEqualToString:@""]){
        
        [timer invalidate];
        timer = nil;
        isTimer = NO;
        return;
    }
    
    
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:NCS([tvcdic objectForKey:@"broadCloseTime"])];
    long long closestamp = [closeTime timeIntervalSince1970];
    
    
    
    NSString * dbstr =   [NSString stringWithFormat:@"%lld", (long long)closestamp ];
    
    //reload tb 통신 실패시
    @try
    {
        [ self.nalHeaderView.lblLiveTime setText:[self getDateLeft:dbstr]];
        self.nalHeaderView.lblLiveTime.textAlignment = NSTextAlignmentCenter;
        
    }
    @catch (NSException *exception)
    {
        isTimer = NO;
        NSLog(@"lefttimeLabel not Exist : %@",exception);
    }
    @finally
    {
        if(![self.nalHeaderView.lblLiveTime isDescendantOfView:self.view])  isTimer = NO;
    }
    
}

- (NSString *) getDateLeft:(NSString *)date{
    
    double left = [date doubleValue] - [[NSDate date] timeIntervalSince1970];
    
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    
    NSString *callTemp = nil;
    
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
        TVCapirequestcount = 0;
    } else if(left <= 0) {
        callTemp = GSSLocalizedString(@"home_tv_live_view_close_text");
        TVCapirequestcount ++;
    } else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
        TVCapirequestcount = 0;
    }
    
    if([callTemp isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]){        
        [timer invalidate];
        timer = nil;
        isTimer = NO;
    }
    
    
    return callTemp;
}


- (void) drawliveBroadtimeToStart {
    //방송 시작까지 남은시간
    
    
    if([NCS([tvcdic objectForKey:@"liveBroadStartTime"]) isEqualToString:@""]){
        
        [timer invalidate];
        timer = nil;
        isTimer = NO;
        return;
    }
    
    
    
    //시작시간
    NSDate *startTime = [dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])];
    double startStamp = [startTime timeIntervalSince1970];
    
    
    //시작 시간이 잘못들어왔을경우
    if (startStamp < (double)[[NSDate date] timeIntervalSince1970]) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
            isTimer = NO;
        }
        
        return;
    }
    
    
    NSString * dbstr =   [NSString stringWithFormat:@"%lld", (long long)startStamp ];
    
    //reload tb 통신 실패시
    @try {

       [self.nalHeaderView setTextWithNextBoardTime:[self getDateLeftToStart:dbstr]];
        
    }
    @catch (NSException *exception) {
        isTimer = NO;
        NSLog(@"lefttimeLabel not Exist : %@",exception);
    }
    
}

-(void)checkStartTime{
    NSLog(@"");
    
    //시작시간
    NSDate *startTime = [dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])];
    long long startStamp = [startTime timeIntervalSince1970] ;
    
    long long leftTimeSec = startStamp - (long long)[[NSDate date] timeIntervalSince1970];
    
    NSLog(@"startStamp = %lld",startStamp);
    
    NSLog(@"leftTimeSec = %lld",leftTimeSec);
    
    if (leftTimeSec < 3600*3) {
        //방송까지 3시간 이하일 경우
        
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
            isTimer = NO;
        }
        if (leftTimeSec < 0) {
            //남은시간이 이미 지나버린경우 생방송 영역만 데이터 갱신후 리로드
            [self tableHeaderDraw:TVLiveContentsBase];
        }else{
            [self tableHeaderDraw:SectionContentsBase];
        }
        
        [self.tableView reloadData];
    }
}

- (NSString *) getDateLeftToStart:(NSString *)date{
    
    double left = [date doubleValue] - [[NSDate date] timeIntervalSince1970];
    
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    

    NSString *callTemp = nil;
    
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
    } else if(left <= 0) {

        callTemp  = [NSString stringWithFormat:@"00:00:00"];
    } else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
    }
    
    if([callTemp isEqualToString:@"00:00:00"]){
        [timer invalidate];
        timer = nil;
        isTimer = NO;
    }
    
    
    return callTemp;
}

- (void)onBtnHFTag:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr{
    //해시테그 선택처리
    
    NSLog(@"arrHashFilter count = %lu",(long)[arrHashFilter count]);
    
    
    if ([self.sectionarrdata count] > idxHF+1) {
        [self.sectionarrdata removeObjectsInRange:NSMakeRange(idxHF+1, [self.sectionarrdata count] -idxHF -1 )];
    }
    
    [dicHFResult removeAllObjects];
    
    idxHFCate = [cnum integerValue];
    
    if ([cstr isEqualToString:kNHPCALLTYPE]) {
        [self reorderHFArrayFastEnumerationUseSet:[dic objectForKey:@"productName"] fromNHP:([cstr isEqualToString:kNHPCALLTYPE])?YES:NO];
    }else{
        
        [self reorderHFArrayAdminButton];
       
    }
    
    
    

    [self.tableView reloadData];
    
    if (!CGRectEqualToRect(rectHFCell, CGRectZero)) {
        if (self.tableView.contentOffset.y > rectHFCell.origin.y) {
            [self.tableView setContentOffset:CGPointMake(0.0, rectHFCell.origin.y) animated:NO];
        }
        
    }
    
}

-(UIView*)topNalBangBannerview {
    //날방 전용 상단 배너
    
    UIView *bannercontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:NALBANNERHEIGHT])] ;
    
    
    UIImageView* basebgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:NALBANNERHEIGHT])] ;
    basebgimgview.image = [UIImage imageNamed:@"noimg_100.png"];
    [bannercontainview addSubview:basebgimgview];


    bannerimg = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, APPFULLWIDTH,[Common_Util DPRateOriginVAL:NALBANNERHEIGHT])];
    
    [bannercontainview addSubview:bannerimg];
    bannercontainview.alpha = 1.0f;
    
    
    
    UIButton* btn_gucell = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_gucell setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    [btn_gucell setFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:NALBANNERHEIGHT])];
    [btn_gucell addTarget:self action:@selector(BannerCellPress) forControlEvents:UIControlEventTouchUpInside];
    btn_gucell.accessibilityLabel = NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"title"]);
    [bannercontainview addSubview:btn_gucell];
    
    
    if([self.apiResultDic objectForKey:@"banner"] == NO)
        return [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, 0)];
    
    NSString *imageURL = NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"imageUrl"]);
    NSLog(@"배너 URL : %@", imageURL );
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            
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



-(void)reorderHFArrayFastEnumerationUseSet:(NSString *)strTag fromNHP:(BOOL)fromNHP{
    NSLog(@"arrHashFilter count = %lu",(long)[arrHashFilter count]);
    NSSet *setTag = [NSSet setWithArray:[NSArray arrayWithObject:strTag]];
    __block NSInteger hashTagCount = 0;
    //[arrHashFilter enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop) {
    
    for (NSInteger i=0; i<[arrHashFilter count]; i++) {
        
        NSDictionary *object = [arrHashFilter objectAtIndex:i];
        
        if (NCA([object objectForKey:@"productHashTags"])) {
        
            NSArray *arrProductHashTag = (NSArray *)[object objectForKey:@"productHashTags"];
            NSSet *setSubArray = [NSSet setWithArray:arrProductHashTag];
            
            if ([setTag isSubsetOfSet:setSubArray]) {
                [self.sectionarrdata addObject:object];
                hashTagCount = hashTagCount+1;
                NSLog(@"hashTagCount = %lu",(long)hashTagCount);
            }
            
            
        }
        
        
    }
    
    
        
    //}];
    
    if (fromNHP) {
        [dicHFResult setObject:[NSString stringWithFormat:@"%lu",(long)hashTagCount] forKey:kHFSEARCHCOUNT];
        [dicHFResult setObject:strTag forKey:kHFSEARCHTAG];
    }
}

-(void)reorderHFArrayAdminButton{
    
    NSDictionary *dicRow = nil;
    
    if ([sectionorigindata count] > idxHF) {
        dicRow = [sectionorigindata objectAtIndex:idxHF];
    }else{
        return;
    }
    
    
    if (NCA([dicRow objectForKey:@"subProductList"])) {
        
        NSArray *arrSubPrdList = [dicRow objectForKey:@"subProductList"];
        
        if ([arrSubPrdList count] > idxHFCate) {
            NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxHFCate];
            
            if (NCA([dicSub objectForKey:@"subProductList"])) {
                //해당 카테고리의 날방 리스트를 추가
                [self.sectionarrdata addObjectsFromArray:[dicSub objectForKey:@"subProductList"]];
            }
        }
    }
    
    
    if ([NCS([dicRow objectForKey:@"wiseLog"]) length] > 0 ) {
        
        NSString *wiselog = [dicRow objectForKey:@"wiseLog"];
        
        if([wiselog hasPrefix:@"http://"]) {
            NSLog(@"hashtag: %@",wiselog);
            ////탭바제거
            [ApplicationDelegate wiseAPPLogRequest:wiselog];
        }

    }
    
}


@end
