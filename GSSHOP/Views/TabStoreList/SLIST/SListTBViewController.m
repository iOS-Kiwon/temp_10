//
//  SListTBViewController.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 3. 28..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SListTBViewController.h"
#import "AppDelegate.h"

@interface SListTBViewController ()

@end

@implementation SListTBViewController

#define widthTopNavi 58.0f
#define heightRightTimeLine 83.0f


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arrLeftProduct = [[NSMutableArray alloc] init];
        //self.arrRightTimeLine = [[NSMutableArray alloc] init];
        self.arrDayNavi = [[NSMutableArray alloc] init];
        self.dicLeftAnchor = [[NSMutableDictionary alloc] init];
        //self.dicRightAnchor = [[NSMutableDictionary alloc] init];
        self.dicNaviAnchor = [[NSMutableDictionary alloc] init];
        self.arrLastMoreUrl = [[NSMutableArray alloc] init];
        is_NODATA = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableNavi = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, 60.0)];
    self.tableNavi.showsVerticalScrollIndicator = NO;
    self.tableNavi.showsHorizontalScrollIndicator = NO;
    self.tableNavi.delegate = self;
    self.tableNavi.dataSource = self;
    self.tableNavi.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [self.tableNavi setFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, 60.0)];
    self.tableNavi.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableNavi.decelerationRate = 0.8;
    self.tableNavi.scrollsToTop = NO;
    self.tableNavi.backgroundColor = [UIColor clearColor];
    [self.viewDayNavi insertSubview:self.tableNavi atIndex:0];    
    [self tableViewRegisterNib];
    [self.view layoutIfNeeded];

    self.viewToggleBG.layer.cornerRadius = 4.0;
    self.viewToggleBG.layer.shouldRasterize = YES;
    self.viewToggleBG.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    self.viewToggleLive.layer.masksToBounds = NO;
    
    self.viewToggleLive.layer.cornerRadius = 4.0;
    self.viewToggleLive.layer.shouldRasterize = YES;
    self.viewToggleLive.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewToggleLive.layer.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.16].CGColor;
    self.viewToggleLive.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.viewToggleLive.layer.shadowRadius = 4.0/2.0; //=blur/2 = radius
    //self.layer.shadowPath = UIBezierPath(rect: rect).cgPath; //=-spread

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//스테이터스 바 클릭시 탑 컨트롤 여부 적용할때 사용
- (void)setScrollToTopLeftTableView{
    self.tableLeftProduct.scrollsToTop = YES;
}

- (void) dealloc {
    self.dicOnAir = nil;
    self.dicResult = nil;
    self.arrLeftProduct = nil;
    //self.arrRightTimeLine = nil;
    self.arrDayNavi = nil;
    self.dicLeftAnchor = nil;
    //self.dicRightAnchor = nil;
    self.dicHeader = nil;
    self.dicFooter = nil;
    self.sectioninfodata = nil;
    
    NSLog(@"!!deallocdealloc!!!")
}

- (void)checkDeallocSList{
    if (self.tableNavi != nil) {
        [self.tableNavi removeFromSuperview];
        self.tableNavi = nil;
    }
    
    if (self.tableLeftProduct != nil) {
        [self.tableLeftProduct removeFromSuperview];
        self.tableLeftProduct = nil;
    }
    
    
}

#pragma mark - UserMethods
- (void)setResultDic:(NSDictionary *)resultDic withAddType:(ProcessType)requestType {
    if (requestType == ProcessTypeNetError || NCO(resultDic) == NO) {
        self.dicResult = nil;
        self.tableLeftProduct.hidden = YES;
        //self.tableRightTimeLine.hidden = YES;
        [self.arrDayNavi removeAllObjects];
        [self.arrLeftProduct removeAllObjects];
        //[self.arrRightTimeLine removeAllObjects];
        [self.tableNavi reloadData];
        [self.tableLeftProduct reloadData];
        //[self.tableRightTimeLine reloadData];
        self.viewDayNavi.hidden = YES;
        self.viewLeftBGLine.hidden = YES;
        self.viewOnAir.hidden = YES;
        self.imgBgShadow.hidden = YES;
        self.viewToggleSwitch.hidden = YES;
        return;
    }
    else {
        self.dicResult = resultDic;
        self.tableLeftProduct.hidden = NO;
        //self.tableRightTimeLine.hidden = NO;
        self.viewDayNavi.hidden = NO;
        self.viewLeftBGLine.hidden = NO;
        self.viewOnAir.hidden = YES; // 사용안함. - 20180619
        self.imgBgShadow.hidden = NO;
        self.viewToggleSwitch.hidden = NO;
    }
    
    ProcessType type = requestType;
    
    isFinishLoad = NO;
    
    //방송타입 설정
    self.strBrdType = NCS([self.dicResult objectForKey:@"broadType"]);
    
    if (requestType == ProcessTypeReload) {
        //Live,Data Setting
        self.dicLiveUrl = [self.dicResult objectForKey:@"liveBroadInfo"];
        self.dicDataUrl = [self.dicResult objectForKey:@"dataBroadInfo"];
    }
    
    
    //[self.switchButton setAccessibilityHint:@"편성표를 선택합니다."];
    
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         if([self isLiveBrd]) {
                             self.lconstToggleLive.constant = 2.0;
                         }
                         else {
                             self.lconstToggleLive.constant = 117.0;
                         }
                         
                         [self.viewToggleBG layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
    
    
    
    

    if ([NCS([self.dicResult objectForKey:@"refreshYn"]) length] > 0 && [NCS([self.dicResult objectForKey:@"refreshYn"]) isEqualToString:@"Y"]) {
        NSLog(@"NCS([self.dicResult objectForKey:@refreshYn]) = %@",NCS([self.dicResult objectForKey:@"refreshYn"]));
        type = ProcessTypeReload;
    }
    
    if (type == ProcessTypeReload) {
        idxLeftOnAir = 0;
        //idxSelectedRight = 1;
        is_NODATA = NO;
        [self.arrLastMoreUrl removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEDULELIVEVIDEOALLKILL object:nil userInfo:nil];
    }
    
    //NSInteger idxLeftFirstTimeCell = -1;
    NSMutableArray *arrProcessLeft = [[NSMutableArray alloc] init];
    //NSMutableArray *arrProcessRight = [[NSMutableArray alloc] init];
    if (NCA([self.dicResult objectForKey:@"broadPrdList"])) {
        NSArray *arrLeft = [self.dicResult objectForKey:@"broadPrdList"];
        for (NSInteger i=0; i<[arrLeft count]; i++) {
            NSDictionary *dicRow = [arrLeft objectAtIndex:i];
            NSMutableDictionary *dicRowMod = [[NSMutableDictionary alloc] init];
            [dicRowMod addEntriesFromDictionary:dicRow];
            BOOL isExistSubPrd = NO;
            NSMutableArray *arrSubAndMore = [[NSMutableArray alloc] init];
//            if (idxLeftFirstTimeCell == -1 && [NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_BAN_MUT_TIME"]) {
//                idxLeftFirstTimeCell = i;
//            }else
            
            if ([[dicRow objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_MAIN"]) {
                if (NCO([dicRowMod objectForKey:@"product"]) == YES &&  [NCS([[dicRowMod objectForKey:@"product"] objectForKey:@"pgmLiveYn"]) isEqualToString:@"Y"]) {
                    [dicRowMod setObject:@"SCH_MAP_MUT_LIVE" forKey:@"viewType"];
                }
                else if ([NCS([dicRowMod objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"]) {
                    [dicRowMod setObject:@"SCH_MAP_ONLY_TITLE" forKey:@"viewType"];
                }
                

                if (NCA([[dicRowMod objectForKey:@"product"] objectForKey:@"subProductList"])) {
                    isExistSubPrd = YES;
                    NSArray *arrSub = [[dicRowMod objectForKey:@"product"] objectForKey:@"subProductList"];
                    for (NSInteger j=0; j<[arrSub count]; j++) {
                        NSMutableDictionary *dicSub = [[NSMutableDictionary alloc] init];
                        [dicSub addEntriesFromDictionary:dicRowMod];
                        [dicSub removeObjectForKey:@"subProductList"];
                        [dicSub setObject:@"N" forKey:@"isVisible"];
                        [dicSub setObject:@"SCH_MAP_MUT_SUB" forKey:@"viewType"];
                        [dicSub setObject:[arrSub objectAtIndex:j] forKey:@"product"];
                        if ([[arrSub objectAtIndex:j] isEqual:[arrSub lastObject]]) {
                            [dicSub setObject:@"Y" forKey:@"isLastSubs"];
                            [arrSubAndMore addObject:dicSub];
                            NSMutableDictionary *dicMore = [[NSMutableDictionary alloc] init];
                            [dicMore setObject:@"SCH_BAN_MORE" forKey:@"viewType"];
                            [dicMore setObject:@"Y" forKey:@"isMore"];
                            [dicMore setObject:[NSString stringWithFormat:@"%ld",(long)[arrSub count]] forKey:@"subPrdCount"];
                            [arrSubAndMore addObject:dicMore];
                        }
                        else {
                            [arrSubAndMore addObject:dicSub];
                        }
                    }
                }
            }
            else if ([[dicRow objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_SUB"]) {
                NSString *strIsLastSub = @"Y";
                if ([arrLeft count] > i+1 &&
                    NCO([arrLeft objectAtIndex:i+1]) &&
                    [[arrLeft objectAtIndex:i+1] isKindOfClass:[NSDictionary class]] &&
                    [[[arrLeft objectAtIndex:i+1] objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_SUB"]
                    ) {
                    strIsLastSub = @"N";
                }
                [dicRowMod setObject:strIsLastSub forKey:@"isLastSubs"];
                [dicRowMod setObject:@"N" forKey:@"isVisible"];
            }
            [arrProcessLeft addObject:dicRowMod];
            if (isExistSubPrd == YES) {
                [arrProcessLeft addObjectsFromArray:arrSubAndMore];
            }
        }
    }
    
    /*
    if (NCA([self.dicResult objectForKey:@"timeLineList"])) {
        NSArray *arrRight = [self.dicResult objectForKey:@"timeLineList"];
        for (NSInteger i=0; i<[arrRight count]; i++) {
            NSDictionary *dicRow = [arrRight objectAtIndex:i];
            if ([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_PRO_BAN_THM"] && type == ProcessTypeReload) {
                //생방송 찾기
                idxSelectedRight = i;
            }
            if ([[arrRight objectAtIndex:i] isEqual:[arrRight lastObject]] && ( [NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_PRO_BAN_THM"] || [NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_PRO_BAN_XXX"] )) {
                NSMutableDictionary *dicRowMod = [[NSMutableDictionary alloc] init];
                [dicRowMod addEntriesFromDictionary:dicRow];
                [dicRowMod setObject:@"Y" forKey:@"isLastRight"];
                [arrProcessRight addObject:dicRowMod];
            }
            else {
                [arrProcessRight addObject:dicRow];
            }
        }
    }
     */
    
    if (NCA([self.dicResult objectForKey:@"dateList"])) {
        [self.arrDayNavi removeAllObjects];
        [self.arrDayNavi addObjectsFromArray:[self.dicResult objectForKey:@"dateList"]];
        for (NSInteger i=0; i<[[self.dicResult objectForKey:@"dateList"] count]; i++) {
            NSDictionary *dicLeftIndexCheck = [[self.dicResult objectForKey:@"dateList"] objectAtIndex:i];
            if (type == ProcessTypeReload && [NCS([dicLeftIndexCheck objectForKey:@"selectedYn"]) isEqualToString:@"Y"]) {
                idxSelectedNavi = i;
            }
        }
    }
    
    if (type == ProcessTypeReload) {
        
        for (NSDictionary *dic in [self.dicResult objectForKey:@"broadPrdList"]) {
            if([[dic objectForKey:@"viewType"] isEqualToString:@"SCH_BAN_NO_DATA"]) {
                is_NODATA = YES;
            }
        }
        
        isLiveDataChanged = YES;
        [self.arrLeftProduct removeAllObjects];
        //[self.arrRightTimeLine removeAllObjects];
        self.dicHeader = nil;
        self.dicFooter = nil;
        self.dicHeader = [self.dicResult objectForKey:@"preBroadInfo"];
        self.dicFooter = [self.dicResult objectForKey:@"nextBroadInfo"];
        [self.arrLeftProduct addObjectsFromArray:arrProcessLeft];
        //[self.arrRightTimeLine addObjectsFromArray:arrProcessRight];
        [self.tableNavi reloadData];
        [self.tableLeftProduct reloadData];
        //[self.tableRightTimeLine reloadData];
        [self setTableViewAnchor];
        if ([self.arrDayNavi count] > idxSelectedNavi) {
            if (idxSelectedNavi-1 > 0) {
                [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            else {
                [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
        
        //isMoveFromRightTimeLine = YES;
        if ([self.arrLeftProduct count] > idxLeftOnAir) {
            if (idxLeftOnAir == 0) { // 0 이면 현제 테이블뷰 리스트에 생방송이 없는것으로 판단
//                if (idxLeftFirstTimeCell > 0) {
                
                for (NSInteger i=0 ;i<[self.arrLeftProduct count];i++) {
                    
                    NSDictionary *dicCheck = [self.arrLeftProduct objectAtIndex:i];
                    
                    if ([@"SCH_MAP_MUT_MAIN" isEqualToString:NCS([dicCheck objectForKey:@"viewType"])] ||
                        [@"SCH_MAP_MUT_LIVE" isEqualToString:NCS([dicCheck objectForKey:@"viewType"])] ||
                        [@"SCH_MAP_ONLY_TITLE" isEqualToString:NCS([dicCheck objectForKey:@"viewType"])]
                        ) {
                        idxLeftOnAir = i;
                        break;
                    }
                }
                
                CGRect rectToScroll = [self.tableLeftProduct rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxLeftOnAir inSection:0]];
                [self.tableLeftProduct setContentOffset:CGPointMake(0.0, rectToScroll.origin.y + 8.0) animated:NO];
            
                if (self.dicHeader != nil && [NCS([self.dicHeader objectForKey:@"apiUrl"]) length] > 0 && [NCS([self.dicHeader objectForKey:@"apiParam"]) length] > 0) {
                    [self onHeaderFooterAction:0 data:self.dicHeader];
                }
                
                
//                }
                /*
                if ([self.arrRightTimeLine count] > 1) {
                    [self.tableRightTimeLine selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    CGRect rectToScroll = [self.tableRightTimeLine rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    [self.tableRightTimeLine setContentOffset:CGPointMake(0.0, rectToScroll.origin.y) animated:NO];
                }
                 */
            }
            else {
               /*
                //오른쪽 타임라인먼저 스크롤
                NSDictionary *dicRow = [self.arrLeftProduct objectAtIndex:idxLeftOnAir];
                NSString *strKey = [NSString stringWithFormat:@"%@_%@",NCS([dicRow objectForKey:@"broadStartDate"]),NCS([[dicRow objectForKey:@"product"] objectForKey:@"prdId"])];
                if ([strKey length] > 0 && [NCS([self.dicRightAnchor objectForKey:strKey]) length] > 0) {
                    NSInteger idxRight = [NCS([self.dicRightAnchor objectForKey:strKey]) integerValue];
                    if ([self.arrRightTimeLine count] > idxRight) {
                        idxSelectedRight = idxRight;
                        [self.tableRightTimeLine selectRowAtIndexPath:[NSIndexPath indexPathForRow:idxRight inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                    }
                }
                else {
                    if ([self.arrRightTimeLine count] > 1) {
                        [self.tableRightTimeLine selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        CGRect rectToScroll = [self.tableRightTimeLine rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        [self.tableRightTimeLine setContentOffset:CGPointMake(0.0, rectToScroll.origin.y ) animated:NO];
                    }
                }
                */
                //왼쪽 상품정보리스트 스크롤
                CGRect rectToScroll = [self.tableLeftProduct rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxLeftOnAir inSection:0]];
                [self.tableLeftProduct setContentOffset:CGPointMake(0.0, rectToScroll.origin.y + 8.0) animated:NO];
            }
        }
        //isMoveFromRightTimeLine = NO;
        isFinishLoad = YES;
    }
    else if (type == ProcessTypeInsertAtZero) {
        //idxSelectedRight = idxSelectedRight+[arrProcessRight count];
        CGFloat offSetLeftTableToScroll = [self.tableLeftProduct rectForSection:0].size.height - self.tableLeftProduct.contentOffset.y;
        //CGFloat offSetRightTableToScroll = [self.tableRightTimeLine rectForSection:0].size.height - self.tableRightTimeLine.contentOffset.y;
        self.dicHeader = [self.dicResult objectForKey:@"preBroadInfo"];
        NSMutableIndexSet *idxSetLeft = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [arrProcessLeft count])];
        [self.arrLeftProduct insertObjects:arrProcessLeft atIndexes:idxSetLeft];
        [self.tableLeftProduct reloadData];
        /*
        NSMutableIndexSet *idxSetRight = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [arrProcessRight count])];
        [self.arrRightTimeLine insertObjects:arrProcessRight atIndexes:idxSetRight];
        [self.tableRightTimeLine reloadData];
         */
        [self setTableViewAnchor];
        //isMoveFromRightTimeLine = YES;
        CGFloat leftY = [self.tableLeftProduct rectForSection:0].size.height - offSetLeftTableToScroll;
        //CGFloat rightY = [self.tableRightTimeLine rectForSection:0].size.height - offSetRightTableToScroll;
        [self.tableLeftProduct setContentOffset:CGPointMake(0.0, leftY) animated:NO];
        //[self.tableRightTimeLine setContentOffset:CGPointMake(0.0, rightY) animated:NO];
        //isMoveFromRightTimeLine = NO;
        [self.tableNavi reloadData];
        isFinishLoad = YES;
    }
    else if (type == ProcessTypeLastAdd) {        
        self.dicFooter = [self.dicResult objectForKey:@"nextBroadInfo"];
        NSMutableArray *arrIndexPathLeft = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[arrProcessLeft count]; i++) {
            //NSLog(@"i+[self.arrLeftProduct count] = %ld",(long)(i+[self.arrLeftProduct count]));
            [arrIndexPathLeft addObject:[NSIndexPath indexPathForRow:i+[self.arrLeftProduct count] inSection:0]];
        }
        [self.tableLeftProduct beginUpdates];
        [self.arrLeftProduct addObjectsFromArray:arrProcessLeft];
        [self.tableLeftProduct insertRowsAtIndexPaths:arrIndexPathLeft withRowAnimation:UITableViewRowAnimationNone];
        [self.tableLeftProduct endUpdates];
        /*
        NSMutableArray *arrIndexPathRight = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[arrProcessRight count]; i++) {
            [arrIndexPathRight addObject:[NSIndexPath indexPathForRow:i+[self.arrRightTimeLine count] inSection:0]];
        }
        [self.tableRightTimeLine beginUpdates];
        [self.arrRightTimeLine addObjectsFromArray:arrProcessRight];
        [self.tableRightTimeLine insertRowsAtIndexPaths:arrIndexPathRight withRowAnimation:UITableViewRowAnimationNone];
        [self.tableRightTimeLine endUpdates];
         */
        [self setTableViewAnchor];
        [self.tableNavi reloadData];
        isFinishLoad = YES;
    }
    isNaviBtnTouch = NO;
}

- (void)loadOnAirInfo {
    [ApplicationDelegate onloadingindicator];
    if(self.currentOperationOnAir != nil){
        [self.currentOperationOnAir cancel];
        self.currentOperationOnAir = nil;
    }
    self.currentOperationOnAir = [ApplicationDelegate.gshop_http_core   gsTVScheduleOnAirRequestOnCompletion:^(NSDictionary *result) {
                  if (result != nil && [NCS([result objectForKey:@"broadEndDate"]) length] > 0) {
                      self.dicOnAir = result;
                  }
                  [ApplicationDelegate offloadingindicator];
              } onError:^(NSError *error) {
                  Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                  [ApplicationDelegate.window addSubview:malert];
                  [ApplicationDelegate offloadingindicator];
              }];
    
}

- (void)loadMoreScheduleDataUrl:(NSString *)strUrl andRequestType:(ProcessType)requestType {
    NSString *apiURL = [Mocha_Util strReplace:[NSString stringWithFormat:@"%@/",SERVERURI] replace:@"" string:NCS(strUrl)];
    apiURL = [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
    
//    for (NSInteger i=0; i<[self.arrLastMoreUrl count]; i++) {
//        NSString *strSavedUrl = NCS([self.arrLastMoreUrl objectAtIndex:i]);
//        if ([apiURL isEqualToString:strSavedUrl]) {
//            [self.arrLastMoreUrl removeObjectAtIndex:i];
//            return;
//        }
//    }
   
    
    // nami0342 - Not used
    if(self.currentOperation != nil){
        //[self.currentOperation cancel];
        //self.currentOperation = nil;
        return;
    }
    
    [ApplicationDelegate onloadingindicator];

   
    //[self.arrLastMoreUrl addObject:apiURL];
    
    // nami0342 - urlsession
    //무조건 새로고침
    self.currentOperation = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              dispatch_async( dispatch_get_main_queue(),^{
                                                                                  if (result != nil) {
                                                                                      [self setResultDic:result withAddType:requestType];
                                                                                  }
                                                                                  else {
                                                                                      //통신실패
                                                                                      [self setResultDic:result withAddType:ProcessTypeNetError];
                                                                                  }
                                                                                  [ApplicationDelegate offloadingindicator];
                                                                                  
                                                                              });
                                                                          } onError:^(NSError *error) {
                                                                              [ApplicationDelegate offloadingindicator];
                                                                          }];
}

- (void)setTableViewAnchor {
    [self.dicLeftAnchor removeAllObjects];
    //[self.dicRightAnchor removeAllObjects];
    NSInteger idxPgmAnchorYn = 0;
    for (NSInteger i=0; i<[self.arrLeftProduct count]; i++) {
        NSDictionary *dicRow = [self.arrLeftProduct objectAtIndex:i];
        if ([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_MAP_MUT_LIVE"] || [NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_MAP_MUT_MAIN"] || [NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_MAP_ONLY_TITLE"]
            ) {
            if ([NCS([dicRow objectForKey:@"pgmLiveYn"]) isEqualToString:@"Y"]) {
                idxLeftOnAir = i;
            }
            
            if ([NCS([dicRow objectForKey:@"pgmAnchorYn"]) isEqualToString:@"Y"]) {
                idxPgmAnchorYn = i;
            }
            NSString *strAnchorKey = [NSString stringWithFormat:@"%@_%@",NCS([dicRow objectForKey:@"broadStartDate"]),NCS([[dicRow objectForKey:@"product"] objectForKey:@"prdId"])];
            [self.dicLeftAnchor setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:strAnchorKey];
        }
    }
    
    if (idxLeftOnAir == 0 && idxPgmAnchorYn > 0) {
        idxLeftOnAir = idxPgmAnchorYn;
    }
    
    
    //pgmAnchorYn
    
    
    /*
    for (NSInteger i=0; i<[self.arrRightTimeLine count]; i++) {
        NSDictionary *dicRow = [self.arrRightTimeLine objectAtIndex:i];
        if ([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_PRO_BAN_THM"] ||
            [NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"SCH_PRO_BAN_XXX"]
            ) {
            NSString *strAnchorKey = [NSString stringWithFormat:@"%@_%@",NCS([dicRow objectForKey:@"broadStartDate"]),NCS([[dicRow objectForKey:@"product"] objectForKey:@"prdId"])];
            if (NCO([self.dicRightAnchor objectForKey:strAnchorKey]) == NO) {
                [self.dicRightAnchor setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:strAnchorKey];
            }
        }
    }
    */
    for (NSInteger i=0; i<[self.arrDayNavi count]; i++) {
        NSDictionary *dicRow = [self.arrDayNavi objectAtIndex:i];
        NSString *strToday = NCS([dicRow objectForKey:@"yyyyMMdd"]);
        if (NCO([self.dicNaviAnchor objectForKey:strToday]) == NO) {
            [self.dicNaviAnchor setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:strToday];
        }
    }
}


- (CGFloat)onAirLeftTime {
    NSString *strDate = NCS([self.dicOnAir objectForKey:@"broadEndDate"]);
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:strDate];
    double closestamp = [closeTime timeIntervalSince1970];
    double left = closestamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    return left;
}


-(void)showViewOnAir:(BOOL)isShow {
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         //self.viewOnAir.alpha = (isShow)?1.0:0.0;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void) hideLoginViewController:(NSInteger)loginviewtype {
    //필수임 그냥두세요
}

- (NSString*) definecurrentUrlString {
    //필수임 그냥두세요
    return @"";
}

- (void)tableCellReloadForHeight:(NSDictionary *)dic indexPath:(NSIndexPath *) indexPath {
    self.arrLeftProduct[indexPath.row] = dic;
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.tableLeftProduct reloadRowsAtIndexPaths:[NSArray arrayWithObject: path] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - TableView data source & Delegate

-(void)tableViewRegisterNib {
    ///// tableLeftProduct start
    
    
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_MAP_MUT_LIVECell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_MAP_MUT_LIVEIdentifier];
    
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_MAP_MUT_LIVETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_MAP_MUT_LIVETypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_MAP_MUT_LIVETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_MAP_MUT_MAINTypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_TXT_DATETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_TXT_DATETypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_MAP_MUT_SUBTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_MAP_MUT_SUBTypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_TXT_TIMETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_TXT_TIMETypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_IMG_W540TypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_IMG_W540TypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_MUT_SPETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_MUT_SPETypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_MAP_ONLY_TITLETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_MAP_ONLY_TITLETypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_MORETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_MORETypeIdentifier];
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_NO_DATATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_NO_DATATypeIdentifier];
    // header, footer
    /* 2017.09.07 "편성표 매장 레이지로드" 자동로딩으로 변경 */
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_TXT_PRETypeCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:SCH_BAN_TXT_PRETypeIdentifier]; //header
    [self.tableLeftProduct registerNib:[UINib nibWithNibName:@"SCH_BAN_TXT_NEXTTypeCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:SCH_BAN_TXT_NEXTTypeIdentifier];//footer
    ///// tableLeftProduct end
    
    /*
    /////// tableRightTimeLine start
    [self.tableRightTimeLine registerNib:[UINib nibWithNibName:@"SCH_PRO_BAN_THMTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_PRO_BAN_THMTypeIdentifier];
    [self.tableRightTimeLine registerNib:[UINib nibWithNibName:@"SCH_PRO_TXT_DATETypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_PRO_TXT_DATETypeIdentifier];
    [self.tableRightTimeLine registerNib:[UINib nibWithNibName:@"SCH_PRO_NO_DATATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_PRO_NO_DATATypeIdentifier];
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableLeftProduct) {
        return [self.arrLeftProduct count];
    }
//    else if (tableView == self.tableRightTimeLine) {
//        return [self.arrRightTimeLine count];
//    }
    else if (tableView == self.tableNavi) {
        return [self.arrDayNavi count];
    }
    else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableLeftProduct) {
        NSDictionary *dicRow = [self.arrLeftProduct objectAtIndex:indexPath.row];
        NSString *viewType = NCS([dicRow objectForKey:@"viewType"]);

        if([viewType  isEqualToString:@"SCH_MAP_MUT_LIVE"]) {
            SCH_MAP_MUT_LIVECell *cell     = [tableView dequeueReusableCellWithIdentifier:SCH_MAP_MUT_LIVEIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.target = self;
            if (isLiveDataChanged == YES) {
                cell.isLiveCellNeedsReload = YES;
                isLiveDataChanged = NO;
            }
            else {
                cell.isLiveCellNeedsReload = NO;
            }
            [cell setCellInfoNDrawData:dicRow andIndexPath:indexPath];
            return  cell;
        }else if([viewType  isEqualToString:@"SCH_MAP_MUT_MAIN"]) {
            SCH_MAP_MUT_LIVECell *cell     = [tableView dequeueReusableCellWithIdentifier:SCH_MAP_MUT_LIVEIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.target = self;
            [cell setCellInfoNDrawData:dicRow andIndexPath:indexPath];
            return  cell;
        }else if([viewType  isEqualToString:@"SCH_BAN_MUT_DATE"]) {
            SCH_BAN_TXT_DATETypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_BAN_TXT_DATETypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellInfoNDrawData:dicRow];
            [cell setUserInteractionEnabled:NO];
            return  cell;
            
        } else if([viewType  isEqualToString:@"SCH_MAP_MUT_SUB"]) {
            SCH_MAP_MUT_SUBTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_MAP_MUT_SUBTypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.target = self;
            [cell setCellInfoNDrawData:dicRow];
            if ([[dicRow objectForKey:@"isVisible"] isEqualToString:@"Y"]) {
                cell.hidden = NO;
//                if ([NCS([dicRow objectForKey:@"isLastSubs"]) isEqualToString:@"Y"]) {
//                    cell.viewBottomLine.hidden = NO;
//                }
//                else {
//                    cell.viewBottomLine.hidden = YES;
//                }
            }
            else {
                cell.hidden = YES;
            }
            return  cell;
        } else if([viewType  isEqualToString:@"SCH_BAN_IMG_W540"]) {
            SCH_BAN_IMG_W540TypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_BAN_IMG_W540TypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.aTarget = self;
            [cell setCellInfoNDrawData:dicRow indexPath: indexPath];
            return  cell;
        } else if([viewType  isEqualToString:@"SCH_MAP_ONLY_TITLE"]) {
            SCH_MAP_ONLY_TITLETypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_MAP_ONLY_TITLETypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.dicAll = dicRow;
            cell.target = self;
            //cell.lblTitle.text = NCS([[dicRow objectForKey:@"product"] objectForKey:@"exposPrdName"]);
            [cell setCellInfoNDrawData:dicRow];
            return  cell;
        } else if([viewType  isEqualToString:@"SCH_BAN_NO_DATA"]) {
            SCH_BAN_NO_DATATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_BAN_NO_DATATypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellInfoNDrawData:dicRow];
            return cell;
        } else if([viewType  isEqualToString:@"SCH_BAN_MORE"]) {
            SCH_BAN_MORETypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_BAN_MORETypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.bTarget = self;
            cell.idxPath = indexPath;
            BOOL isMore = ([NCS([dicRow objectForKey:@"isMore"]) isEqualToString:@"Y"])?YES:NO;
            if (isMore) {
                NSString *strCount = [NSString stringWithFormat:@"(%@개)",NCS([dicRow objectForKey:@"subPrdCount"])];
                [cell changeStatusWithStr:@"관련 상품" andNumber:strCount andStatus:isMore];
            }
            else {
                [cell changeStatusWithStr:@"" andNumber:@"관련 상품 닫기" andStatus:isMore];
            }
            return  cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SListCell"];
            return cell;
        }
    }
    /*
    else if (tableView == self.tableRightTimeLine) {
        NSDictionary *dicRow = [self.arrRightTimeLine objectAtIndex:indexPath.row];
        NSString *viewType = NCS([dicRow objectForKey:@"viewType"]);
        if([viewType isEqualToString:@"SCH_PRO_BAN_THM"] || [viewType isEqualToString:@"SCH_PRO_BAN_XXX"]) {
            SCH_PRO_BAN_THMTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_PRO_BAN_THMTypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellInfoNDrawData:dicRow];            
            //생방송 여부
            [cell setOnAir:[viewType isEqualToString:@"SCH_PRO_BAN_THM"]];
            if (idxSelectedRight == indexPath.row) { // 선택된 셀 설정
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            return  cell;
        }
        else if([viewType isEqualToString:@"SCH_PRO_TXT_DATE"]) {
            SCH_PRO_TXT_DATETypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_PRO_TXT_DATETypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setUserInteractionEnabled:NO]; // 선택되지 않음.
            [cell setCellInfoNDrawData:dicRow];
            return  cell;
        }
        else if([viewType isEqualToString:@"SCH_PRO_NO_DATA"]) {
            SCH_PRO_NO_DATATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_PRO_NO_DATATypeIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[cell setUserInteractionEnabled:NO]; // 선택되지 않음.
            [cell setCellInfoNDrawData:dicRow];
            return  cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SListCell"];
            return cell;
        }
    }
     */
    else if (tableView == self.tableNavi) {
        NSDictionary *dicRow = [self.arrDayNavi objectAtIndex:indexPath.row];
        SCH_DAYTypeCell *cell = (SCH_DAYTypeCell *)[tableView dequeueReusableCellWithIdentifier:SCH_DAYTypeIdentifier];
        if (cell == nil) {
            cell = (SCH_DAYTypeCell *)[[[NSBundle mainBundle] loadNibNamed:SCH_DAYTypeIdentifier owner:self options:nil] firstObject];;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bTarget = self;
        cell.indexPos = indexPath.row;
        if (NCO(dicRow) && [dicRow isKindOfClass:[NSDictionary class]]) {
            [cell setCellInfoNDrawData:dicRow];
        }
        
        if (idxSelectedNavi == indexPath.row) { // 선택된 셀 설정
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        return  cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SListCell"];
        cell.frame = CGRectZero;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableLeftProduct) {
        NSDictionary *dicRow = [self.arrLeftProduct objectAtIndex:indexPath.row];
        NSString *viewType = NCS([dicRow objectForKey:@"viewType"]);
        if([viewType  isEqualToString:@"SCH_MAP_MUT_LIVE"] || [viewType  isEqualToString:@"SCH_MAP_MUT_MAIN"] ) {
            
            CGFloat heightTop = 16.0;
            
            if ([NCS([dicRow objectForKey:@"startTime"]) length] > 0) {
                
                heightTop = heightTop + 34.0;
            }
            
            CGFloat heightPrice = SCH_MAP_MUT_LIVE_heightPriceArea;
            
            if ([NCS([[dicRow  objectForKey:@"product"] objectForKey:@"insuYn"]) isEqualToString:@"Y"]){
                heightPrice = heightPrice - 30.0;
            }
            
            return (heightTop+roundf((APPFULLWIDTH - 32.0)*(1.0/2.0))+ heightPrice +1.0);
            
        }
        else if([viewType  isEqualToString:@"SCH_BAN_MUT_DATE"]) {
            return 64.0;
        }
        else if([viewType  isEqualToString:@"SCH_BAN_MUT_TIME"]) {
            return 48.0;
        }
        else if([viewType  isEqualToString:@"SCH_BAN_MUT_SPE"]) {
            return (20.0/160.0)*widthTableLeftProduct;
        }
        else if([viewType  isEqualToString:@"SCH_MAP_MUT_SUB"]) {
            CGFloat heightDefault = CGFLOAT_MIN;
            if ([[dicRow objectForKey:@"isVisible"] isEqualToString:@"Y"] && NCO([dicRow objectForKey:@"product"])) {
                heightDefault = [self heightCalculatorSCH_MAP_MUT_SUB:[dicRow objectForKey:@"product"]];
            }
            
            return heightDefault;
        }
        else if([viewType  isEqualToString:@"SCH_BAN_IMG_W540"]) {
            NSString * height = NCS([[dicRow objectForKey:@"liveBanner"] objectForKey:@"height"]);
            if ((height != nil) && (height.length > 0)) {
                return height.floatValue;
            }
            return ((50.0/320.0) * widthTableLeftProduct) + 20;
        }
        else if([viewType  isEqualToString:@"SCH_MAP_ONLY_TITLE"]) {
            return  84.0;
        }
        else if([viewType  isEqualToString:@"SCH_BAN_MORE"]) {
            return  49.0;
        }
        else if([viewType  isEqualToString:@"SCH_BAN_NO_DATA"]) {
            return 136.0;
        }
        else {
            return CGFLOAT_MIN;
        }
    }
    
    /*
    else if (tableView == self.tableRightTimeLine) {
        NSString *viewType = NCS([[self.arrRightTimeLine objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
        if([viewType isEqualToString:@"SCH_PRO_BAN_THM"] || [viewType isEqualToString:@"SCH_PRO_BAN_XXX"]) {
            NSDictionary *dicRow = [self.arrRightTimeLine objectAtIndex:indexPath.row];
            if ([NCS([dicRow objectForKey:@"isLastRight"]) isEqualToString:@"Y"]) {
                return heightRightTimeLine + 3.0;
            }
            else {
                return heightRightTimeLine;
            }
        }
        else if([viewType isEqualToString:@"SCH_PRO_TXT_DATE"]){
            return 53.0;
        }
        else if([viewType isEqualToString:@"SCH_PRO_NO_DATA"]){
            return 0.0;
        }
        else {
            return CGFLOAT_MIN;
        }
    }
     */
    else if (tableView == self.tableNavi){
        return widthTopNavi;
    }
    else {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableLeftProduct) {
        NSLog(@"");
    }
    /*
    else if (tableView == self.tableRightTimeLine) {
        NSString *viewType = NCS([[self.arrRightTimeLine objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
        NSDictionary *dicRow = [self.arrRightTimeLine objectAtIndex:indexPath.row];
        NSLog(@"");
        if([viewType isEqualToString:@"SCH_PRO_BAN_THM"] || [viewType isEqualToString:@"SCH_PRO_BAN_XXX"]) {
            idxSelectedRight = indexPath.row;
            NSString *strKey = [NSString stringWithFormat:@"%@_%@",NCS([dicRow objectForKey:@"broadStartDate"]),NCS([[dicRow objectForKey:@"product"] objectForKey:@"prdId"])];
            if ([strKey length] > 0 && [NCS([self.dicLeftAnchor objectForKey:strKey]) length] > 0) {
                 NSInteger idxLeft = [NCS([self.dicLeftAnchor objectForKey:strKey]) integerValue];
                 if ([self.arrLeftProduct count] > idxLeft) {
                     isMoveFromRightTimeLine = YES;
                     CGRect rectToScroll = [self.tableLeftProduct rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxLeft inSection:0]];
                     [self.tableLeftProduct setContentOffset:CGPointMake(0.0, rectToScroll.origin.y) animated:YES];

                     if ([strKey length] > 0 && [NCS([self.dicRightAnchor objectForKey:strKey]) length] > 0) {
                         if ([strKey length] >= 8) {
                             NSString *strIndexSub = [strKey substringWithRange:NSMakeRange(0, 8)];
                             NSInteger idxNavi = [NCS([self.dicNaviAnchor objectForKey:strIndexSub]) integerValue];
                             if (idxNavi != idxSelectedNavi) {
                                 idxSelectedNavi = idxNavi;
                                 [self.tableNavi selectRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                                 if ([self.arrDayNavi count] > idxSelectedNavi) {
                                     if (idxSelectedNavi-1 > 0) {
                                         [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                     }
                                     else {
                                         [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                     }
                                 }
                             }
                         }
                     }
                 }
            }
        }
        else if([viewType isEqualToString:@"SCH_PRO_TXT_DATE"]) {
        }
        else {
        }
        
        //효율코드 던지기
        if([viewType isEqualToString:@"SCH_PRO_BAN_THM"]) { //생방송
            if([self isLiveBrd]) {
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_S-LP")];
            }
            else {
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_S_D-LP")];
            }
        }
        else { //이전 이후
            if([self isLiveBrd]) {
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_S-AP")];
            }
            else {
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_S_D-AP")];
            }
        }
    }
     */
    else if (tableView == self.tableNavi) {
        idxSelectedNavi = indexPath.row; //클릭된 아이템
        NSIndexPath *pathToScroll = indexPath;
        if ([self.arrDayNavi count] > indexPath.row) {
            [self.tableNavi scrollToRowAtIndexPath:pathToScroll atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
    else {
    }
}


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( isFinishLoad == YES && (tableView == self.tableLeftProduct /*|| tableView == self.tableRightTimeLine */) ) {
        NSInteger idxLeftLast = [self.arrLeftProduct count] - 1;
        //NSInteger idxRightLast = [self.arrRightTimeLine count] - 1;
        NSInteger intCase = 0;
        NSDictionary *infoDic = nil;
        if (tableView == self.tableLeftProduct && (indexPath.row == 0 || indexPath.row == idxLeftLast )) {
            if (indexPath.row == 0) {
                intCase = 0;
                if (NCO(self.dicHeader)) {
                    infoDic = self.dicHeader;
                }
            }
            else if (indexPath.row == idxLeftLast) {
                intCase = 1;
                if (NCO(self.dicFooter)) {
                    infoDic = self.dicFooter;
                }
            }
            
            if (infoDic != nil && [NCS([infoDic objectForKey:@"apiUrl"]) length] > 0 && [NCS([infoDic objectForKey:@"apiParam"]) length] > 0) {
                [self onHeaderFooterAction:intCase data:infoDic];
            }
            else {
                
            }
        }
        /*
        else if (tableView == self.tableRightTimeLine && (indexPath.row == 0 || indexPath.row == idxRightLast )) {
            if (indexPath.row == 0) {
                intCase = 2;
                if (NCO(self.dicHeader)) {
                    infoDic = self.dicHeader;
                }
            }
            else if (indexPath.row == idxRightLast) {
                intCase = 3;
                if (NCO(self.dicFooter)) {
                    infoDic =self.dicFooter;
                }
                
            }
            
            if (infoDic != nil && [NCS([infoDic objectForKey:@"apiUrl"]) length] > 0 && [NCS([infoDic objectForKey:@"apiParam"]) length] > 0) {
                [self onHeaderFooterAction:intCase data:infoDic];
            }
            else {
                
            }
        }
         */
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableLeftProduct) {
        return 80.0;
    }
    /*
    else if (tableView == self.tableRightTimeLine) {
        return CGFLOAT_MIN;
    }
     */
    else {
        return CGFLOAT_MIN;
    }
}

#pragma mark - TableView Touch Events

// 헤더푸터 클릭 액션
- (void)onHeaderFooterAction:(NSInteger)tag data:(NSDictionary*)info {
    if(is_NODATA) {
        return;
    }
    NSString *loadUrl = [Common_Util makeUrlWithParam:[info objectForKey:@"apiUrl"] parameter:[info objectForKey:@"apiParam"]];
    switch (tag) {
        case 0: //left header
            [self loadMoreScheduleDataUrl:loadUrl andRequestType:ProcessTypeInsertAtZero];
            break;
        case 1: //left footer
            [self loadMoreScheduleDataUrl:loadUrl andRequestType:ProcessTypeLastAdd];
            break;
        case 2: //r header
            [self loadMoreScheduleDataUrl:loadUrl andRequestType:ProcessTypeInsertAtZero];
            break;
        case 3: //r header
            [self loadMoreScheduleDataUrl:loadUrl andRequestType:ProcessTypeLastAdd];
            break;            
        default:
            break;
    }
}

// 생방송/마이샵 전환 데이터 리로드
- (IBAction)switchAction:(id)sender {
    //self.switchImg.highlighted = !self.switchImg.highlighted;
    
    NSString *url = @"";
    NSString *param = @"";
    if([((UIButton *)sender) tag] == 88) { //Data!!
        url= NCS([self.dicDataUrl objectForKey:@"apiUrl"]);
        param = NCS([self.dicDataUrl objectForKey:@"apiParam"]);
    }
    else {
        url= NCS([self.dicLiveUrl objectForKey:@"apiUrl"]);
        param = NCS([self.dicLiveUrl objectForKey:@"apiParam"]);
        
    }
    
    if ([url length] == 0) {
        return;
    }
    
    
    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[url componentsSeparatedByString:@"/broadSchedule"] objectAtIndex:0]];
    NSDictionary *dicSeletedNavi = [self.arrDayNavi objectAtIndex:idxSelectedNavi];

    [strDate appendString:@"/broadSchedule/"];
    [strDate appendString:NCS([dicSeletedNavi objectForKey:@"yyyyMMdd"])];

    
    self.strReloadUrl = [Common_Util makeUrlWithParam:strDate parameter:param];
    
    // 반대로 호출해야 한다.
    if(![self isLiveBrd]) {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-SWT-L")];
    }
    else {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-SWT-D")];
    }
    
    if ([NCS(self.strReloadUrl) length] > 0) {
        [self loadMoreScheduleDataUrl:self.strReloadUrl andRequestType:ProcessTypeReload];
    }
    else {
        //유효하지 않는 주소
    }
}


////// 헤더/푸터 설정
-(void)onBtnNaviDay:(NSDictionary *)dic cellIndex:(NSInteger) index {
    isNaviBtnTouch = YES;
    NSString *loadUrl = [Common_Util makeUrlWithParam:[dic objectForKey:@"apiUrl"] parameter:[dic objectForKey:@"apiParm"]];
    
    [self loadMoreScheduleDataUrl:loadUrl andRequestType:ProcessTypeReload];

    // 효율코드 던지기
    if([NCS([dic objectForKey:@"todayYn"]) isEqualToString:@"Y"]) {
        // 오늘
        if([self isLiveBrd]) {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-C_SCH-TODAY")];
        }
        else {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-C_SCH_D-TODAY")];
        }
    }
    else {
        // 오늘을 찾는다.
        int todayPos = 0;
        for (NSDictionary *tempDay in self.arrDayNavi) {
            if([NCS([tempDay objectForKey:@"todayYn"]) isEqualToString:@"Y"]) {
                break;
            }
            todayPos ++;
        }
        
        int value = todayPos - (int)index;
        if(value > 0) {
            // 음수이면.. 과거 (절대값)
            NSString *key = @"";
            if([self isLiveBrd]) {
                key = [NSString stringWithFormat:@"?mseq=A00323-C_SCH-PD_%d",abs(value)];
            }
            else {
                key = [NSString stringWithFormat:@"?mseq=A00323-C_SCH_D-PD_%d",abs(value)];
            }
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(key)];
        }
        else {
            //양수이면 미래
            NSString *key = @"";
            if([self isLiveBrd]) {
                key = [NSString stringWithFormat:@"?mseq=A00323-C_SCH-ND_%d",abs(value)];
            }
            else {
                key = [NSString stringWithFormat:@"?mseq=A00323-C_SCH_D-ND_%d",abs(value)];
            }
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(key)];
        }
    }
}

- (void)onBtnTableViewCellAlarm:(NSDictionary *)dicSeleted {
    SListAlarmPopupView *viewPopup = [[[NSBundle mainBundle] loadNibNamed:@"SListAlarmPopupView" owner:self options:nil] firstObject];
    viewPopup.delegate = self;
    [viewPopup setViewInfoNDrawData:dicSeleted alarmType:@"TYPE_REG"];
    [ApplicationDelegate.window addSubview:viewPopup];
}


- (void)setResultTableViewCellAlarm:(NSDictionary *)dicCommResult andAlarmYN:(NSString *)strAlarmYN {
    NSDictionary *dicSeletedProduct = dicCommResult;
    if (NCO(dicSeletedProduct) == YES && [NCS([dicSeletedProduct objectForKey:@"prdId"]) length] > 0) {
        NSString *strCompareId = [dicSeletedProduct objectForKey:@"prdId"];
        for (NSInteger i=0; i<[self.arrLeftProduct count]; i++) {
            NSMutableDictionary *dicRow = [[NSMutableDictionary alloc] init];
            [dicRow addEntriesFromDictionary:[self.arrLeftProduct objectAtIndex:i]];
            NSString *viewType = [dicRow objectForKey:@"viewType"];
            if ([viewType isEqualToString:@"SCH_MAP_MUT_LIVE"] || [viewType isEqualToString:@"SCH_MAP_MUT_MAIN"] || [viewType  isEqualToString:@"SCH_MAP_MUT_SUB"]) {
                NSMutableDictionary *dicRowProduct = [[NSMutableDictionary alloc] init];
                [dicRowProduct addEntriesFromDictionary:[dicRow objectForKey:@"product"]];
                if (NCO(dicRowProduct) && [NCS([dicRowProduct objectForKey:@"prdId"]) length] > 0 && [[dicRowProduct objectForKey:@"prdId"] isEqualToString:strCompareId]) {
                    [dicRowProduct setObject:strAlarmYN forKey:@"broadAlarmDoneYn"];
                    [dicRow setObject:dicRowProduct forKey:@"product"];
                    [self.arrLeftProduct replaceObjectAtIndex:i withObject:dicRow];
                    NSIndexPath *pathToChange = [NSIndexPath indexPathForRow:i inSection:0];
                    if ([[self.tableLeftProduct indexPathsForVisibleRows] containsObject:pathToChange]) {
                        if ([viewType isEqualToString:@"SCH_MAP_MUT_LIVE"] || [viewType isEqualToString:@"SCH_MAP_MUT_MAIN"]) {
                            SCH_MAP_MUT_LIVETypeCell *cell = (SCH_MAP_MUT_LIVETypeCell *)[self.tableLeftProduct cellForRowAtIndexPath:pathToChange];
                            if (isLiveDataChanged == YES) {
                                cell.isLiveCellNeedsReload = YES;
                                isLiveDataChanged = NO;
                            }
                            else {
                                cell.isLiveCellNeedsReload = NO;
                            }
                            [cell setCellInfoNDrawData:dicRow andIndexPath:pathToChange];
                        }
                        else {
                            SCH_MAP_MUT_SUBTypeCell *cell = (SCH_MAP_MUT_SUBTypeCell *)[self.tableLeftProduct cellForRowAtIndexPath:pathToChange];
                            [cell setCellInfoNDrawData:dicRow];
                        }
                    }
                }
            }
        }
    }
}


//20180620 사용하지 않음.
- (IBAction)onBtnLeftBottomOnAir:(id)sender {
    //효율코드 던지기
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-C_SCH-ONAIR")];
    if ([NCS(self.strReloadUrl) length] > 0) {
        [self loadMoreScheduleDataUrl:self.strReloadUrl andRequestType:ProcessTypeReload];
    }
}


- (void)requestAlarmWithDic:(NSDictionary *)dicProduct andProcess:(NSString *)strProcess andPeroid:(NSString *)strPeriod andCount:(NSString *)strCount {
    if (dicProduct == nil || [NCS(strProcess) length] == 0) {
        return;
    }
    
    [ApplicationDelegate onloadingindicator];
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    NSString *strApiUrl = nil;
    
    if ([NCS(strProcess) isEqualToString:TVS_ALARMINFO]) {
        strApiUrl = GS_TVSCHEDULE_ALARMINFO;
    }
    else if ([NCS(strProcess) isEqualToString:TVS_ALARMADD]) {
        strApiUrl = GS_TVSCHEDULE_ALARMADD;
    }
    else if ([NCS(strProcess) isEqualToString:TVS_ALARMDELETE]) {
        strApiUrl = GS_TVSCHEDULE_ALARMDELETE;
    }
   
    [post_dict setValue:@"PRDID" forKey:@"type"];
    [post_dict setValue:NCS([dicProduct objectForKey:@"prdId"]) forKey:@"prdId"];
    [post_dict setValue:NCS([dicProduct objectForKey:@"prdName"]) forKey:@"prdName"];
    [post_dict setValue:NCS(strPeriod) forKey:@"period"];
    [post_dict setValue:NCS(strCount) forKey:@"alarmCnt"];

    NSData *postData = [[post_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"json str %@", [post_dict jsonEncodedKeyValueString]);
    
    // Establish the API request. Use upload vs uploadAndPost for skip tweet
    NSString *baseurl = strApiUrl;
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    
    // Submit & retrieve results
    // NSError *error;
    // NSHTTPURLResponse *response;
    NSLog(@"Contacting Server....");
    
    NSLog(@"strApiUrl =%@",strApiUrl);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if (!resultString) {
                                          dispatch_async( dispatch_get_main_queue(),^{
                                              NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
                                              Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                              [ApplicationDelegate.window addSubview:malert];
                                          });
                                      }
                                      else {
                                          NSDictionary *result = [resultString JSONtoValue];
                                          NSString *strErrMsg = @"알수 없는 에러가 발생했습니다";
                                          if (result != nil && [NCS([result objectForKey:@"errMsg"]) length] > 0) {
                                              if ([NCS([result objectForKey:@"errMsgText"]) length]>0) {
                                                  strErrMsg = NCS([result objectForKey:@"errMsgText"]);
                                              }
                                              
                                              
                                              dispatch_async( dispatch_get_main_queue(),^{
                                                  [ApplicationDelegate offloadingindicator];
                                                  if ([[result objectForKey:@"errMsg"] isEqualToString:@"ERR_NOT_LOGIN"]) {
                                                      Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                      malert.tag = 666;
                                                      [ApplicationDelegate.window addSubview:malert];
                                                  }
                                                  else if ([[result objectForKey:@"errMsg"] isEqualToString:@"MSG_SUCCESS"]) {
                                                      if ([NCS(strProcess) isEqualToString:TVS_ALARMINFO]) {
                                                          [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                                                      }
                                                      else if ([NCS(strProcess) isEqualToString:TVS_ALARMADD]) {
                                                          [self setResultTableViewCellAlarm:result andAlarmYN:@"Y"];
                                                          [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                                                          
                                                      }
                                                      else if ([NCS(strProcess) isEqualToString:TVS_ALARMDELETE]) {
                                                          [self setResultTableViewCellAlarm:result andAlarmYN:@"N"];
                                                          [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                                                      }
                                                  }
                                                  else if ([[result objectForKey:@"errMsg"] isEqualToString:@"ERR_DUPLICATE_PRODUCT"]) {
                                                      //ERR_DUPLICATE_PRODUCT(이미 방송알림 등록된 상품) : MSG_SUCCESS 케이스는 아니지만, broadAlarmDoneYn N->Y , 상태 토글, MSG_SUCCESS와 동일 처리해야함, ( 기획자)  : 성공한것 처럼 처리
                                                      [self setResultTableViewCellAlarm:result andAlarmYN:@"Y"];
                                                      Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                      [ApplicationDelegate.window addSubview:malert];
                                                      
                                                  }
                                                  else if ([[result objectForKey:@"errMsg"] isEqualToString:@"ERR_NOT_ALARM_PRODUCT"]) {
                                                      //ERR_NOT_ALARM_PRODUCT(등록된 방송알림 상품 아님) : MSG_SUCCESS 케이스는 아니지만, broadAlarmDoneYn Y->N , 상태 토글, 켄슬 성공한것 처럼 처리,
                                                      [self setResultTableViewCellAlarm:result andAlarmYN:@"N"];
                                                      [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                                                  }
                                                  else {
                                                      Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                      [ApplicationDelegate.window addSubview:malert];
                                                  }
                                              });
                                          }
                                          else {
                                              dispatch_async( dispatch_get_main_queue(),^{
                                                  [ApplicationDelegate offloadingindicator];
                                                  Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                  [ApplicationDelegate.window addSubview:malert];
                                              });
                                          }
                                      }
                                  }];
    [task resume];
    
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!resultString) {
            dispatch_async( dispatch_get_main_queue(),^{
                   NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [connectionError localizedDescription]]);
                   Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                   [ApplicationDelegate.window addSubview:malert];
               });
        }
        else {
            NSDictionary *result = [resultString JSONtoValue];
            NSString *strErrMsg = @"알수 없는 에러가 발생했습니다";
            if (result != nil && [NCS([result objectForKey:@"errMsg"]) length] > 0) {
                if ([NCS([result objectForKey:@"errMsgText"]) length]>0) {
                    strErrMsg = NCS([result objectForKey:@"errMsgText"]);
                }
                
                
                dispatch_async( dispatch_get_main_queue(),^{
                    [ApplicationDelegate offloadingindicator];
                    if ([[result objectForKey:@"errMsg"] isEqualToString:@"ERR_NOT_LOGIN"]) {
                        Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                        malert.tag = 666;
                        [ApplicationDelegate.window addSubview:malert];
                    }
                    else if ([[result objectForKey:@"errMsg"] isEqualToString:@"MSG_SUCCESS"]) {
                        if ([NCS(strProcess) isEqualToString:TVS_ALARMINFO]) {
                            [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                        }
                        else if ([NCS(strProcess) isEqualToString:TVS_ALARMADD]) {
                            [self setResultTableViewCellAlarm:result andAlarmYN:@"Y"];
                            [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                            
                        }
                        else if ([NCS(strProcess) isEqualToString:TVS_ALARMDELETE]) {
                            [self setResultTableViewCellAlarm:result andAlarmYN:@"N"];
                            [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                        }
                    }
                    else if ([[result objectForKey:@"errMsg"] isEqualToString:@"ERR_DUPLICATE_PRODUCT"]) {
                        //ERR_DUPLICATE_PRODUCT(이미 방송알림 등록된 상품) : MSG_SUCCESS 케이스는 아니지만, broadAlarmDoneYn N->Y , 상태 토글, MSG_SUCCESS와 동일 처리해야함, ( 기획자)  : 성공한것 처럼 처리
                        [self setResultTableViewCellAlarm:result andAlarmYN:@"Y"];
                        Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                        [ApplicationDelegate.window addSubview:malert];
                        
                    }
                    else if ([[result objectForKey:@"errMsg"] isEqualToString:@"ERR_NOT_ALARM_PRODUCT"]) {
                        //ERR_NOT_ALARM_PRODUCT(등록된 방송알림 상품 아님) : MSG_SUCCESS 케이스는 아니지만, broadAlarmDoneYn Y->N , 상태 토글, 켄슬 성공한것 처럼 처리,
                        [self setResultTableViewCellAlarm:result andAlarmYN:@"N"];
                        [self showAlarmPopupWithDic:result andAlarmType:strProcess];
                    }
                    else {
                        Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                        [ApplicationDelegate.window addSubview:malert];
                    }
                    });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    [ApplicationDelegate offloadingindicator];
                    Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                    [ApplicationDelegate.window addSubview:malert];
                });
            }
        }
        [queue waitUntilAllOperationsAreFinished];
    }];
     */
}

- (void)showAlarmPopupWithDic:(NSDictionary*)dicAlarm andAlarmType:(NSString *)strType {
    if (viewAlarmPopup == nil) {
        viewAlarmPopup = [[[NSBundle mainBundle] loadNibNamed:@"SListAlarmPopupView" owner:self options:nil] firstObject];
        viewAlarmPopup.delegate = self;
    }
    else {
        [viewAlarmPopup onBtnClose:nil];
    }
    [viewAlarmPopup setViewInfoNDrawData:dicAlarm alarmType:strType];
    [ApplicationDelegate.window addSubview:viewAlarmPopup];
}

- (void)touchEventTBCell:(NSDictionary *)dic {
    if ([self.delegatetarget respondsToSelector:@selector(touchEventTBCell:)]) {
        [self.delegatetarget touchEventTBCell:dic];
    }
}


- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr {
    if ([self.delegatetarget respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [self.delegatetarget touchEventTBCellJustLinkStr:linkstr];
    }
}

- (void)touchSubProductStatus:(BOOL)isShowMore andIndexPath:(NSIndexPath*)idxPath {
    NSMutableArray *arrIndexPaths = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicMore = [[NSMutableDictionary alloc] init];
    [dicMore addEntriesFromDictionary:[self.arrLeftProduct objectAtIndex:idxPath.row]];
    
    if ([NCS([dicMore objectForKey:@"subPrdCount"]) length] > 0) {
        NSInteger cntSub = [[dicMore objectForKey:@"subPrdCount"] integerValue];
        for (NSInteger i = idxPath.row - 1 ; cntSub > 0; cntSub--,i--) {
            NSMutableDictionary *dicSubMod = [[NSMutableDictionary alloc] init];
            [dicSubMod addEntriesFromDictionary:[[self.arrLeftProduct objectAtIndex:i] copy]];
            if ([[dicSubMod objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_SUB"]) {
                NSString *strYN = (isShowMore)?@"Y":@"N";
                [dicSubMod setObject:strYN forKey:@"isVisible"];
                [self.arrLeftProduct replaceObjectAtIndex:i withObject:dicSubMod];
                [arrIndexPaths insertObject:[NSIndexPath indexPathForRow:i inSection:0] atIndex:0];
            }
        }
        
        NSString *strYN = (isShowMore)?@"N":@"Y";
        [dicMore setObject:strYN forKey:@"isMore"];
        [self.arrLeftProduct replaceObjectAtIndex:idxPath.row withObject:dicMore];
        [self.tableLeftProduct reloadRowsAtIndexPaths:[NSArray arrayWithObject:idxPath] withRowAnimation:UITableViewRowAnimationNone];
        if (isShowMore) {
            [self.tableLeftProduct reloadRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            [self.tableLeftProduct reloadRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}


- (void)liveCellSaleCountEnd:(NSIndexPath *)path {
    NSMutableDictionary *dicModify = [[NSMutableDictionary alloc] init];
    [dicModify addEntriesFromDictionary:[self.arrLeftProduct objectAtIndex:path.row]];
    if (NCO([dicModify objectForKey:@"product"]) && NCO([[dicModify objectForKey:@"product"] objectForKey:@"salesInfo"]) ) {
        NSMutableDictionary *dicProduct = [[NSMutableDictionary alloc] init];
        [dicProduct addEntriesFromDictionary:[dicModify objectForKey:@"product"]];
        [dicProduct setObject:[NSNull null] forKey:@"salesInfo"];
        [dicModify setObject:dicProduct forKey:@"product"];
        [self.arrLeftProduct replaceObjectAtIndex:path.row withObject:dicModify];
    }
}

- (void)hideRightTimeLineOnImage:(NSIndexPath *)pathFromLeft {
    /*
    if (pathFromLeft != nil && [self.arrLeftProduct count] > pathFromLeft.row) {
        NSDictionary *dicLeftLiveCell = [self.arrLeftProduct objectAtIndex:pathFromLeft.row];
        NSString *strKey = [NSString stringWithFormat:@"%@_%@",NCS([dicLeftLiveCell objectForKey:@"broadStartDate"]),NCS([[dicLeftLiveCell objectForKey:@"product"] objectForKey:@"prdId"])];
        
        if ([NCS([self.dicRightAnchor objectForKey:strKey]) length] > 0) {
            NSInteger idxRightLiveCell = [NCS([self.dicRightAnchor objectForKey:strKey]) integerValue];
            NSMutableDictionary *dicRightLive = [[NSMutableDictionary alloc] init];
            [dicRightLive addEntriesFromDictionary:[self.arrRightTimeLine objectAtIndex:idxRightLiveCell]];
            [dicRightLive setObject:@"SCH_PRO_BAN_XXX" forKey:@"viewType"];
            [self.arrRightTimeLine replaceObjectAtIndex:idxRightLiveCell withObject:dicRightLive];
            [self.tableRightTimeLine reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:idxRightLiveCell inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
     */
}

#pragma mark - UICustomAlertDelegate
- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if (alert.tag == 666) {
        AutoLoginViewController *loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
        loginView.delegate = self;
        loginView.loginViewType = 4;
        /// 비로그인 상태에서 TV편성표의 알람버튼 Tap시 로그인 완료 후 TV 편성표로 이동되도록 하기 위함.
        loginView.deletargetURLstr = @"http://m.gsshop.com/index.gs?tabId=323";
        UINavigationController * navigationController = ApplicationDelegate.mainNVC;
        [navigationController pushViewControllerMoveInFromBottom:loginView];
        //로그인 이후 최종 위치 확인 필요.
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.tableLeftProduct) {
        [self.scrollExpandingDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableLeftProduct) {
        [self.delegatetarget customscrollViewDidScroll:(UIScrollView *)scrollView];
        [self.scrollExpandingDelegate scrollViewDidScroll:scrollView];
        if (/*isMoveFromRightTimeLine == NO &&*/ [[self.tableLeftProduct visibleCells] count] > 0) {
            NSArray *arrVisibleCells = [self.tableLeftProduct visibleCells];
            for (NSInteger i=0; i<[arrVisibleCells count]; i++) {
                if ([[arrVisibleCells objectAtIndex:i] isKindOfClass:[SCH_MAP_MUT_LIVECell class]]) {
                    SCH_MAP_MUT_LIVECell *cell = (SCH_MAP_MUT_LIVECell *)[arrVisibleCells objectAtIndex:i];
                    CGRect onlyImageRect = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width,cell.viewImageArea.frame.size.height);
                    CGRect rectToCheck = [scrollView convertRect:onlyImageRect toView:scrollView.superview];
                    CGFloat heightTable =  self.tableLeftProduct.frame.size.height ;//APPFULLHEIGHT - 20.0 - 44.0 - 44.0 - 50.0;
                    CGRect rectCenterLine = CGRectMake(scrollView.frame.origin.x, heightTable * 0.5, scrollView.frame.size.width, 1.0);
                    if (CGRectContainsRect(rectToCheck,rectCenterLine)) {
                        NSString *strKey = [NSString stringWithFormat:@"%@_%@",NCS([cell.dicAll objectForKey:@"broadStartDate"]),NCS([[cell.dicAll objectForKey:@"product"] objectForKey:@"prdId"])];
                        
                        if ([strKey length] > 0 /*&& [NCS([self.dicRightAnchor objectForKey:strKey]) length] > 0*/) {
                            //NSInteger idxRight = [NCS([self.dicRightAnchor objectForKey:strKey]) integerValue];
                            if ([strKey length] >= 8) {
                                NSString *strIndexSub = [strKey substringWithRange:NSMakeRange(0, 8)];
                                NSInteger idxNavi = [NCS([self.dicNaviAnchor objectForKey:strIndexSub]) integerValue];
                                if (idxNavi != idxSelectedNavi) {
                                    idxSelectedNavi = idxNavi;
                                    [self.tableNavi selectRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                                    
                                    if ([self.arrDayNavi count] > idxSelectedNavi) {
                                        if (idxSelectedNavi-1 > 0) {
                                            [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                        }
                                        else {
                                            [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                        }
                                    }
                                }
                            }
                            
                            /*
                            if (idxRight == idxSelectedRight) {
                                continue;
                            }
                            
                            if ([self.arrRightTimeLine count] > idxRight) {
                                idxSelectedRight = idxRight;
                                [self.tableRightTimeLine selectRowAtIndexPath:[NSIndexPath indexPathForRow:idxRight inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                            }
                             */
                        }
                    }
                }
                else if ([[arrVisibleCells objectAtIndex:i] isKindOfClass:[SCH_MAP_ONLY_TITLETypeCell class]]) {
                    SCH_MAP_ONLY_TITLETypeCell *cell = (SCH_MAP_ONLY_TITLETypeCell *)[arrVisibleCells objectAtIndex:i];
                    CGRect rectToCheck = [scrollView convertRect:cell.frame toView:scrollView.superview];
                    CGFloat heightTable = self.tableLeftProduct.frame.size.height ;//APPFULLHEIGHT - 20.0 - 44.0 - 44.0 - 50.0;
                    CGRect rectCenterLine = CGRectMake(scrollView.frame.origin.x, heightTable * 0.5, scrollView.frame.size.width, 1.0);
                    if (CGRectContainsRect(rectToCheck,rectCenterLine)) {
                        NSString *strKey = [NSString stringWithFormat:@"%@_%@",NCS([cell.dicAll objectForKey:@"broadStartDate"]),NCS([[cell.dicAll objectForKey:@"product"] objectForKey:@"prdId"])];
                        if ([strKey length] > 0 /*&& [NCS([self.dicRightAnchor objectForKey:strKey]) length] > 0*/) {
                            //NSInteger idxRight = [NCS([self.dicRightAnchor objectForKey:strKey]) integerValue];
                            if ([strKey length] >= 8) {
                                NSString *strIndexSub = [strKey substringWithRange:NSMakeRange(0, 8)];
                                NSInteger idxNavi = [NCS([self.dicNaviAnchor objectForKey:strIndexSub]) integerValue];
                                if (idxNavi != idxSelectedNavi) {
                                    idxSelectedNavi = idxNavi;
                                    [self.tableNavi selectRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                                    
                                    if ([self.arrDayNavi count] > idxSelectedNavi) {
                                        if (idxSelectedNavi-1 > 0) {
                                            [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                        }
                                        else {
                                            [self.tableNavi scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxSelectedNavi inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                        }
                                    }
                                }
                            }
                            /*
                            if (idxRight == idxSelectedRight) {
                                continue;
                            }
                            
                            if ([self.arrRightTimeLine count] > idxRight) {
                                idxSelectedRight = idxRight;
                                [self.tableRightTimeLine selectRowAtIndexPath:[NSIndexPath indexPathForRow:idxRight inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                            }
                             */
                        }
                    }
                }
            }//for 끝
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableLeftProduct) {
        //isMoveFromRightTimeLine = NO;
        [self.scrollExpandingDelegate scrollViewWillBeginDragging:scrollView];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableLeftProduct) {
        [self.delegatetarget customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate];
        [self.scrollExpandingDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableLeftProduct) {
        [self.delegatetarget customscrollViewDidEndDecelerating:(UIScrollView *)scrollView];
        [self.scrollExpandingDelegate scrollViewDidEndDecelerating:scrollView];
        //isMoveFromRightTimeLine = NO;
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (scrollView == self.tableLeftProduct) {
        [self.scrollExpandingDelegate scrollViewShouldScrollToTop:scrollView];
        return YES;
    }
    else {
        return NO;
    }
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (scrollView == self.tableLeftProduct) {
        [self.scrollExpandingDelegate scrollViewDidScrollToTop:scrollView];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

}


- (BOOL) parseInteger:(NSString *)value {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet]; //숫자가 아닌?
    if ([value rangeOfCharacterFromSet:notDigits].location == NSNotFound) { // 숫자가 아닌걸 못찾았다
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isLiveBrd {
    return ![self.strBrdType isEqualToString:@"DATA"];
}

- (NSDictionary *)loadTestApiUrl:(NSString *)strUrl {
    NSURL *turl = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    [urlRequest setHTTPMethod:@"GET"];
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:30 error:&error];
    return [result JSONtoValue];
}

-(CGFloat)heightCalculatorSCH_MAP_MUT_SUB:(NSDictionary *)dicRow{
    
    CGFloat heightReturn = 16.0;
    
    CGFloat widthLineCut = WIDTH_LIMIT_TV_SUB;
    CGFloat widthTotal = 0.0;
    CGFloat offsetXBasePrice = 0.0;
    CGSize sizeDiscountRate = CGSizeMake(0.0, 0.0);
    
    if ([NCS([dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"] && [NCS([dicRow objectForKey:@"priceMarkUp"]) length] > 0 ) {
        sizeDiscountRate = [[NSString stringWithFormat:@"%@%%",NCS([dicRow objectForKey:@"priceMarkUp"])] MochaSizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(APPFULLWIDTH, 14.5) lineBreakMode:NSLineBreakByClipping];
        offsetXBasePrice = 3.0;
    }else{
        offsetXBasePrice = 0.0;
    }
    
    CGSize sizeSalePrice = [NCS([dicRow objectForKey:@"broadPrice"]) MochaSizeWithFont:[UIFont boldSystemFontOfSize:19.0] constrainedToSize:CGSizeMake(APPFULLWIDTH, 23.0) lineBreakMode:NSLineBreakByClipping];
    
    CGSize sizeSalePriceWon = [NCS([dicRow objectForKey:@"exposePriceText"]) MochaSizeWithFont: [UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(APPFULLWIDTH, 17.0) lineBreakMode:NSLineBreakByClipping];
    
    CGSize sizeBasePrice = [NCS([dicRow objectForKey:@"salePrice"]) MochaSizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(APPFULLWIDTH, 16.0) lineBreakMode:NSLineBreakByClipping];
    
    CGSize sizeBasePriceWon = [@"원" MochaSizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(APPFULLWIDTH, 16.0) lineBreakMode:NSLineBreakByClipping];
    
    widthTotal = sizeSalePrice.width + sizeSalePriceWon.width + 3.0 + sizeDiscountRate.width + offsetXBasePrice + sizeBasePrice.width + sizeBasePriceWon.width;
    
//    NSLog(@"widthTotal = %f",widthTotal);
//    NSLog(@"widthLineCut = %f",widthLineCut);
    
    /// 최상단 16 + 가격 영역 + 타이틀 전까지 높이
    if (widthLineCut < widthTotal) {
        heightReturn = heightReturn + 23.0 + 14.5 + 4.0;
    }else{
        heightReturn = heightReturn + 23.0 + 4.0;
    }
    
//    NSLog(@"최상단 16 + 가격 영역 + 타이틀 전까지 높이");
//    NSLog(@"heightReturnheightReturn = %f",heightReturn);
    
    NSAttributedString *strTitle = [Common_Util attributedProductTitle:dicRow titleKey:@"exposPrdName"];
    
    CGRect rectTitle = [strTitle boundingRectWithSize:CGSizeMake(APPFULLWIDTH, 500.0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (rectTitle.size.width > widthLineCut) {
        heightReturn = heightReturn + 40.5;
    }else{
        heightReturn = heightReturn + 21.5;
    }
    
    heightReturn = heightReturn + 8.0;
    
//    NSLog(@"heightReturnheightReturn = %f",heightReturn);
    
    NSAttributedString *strBenefit = [Common_Util attributedBenefitString:dicRow widthLimit:WIDTH_LIMIT_TV_SUB lineLimit:2];
    CGRect rectBene = [strBenefit boundingRectWithSize:CGSizeMake(WIDTH_LIMIT_TV_SUB, 500.0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    NSLog(@"rectBenerectBene = %@",NSStringFromCGRect(rectBene));
    
    if (strBenefit.length > 0) {
        heightReturn = heightReturn + rectBene.size.height;
        //heightReturn = heightReturn + 12.0;
        heightReturn = heightReturn + 8.0;
    }
    
//    NSLog(@"heightReturnheightReturn = %f",heightReturn);
    
    NSAttributedString *strReview = [Common_Util attributedReview:dicRow isWidth320Cut:NO];
    
    if (strReview.length > 0) {
        CGRect rectReview = [strReview boundingRectWithSize:CGSizeMake(WIDTH_LIMIT_TV_SUB, 500.0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        heightReturn = heightReturn + rectReview.size.height;
        heightReturn = heightReturn + 16.0;
    }else{
        
        if (strBenefit.length > 0) {
            heightReturn = heightReturn + 8.0;
        }
    }
    
//    NSLog(@"heightReturnheightReturn = %f",heightReturn);
    
    
    
    if (heightReturn < 160) {
        heightReturn = 160.0;
    }
    
//    NSLog(@"heightReturnheightReturn = %f",heightReturn);
    
    return heightReturn;
    
}

@end
