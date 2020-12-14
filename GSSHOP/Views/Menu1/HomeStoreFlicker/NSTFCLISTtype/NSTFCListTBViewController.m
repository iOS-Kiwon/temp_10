//
//  NSTFCListTBViewController.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "NSTFCListTBViewController.h"
#import "TableHeaderEItypeView.h"
#import "TableHeaderDCtypeView.h"

@interface NSTFCListTBViewController ()

@end

@implementation NSTFCListTBViewController
@synthesize nalHeaderView;
@synthesize sectionView;
@synthesize tvhview;

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if(self)
    {
        
        arrNSTFC = [[NSMutableArray alloc] init];
        arrAllShortBang = [[NSMutableArray alloc] init];
        
        dateformat = [[NSDateFormatter alloc]init];
        [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
        
        isPagingComm =NO;
        tbviewrowmaxNum =0;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 딜전용
-(void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype{
    
    if (arrHashFilter == nil) {
        arrHashFilter = [[NSMutableArray alloc] init];
    }else{
        [arrHashFilter removeAllObjects];
    }
    
    [arrAllShortBang removeAllObjects];
    [arrNSTFC removeAllObjects];
    
    
    
    idxHFCate = 0;
    idxSCFCate = 0;
    

    if (NCA([self.apiResultDic objectForKey:@"videoSectionList"])) {
        NSArray *arrVideoSectionAll = [self.apiResultDic objectForKey:@"videoSectionList"];
        
        /*
        NSMutableArray *arrVideoSectionAll = [[NSMutableArray alloc] initWithArray:[self.apiResultDic objectForKey:@"videoSectionList"]];
        [arrVideoSectionAll removeLastObject];
        [arrVideoSectionAll insertObject:[[self.apiResultDic objectForKey:@"videoSectionList"] objectAtIndex:1] atIndex:0];
        */
        
        //NSLog(@"arrVideoSectionAll = %@",arrVideoSectionAll);
        
        for (NSInteger vsIndex=0; vsIndex<[arrVideoSectionAll count]; vsIndex++) {
            
            NSMutableArray *arrOrderSection = [[NSMutableArray alloc] init];
            NSInteger prevIndex = 0;
            
            
            if (NCO([arrVideoSectionAll objectAtIndex:vsIndex]) && [[arrVideoSectionAll objectAtIndex:vsIndex] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dicSectionSub = [arrVideoSectionAll objectAtIndex:vsIndex];
                
                if (NCO([dicSectionSub objectForKey:@"product"])) {   // 상단 배너 영역
                    
                    NSMutableDictionary *dicBanner = [[NSMutableDictionary alloc] initWithDictionary:[dicSectionSub objectForKey:@"product"]];
                
                    [arrOrderSection addObject:dicBanner];
                    
                    prevIndex = prevIndex +1;
                }
                
                if ([NCS([dicSectionSub objectForKey:@"sectionType"]) isEqualToString:@"NTFCLIST"]) { // 날방일 경우에만 날생방 영역 추가
                    if (NCO([dicSectionSub objectForKey:@"tvLiveDealBanner"])) {
                        
                        NSMutableDictionary *dicBroad = [[NSMutableDictionary alloc] init];
                        [dicBroad addEntriesFromDictionary:[dicSectionSub objectForKey:@"tvLiveDealBanner"]];
                        [dicBroad setObject:@"NTC_Broad" forKey:@"viewType"];
                        
                        indexPathNalbangHeader = [NSIndexPath indexPathForRow:[arrOrderSection count] inSection:vsIndex];
                        
                        tvcdic = [NSDictionary dictionaryWithDictionary:dicBroad];
                        
                        [arrOrderSection addObject:dicBroad];
                        
                        prevIndex = prevIndex +1;
                    }
                }
                
                if (NCA([dicSectionSub objectForKey:@"productList"])) { //날방,숏방 상단 헤더 + 상품들
                    NSArray *arrSubProducts = [dicSectionSub objectForKey:@"productList"];
                    
                    
                    for (NSInteger j=0; j<[arrSubProducts count]; j++) {
                        
                        if (j==0 && [NCS([dicSectionSub objectForKey:@"sectionType"]) isEqualToString:@"STFCLIST"]) {
                            //숏방인경우 숏방 상세에서 빽할시 숏방 탑으로 가야함으로 인덱스패스 저장
                            indexPathShortbangTop = [NSIndexPath indexPathForRow:j inSection:vsIndex];
                        }
                        
                        //뷰타입이 HF인 경우
                        if([NCS([[arrSubProducts objectAtIndex:j] objectForKey:@"viewType"]) isEqualToString:@"HF"]){
                            NSDictionary *dicRow = [arrSubProducts objectAtIndex:j];
                            
                            //날방 전용
                            indexPathHFCell = [NSIndexPath indexPathForRow:j+prevIndex inSection:vsIndex];
                            
                            rectHFCell = CGRectZero;
                            if (dicHFResult == nil) {
                                dicHFResult = [[NSMutableDictionary alloc] init];
                            }
                            [dicHFResult removeAllObjects];
                            
                            
                            if (NCA([dicRow objectForKey:@"subProductList"])) {
                                
                                NSArray *arrSubPrdList = [dicRow objectForKey:@"subProductList"];
                                
                                [arrOrderSection addObject:[arrSubProducts objectAtIndex:j]];
                                
                                if ([arrSubPrdList count] > idxHFCate) {
                                    
                                    NSLog(@"[arrSubPrdList count] = %lu",(long)[arrSubPrdList count]);
                                    
                                    NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxHFCate];
                                    
                                    if (NCA([dicSub objectForKey:@"subProductList"])) {
                                        
                                        NSArray *arrSub = (NSArray *)[dicSub objectForKey:@"subProductList"];
                                        
                                        NSInteger limitCount = 0;
                                        NSInteger checkEndCount = [arrSub count];
                                        
                                        if (checkEndCount >= kDefaultNalBangContentsCount) {
                                            
                                            if (vsIndex+1 < [arrVideoSectionAll count]) {  // 해당 섹션이 최종이 아닐경우 페이징을위한 최소배열 추가
                                                
                                                NSLog(@"vsIndex+1 = %lu",(long)vsIndex+1);
                                                NSLog(@"[arrVideoSectionAll count] = %lu",(long)[arrVideoSectionAll count]);
                                                
                                                limitCount = kDefaultNalBangContentsCount;
                                            }else{
                                                limitCount = checkEndCount;
                                            }
                                            
                                            
                                        }else{
                                            limitCount = checkEndCount;
                                        }
                                        
                                        
                                        [arrOrderSection addObjectsFromArray:[arrSub subarrayWithRange:NSMakeRange(0, limitCount)]];
                                        
                                        
                                        //해시 필터 검색을 위해 0배열인 "몽땅" 에 해당하는 데이터 추가
                                        [arrHashFilter addObjectsFromArray:[[arrSubPrdList objectAtIndex:0] objectForKey:@"subProductList"]];
                                    }
                                }
                            }
                            
                        //뷰타입이 SCF 인경우
                        }else if([NCS([[arrSubProducts objectAtIndex:j] objectForKey:@"viewType"]) isEqualToString:@"SCF"]){
                            NSDictionary *dicRow = [arrSubProducts objectAtIndex:j];
                            
                            //숏방전용
                            indexPathSCFCell = [NSIndexPath indexPathForRow:j+prevIndex inSection:vsIndex];
                            //rectSCFCell = CGRectZero;
                            BOOL SBT_first = YES;
                            
                            if (NCA([dicRow objectForKey:@"subProductList"])) {
                                
                                NSArray *arrSubPrdList = [dicRow objectForKey:@"subProductList"];
                                
                                [arrAllShortBang addObjectsFromArray:arrSubPrdList]; //모든숏방 데이터 저장
                                
                                //숏방없음 테스트용
                                //[(NSMutableArray *)[[arrAllShortBang objectAtIndex:2] objectForKey:@"subProductList"] removeAllObjects];
                                
                                NSLog(@"");
                                
                                [arrOrderSection addObject:[arrSubProducts objectAtIndex:j]];
                                
                                if ([arrSubPrdList count] > idxSCFCate) {
                                    
                                    NSLog(@"[arrSubPrdList count] = %lu",(long)[arrSubPrdList count]);
                                    
                                    NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxSCFCate];
                                    
                                    if (NCA([dicSub objectForKey:@"subProductList"])) {
                                        
                                        NSArray *arrSub = (NSArray *)[dicSub objectForKey:@"subProductList"];
                                        
                                        ///여기서 SCF 필터 및 나누기
                                        //SBT
                                        
                                        NSInteger rowCountSBT = 0;
                                        
                                        NSInteger limitCount = 0;
                                        NSInteger checkEndCount = [arrSub count];
                                        
                                        if (checkEndCount >= kDefaultShortBangContentsCount) {
                                            
                                            if (vsIndex+1 < [arrVideoSectionAll count]) {  // 해당 섹션이 최종이 아닐경우 페이징을위한 최소배열 추가
                                                
                                                limitCount = kDefaultShortBangContentsCount;
                                            }else{
                                                limitCount = checkEndCount;
                                            }
                                            
                                        }else{
                                            limitCount = checkEndCount;
                                        }

                                        
                                        for(int inc = 0; inc < arrSub.count ;inc++){
                                            if([NCS([[arrSub objectAtIndex:inc] objectForKey:@"viewType"]) isEqualToString:@"SBT"])//숏방 타일 셀 3개
                                            {
                                                //3개를 하나의 새로운 딕을 만들어 버린다.
                                                NSMutableArray *temp = [NSMutableArray array];
                                    
                                    
                                                [temp addObject:[arrSub objectAtIndex:inc]];
                                    
                                                
                                                //로직상 kDefaultShortBangContentsPerRow 따라가지 못하고 하드코딩 
                                                if([arrSub count] > inc+1 && [NCS([[arrSub objectAtIndex:inc+1] objectForKey:@"viewType"]) isEqualToString:@"SBT"])
                                                {
                                                    [temp addObject:[arrSub objectAtIndex:inc+1]];
                                                    inc+=1;
                                                    if([arrSub count] > inc+1 && [NCS([[arrSub objectAtIndex:inc+1] objectForKey:@"viewType"]) isEqualToString:@"SBT"])
                                                    {
                                                        [temp addObject:[arrSub objectAtIndex:inc+1]];
                                                        inc+=1;
                                                    }
                                                    
                                                }
                                                
                                                NSMutableDictionary *set = [NSMutableDictionary dictionary];
                                    
                                                [set setObject:@"SBT" forKey:@"viewType"];
                                                [set setObject:temp forKey:@"subProductList"];
                                                [set setObject:SBT_first?@"Y":@"N" forKey:@"isFirst"];
                                                SBT_first = NO;// 상단에 라인을 넣기 위한 flag
                                                                            
                                                [arrOrderSection addObject:set];
                                                
                                                rowCountSBT ++;
                                                
                                                if (rowCountSBT == limitCount) {
                                                    break;
                                                }
                                            }
                                            
                                        }// for
                                        
                                        
                                        
                                        //[arrOrderSection addObjectsFromArray:[arrSub subarrayWithRange:NSMakeRange(0, limitCount)]];
                                        
                                    }
                                }
                                
                            }
                        }else{ //특수 뷰타입이 아닌경우
                            [arrOrderSection addObject:[arrSubProducts objectAtIndex:j]];
                        }
                    }
                }
            }
            
            
            [arrNSTFC addObject:arrOrderSection];
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
        NSInteger heightBanner = BANNERHEIGHT;
        if (NCO([self.apiResultDic objectForKey:@"banner"]) && [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) length] > 0) {
            heightBanner = [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) integerValue];
        }
        tableheaderBANNERheight = [Common_Util DPRateOriginVAL:heightBanner];
        [tvhview addSubview:[self topBannerview]];
    }
    
    self.tvhview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight + tableheaderListheight + tableheaderTVCVheight + tableheaderTDCTVCBTNVheight + tableheaderTVCBOTTOMMARGIN+tableheaderNo1DealListheight+tableheaderNo1DealZoneheight);
    
    NSLog(@"self.tvhview = %@",self.tvhview);
    
    if (self.tvhview.frame.size.height > 0) {
        self.tableView.tableHeaderView = self.tvhview;
        self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
        NSLog(@"self.tableView.tableHeaderView = %@",self.tableView.tableHeaderView);
    }
    
    
    
    
    
    
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
        
        @try {
            
            [self performSelector:@selector(refreshOnlyNalBangHeaderCell)  withObject:nil afterDelay:3.0f];
        }
        @catch (NSException *exception) {
            NSLog(@"방송종료 후 방송컨텐츠 새로고침 ERROR : %@", exception);
        }
        
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
            [self refreshOnlyNalBangHeaderCell];
        }else{
            [self.tableView reloadData];
        }
        
        
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
        
        @try {
            
            //방송 시작임 , 방송 영역만 교체 API 후 리로드 해야함
            [self performSelector:@selector(refreshOnlyNalBangHeaderCell)  withObject:nil afterDelay:3.0f];
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"방송종료 후 방송컨텐츠 새로고침 ERROR : %@", exception);
        }
        
    }
    
    
    return callTemp;
}

-(void)refreshOnlyNalBangHeaderCell{
    
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
        //날방 갱신 실패
        
        tvcdic = nil;
        
    }
    else {
        
        // Return results
        // nami0342 - JSON
        
        NSMutableDictionary *dicBroad = [[NSMutableDictionary alloc] init];
        
        [dicBroad addEntriesFromDictionary:[[result JSONtoValue] objectForKey:@"tvLiveDealBanner"]];
        [dicBroad setObject:@"NTC_Broad" forKey:@"viewType"];
        
        tvcdic = [NSDictionary dictionaryWithDictionary:dicBroad];
        
        NSLog(@"section NTC JDic: %@",dicBroad);
        
        
        
        //조건에 따라 셀 높이가 바뀌어서 셀만 리로드 해서는 테이블뷰 높이에 문제가 생김 전체 리로드로 변경
        [self.tableView reloadData];
        
        /*
        if ([self.tableView.indexPathsForVisibleRows containsObject:indexPathNalbangHeader]) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPathNalbangHeader] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        */
    }
    
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [arrNSTFC count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [(NSArray*)[arrNSTFC objectAtIndex:section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    SectionNSTFCMoreView *footer  = (SectionNSTFCMoreView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSTFCMoreIdentifier];
    footer.section = section;
    footer.target = self;
    
    if ([self tableViewSectionIsShowMore:section]) {
        
        footer.viewDefault.hidden = NO;
        [footer setMoreModeNalbang:(section==indexPathHFCell.section)?YES:NO];
        footer.viewNoData.hidden = YES;
        
    }else{
        
        footer.viewDefault.hidden = YES;
        
        //NSArray *arrCountForSub = (NSArray *);
        if (section == indexPathSCFCell.section && !NCA([[arrAllShortBang objectAtIndex:idxSCFCate] objectForKey:@"subProductList"])) {
            footer.viewNoData.hidden = NO;
        }else{
            footer.viewNoData.hidden = YES;
        }

    }
    
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self tableViewSectionIsShowMore:section]) { // 더보기가 존재할경우
        return 65.0;
    }else{
        
        if (section + 1 < [arrNSTFC count]) {
            //섹션이 마지막이 아닐경우 간격 조절
            
            if (section == indexPathSCFCell.section) {
                
                //해당 섹션이 숏방이고 데이터가 0 일경우 조회된 숏방이 없음 표시
                //NSArray *arrCountForSub = (NSArray *)[[arrAllShortBang objectAtIndex:idxSCFCate] objectForKey:@"subProductList"];
                if (!NCA([[arrAllShortBang objectAtIndex:idxSCFCate] objectForKey:@"subProductList"])) {
                    return 248.0;
                }else{
                    return 25.0;
                }
                
            }else{
                //날방일경우는 마지막 셀이 하단 간격이9 있음으로 6만
                return 16.0;
            }
        }else{
            if (section == indexPathSCFCell.section) {
                //숏방일경우 너무 딱붙어서 간격 띄움
                
                //해당 섹션이 숏방이고 데이터가 0 일경우 조회된 숏방이 없음 표시
                if (!NCA([[arrAllShortBang objectAtIndex:idxSCFCate] objectForKey:@"subProductList"])) {
                    return 231.0;
                }else{
                    return kTVCBOTTOMMARGIN;
                }
                
            }else{
                return CGFLOAT_MIN;
            }
            
        }

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dicRow = [(NSArray*)[arrNSTFC objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *viewType = NCS([dicRow objectForKey:@"viewType"]);
    
    
    if([viewType  isEqualToString:@"B_IXS"]){
        SectionBIXStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIXStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
        //B_IS 베너 형 이미지 1개 셀 기본 이미지 높이 50
    }else if([viewType  isEqualToString:@"B_IS"]){
        SectionBIStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
        //B_IM 베너 형 이미지 1개 셀 기본 이미지 높이 160
    }else  if([viewType  isEqualToString:@"B_IM"]){
        NSLog(@"");
        SectionBIMtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIMtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        NSLog(@"cellcellcellcell = %@",cell);
        return  cell;
        
        
        //B_IM440 베너 형 이미지 1개 셀 기본 이미지 높이 220
    }else if([viewType  isEqualToString:@"B_IM440"]){
        SectionBIM440StypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIM440typeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
        //B_IL 베너 형 이미지 1개 셀 기본 이미지 높이
    }else if([viewType  isEqualToString:@"B_IL"]){
        SectionBILtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BILtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
        //B_IXL 베너 형 이미지 1개 셀 기본 이미지 높이
    }else if([viewType  isEqualToString:@"B_IXL"]){
        SectionBIXLtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BIXLtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
        //B_IXL 베너 형 이미지 3개 셀 기본 첫번쨰 이미지 높이 240,116,116
    }else if([viewType  isEqualToString:@"B_TS"]){
        SectionBTStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BTStypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
    }else if( [viewType  isEqualToString:@"B_TS2"]){
        
        SectionBTS2typeCell *cell     = [tableView dequeueReusableCellWithIdentifier:BTS2typedentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
        
        
        
    }else if([viewType  isEqualToString:@"B_TSC"]){
        SectionB_TSCtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:B_TSCtypedentifier];
        
        //cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setCellInfoNDrawData:dicRow];
        
        
        return  cell;
        
        
        
    }else if([viewType  isEqualToString:@"HF"]){
        SectionHFtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:HFtypedentifier];
        
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setCellInfoNDrawData:dicRow andSeletedIndex:idxHFCate andSearchResult:dicHFResult];
        
        
        //if (CGRectEqualToRect(rectHFCell, CGRectZero)) {
            rectHFCell = [self.tableView rectForRowAtIndexPath:indexPath];
        //}
        
        return  cell;
        
    }else if([viewType  isEqualToString:@"NHP"]){
        
        SectionNHPtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:NHPtypedentifier];
        
        cell.target = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellClick.tag = indexPath.row;
        
        [cell setCellInfoNDrawData:dicRow];
        
        
        
        return  cell;
        
    }
    else if([viewType  isEqualToString:@"B_ISS"]){
        SectionB_ISStypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:B_ISStypeIdentifier];
        
        cell.target = self;
        cell.cellClick.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;

    }else if([viewType  isEqualToString:@"SCF"]){
        SectionSCFtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:SCFtypedentifier];
        
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setCellInfoNDrawData:dicRow andSeletedIndex:idxSCFCate];
        
        return  cell;
        
        
    }else if([viewType  isEqualToString:@"NTC_Broad"]){
        
        SectionNTCHeaderBroadCell *cell     = [tableView dequeueReusableCellWithIdentifier:NTCHeaderBroadIdentifier];
        
        
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat cellHeight = 0.0;
        
        isOnAir = ([NCS([tvcdic objectForKey:@"onAirYn"]) isEqualToString:@"Y"])?YES:NO;
        
        //방송 시작시간
        long long startStamp = [[dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])] timeIntervalSince1970];
        long long nowStamp = [[NSDate date] timeIntervalSince1970];
        //다음 방송까지 남은시간
        long long leftTimeSec = startStamp - nowStamp;
        
        
        if(isOnAir){
            
            //생방송일때
            if ([NCS([tvcdic objectForKey:@"promotionName"]) length] > 0) {
                
                cellHeight = 35.0 + (APPFULLWIDTH-20.0)*(169.0/300.0)  + 10.0;
                
                cell.isShowTop = YES;
                
            }else{
                //공지 문구 없을경우
                cellHeight = (APPFULLWIDTH-20.0)*(169.0/300.0) + 10.0;
                
                cell.isShowTop = NO;
            }
            
            
            if (NCO([tvcdic objectForKey:@"nalTalkBanner"]) && NCA([[tvcdic objectForKey:@"nalTalkBanner"] objectForKey:@"talkList"])){
                //날톡 array 가 들어올경우에만 날톡 영역 노출
                cellHeight = cellHeight + 50.0;
            }
            
            if ([timer isValid]) {
                [timer invalidate];
                timer = nil;
            }
            
            
            isTimer = YES;
            timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(timerProc)
                                                   userInfo:nil
                                                    repeats:YES];
            
        }else{
            //vod 일때
            
            cellHeight = (APPFULLWIDTH-20.0)*(169.0/300.0) + 10.0;
            
            if (NCO([tvcdic objectForKey:@"product"])) {
                //상품정보가 있을경우에만 해당 영역 노출
                
                //상품 조건따라 높이 다름
                if ([NCS([[tvcdic objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VP"]) { //상품 있음
                    cellHeight = cellHeight + 50.0;
                }else if ([NCS([[tvcdic objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VNP"]) { //상품없이 제목만
                    cellHeight = cellHeight + 32.0;
                }
                
                
            }
            
            if ((leftTimeSec > 0) && (leftTimeSec - 3600*3 <= 0)) {
                //방송시작 3 시간전 일경우 공시사항 영역에서 남은 시간 카운팅
                cellHeight = 35.0 + cellHeight;
                cell.isShowTop = YES;
                
            }else{
                cell.isShowTop = NO;
            }
            
            
            //시작 시간이 지금 시간보다 작을경우
            if (startStamp < (long long)[[NSDate date] timeIntervalSince1970]) {
                
            }else{
                if ([timer isValid]) {
                    [timer invalidate];
                    timer = nil;
                }
                
                
                isTimer = YES;
                timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(timerProc)
                                                       userInfo:nil
                                                        repeats:YES];
            }
        }
        
        
        [cell setCellInfoNDrawData:tvcdic cellHeight:cellHeight];
        
        self.nalHeaderView = cell.nalHeaderView;
        
        //view를 설정후에만 아래 라벨 타이머 갱신이 작동함
        if(isOnAir){
            [self drawliveBroadlefttime];
        }else{
            //vod 일때
            if ((leftTimeSec > 0) && (leftTimeSec - 3600*3 <= 0)) {
                [self drawliveBroadtimeToStart];
            }
            
        }
        
        return  cell;
        
    } else if([viewType  isEqualToString:@"B_NIS"]){
        SectionNTCHeaderBannerCell *cell     = [tableView dequeueReusableCellWithIdentifier:B_NIStypeIdentifier];
        
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;

    }
    // 숏방
    else if([viewType  isEqualToString:@"SBT"]){
        SectionSBTtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SBTtypeIdentifier];
        
        cell.target = self;
        cell.backColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow andIndexPath:indexPath];
        
        if ( ![self tableViewSectionIsShowMore:indexPath.section] && (indexPath.row+1 == [[arrNSTFC objectAtIndex:indexPath.section] count])) {
            cell.viewBottomLine.hidden = NO;
        }else{
            cell.viewBottomLine.hidden = YES;
        }
        
        return  cell;
    }
    // 숏방
    else if([viewType  isEqualToString:@"SSL"]){
        SectionSSLtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SSLtypeIdentifier];
        
        cell.target = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        cell.indexPath = indexPath;
        
        return  cell;
    }
    else {
        
        SectionDCtypeCell *cell     = [tableView dequeueReusableCellWithIdentifier:DCtypeIdentifier];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:dicRow];
        
        return  cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!NCO([self.sectioninfodata  objectForKey:@"viewType"])) {
        return 0;
    }
    
    
    NSDictionary *dicRow = [(NSArray*)[arrNSTFC objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *viewType = NCS([dicRow objectForKey:@"viewType"]);
      
    
    if([viewType  isEqualToString:@"B_IXS"]){
        return [Common_Util DPRateOriginVAL:35] + 8.0;
    }else if([viewType  isEqualToString:@"B_IS"]){
        return [Common_Util DPRateOriginVAL:50] + 8.0;
    }else if([viewType  isEqualToString:@"B_IM"]){
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
    }else if([viewType  isEqualToString:@"B_TS"]){
        return 40.0;
    }else if([viewType  isEqualToString:@"B_TS2"]){
        return 40.0;
        
    }else if([viewType  isEqualToString:@"B_TSC"]){
        return  40.0;
        
    }else if([viewType  isEqualToString:@"HF"]){
        NSArray *arrHF = [dicRow objectForKey:@"subProductList"];
        
        NSInteger limit = ([arrHF count]<kMaxCountHF)?[arrHF count]:kMaxCountHF;
        
        CGFloat heightViewDefault = kHEIGHTHF * (limit/kRowPerCountHF + ((limit%kRowPerCountHF>0)?1.0:0.0));
        
        if([dicHFResult count] > 0){
            heightViewDefault = heightViewDefault + 32;
        }
        
        
        return 5+heightViewDefault +kTVCBOTTOMMARGIN;
        
    }else if([viewType  isEqualToString:@"NHP"]){
        return  129 + kTVCBOTTOMMARGIN;

    }else if([viewType  isEqualToString:@"B_ISS"]){
        
        return  40 + kTVCBOTTOMMARGIN;
        
    }else if([viewType  isEqualToString:@"NTC_Broad"]){
        
        if (tvcdic == nil) {
            return 0.0;
        }
        
        CGFloat cellHeight = 0.0;
        
        isOnAir = ([NCS([tvcdic objectForKey:@"onAirYn"]) isEqualToString:@"Y"])?YES:NO;
        
        if(isOnAir){
            
            //생방송일때
            if ([NCS([tvcdic objectForKey:@"promotionName"]) length] > 0) {
                
                cellHeight = 35.0 + (APPFULLWIDTH-20.0)*(169.0/300.0)  + 10.0;
                
            }else{
                //공지 문구 없을경우
                cellHeight = (APPFULLWIDTH-20.0)*(169.0/300.0) + 10.0;
                
            }
            
            
            if (NCO([tvcdic objectForKey:@"nalTalkBanner"]) && NCA([[tvcdic objectForKey:@"nalTalkBanner"] objectForKey:@"talkList"])){
                //날톡 array 가 들어올경우에만 날톡 영역 노출
                cellHeight = cellHeight + 50.0;
            }
            
        }else{
            //vod 일때
            
            cellHeight = (APPFULLWIDTH-20.0)*(169.0/300.0) + 10.0;
            
            if (NCO([tvcdic objectForKey:@"product"])) {
                //상품정보가 있을경우에만 해당 영역 노출
                
                //상품 조건따라 높이 다름
                if ([NCS([[tvcdic objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VP"]) { //상품 있음
                    cellHeight = cellHeight + 50.0;
                }else if ([NCS([[tvcdic objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VNP"]) { //상품없이 제목만
                    cellHeight = cellHeight + 32.0;
                }
                
                
            }
            
            //방송 시작시간
            long long startStamp = [[dateformat dateFromString:NCS([tvcdic objectForKey:@"liveBroadStartTime"])] timeIntervalSince1970];
            long long nowStamp = [[NSDate date] timeIntervalSince1970];
            //다음 방송까지 남은시간
            long long leftTimeSec = startStamp - nowStamp;
            if ((leftTimeSec > 0) && (leftTimeSec - 3600*3 <= 0)) {
                //방송시작 3 시간전 일경우 공시사항 영역에서 남은 시간 카운팅
                cellHeight = 35.0 + cellHeight;
            }
            
        }
        
        return cellHeight + kTVCBOTTOMMARGIN;
    }else if([viewType  isEqualToString:@"B_NIS"]){
        return  [Common_Util DPRateOriginVAL:58.0];

    }else if([viewType  isEqualToString:@"SCF"]){
        NSArray *arrHF = [dicRow objectForKey:@"subProductList"];
        
        NSInteger limit = ([arrHF count]<kMaxCountHF)?[arrHF count]:kMaxCountHF;
        
        CGFloat heightViewDefault = kHEIGHTHF * (limit/kRowPerCountHF + ((limit%kRowPerCountHF>0)?1.0:0.0));

        NSLog(@"heightheightheight = %f ",5+heightViewDefault +kTVCBOTTOMMARGIN);
        
        return 5+heightViewDefault +kTVCBOTTOMMARGIN;
        
    }
    else if([viewType  isEqualToString:@"SBT"]){
        float spaceW = 10;
        float subWidth = (APPFULLWIDTH - (spaceW * 4))/3;
        
        NSString *isfirst = [dicRow objectForKey:@"isFirst"];
        
        return  (subWidth * 1.774) + ([isfirst isEqualToString:@"Y"]?20:10);
    }
    else if([viewType  isEqualToString:@"SSL"]){
        return  [Common_Util DPRateOriginVAL:58] + 355 + 10 + kTVCBOTTOMMARGIN;
    }
    else{
        //섹션디씨타입 SectionDCtypeCell
        return [Common_Util DPRateVAL:246 withPercent:66]+kTVCBOTTOMMARGIN;
        
    }
 
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([arrNSTFC count] == 0 || arrNSTFC == nil) { return; }
    
    if ([[arrNSTFC objectAtIndex:indexPath.section] count] <= indexPath.row) {
        return;
    }
    
    NSDictionary *secdic = [(NSArray*)[arrNSTFC objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (secdic == nil) {
        
        return;
    }
    
    NSString *viewType = NCS([secdic objectForKey:@"viewType"]);
    
    if ([viewType isEqualToString:@"DSL_A"] || [viewType isEqualToString:@"DSL_B"] ||
        [viewType isEqualToString:@"DSL_A2"] || [viewType isEqualToString:@"RPS"] ||
        [viewType isEqualToString:@"FPC"] || [viewType isEqualToString:@"BFP"] ||
        [viewType isEqualToString:@"TCF"] || [viewType isEqualToString:@"B_INS"] ||
        [viewType isEqualToString:@"B_SIC"] || [viewType isEqualToString:@"PDV"] ||
        [viewType isEqualToString:@"B_TSC"] || [viewType isEqualToString:@"B_IT"] ||
        [viewType isEqualToString:@"B_DHS"] || [viewType isEqualToString:@"HF"] ||
        [viewType isEqualToString:@"NHP"] ||  [viewType isEqualToString:@"B_ISS"] ||
        [viewType isEqualToString:@"SBT"] || [viewType isEqualToString:@"SSL"] ||
        [viewType isEqualToString:@"SCF"] || [viewType isEqualToString:@"API_SRL"]
        )
    {
        return;
    }
    
    
    [delegatetarget touchEventTBCell:secdic];
    
    
    @try {
        
        NSString *prdno = nil;
        URLParser *parser = [[URLParser alloc] initWithURLString:NCS([secdic objectForKey:@"linkUrl"])];
        if([parser valueForVariable:@"dealNo"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"dealNo"]];
        }else if([parser valueForVariable:@"prdid"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"prdid"]];
            
        }else {
            prdno = @"";
        }
        
        
        BOOL isforevent  =   ([NCS([secdic objectForKey:@"productName"]) length] > 1);
        
        NSLog(@"event productName nonExist: %i", isforevent);
        
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_%@%@", NCS([self.sectioninfodata objectForKey:@"sectionName"]),prdno]
         
                               withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", (int)indexPath.row ],  (isforevent)?NCS([secdic objectForKey:@"productName"]) : NCS([secdic objectForKey:@"linkUrl"]) ]  ];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
        
    }
    
    
}


-(BOOL)tableViewSectionIsShowMore:(NSInteger)section{
    
    if ([arrNSTFC count] != 0 && [arrNSTFC count] == section + 1) {
        //마지막 줄
        return NO;
    }else{
        
        if (section == indexPathHFCell.section) {
            
            NSArray *arrNalBang = [arrNSTFC objectAtIndex:indexPathHFCell.section];
            NSDictionary *dicRowHF = [arrNalBang objectAtIndex:indexPathHFCell.row];
            
            
            if ([dicHFResult count] > 0) { // 검색결과가 있으면 헤쉬테그 상태 , 없으면 관리자 버튼 상태
                
                NSInteger totCount = 0;
                NSInteger insertedCount = 0;
                
                totCount = [(NSString *)[dicHFResult objectForKey:kHFSEARCHCOUNT] integerValue]; //검색필터 총 카운트
                
                insertedCount = [arrNalBang count] - (indexPathHFCell.row + 1);
                
                //검색필터 총 카운트보다 들어간 배열의 카운트가 작으면 더보기 노출
                
                if (totCount > insertedCount) {
                    return YES;
                }else{
                    return NO;
                }
                
            }else{
                //관리자 테그 상태
                
                NSInteger totCount = 0;
                NSInteger insertedCount = 0;
                
                if (NCA([dicRowHF objectForKey:@"subProductList"])) {
                    
                    NSArray *arrSubPrdList = [dicRowHF objectForKey:@"subProductList"];
                    
                    if ([arrSubPrdList count] > idxHFCate) {
                        NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxHFCate];
                        
                        if (NCA([dicSub objectForKey:@"subProductList"])) {
                            
                            totCount = [[dicSub objectForKey:@"subProductList"] count];
                            
                            insertedCount = [arrNalBang count] - (indexPathHFCell.row + 1);
                            
                            
                        }
                    }
                }
                
                
                NSLog(@"[arrInsertedRow count] = %lu",(long)[arrNalBang count]);
                NSLog(@"totCount = %lu",(long)totCount);
                
                NSLog(@"insertedCount = %lu",(long)insertedCount);
                NSLog(@"totCount = %lu",(long)totCount);
                
                if (totCount > insertedCount) {
                    return YES;
                }else{
                    return NO;
                }
            }
            
            
            
        }else if (section == indexPathSCFCell.section) {
            //숏방 영역
            
            
            NSArray *arrShortBang = [arrNSTFC objectAtIndex:indexPathSCFCell.section];
            NSDictionary *dicRowSCF = [arrShortBang objectAtIndex:indexPathSCFCell.row];
            
            
            //관리자 테그 상태
            
            NSInteger totCount = 0;
            NSInteger insertedCount = 0;
            
            if (NCA([dicRowSCF objectForKey:@"subProductList"])) {
                
                NSArray *arrSubPrdList = [dicRowSCF objectForKey:@"subProductList"];
                
                if ([arrSubPrdList count] > idxSCFCate) {
                    NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxSCFCate];
                    
                    if (NCA([dicSub objectForKey:@"subProductList"])) {
                        
                        //여기 카운트랑 위에랑 다를수 있음
                        NSInteger tailCount = ([[dicSub objectForKey:@"subProductList"] count] % kDefaultShortBangContentsPerRow > 0)?1:0;
                        totCount = [[dicSub objectForKey:@"subProductList"] count] / kDefaultShortBangContentsPerRow + tailCount;
                        
                        insertedCount = [arrShortBang count] - (indexPathSCFCell.row + 1);
                        
                        
                    }
                }
            }
            
            
            NSLog(@"[arrInsertedRow count] = %lu",(long)[arrShortBang count]);
            NSLog(@"insertedCount = %lu",(long)insertedCount);
            NSLog(@"totCount = %lu",(long)totCount);
            
            if (totCount > insertedCount) {
                return YES;
            }else{
                return NO;
            }
            
            
        }else{
            return NO;
        }
        
    }
    
}

-(void)tableViewSectionloadMoreButton:(NSInteger)section{
    
    NSLog(@"sectionsectionsection = %lu",(long)section);
    
    
    if (section == indexPathHFCell.section) {
        
        NSInteger idxContentsStart = indexPathHFCell.row + 1;
        NSArray *arrNalBang = [arrNSTFC objectAtIndex:indexPathHFCell.section];
        NSInteger beforeUpdateCount = [[arrNSTFC objectAtIndex:indexPathHFCell.section] count];
        
        
        
        if ([dicHFResult count] > 0) { // 검색결과가 있으면 헤쉬테그 상태 , 없으면 관리자 버튼 상태
            
            //NSInteger totCount = [(NSString *)[dicHFResult objectForKey:kHFSEARCHCOUNT] integerValue]; //검색필터 총 카운트
            NSInteger insertedCount = 0;
            
            
            insertedCount = 0;
            for (NSInteger i=idxContentsStart; i<[arrNalBang count]; i++) {
                insertedCount++;
            }
            
            //검색필터 총 카운트보다 들어간 배열의 카운트가 작으면 더보기 노출
            
            [self reorderHFArrayFastEnumerationUseSet:[dicHFResult objectForKey:kHFSEARCHTAG] cntIndex:insertedCount endCount:insertedCount+kTableViewMoreCountNalBang];
            
            
            
        }else{
            //관리자 테그 상태
            
            //관리자 테그 카테고리 총 카운트보다 들어간 배열의 카운트가 작으면 더보기 노출
            [self reorderHFArrayAdminButtonAddCount:kTableViewMoreCountNalBang];
        }
        
        NSMutableArray *arrIndexUpdate = [[NSMutableArray alloc] init];
        
        for (NSInteger i=beforeUpdateCount; i<[[arrNSTFC objectAtIndex:indexPathHFCell.section] count]; i++) {
            [arrIndexUpdate addObject:[NSIndexPath indexPathForRow:i inSection:indexPathHFCell.section]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:arrIndexUpdate withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPathHFCell.section] withRowAnimation:UITableViewRowAnimationBottom];
        
        
    }else if (section == indexPathSCFCell.section){
        
        
        NSInteger beforeUpdateCount = [[arrNSTFC objectAtIndex:indexPathSCFCell.section] count];
        
        [self reorderSCFArrayAdminButtonAddCount:kTableViewMoreCountShortBang];
        
        NSMutableArray *arrIndexUpdate = [[NSMutableArray alloc] init];
        
        for (NSInteger i=beforeUpdateCount; i<[[arrNSTFC objectAtIndex:indexPathSCFCell.section] count]; i++) {
            [arrIndexUpdate addObject:[NSIndexPath indexPathForRow:i inSection:indexPathSCFCell.section]];
        }
        
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:arrIndexUpdate withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        
        
        
    }else{
        return;
    }
    
}




-(void) tableFooterDraw {
    
    if(self.tableView.tableFooterView != nil) {
        [self.tableView.tableFooterView removeFromSuperview];
        
        self.tableView.tableFooterView  = nil;
        
    }
    if([arrNSTFC count] < 1){
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return;
    }
    
    tablefooterLoginVheight = 173;
    
    self.tableView.tableFooterView =  [self footerLoginView];
    
}

-(void)touchEventTBCellJustLinkStr:(NSString *)linkstr{
    [delegatetarget touchEventTBCellJustLinkStr:linkstr];
}


-(void)touchEventSBTCell:(NSDictionary*)dic andCnum:(NSNumber *)prdIndex andCImage:(UIImage*)prdImage indexPathCell:(NSIndexPath *)indexPathCell withCallType:(NSString*)cstr{
    
    //[delegatetarget  touchEventTBCell:dic];
    
    if ([cstr isEqualToString:@"SBT"]) {

        
        NSLog(@"indexPath = %@",indexPathCell);
        

        float spaceW = 10;
        float subWidth = (APPFULLWIDTH - (spaceW * 4))/3;

        CGRect convertRect = [self.tableView convertRect:[self.tableView rectForRowAtIndexPath:indexPathCell] toView:ApplicationDelegate.window];
        
        CGFloat yOrigin = convertRect.origin.y;
        if (convertRect.origin.y < 0) {
            yOrigin =  yOrigin + 65.0;
        }
        
        CGRect rectToAni = CGRectMake(convertRect.origin.x+(spaceW +(subWidth+spaceW)*[prdIndex integerValue]), yOrigin + ((indexPathCell.row==0)?10:0), subWidth, (subWidth * 1.774));
        
        NSLog(@"convertRect = %@",NSStringFromCGRect(convertRect));
        
        NSLog(@"rectToAni = %@",NSStringFromCGRect(rectToAni));

        [delegatetarget touchEventShortBang:dic index:((indexPathCell.row - (indexPathSCFCell.row+1 ))*kDefaultShortBangContentsPerRow)+[prdIndex integerValue]  indexCate:idxSCFCate arrShortBangAll:arrAllShortBang imageRect:rectToAni backGroundImage:prdImage apiString:nil];

    }else if([cstr isEqualToString:@"SSL"]){
    
//        - 비디오 매장 -> 상세 : 선택하신 숏방이
//        유효하지 않습니다.
        
        NSLog(@"indexPath = %@",indexPathCell);
        
        CGRect convertRect = [self.tableView convertRect:[self.tableView rectForRowAtIndexPath:indexPathCell] toView:ApplicationDelegate.window];
        
        CGFloat yOrigin = convertRect.origin.y;
//        if (convertRect.origin.y < 0) {
//            yOrigin =  yOrigin + 65.0;
//        }
        
        CGRect rectToAni = CGRectMake((APPFULLWIDTH/2.0)-105.0, yOrigin + [Common_Util DPRateOriginVAL:58], 210.0, 355.0);
        
        
        NSLog(@"convertRect = %@",NSStringFromCGRect(convertRect));
        
        NSLog(@"rectToAni = %@",NSStringFromCGRect(rectToAni));
        
        //UIImage *imgSeleted = seletedCell.productImage.image;
        
        //NSLog(@"imgSeleted = %@",imgSeleted);
        
        
        [delegatetarget touchEventShortBang:dic index:-1  indexCate:-1 arrShortBangAll:arrAllShortBang imageRect:rectToAni backGroundImage:prdImage apiString:nil];
        
        //[delegatetarget touchEventShortBang:dic sbVideoNum:NCS([dic objectForKey:@"sbVideoNum"]) cateGb:NCS([dic objectForKey:@"sbCateGb"]) arrShortBangAll:arrAllShortBang imageRect:rectToAni backGroundImage:prdImage apiString:nil];
        
    }else{
        [delegatetarget touchEventTBCell:dic];
    }
    
    
    if ([NCS([dic objectForKey:@"wiseLog"]) length] > 0 ) {
        
        NSString *wiselog = [dic objectForKey:@"wiseLog"];
        
        if([wiselog hasPrefix:@"http://"]) {
            NSLog(@"hashtag: %@",wiselog);
            ////탭바제거
            [ApplicationDelegate wiseAPPLogRequest:wiselog];
        }
        
    }
}

- (void)onBtnSCFTag:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr{
    //숏방 카테고리 선택 처리
 
    NSInteger beforeCount = 0;
    
    
    if ([[arrNSTFC objectAtIndex:indexPathSCFCell.section] count] > indexPathSCFCell.row + 1) {
        
        beforeCount = [[arrNSTFC objectAtIndex:indexPathSCFCell.section] count] - indexPathSCFCell.row -1 ;
        
        [[arrNSTFC objectAtIndex:indexPathSCFCell.section] removeObjectsInRange:NSMakeRange(indexPathSCFCell.row+1, [[arrNSTFC objectAtIndex:indexPathSCFCell.section] count] - indexPathSCFCell.row -1 )];
    }

    idxSCFCate = [cnum integerValue];
    
    
    
    //날방 영역이 마지막 배치가 아닐경우 kDefaultNalBangContentsCount, 마지막일경우 모두 뿌리기
    NSUInteger limitShortBang = 0;
    
    if ([arrNSTFC count] == indexPathSCFCell.section+1) {
        limitShortBang = -1;
    }else{
        limitShortBang = kDefaultShortBangContentsCount;
    }
    
    NSLog(@"limitShortBang = %ld",(unsigned long)limitShortBang);

    
    //[self.tableView reloadData];
    
    
    
    [self reorderSCFArrayAdminButtonAddCount:limitShortBang];
    
    NSInteger afterCount = [[arrNSTFC objectAtIndex:indexPathSCFCell.section] count] - indexPathSCFCell.row -1 ;
    
    NSMutableArray *arrIndexUpdate = [[NSMutableArray alloc] init];
    NSMutableArray *arrIndexModify = [[NSMutableArray alloc] init];
    
    
    [arrIndexUpdate addObject:[NSIndexPath indexPathForRow:indexPathSCFCell.row inSection:indexPathSCFCell.section]];
    
    
    //[UIView setAnimationsEnabled:NO];
    
    if (beforeCount == afterCount) {
        
        if (beforeCount == 0) {
            
            [UIView setAnimationsEnabled:NO];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:arrIndexUpdate withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            [UIView setAnimationsEnabled:YES];
            
            return;
        }
        
        
        for (NSInteger i=0; i<beforeCount; i++) {
            [arrIndexUpdate addObject:[NSIndexPath indexPathForRow:(indexPathSCFCell.row+1+i) inSection:indexPathSCFCell.section]];
        }
        
        
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:arrIndexUpdate withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        
    }else if (beforeCount > afterCount){
        
        NSInteger cntChange = 0;
        for (NSInteger i=0; i<beforeCount; i++) {
            
            
            
            NSLog(@"beforeCount = %ld",(long)beforeCount);
            NSLog(@"afterCount = %ld",(long)afterCount);
            NSLog(@"cntChange = %ld",(long)cntChange);
            
            if (cntChange < afterCount ) {
                [arrIndexUpdate addObject:[NSIndexPath indexPathForRow:(indexPathSCFCell.row+1+i) inSection:indexPathSCFCell.section]];
            }else{
                [arrIndexModify addObject:[NSIndexPath indexPathForRow:(indexPathSCFCell.row+1+i) inSection:indexPathSCFCell.section]];
            }
            
            cntChange++;
        }
        
        NSLog(@"arrIndexUpdate = %@",arrIndexUpdate);
        NSLog(@"arrIndexModify = %@",arrIndexModify);
        
        
        [self.tableView beginUpdates];
        
        if ([arrIndexModify count] > 0) {
            [self.tableView deleteRowsAtIndexPaths:arrIndexModify withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if ([arrIndexUpdate count] > 0) {
            [self.tableView reloadRowsAtIndexPaths:arrIndexUpdate withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [self.tableView endUpdates];
        
        
        
    }else if (beforeCount < afterCount){
        
        NSInteger cntChange = 0;
        for (NSInteger i=0; i<afterCount; i++) {
            
            
            
            NSLog(@"beforeCount = %ld",(long)beforeCount);
            NSLog(@"afterCount = %ld",(long)afterCount);
            NSLog(@"cntChange = %ld",(long)cntChange);
            
            if (beforeCount == 0) {
                
                [arrIndexModify addObject:[NSIndexPath indexPathForRow:(indexPathSCFCell.row+1+i) inSection:indexPathSCFCell.section]];
                
            }else{
            
                if (cntChange < ( afterCount - beforeCount) ) {
                    [arrIndexUpdate addObject:[NSIndexPath indexPathForRow:(indexPathSCFCell.row+1+i) inSection:indexPathSCFCell.section]];
                }else{
                    [arrIndexModify addObject:[NSIndexPath indexPathForRow:(indexPathSCFCell.row+1+i) inSection:indexPathSCFCell.section]];
                }
            }
            
            
            
            cntChange++;
        }
        
        NSLog(@"arrIndexUpdate = %@",arrIndexUpdate);
        NSLog(@"arrIndexModify = %@",arrIndexModify);
        
        
        [self.tableView beginUpdates];
        
        if ([arrIndexModify count] > 0) {
            [self.tableView insertRowsAtIndexPaths:arrIndexModify withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if ([arrIndexUpdate count] > 0) {
            [self.tableView reloadRowsAtIndexPaths:arrIndexUpdate withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView endUpdates];
        
    }else{
        
        [self.tableView reloadData];
    }
    
    
    if ([[self.tableView footerViewForSection:indexPathSCFCell.section] isKindOfClass:[SectionNSTFCMoreView class]]) {
    
        SectionNSTFCMoreView *moreView =  (SectionNSTFCMoreView*)[self.tableView footerViewForSection:indexPathSCFCell.section];
        
        if (!NCA([[arrAllShortBang objectAtIndex:idxSCFCate] objectForKey:@"subProductList"])) {
            moreView.viewNoData.hidden = NO;
        }else{
            moreView.viewNoData.hidden = YES;
        }
        
        
        if([self tableViewSectionIsShowMore:indexPathSCFCell.section]){
            moreView.viewDefault.hidden = NO;
            [moreView setMoreModeNalbang:NO];
        }else{
            moreView.viewDefault.hidden = YES;
        }

    }else{
        
        NSLog(@"[self.tableView footerViewForSection:indexPathSCFCell.section] = %@",[self.tableView footerViewForSection:indexPathSCFCell.section]);
    }
    
    
    

    //[UIView setAnimationsEnabled:YES];
    
    if ([self.tableView rectForRowAtIndexPath:indexPathSCFCell].origin.y < self.tableView.contentOffset.y) {
        [self.tableView scrollToRowAtIndexPath:indexPathSCFCell atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    
    
}



-(void)reorderSCFArrayAdminButtonAddCount:(NSUInteger)cntAdd{
    
    if ([arrNSTFC count] > indexPathSCFCell.section && [[arrNSTFC objectAtIndex:indexPathSCFCell.section] count] > indexPathSCFCell.row) {
        //배열 유효 체크
    }else{
        return;
    }
    
    
    NSMutableArray *arrInsertedRow = [arrNSTFC objectAtIndex:indexPathSCFCell.section];
    
    NSLog(@"");
    
    NSDictionary *dicRowSCF = [arrInsertedRow objectAtIndex:indexPathSCFCell.row];
    
    
    if (NCA([dicRowSCF objectForKey:@"subProductList"])) {
        
        NSArray *arrSubPrdList = [dicRowSCF objectForKey:@"subProductList"];
        
        if ([arrSubPrdList count] > idxSCFCate) {
            NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxSCFCate];
            
            if (NCA([dicSub objectForKey:@"subProductList"])) {
                
                NSArray *arrSeletedCate = [dicSub objectForKey:@"subProductList"];
                
                NSUInteger intStart = ([arrInsertedRow count] - (indexPathSCFCell.row + 1) ) * kDefaultShortBangContentsPerRow;
                
                NSUInteger insertCount = 0;
                NSLog(@"intStart = %lu",(long)intStart);
                NSLog(@"cntAdd = %ld",(unsigned long)cntAdd);
                
                for (NSUInteger inc=intStart; inc<[arrSeletedCate count]; inc++) {
                    BOOL SBT_first = (inc==0)?YES:NO;
                    
                    NSMutableArray *temp = [NSMutableArray array];
                    
                    
                    [temp addObject:[arrSeletedCate objectAtIndex:inc]];
                    
                    if([arrSeletedCate count] > inc+1 && [NCS([[arrSeletedCate objectAtIndex:inc+1] objectForKey:@"viewType"]) isEqualToString:@"SBT"])
                    {
                        [temp addObject:[arrSeletedCate objectAtIndex:inc+1]];
                        inc+=1;
                        if([arrSeletedCate count] > inc+1 && [NCS([[arrSeletedCate objectAtIndex:inc+1] objectForKey:@"viewType"]) isEqualToString:@"SBT"])
                        {
                            [temp addObject:[arrSeletedCate objectAtIndex:inc+1]];
                            inc+=1;
                        }
                        
                    }
                    
                    NSMutableDictionary *set = [NSMutableDictionary dictionary];
                    
                    [set setObject:@"SBT" forKey:@"viewType"];
                    [set setObject:temp forKey:@"subProductList"];
                    [set setObject:SBT_first?@"Y":@"N" forKey:@"isFirst"];
                    
                    
                    [arrInsertedRow addObject:set];
                    
                    insertCount ++;
                    
                    if (insertCount == cntAdd) {
                        NSLog(@"insertCount = %lu",(long)insertCount);
                        break;
                    }

                    
                }
                
                
            }
        }
    }
    
    
    if ([NCS([dicRowSCF objectForKey:@"wiseLog"]) length] > 0 ) {
        
        NSString *wiselog = [dicRowSCF objectForKey:@"wiseLog"];
        
        if([wiselog hasPrefix:@"http://"]) {
            NSLog(@"hashtag: %@",wiselog);
            ////탭바제거
            [ApplicationDelegate wiseAPPLogRequest:wiselog];
        }
        
    }
    
}

- (void)onBtnHFTag:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr{
    //해시테그 선택처리
    
    NSLog(@"arrHashFilter count = %lu",(long)[arrHashFilter count]);
    
    
    if ([[arrNSTFC objectAtIndex:indexPathHFCell.section] count] > indexPathHFCell.row + 1) {
        [[arrNSTFC objectAtIndex:indexPathHFCell.section] removeObjectsInRange:NSMakeRange(indexPathHFCell.row+1, [[arrNSTFC objectAtIndex:indexPathHFCell.section] count] - indexPathHFCell.row -1 )];
    }
    
    [dicHFResult removeAllObjects];
    
    idxHFCate = [cnum integerValue];
    
    //날방 영역이 마지막 배치가 아닐경우 kDefaultNalBangContentsCount, 마지막일경우 모두 뿌리기
    NSUInteger limitNalBang = 0;
    
    if ([arrNSTFC count] == indexPathHFCell.section+1) {
        limitNalBang = -1;
    }else{
        limitNalBang = kDefaultNalBangContentsCount;
    }
    
    NSLog(@"limitNalBang = %ld",(unsigned long)limitNalBang);
    
    if ([cstr isEqualToString:kNHPCALLTYPE]) {
        [self reorderHFArrayFastEnumerationUseSet:[dic objectForKey:@"productName"] cntIndex:0 endCount:limitNalBang];
    }else{
        
        [self reorderHFArrayAdminButtonAddCount:limitNalBang];
        
    }
    
    
    
    
    [self.tableView reloadData];

    if ([self.tableView rectForRowAtIndexPath:indexPathHFCell].origin.y < self.tableView.contentOffset.y) {
        [self.tableView scrollToRowAtIndexPath:indexPathHFCell atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }   
    
}


-(void)reorderHFArrayFastEnumerationUseSet:(NSString *)strTag cntIndex:(NSUInteger)cntStart endCount:(NSUInteger)cntEnd{
    NSLog(@"arrHashFilter count = %lu",(long)[arrHashFilter count]);
    NSSet *setTag = [NSSet setWithArray:[NSArray arrayWithObject:strTag]];
    NSUInteger hashTagCount = 0;
    
    for (NSInteger i=0; i<[arrHashFilter count]; i++) {
        
        NSDictionary *object = [arrHashFilter objectAtIndex:i];
        
        if (NCA([object objectForKey:@"productHashTags"])) {
            
            NSArray *arrProductHashTag = (NSArray *)[object objectForKey:@"productHashTags"];
            NSSet *setSubArray = [NSSet setWithArray:arrProductHashTag];
            
            if ([setTag isSubsetOfSet:setSubArray]) {
                
                hashTagCount = hashTagCount+1;
                
                NSLog(@"hashTagCount = %lu",(long)hashTagCount);
                
                if (hashTagCount > cntEnd) {
                    //범위 밖임으로 패스
                    
                    NSLog(@"hashTagCount = %lu",(long)hashTagCount);
                    NSLog(@"cntEnd = %lu",(long)cntEnd);
                    
                }else{
                    if (hashTagCount > cntStart) {
                        [[arrNSTFC objectAtIndex:indexPathHFCell.section] addObject:object];
                        
                        NSLog(@"");
                    }else{
                        //이미 들어가 있는 녀석들임으로 패스
                        NSLog(@"");
                    }
                    
                }
            }
            
            
        }
        
        
    }
    
    
    [dicHFResult setObject:[NSString stringWithFormat:@"%lu",(long)hashTagCount] forKey:kHFSEARCHCOUNT];
    [dicHFResult setObject:strTag forKey:kHFSEARCHTAG];
    
}


-(void)reorderHFArrayAdminButtonAddCount:(NSUInteger)cntAdd{
    
    if ([arrNSTFC count] > indexPathHFCell.section && [[arrNSTFC objectAtIndex:indexPathHFCell.section] count] > indexPathHFCell.row) {
        //배열 유효 체크
    }else{
        return;
    }
    
    
    NSMutableArray *arrInsertedRow = [arrNSTFC objectAtIndex:indexPathHFCell.section];
    
    NSLog(@"");
    
    NSDictionary *dicRowHF = [arrInsertedRow objectAtIndex:indexPathHFCell.row];

    
    if (NCA([dicRowHF objectForKey:@"subProductList"])) {
        
        NSArray *arrSubPrdList = [dicRowHF objectForKey:@"subProductList"];
        
        if ([arrSubPrdList count] > idxHFCate) {
            NSDictionary *dicSub  = [arrSubPrdList objectAtIndex:idxHFCate];
            
            if (NCA([dicSub objectForKey:@"subProductList"])) {
                
                NSArray *arrSeletedCate = [dicSub objectForKey:@"subProductList"];
                
                NSUInteger intStart = [arrInsertedRow count] - (indexPathHFCell.row + 1);
                
                NSUInteger insertCount = 0;
                NSLog(@"intStart = %lu",(long)intStart);
                NSLog(@"cntAdd = %ld",(unsigned long)cntAdd);
                
                for (NSUInteger i=intStart; i<[arrSeletedCate count]; i++) {
                    [arrInsertedRow addObject:[arrSeletedCate objectAtIndex:i]];
                    insertCount++;
                    
                    if (insertCount == cntAdd) {
                        NSLog(@"insertCount = %lu",(long)insertCount);
                        break;
                    }
                }
                
                NSLog(@"[arrInsertedRow count] = %lu",(long)[arrInsertedRow count]);
                NSLog(@"[arrSeletedCate count] = %lu",(long)[arrSeletedCate count]);
                
            }
        }
    }
    
    
    if ([NCS([dicRowHF objectForKey:@"wiseLog"]) length] > 0 ) {
        
        NSString *wiselog = [dicRowHF objectForKey:@"wiseLog"];
        
        if([wiselog hasPrefix:@"http://"]) {
            NSLog(@"hashtag: %@",wiselog);
            ////탭바제거
            [ApplicationDelegate wiseAPPLogRequest:wiselog];
        }
        
    }
    
}



-(void)scrollToShortBangSectionTop{
    
    if (indexPathShortbangTop != nil) {
        
        if ([[arrNSTFC objectAtIndex:indexPathShortbangTop.section] count] > 0) {
            
            [self.tableView scrollToRowAtIndexPath:indexPathShortbangTop atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    
}

@end
