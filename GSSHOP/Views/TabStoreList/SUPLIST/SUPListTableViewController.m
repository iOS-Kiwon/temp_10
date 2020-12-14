//
//  SUPListTableViewController.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SUPListTableViewController.h"
#import "Home_Main_ViewController.h"
#import "SectionTBViewController.h"
#import "SectionTBViewFooter.h"
#import "AutoLoginViewController.h"
#import "Common_Util.h"

#define MAP_CX_GBB_VISIBLE_COUNT 20

@interface SUPListTableViewController ()
@property (nonatomic, strong) SectionSUP_ViewCateFreezePans *viewCateFreezePans;
@property (nonatomic, assign) BOOL isFreezePanes;       //틀고정이 실제 액셀의 영어버전에서는 freeze panes 이랍니다.
@property (nonatomic, assign) CGRect rectFreezePanes;
@property (nonatomic, strong) NSMutableArray *arrFreezePans; // 데이터
@property (nonatomic, strong) NSMutableArray *arrFreezePansIndex; //인덱스
@property (nonatomic, strong) NSMutableArray *arrFreezePansRect; //프레임
@property (nonatomic, assign) CGPoint lastOffset;


@end

@implementation SUPListTableViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sectionarrdata = [[NSMutableArray alloc] init];
        self.arrFreezePansIndex = [[NSMutableArray alloc] init];
        self.arrFreezePans = [[NSMutableArray alloc] init];
        self.arrFreezePansRect = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewRegisterNib];
    self.tableView.backgroundColor = [UIColor getColor:@"EEEEEE" alpha:1 defaultColor:UIColor.grayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setResultDic:(NSDictionary *)resultDic{
    if (NCO(resultDic) == YES) {
        self.dicResult = resultDic;
        [self.sectionarrdata removeAllObjects];
        [self.arrFreezePansIndex removeAllObjects];
        [self.arrFreezePans removeAllObjects];
        [self.arrFreezePansRect removeAllObjects];
        [self.viewCateFreezePans removeFromSuperview];
        self.viewCateFreezePans = nil;
        self.isFreezePanes = NO;
    }
    else {
        [self.sectionarrdata removeAllObjects];
        self.dicResult = nil;
        [self tableFooterDraw];
        [self.tableView reloadData];
        return;
    }
    
    if (NCA([self.dicResult objectForKey:@"productList"])) {
        NSArray *arrFetch = [self.dicResult objectForKey:@"productList"];
        NSInteger i = 0;

        for(NSDictionary *dicRow in arrFetch) {
            i = i+1;
            if ([[dicRow objectForKey:@"viewType"] isEqualToString:@"TOOLTIP_GSF_GBA"]) {
                if ([self isShowToast] == YES) {
                    [self showToast:dicRow];
                }
            }
            else if ([[dicRow objectForKey:@"viewType"] isEqualToString:@"MAP_CX_GBB"]) {
                
                NSArray *arrSubContent = [dicRow objectForKey:@"subContentChild"];
                if(NCA(arrSubContent)){
                    
                    self.isFreezePanes = YES;
                    
                    NSMutableDictionary *dicCate = [[NSMutableDictionary alloc] initWithDictionary:dicRow];
                    [dicCate setObject:@"MAP_CX_GBB_CATE" forKey:@"viewType"];
                    
                    for (NSInteger as = 0 ; as <[arrSubContent count]; as++) {
                        if ([NCS([dicRow objectForKey:@"dealNo"]) isEqualToString:NCS([[arrSubContent objectAtIndex:as] objectForKey:@"dealNo"])]) {
                            [dicCate setObject:[NSString stringWithFormat:@"%ld",(long)as] forKey:@"index"];
                            if (self.viewCateFreezePans == nil) {
                                [self.arrFreezePans removeAllObjects];
                                [self.arrFreezePans addObjectsFromArray:arrSubContent];
                                [self initViewCateFreezePans:as];
                            }
                            break;
                        }
                    }
                    [self.arrFreezePansIndex addObject:[NSNumber numberWithInteger:[self.sectionarrdata count]]];
                    [self.sectionarrdata addObject:dicCate];
                }
                
                //타이틀 영역
                NSMutableDictionary *dicTitle = [[NSMutableDictionary alloc] initWithDictionary:dicRow];
                [dicTitle setObject:@"MAP_CX_GBB_TITLE" forKey:@"viewType"];
                [self.sectionarrdata addObject:dicTitle];
                
                NSArray *arrSubPrdALL = [dicRow objectForKey:@"subProductList"];
                
                if (NCA(arrSubPrdALL)) { //상품이 존재 할때만 노출
                    //상품 영역
                    NSMutableDictionary *dicSub = [[NSMutableDictionary alloc] initWithDictionary:dicRow];
                    [dicSub setObject:@"MAP_CX_GBB_PRD" forKey:@"viewType"];
                    NSMutableArray *arrSub = [[NSMutableArray alloc] init];
                    NSInteger cntSubViews = 0;
                    
                    for (NSInteger p=0; p<[arrSubPrdALL count]; p++) {
                        
                        [arrSub addObject:[arrSubPrdALL objectAtIndex:p]];
                        
                        if (((p+1)%2 == 0) || p+1 == [arrSubPrdALL count] ) {
                            if (p+1 <= MAP_CX_GBB_VISIBLE_COUNT) {
                                [dicSub setObject:@"Y" forKey:@"isVisible"];
                            }
                            else {
                                [dicSub setObject:@"N" forKey:@"isVisible"];
                            }
                            [dicSub setObject:[arrSub copy] forKey:@"subProductList"];
                            [self.sectionarrdata addObject:[dicSub copy]];
                            [arrSub removeAllObjects];
                            cntSubViews ++;
                        }
                    }
                    
                    //상품 더보기 ,매장 바로가기 영역
                    NSMutableDictionary *dicMore = [[NSMutableDictionary alloc] initWithDictionary:dicRow];
                    [dicMore setObject:@"MAP_CX_GBB_MORE" forKey:@"viewType"];
                    [dicMore removeObjectForKey:@"subProductList"];
//                    if ([arrSubPrdALL count] > MAP_CX_GBB_VISIBLE_COUNT) {
//                        [dicMore setObject:@"Y" forKey:@"isMore"];
//                        [dicMore setObject:[NSString stringWithFormat:@"%ld",(long)cntSubViews] forKey:@"subPrdCount"];
//                        [dicMore setObject:@"N" forKey:@"noShow"];
//                    }
//                    else {
//                        [dicMore setObject:@"N" forKey:@"isMore"];
//                        [dicMore setObject:@"Y" forKey:@"noShow"];
//                    }
                    //링크가 있고 20개 이상인 경우
                    if( [NCS([dicRow objectForKey:@"linkUrl"]) length] > 0 && [arrSubPrdALL count] >= 1) {
                        [dicMore setObject:@"N" forKey:@"isMore"];
                        [dicMore setObject:@"N" forKey:@"noShow"];
                    }
                    else {
                        [dicMore setObject:@"N" forKey:@"isMore"];
                        [dicMore setObject:@"Y" forKey:@"isMore"];
                    }
                    [self.sectionarrdata addObject:dicMore];
                
                }else{//subProductList 가 0 일경우
                    
                    //NODATA 영역
                    NSMutableDictionary *dicNoData = [[NSMutableDictionary alloc] initWithDictionary:dicRow];
                    [dicNoData setObject:@"NO_DATA" forKey:@"viewType"];
                    [self.sectionarrdata addObject:dicNoData];
                    
                }
            }
            else {
                [self.sectionarrdata addObject:dicRow];                
            }
            
            
        }
        
        
        [self tableFooterDraw];
        [self.tableView reloadData];
        
        if (self.isFreezePanes) {
            [self storeFreezePansRect];
        }
        
    }
    //NSLog(@"self.sectionarrdata =%@",self.sectionarrdata);
}

-(void)initViewCateFreezePans:(NSInteger)index{
    
    if (self.viewCateFreezePans == nil) {
        self.viewCateFreezePans = [[[NSBundle mainBundle] loadNibNamed:@"SectionSUP_ViewCateFreezePans" owner:self options:nil] firstObject];
        self.viewCateFreezePans.aTarget = self;
    }

    [self.viewCateFreezePans setCellInfoNDrawData:self.arrFreezePans andIndex:index];
    
}


-(void)storeFreezePansRect{
    
    [self.arrFreezePansRect removeAllObjects];
    
    for (NSInteger i=0; i<[self.arrFreezePansIndex count]; i++) {
        CGRect rectCate = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue] inSection:0]];

        if (CGRectEqualToRect(self.rectFreezePanes, CGRectZero)) {
            self.rectFreezePanes = rectCate;
        }
        [self.arrFreezePansRect addObject:[NSValue valueWithCGRect:rectCate]];
    }
    
}


- (void)reloadAction {
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0f];
}

- (void)refresh {
    [self.delegatetarget tablereloadAction];
}

- (BOOL)isShowToast {
    NSDate * today = [NSDate date];
    NSDate * dayBefore = (NSDate *)(LL(GS_SUPER_TOAST));
    NSLog(@"todaytoday = %@",today);
    NSLog(@"dayBefore30 = %@",dayBefore);
    if (dayBefore == nil) {
        return YES;
    }
    else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        if ([[dateFormat stringFromDate:today] isEqualToString:[dateFormat stringFromDate:dayBefore]]) {
            return NO;
        }
        else {
            return YES;
        }
    }
}

- (void)showToast:(NSDictionary *)dicRow {
    
    SUPToastView *toast = [[[NSBundle mainBundle] loadNibNamed:@"SUPToastView" owner:self options:nil] firstObject];
    toast.aTarget = self;
    [toast setToastInfo:dicRow];
    toast.frame = CGRectMake(0.0, self.view.frame.size.height - 45.0 - 10.0, APPFULLWIDTH, 45.0);
    
    if ([self.delegatetarget isKindOfClass:[UIView class]]) {
        UIView *viewDT = (UIView *)self.delegatetarget;
        [viewDT addSubview:toast];
        toast.alpha = 0.0;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             toast.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

///테이블뷰가 나타날때 호출됩니다.
- (void)checkTableViewAppear {
    NSLog(@"#checkTableViewAppear")
    if (ApplicationDelegate.isShowGsFreshTopView == YES) {
        return;
    }
    
    NSArray *arrVisibleCells = [self.tableView visibleCells];
    for (id cell in arrVisibleCells) {
        if ([cell isKindOfClass: SectionBAN_IMG_GSF_GBAtypeCell.class] ) {
            SectionBAN_IMG_GSF_GBAtypeCell *gbaCell = (SectionBAN_IMG_GSF_GBAtypeCell *)cell;
            if ([gbaCell.viewType isEqualToString:@"BAN_IMG_GSF_GBB"] || [gbaCell.viewType isEqualToString:@"BAN_IMG_GSF_GBE"]) {
                [gbaCell showTopView]; // 툴팁뷰를 보이기 함수 호출.
            }
        }
    }
}


- (void)callLogin:(NSString*)linkstr {
    NSLog(@"linkstrlinkstrlinkstr %@",linkstr);
    URLParser *parser = [[URLParser alloc] initWithURLString:linkstr];
    self.curRequestString = [NCS([parser valueForVariable:@"openUrl"]) urlDecodedString];
     AutoLoginViewController  *loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
    loginView.delegate = self;
    loginView.loginViewType = 4;
    loginView.view.hidden=NO;
    loginView.btn_naviBack.hidden = NO;
    loginView.deletargetURLstr = linkstr;
    [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:loginView];
}

- (void) hideLoginViewController:(NSInteger)loginviewtype {
    //로그인 성공시 무브무브
    [self performSelector:@selector(delayGoWebviewWithcurRequestString) withObject:nil afterDelay:1.0f];
}

- (NSString*) definecurrentUrlString {
    return self.curRequestString;
}

- (void)delayGoWebviewWithcurRequestString {
    [self onBtnSUPCellJustLinkStr:self.curRequestString];
}

- (void)onBtnSUPCellJustLinkStr:(NSString*)linkstr {
    if ([self.delegatetarget respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [self.delegatetarget touchEventTBCellJustLinkStr:linkstr];
    }
}


- (void)onBtnSLD_GBD_ShowAll:(NSMutableArray *)arrAll {
    if (NCA(arrAll)) {
        SUPBannerModal *viewSUPModal = [[[NSBundle mainBundle] loadNibNamed:@"SUPBannerModal" owner:self options:nil] firstObject];
        viewSUPModal.aTarget = self;
        viewSUPModal.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH,APPFULLHEIGHT);
        [viewSUPModal setData:arrAll];
        viewSUPModal.alpha = 0.0;
        [ApplicationDelegate.window addSubview:viewSUPModal];
        [UIView animateWithDuration:0.1 animations:^{
            viewSUPModal.alpha = 1.0;
        }];
    }
}

-(void)dealloc{
    NSLog(@"!!deallocdealloc!!!")
}

- (void)checkDeallocSUP{
    self.tableView = nil;
    [self checkDealloc];
    
}

- (void)addCartProcess:(NSDictionary *)dicSeleted {
    if (ApplicationDelegate.islogin == NO) {
        self.curRequestString = nil;
        AutoLoginViewController  *loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
        loginView.delegate = self;
        loginView.loginViewType = 4;
        loginView.view.hidden=NO;
        loginView.btn_naviBack.hidden = NO;
        if (self.delegatetarget != nil && [self.delegatetarget isKindOfClass:[SectionView class]]) {
            SectionView *SVTarget = (SectionView *)self.delegatetarget;
            NSString *retUrl = [NSString stringWithFormat:@"%@/index.gs?tabId=%@",SERVERURI,[SVTarget.m_iNavigationID stringValue]];
            loginView.deletargetURLstr = NCS(retUrl);
        }
        [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:loginView];
        return;
    }
    
    if (NCO([dicSeleted objectForKey:@"basket"]) && [[dicSeleted objectForKey:@"basket"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicPostInfo = [dicSeleted objectForKey:@"basket"];
        NSURL *url = [NSURL URLWithString:NCS([dicPostInfo objectForKey:@"url"])];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        [urlRequest setHTTPMethod:NCS([dicPostInfo objectForKey:@"format"])];
        [urlRequest setValue:URLENCODEDFORMHEAD forHTTPHeaderField:@"Content-Type"];
        NSArray *arrParams = [dicPostInfo objectForKey:@"params"];
        NSMutableString *strPost = [[NSMutableString alloc] init];
        for(NSDictionary *dicRow in arrParams) {
            NSString *strAppend = [NSString stringWithFormat:@"%@=%@",NCS([dicRow objectForKey:@"name"]),NCS([dicRow objectForKey:@"value"])];
            [strPost appendString:strAppend];
            if(![[arrParams lastObject] isEqual:dicRow]) { // 마지막은 제외
                [strPost appendString:@"&"];
            }
        }

        NSLog(@"strAppend = %@",strPost);
        NSData *postData = [strPost dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%ld",(long)[postData length]];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setHTTPBody: postData];
        NSLog(@"urlRequesturlRequest = %@",urlRequest);
        
        // Submit & retrieve results
//        NSError *error;
//        NSURLResponse *response;
        NSLog(@"Contacting Server....");
        //NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        
        [ApplicationDelegate onloadingindicator];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:urlRequest
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"resultString = %@",strResult);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [ApplicationDelegate offloadingindicator];
                        });
                        
                        if (data != nil) {
                            NSLog(@"responseresponse = %@",response);
                            NSDictionary *resultj = [strResult JSONtoValue];
                            NSLog(@"resultjresultjresultj = %@",resultj)
                            if (resultj != nil) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if ([NCS([resultj objectForKey:@"retCd"]) isEqualToString:@"S"] || [NCS([resultj objectForKey:@"retCd"]) isEqualToString:@"EXP"]) {
                                        if ([NCS([resultj objectForKey:@"retCd"]) isEqualToString:@"S"] == YES) {
                                            self.imgCartPopup.highlighted = NO;
                                            [ApplicationDelegate.HMV DrawCartCountstr];
                                        }
                                        else {
                                            self.imgCartPopup.highlighted = YES;
                                        }
                                        
                                        if ([self.delegatetarget isKindOfClass:[UIView class]]) {
                                            UIView *viewDT = (UIView *)self.delegatetarget;
                                            
                                            NSLog(@"viewDT = %@",viewDT);
                                            NSLog(@"self.viewCartPopup = %@",self.viewCartPopup);
                                            
                                           
                                            if ([self.timerCart isValid]) {
                                                [self.timerCart invalidate];
                                            }
                                            
                                            self.viewCartPopup.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
                                            
                                            self.viewCartPopup.center = viewDT.center;
                                            
                                            [viewDT addSubview:self.viewCartPopup];
                                            self.viewCartPopup.alpha = 0.0;
                                            [UIView animateWithDuration:0.3
                                                                  delay:0
                                                                options:UIViewAnimationOptionBeginFromCurrentState
                                                             animations:(void (^)(void)) ^{
                                                                 self.viewCartPopup.alpha = 1.0;
                                                             }
                                                             completion:^(BOOL finished){
                                                                 self.timerCart = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(viewCartRemove) userInfo:nil repeats:NO];
                                                             }];
                                            
                                        }
                                        
                                        
                                    }else if([NCS([resultj objectForKey:@"retCd"]) isEqualToString:@"NRD"]){
                                        
                                        self.curRequestString = NCS([resultj objectForKey:@"retUrl"]);
                                        
                                        //retUrl 취소 확인
                                        if(self.curRequestString.length > 0) {
                                            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:NCS([resultj objectForKey:@"retMsg"]) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                            malert.tag = 55;
                                            [ApplicationDelegate.window addSubview:malert];
                                        }
                                        else { //없으면 닫기
                                            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:NCS([resultj objectForKey:@"retMsg"]) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                            [ApplicationDelegate.window addSubview:malert];
                                        }
                                        
                                    }
                                    else {
                                        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:NCS([resultj objectForKey:@"retMsg"]) maintitle:nil delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                        [ApplicationDelegate.window addSubview:malert];
                                    }
                                });
                            }
                        }
                    }] resume];
    }
}

#pragma mark 새벽배송 상단 안내뷰 관련
/// 새벽배송 상단 안내뷰 3초후 닫히도록 하는 함수.
- (void)showTooltip:(SectionBAN_IMG_GSF_GBAtypeCell *)cell {
    if([cell.viewType isEqualToString:@"BAN_IMG_GSF_GBB"] || [cell.viewType isEqualToString:@"BAN_IMG_GSF_GBE"]) {
        ApplicationDelegate.isActivateGsFreshTopView = YES;
        cell.topTooltipView.hidden = NO;
        [self.tableView beginUpdates];
        cell.topTooltipViewHight.constant = 46.0;
        [UIView animateWithDuration:0.3 animations:^{
            [cell.contentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.tableView endUpdates];
            
            [self performSelector:@selector(hideTooltip:) withObject:cell afterDelay:3.0];
        }];
    }
}

- (void) hideTooltip:(SectionBAN_IMG_GSF_GBAtypeCell *)cell  {
    if (ApplicationDelegate.isShowGsFreshTopView) {
        return;
    }
    ApplicationDelegate.isShowGsFreshTopView = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    // kiwon : 아래 주석을 풀면, 매장 들어올때마다 새벽배송 툴팁이 나타남
//    ApplicationDelegate.isShowGsFreshTopView = NO;
//    ApplicationDelegate.isActivateGsFreshTopView = NO;
}

#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 55) {
        //장바구니 클릭시 배송지가 미 선택된 경우 배송지 선택창으로 보냄
        if( index == 1) {
            NSString *strDeleInfo = [self.curRequestString copy];
            self.curRequestString = nil;
            [self onBtnSUPCellJustLinkStr:strDeleInfo];
        }
        else {
            self.curRequestString = nil;
        }
    }
    else if(alert.tag == 990) { //검색어 미입력 알럿창
        //키보드 포커싱 재적용
        if(searchCell) {
            [searchCell.searchText becomeFirstResponder];
        }
    }
}


- (IBAction)onBtnCartPopup:(id)sender{
    
    [self viewCartRemove];
    
    if ([((UIButton *)sender) tag] == 66) {
        //효율코드 A00481-GC-1
        //[ApplicationDelegate wiseAPPLogRequest:WISELOGCOMMONURL(@"?mseq=A00481-GC-1")];
        [self onBtnSUPCellJustLinkStr:SMARTCART_GSFRESH_URL];
    }
}

-(void)viewCartRemove{
    if ([self.timerCart isValid]) {
        [self.timerCart invalidate];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.viewCartPopup.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.viewCartPopup removeFromSuperview];
                     }];

}


-(void)onBtnCateFreezePans:(NSInteger)idxSelected{
    NSLog(@"onBtnCateFreezePansonBtnCateFreezePans");
    if ([self.arrFreezePansIndex count] > idxSelected  ) {
        self.isFreezePanes = NO;
        
        
        NSInteger idxRow = -1;
        for (NSInteger i=0; i<[self.arrFreezePansIndex count]; i++) {
            NSInteger idxCheck = [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue];
            NSDictionary *dicRow = [self.sectionarrdata objectAtIndex:idxCheck];
            if ([NCS([dicRow objectForKey:@"index"]) integerValue] == idxSelected) {
                idxRow = [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue];
                break;
            }
        }
        if (idxRow >=0) {
            //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idxRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            CGRect rectToScroll = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:idxRow inSection:0]];
            [self.tableView setContentOffset:CGPointMake(0.0, rectToScroll.origin.y + 1.0) animated:NO];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkFreezePanesYES) userInfo:nil repeats:NO];
    }
}

- (void)checkFreezePanesYES{
    self.isFreezePanes = YES;
    [self checkFreezePanes];
}

// 틀고정 메뉴 노출 확인
- (void)checkFreezePanes {
    if (self.isFreezePanes) {
        CGFloat tableY = self.tableView.contentOffset.y;
        NSLog(@"tableYtableY = %f",tableY);
        for (NSInteger i=0; i<[self.arrFreezePansRect count]; i++) {
            CGRect rectPans = [[self.arrFreezePansRect objectAtIndex:i] CGRectValue];
            
            NSLog(@"NSStringFromCGRect(rectPans) = %@",NSStringFromCGRect(rectPans));

            
            if (tableY == rectPans.origin.y) {
                NSInteger idxRow = [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue];
                NSInteger cateIndex = [[[self.sectionarrdata objectAtIndex:idxRow] objectForKey:@"index"] integerValue];
                [self initViewCateFreezePans:cateIndex];
                if (self.viewCateFreezePans.frame.origin.y !=0) {
                    self.viewCateFreezePans.frame = CGRectMake(0.0, 0.0, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                }
                self.rectFreezePanes = [[self.arrFreezePansRect objectAtIndex:i] CGRectValue];
                SectionView *viewToadd = (SectionView *)self.delegatetarget;
                [viewToadd addSubview:self.viewCateFreezePans];
                break;
                
            }else if (tableY < rectPans.origin.y) {
                if (i==0) {
                    break;
                }
                
                if (self.viewCateFreezePans.idxSelected == i-1) {
                    //같음으로 패스
                    NSLog(@"//같음으로 패스");
                }else{
                    NSInteger idxRow = [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:(i-1)] integerValue];
                    NSInteger cateIndex = [[[self.sectionarrdata objectAtIndex:idxRow] objectForKey:@"index"] integerValue];
                    [self initViewCateFreezePans:cateIndex];

                    if (self.viewCateFreezePans.frame.origin.y !=0) {
                        self.viewCateFreezePans.frame = CGRectMake(0.0, 0.0, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                    }
                    SectionView *viewToadd = (SectionView *)self.delegatetarget;
                    [viewToadd addSubview:self.viewCateFreezePans];
                }
                break;
            }
        }
        CGRect rectLast = [[self.arrFreezePansRect lastObject] CGRectValue];
        if (tableY >= rectLast.origin.y) {
            
            NSInteger idxRow = [(NSNumber *)[self.arrFreezePansIndex lastObject] integerValue];
            NSInteger cateIndex = [[[self.sectionarrdata objectAtIndex:idxRow] objectForKey:@"index"] integerValue];
            [self initViewCateFreezePans:cateIndex];
            
            if (self.viewCateFreezePans.frame.origin.y !=0) {
                self.viewCateFreezePans.frame = CGRectMake(0.0, 0.0, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
            }
            SectionView *viewToadd = (SectionView *)self.delegatetarget;
            [viewToadd addSubview:self.viewCateFreezePans];
            
        }
    }
}

- (void)changeMartDeliveryWithStrUrl:(NSString *)strUrl {
    NSString *apiURL = strUrl;
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
    
    NSLog(@"!!!!apiURLapiURLapiURL = %@",apiURL);
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              dispatch_async( dispatch_get_main_queue(),^{
                                                                                  [ApplicationDelegate offloadingindicator];
                                                                                  if (result != nil) {
                                                                                      [self setResultDic:result];
                                                                                      //쿠키동기화 로직추가
                                                                                      [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
                                                                                  }else{
                                                                                      Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"error_server") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                                                      [ApplicationDelegate.window addSubview:lalert];
                                                                                  }
                                                                                  
                                                                              }
                                                                                             );
                                                                          }
                                                                               onError:^(NSError *error) {
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                               }];
}



#pragma mark - Table view data source

//PMO + B_IM, B_IL 이미지 베너인지 판단.
- (BOOL)isPMOIMG:(NSString *) veiwType {
    return ([veiwType isEqualToString:@"PMO_T1_IMG"] || [veiwType isEqualToString:@"PMO_T2_IMG"] || [veiwType isEqualToString:@"PMO_T3_IMG"] || [veiwType isEqualToString:@"B_IM"] || [veiwType isEqualToString:@"B_IL"]);
}

-(void)tableViewRegisterNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_GSF_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_GSF_GBATypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_GSF_LOC_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_GSF_LOC_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_SLD_GBDtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_SLD_GBDTypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_C8_SLD_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_C8_SLD_GBATypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_H000_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_H000_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBB_TITLEtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBB_TITLETypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBB_PRDtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBB_PRDTypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBB_MOREtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBB_MORETypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_GBB_CATEtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_GBB_CATETypeIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SCH_BAN_NO_DATATypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SCH_BAN_NO_DATATypeIdentifier];
    
    // kiwon : PRD_2Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_2Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_2Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionarrdata count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionarrdata.count < 1 || self.sectionarrdata.count < indexPath.row ) {
        return [[UITableViewCell alloc] init];
    }
    
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    
    if([viewType  isEqualToString:@"BAN_IMG_GSF_GBA"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBC"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBD"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBE"]) {
        SectionBAN_IMG_GSF_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_GSF_GBATypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
        
    }else if([viewType  isEqualToString:@"BAN_GSF_LOC_GBA"]) {
        SectionBAN_GSF_LOC_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_GSF_LOC_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }else if([viewType  isEqualToString:@"BAN_SLD_GBD"]) {
        SectionBAN_SLD_GBDtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_SLD_GBDTypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
        
    }
    else if([viewType  isEqualToString:@"MAP_C8_SLD_GBA"]) {
        if(searchCell != nil) {
            [searchCell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
            searchCell.myIndex = indexPath;
            return searchCell;
        }
        //한개만 존재..
        searchCell = [tableView dequeueReusableCellWithIdentifier:MAP_C8_SLD_GBATypeIdentifier];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        searchCell.target = self;
        searchCell.myIndex = indexPath;
        searchCell.searchText.delegate = self;
        [searchCell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return searchCell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType]) {
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
    else if( [viewType isEqualToString:@"MAP_CX_GBB_TITLE"] ) {
        SectionMAP_CX_GBB_TITLEtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_GBB_TITLETypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }else if( [viewType isEqualToString:@"MAP_CX_GBB_PRD"] ) {
        PRD_2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_2Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        cell.hidden = NO;
        [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        if ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"isVisible"] isEqualToString:@"Y"]) {
            cell.hidden = NO;
            [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        }else{
            return [[UITableViewCell alloc] initWithFrame: CGRectZero];
        }
        return cell;
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBB_MORE"] ) {
        SectionMAP_CX_GBB_MOREtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_GBB_MORETypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    } else if( [viewType isEqualToString:@"MAP_CX_GBB_CATE"] ) {
        SectionMAP_CX_GBB_CATEtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_GBB_CATETypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.path = indexPath;
        NSInteger idx = [[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"index"] integerValue];
        [cell setCellInfoNDrawData:self.arrFreezePans andIndex:idx andTarget:self];

        
        return cell;
        
    }else if([viewType isEqualToString:@"NO_DATA"]) {

        SCH_BAN_NO_DATATypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SCH_BAN_NO_DATATypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawDatafromFresh];
        return cell;
        
    } else {
        NSLog(@"ViewType doesn't drawed: %@", viewType);
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SUPERListCell"];
        cell.frame = CGRectZero;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionarrdata.count < 1 || self.sectionarrdata.count < indexPath.row ) {
        return 0;
    }
    
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    
    if([viewType  isEqualToString:@"BAN_IMG_GSF_GBA"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBC"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBD"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBE"]) {
        
        if([viewType isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType isEqualToString:@"BAN_IMG_GSF_GBE"]) {
            if (ApplicationDelegate.isShowGsFreshTopView == NO &&
                ApplicationDelegate.isActivateGsFreshTopView == YES) {
                return 81.0;
            }
        }
        return 35.0;
    }else if([viewType  isEqualToString:@"BAN_GSF_LOC_GBA"]) {
        return 45.0;
    }else if([viewType  isEqualToString:@"BAN_SLD_GBD"]) {
         return ceil((187.0/375.0) * APPFULLWIDTH);// + 10.0; //20190312 parksegun 하단여백 제거
    }else if([viewType  isEqualToString:@"MAP_C8_SLD_GBA"]) {
         return MAP_C8_SLD_GBA_SUB_CELL_HEIGHT + 15 + 55 + kTVCBOTTOMMARGIN + 1.0; //콜렉션 뷰의경우 조금더 커야해서 +1 해줌
    }else if([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [viewType isEqualToString:@"BAN_IMG_H000_GBB"] || [self isPMOIMG:viewType]) {
        //높이값을 받아온다.// 가변형 이미지 베너
        float bannerHeigth = 0;
        NSDictionary *item = [self.sectionarrdata objectAtIndex:indexPath.row];
        //계산된 CALCCELLHEIGHT 가 있으면 이 값을 사용한다.
        if(NCO([item objectForKey:CALCCELLHEIGHT]) && ![NCS([item objectForKey:CALCCELLHEIGHT]) isEqualToString:@""]) {
            return  [[item objectForKey:CALCCELLHEIGHT] floatValue] + ([viewType isEqualToString:@"BAN_IMG_H000_GBA"] ? kTVCBOTTOMMARGIN : 0);
        }
        else {
            if(NCO([item objectForKey:@"height"]) && ![NCS([item objectForKey:@"height"]) isEqualToString:@""]) {
                bannerHeigth = [[item objectForKey:@"height"] floatValue] / 2;
            }
            else {
                bannerHeigth = [Common_Util DPRateOriginVAL:160]; //20190423 parksegun QA요청으로 이미지가 없을경우 기본 높이 노출 - Android기본 너비 160에 비례
            }
            return  [Common_Util DPRateOriginVAL:bannerHeigth] + kTVCBOTTOMMARGIN;
        }
    }else if( [viewType isEqualToString:@"MAP_CX_GBB_TITLE"] ) {
        return 56;
    }else if( [viewType isEqualToString:@"MAP_CX_GBB_PRD"] ) {
        NSDictionary *dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        //if ([[dic objectForKey:@"isVisible"] isEqualToString:@"Y"]) {
        // 이미지 높이(전체 넓이 - 양쪽 side 32 - 중앙 margin 11)/2 + 기본 높이 159 + 하단 여백 1
        CGFloat imgHeight = (APPFULLWIDTH - (16 * 2) - 11) / 2;
        CGFloat height = imgHeight + 159 +  1;
        // 혜택 유무 판단
        //NSDictionary *dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        CGFloat benefitHeight = [[Common_Util attributedBenefitString:dic widthLimit:imgHeight lineLimit:2] size].height;
        if (benefitHeight < 0.0) {
            // 혜택뷰 하단 여백만큼 빼준다.
            height -= 9;
        }
        return height + benefitHeight;
//        }else{
//            return CGFLOAT_MIN;
//        }
        
    }
    else if( [viewType isEqualToString:@"MAP_CX_GBB_MORE"] ) {

        if ([[[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"noShow"] isEqualToString:@"Y"]) {
            return 10.0;
        }else{
            return 49 + 10.0;
        }
    } else if( [viewType isEqualToString:@"MAP_CX_GBB_CATE"] ) {
        return 46.0;
        
    }else if( [viewType  isEqualToString:@"NO_DATA"]) {
            return 150.0;
    } else {
        return 0;
    }
    
    return CGFLOAT_MIN;
}

- (void)touchSubProductShowMoreIndexPath:(NSIndexPath*)idxPath {
    NSMutableArray *arrIndexPaths = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicMore = [[NSMutableDictionary alloc] init];
    [dicMore addEntriesFromDictionary:[self.sectionarrdata objectAtIndex:idxPath.row]];
    
    
    if ([NCS([dicMore objectForKey:@"subPrdCount"]) length] > 0) {
        NSInteger cntSub = [[dicMore objectForKey:@"subPrdCount"] integerValue];
        NSLog(@"cntSubcntSubcntSub %ld",(long)cntSub);
        for (NSInteger i = idxPath.row - 1 ; cntSub > 0; cntSub--,i--) {
            if (i < 0) {
                break;
            }
            
            NSMutableDictionary *dicSubMod = [[NSMutableDictionary alloc] init];
            [dicSubMod addEntriesFromDictionary:[[self.sectionarrdata objectAtIndex:i] copy]];

            if ([[dicSubMod objectForKey:@"viewType"] isEqualToString:@"MAP_CX_GBB_PRD"]
                && [[dicSubMod objectForKey:@"isVisible"] isEqualToString:@"N"]) {
                NSString *strYN = @"Y";
                [dicSubMod setObject:strYN forKey:@"isVisible"];
                [self.sectionarrdata replaceObjectAtIndex:i withObject:dicSubMod];
                [arrIndexPaths insertObject:[NSIndexPath indexPathForRow:i inSection:0] atIndex:0];
            }
        }
        
        NSString *strYN = @"N";
        [dicMore setObject:strYN forKey:@"isMore"];
        [self.sectionarrdata replaceObjectAtIndex:idxPath.row withObject:dicMore];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:idxPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self storeFreezePansRect];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionarrdata.count < indexPath.row ) {
        return ;
    }
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    
    if([viewType  isEqualToString:@"BAN_IMG_GSF_GBA"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBC"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBD"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBE"]) {
        
        if([viewType isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType isEqualToString:@"BAN_IMG_GSF_GBE"]) {
            // Cell이 나타나기 직전에, 현재 선택된(노출된) 매장이 GS Fresh일때만 동작하도록
            if([ApplicationDelegate.HMV isCurrentHomeMainTabMyList:HOMESECTSUPLIST]
               && ApplicationDelegate.isShowGsFreshTopView == NO) {
                SectionBAN_IMG_GSF_GBAtypeCell * gbaCell = (SectionBAN_IMG_GSF_GBAtypeCell *) cell;
                [gbaCell showTopView];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionarrdata.count < 1 || self.sectionarrdata.count < indexPath.row ) {
        return;
    }
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    
    if([viewType  isEqualToString:@"BAN_IMG_GSF_GBA"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType  isEqualToString:@"BAN_IMG_GSF_GBC"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBD"]  || [viewType  isEqualToString:@"BAN_IMG_GSF_GBE"]) {
        
        if([viewType isEqualToString:@"BAN_IMG_GSF_GBB"] || [viewType isEqualToString:@"BAN_IMG_GSF_GBE"]) {
            if (ApplicationDelegate.isShowGsFreshTopView == NO) {
                // 셀이 사라질때, DispatchQueue에 쌓인 동작 취소
                SectionBAN_IMG_GSF_GBAtypeCell * gbaCell = (SectionBAN_IMG_GSF_GBAtypeCell *) cell;
                [gbaCell cancelTaskToopTip];
            }
        }
    }
}

//해당 위치에 높이를 갱신한다.
- (void)tableCellReloadForHeight:(NSString*)h indexPath:(NSIndexPath*)indexPath {
    NSInteger position = indexPath.row;
    NSLog(@"calcCell: %@  ,%f --- %ld",h,[h floatValue], position);
    @synchronized(self.sectionarrdata) {
        if([self.sectionarrdata isKindOfClass:NSMutableArray.class] && [self.sectionarrdata count] > position) {
            NSMutableDictionary *mut = [[self.sectionarrdata objectAtIndex:position] mutableCopy];
            [mut setObject:h forKey:CALCCELLHEIGHT];
            [self.sectionarrdata removeObjectAtIndex:position];
            [self.sectionarrdata insertObject:mut atIndex:position];
            [self tableCellReload:position];
            [self storeFreezePansRect];
        }
    }
}

//20190308 parksegun GS fresh 검색 기능
#pragma mark -텍스트 필드 델리게이트 메서드

//20190308 parksegun GS fresh 검색 기능 텍스트 필드 델리게이트는 controller에서 받을수 있다. (cell은 안됨)
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(searchCell != nil && [textField isEqual:searchCell.searchText]) {//MAP_C8_SLD_GBA
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:searchCell.myIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(searchCell != nil && [textField isEqual:searchCell.searchText]) {//MAP_C8_SLD_GBA
        [self clearTextFiled];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(searchCell != nil && [textField isEqual:searchCell.searchText]) {//MAP_C8_SLD_GBA
        //string == @"" 이면 삭제중
        //range = 0
        if(range.location <= 0 && string.length <= 0) {
            //클리어 버튼을 날려야 하는데 어떻게 하지?
            searchCell.clsButton.hidden = YES;
        }
        else {
            searchCell.clsButton.hidden = NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(searchCell != nil && [textField isEqual:searchCell.searchText]) {//MAP_C8_SLD_GBA
        searchCell.clsButton.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self goSearch:textField];
}

- (BOOL) goSearch:(UITextField *)textField {
    if(searchCell != nil && [textField isEqual:searchCell.searchText]) {//MAP_C8_SLD_GBA
        //공백 체크
        NSString *spaceCheck = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(spaceCheck.length > 0) {
            //검색 출발
            //NSString *strLink = [NSString stringWithFormat:@"%@",GSSEARCHURL(@"" ,textField.text,@"") ];
            NSString *strLink = [NSString stringWithFormat:@"%@%@",searchCell.searchLink,[spaceCheck urlEncodedString]];
            if ([strLink length] > 0 && [strLink hasPrefix:@"http"]) {
                [self onBtnSUPCellJustLinkStr:strLink];
            }
            [self clearTextFiled];
            return NO;
        }
        else {
            [self clearTextFiled];
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"search_description_search_main") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            malert.tag = 990;
            [ApplicationDelegate.window addSubview:malert];
        }
    }
    return NO;
}

- (void)clearTextFiled {
    if(searchCell != nil) {//MAP_C8_SLD_GBA
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchCell.searchText resignFirstResponder];
        });
        searchCell.clsButton.hidden = YES;
        searchCell.searchText.text = @"";
    }
}



#pragma mark - Scroll View

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]){
        [self.scrollExpandingDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    if ([self.delegatetarget respondsToSelector:@selector(customscrollViewDidScroll:)]) {
        [self.delegatetarget customscrollViewDidScroll:(UIScrollView *)scrollView];
    }
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.scrollExpandingDelegate scrollViewDidScroll:scrollView];
    }
    
    if (self.isFreezePanes) {
        
        CGPoint currentOffset = scrollView.contentOffset;
        CGRect rectFirst = CGRectZero;
        if ([self.arrFreezePansRect count] > 0) {
            rectFirst = [[self.arrFreezePansRect objectAtIndex:0] CGRectValue];
        }
        
        NSArray *arrVisibleCells = [self.tableView visibleCells];
        SectionMAP_CX_GBB_CATEtypeCell *cellCheck = nil;
        for (id tCell in arrVisibleCells) {
            if ([tCell isKindOfClass:[SectionMAP_CX_GBB_CATEtypeCell class]]) {
                cellCheck = (SectionMAP_CX_GBB_CATEtypeCell *)tCell;
                break;
            }
        }
        
        if (self.lastOffset.y < scrollView.contentOffset.y) {
            //아래로 스크롤
        
            CGRect rectFreezePans = [scrollView convertRect:self.rectFreezePanes toView:scrollView.superview];
            CGFloat yposFView = rectFreezePans.origin.y;
            SectionView *viewToadd = (SectionView *)self.delegatetarget;
            
            if (cellCheck != nil) {
                self.rectFreezePanes = cellCheck.frame;
            }
            
            if(yposFView > 0) {
                if (!CGRectEqualToRect(self.rectFreezePanes,rectFirst)  && cellCheck != nil && ( (currentOffset.y + self.viewCateFreezePans.frame.size.height) > cellCheck.frame.origin.y ) ) {
                    if (cellCheck.frame.origin.y > currentOffset.y) {
                        CGFloat originY = -( cellCheck.frame.size.height - yposFView);

                        self.viewCateFreezePans.frame = CGRectMake(0.0, originY, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                    }
                }
                
            } else {

//                NSLog(@"currentOffset.y = %f",currentOffset.y);
//                NSLog(@"cellCheck.frame.origin.y = %f",cellCheck.frame.origin.y);
                
                if (cellCheck != nil && (currentOffset.y > cellCheck.frame.origin.y)) {
                    
                    for (NSInteger i=0; i<[self.arrFreezePansIndex count]; i++) {
                        if (cellCheck.path.row == [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue]) {
                            
                            NSInteger idxRow = [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue];
                            NSInteger cateIndex = [[[self.sectionarrdata objectAtIndex:idxRow] objectForKey:@"index"] integerValue];
                            [self initViewCateFreezePans:cateIndex];
                            

                            if (self.viewCateFreezePans.frame.origin.y !=0) {
                                self.viewCateFreezePans.frame = CGRectMake(0.0, 0.0, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                            }
                            //NSLog(@"initViewCateFreezePansinitViewCateFreezePans %ld",(long)i);
                            if ([self.arrFreezePansRect count] > i+1) {
                                self.rectFreezePanes = [[self.arrFreezePansRect objectAtIndex:i+1] CGRectValue];
                            }
                            break;
                        }
                    }
                }
                
                if (self.viewCateFreezePans != nil && [self.viewCateFreezePans superview] == nil) {
                    [viewToadd addSubview:self.viewCateFreezePans];
                }
            }
             
            
            
            
        } else if (self.lastOffset.y > scrollView.contentOffset.y) {
            //위로
            CGRect cellRect = [scrollView convertRect:self.rectFreezePanes toView:scrollView.superview];
            CGFloat yposFView = cellRect.origin.y;
            SectionView *viewToadd = (SectionView *)self.delegatetarget;
            
            if(yposFView > 0) {
                if (CGRectEqualToRect(self.rectFreezePanes,rectFirst)) {
                    if (self.viewCateFreezePans != nil) {
                        for (UIView *viewToRemove in viewToadd.subviews) {
                            if ([viewToRemove isKindOfClass:[SectionSUP_ViewCateFreezePans class]]) {
                                [viewToRemove removeFromSuperview];
                            }
                        }
                    }
                }else{

                    //NSLog(@"currentOffset.y = %f",currentOffset.y);
                    //NSLog(@"cellCheck.frame.origin.y = %f",cellCheck.frame.origin.y);
                    if (cellCheck != nil && (currentOffset.y < cellCheck.frame.origin.y)) {
                        for (NSInteger i=0; i<[self.arrFreezePansIndex count]; i++) {
                            if (cellCheck.path.row == [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i] integerValue]) {
                                
                                if (i>0) {
                                    
                                    if ((currentOffset.y >= cellCheck.frame.origin.y - cellCheck.frame.size.height)) {
                                        
                                        CGFloat originY = -(self.viewCateFreezePans.frame.size.height - ( cellCheck.frame.origin.y - currentOffset.y));
                                        self.viewCateFreezePans.frame = CGRectMake(0.0, originY, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                                    }
                                    
                                    NSInteger idxRow = [(NSNumber *)[self.arrFreezePansIndex objectAtIndex:i-1] integerValue];
                                    NSInteger cateIndex = [[[self.sectionarrdata objectAtIndex:idxRow] objectForKey:@"index"] integerValue];
                                    [self initViewCateFreezePans:cateIndex];
                                    
                                    self.rectFreezePanes = [[self.arrFreezePansRect objectAtIndex:i-1] CGRectValue];;
                                }else{
                                    self.rectFreezePanes = [[self.arrFreezePansRect objectAtIndex:0] CGRectValue];;
                                }
                                NSLog(@"self.rectFreezePanes = %@",NSStringFromCGRect(self.rectFreezePanes));
                                break;
                            }
                        }
                    }
                }
                
            } else {

                if (!CGRectEqualToRect(cellCheck.frame,rectFirst)  && cellCheck != nil) {
                    

                    if ( ((cellCheck.frame.origin.y - cellCheck.frame.size.height) < currentOffset.y ) && (cellCheck.frame.origin.y >= currentOffset.y )) {
                        
                        NSLog(@"cellCheck.frame.origin.y = %f",cellCheck.frame.origin.y);
                        NSLog(@"currentOffset.y = %f",currentOffset.y);
                        
                        CGFloat originY = -(self.viewCateFreezePans.frame.size.height - ( cellCheck.frame.origin.y - currentOffset.y));
                        self.viewCateFreezePans.frame = CGRectMake(0.0, originY, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                        
                    }else{
                        if (self.viewCateFreezePans.frame.origin.y !=0) {
                            self.viewCateFreezePans.frame = CGRectMake(0.0, 0.0, self.viewCateFreezePans.frame.size.width, self.viewCateFreezePans.frame.size.height);
                        }
                    }
                    

                }
            }
        }
    
        self.lastOffset = currentOffset;

    }
}

// 스크롤 할때 키보드 내리기
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        [self.scrollExpandingDelegate scrollViewWillBeginDragging:scrollView];
    }
    //키보드가 활성화 되어 있는지 체크
    if(searchCell != nil && [searchCell.searchText isFirstResponder]) {
        [searchCell.searchText resignFirstResponder];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //PulltoRefresh 용
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if ([self.delegatetarget respondsToSelector:@selector(customscrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegatetarget customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate];
    }
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [self.scrollExpandingDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if ([self.delegatetarget respondsToSelector:@selector(customscrollViewDidEndDecelerating:)]) {
        [self.delegatetarget customscrollViewDidEndDecelerating:(UIScrollView *)scrollView];
    }
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
        [self.scrollExpandingDelegate scrollViewDidEndDecelerating:scrollView];
    }
    
    [self checkFreezePanes];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]){
        [self.scrollExpandingDelegate scrollViewShouldScrollToTop:scrollView];
    }
    [self removeFreezPanses];
    return YES;
}

-(void)removeFreezPanses{
    SectionView *viewToadd = (SectionView *)self.delegatetarget;
    if (self.viewCateFreezePans != nil) {
        for (UIView *viewToRemove in viewToadd.subviews) {
            if ([viewToRemove isKindOfClass:[SectionSUP_ViewCateFreezePans class]]) {
                [viewToRemove removeFromSuperview];
            }
        }
    }
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    if ([self.scrollExpandingDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]){
        [self.scrollExpandingDelegate scrollViewDidScrollToTop:scrollView];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.arrFreezePans count] > 0 && self.viewCateFreezePans != nil) {
        self.isFreezePanes = YES;
    }
    [self checkFreezePanes];
}


//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        searchCell.clsButton.hidden = YES;
//        //[self.tableView scrollToRowAtIndexPath:searchCell.myIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        CGRect point = [self.tableView rectForRowAtIndexPath:searchCell.myIndex];
//        [UIView animateWithDuration:0.25 animations:^{
//            [self.tableView setContentOffset:CGPointMake(0, point.origin.y - kbSize.height + searchCell.frame.size.height)]; // 키보드 높이 많큼 뺌.. 조정 필요함
//        } completion:^(BOOL finished) {
//        }];
//    });
//
//}

@end



@implementation UIImage (FILLSIZE)
- (UIImage *)aspectFillToSize:(CGSize)size
{
    CGFloat imgAspect = self.size.width / self.size.height;
    CGFloat sizeAspect = size.width/size.height;
    
    CGSize scaledSize;
    
    if (sizeAspect > imgAspect) { // increase width, crop height
        scaledSize = CGSizeMake(size.width, size.width / imgAspect);
    } else { // increase height, crop width
        scaledSize = CGSizeMake(size.height * imgAspect, size.height);
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, CGRectMake(0, 0, size.width, size.height));
    [self drawInRect:CGRectMake(0.0f, 0.0f, scaledSize.width, scaledSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
