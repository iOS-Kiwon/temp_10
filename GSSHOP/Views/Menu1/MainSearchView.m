//
//  MainSearchView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 12..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "MainSearchView.h"
#import "CooKieDBManager.h"
#import "AppDelegate.h"

#define HEIGHT_TABLEAREA APPFULLHEIGHT - 58.0f  //[Common_Util DPRateOriginVAL:264.0f] - 22.0f //20190218 셀높이 절반을 제거함.
#define HEIGTH_RECOMMENEDED_RELATED_SEARCH 50.0f + 31.0f    // 추천검색어 타이틀

@interface MainSearchView()
@property (nonatomic, strong) IBOutlet UIImageView *m_imgvTextInput;
@end



@implementation MainSearchView
@synthesize currentOperation = currentOperation_;
@synthesize  delegate;
@synthesize searchType;
@synthesize  tbvSearch,viewTableViewArea,recommendedRelatedSearchList;

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.rrSList registerNib:[UINib nibWithNibName:@"recommendedRelatedSearchCell" bundle:nil] forCellWithReuseIdentifier:@"recommendedRelatedSearchCell"];
    
}

//검색어 선택시 BOLD 처리해줘야함
- (void)initWithDelegate:(id)sender Nframe:(CGRect)tframe {
    
    delegate = sender;
    self.frame = tframe;
    
    arrSearch = [NSMutableArray array];
    arrAuto = [NSMutableArray array];
    strABTest = [NSMutableString string];
    searchType = MainSearchModeRecent;

    NSArray *arrCookie = [CooKieDBManager getRecentKeywordCK];
    for (int i=0; i<[arrCookie count]; i++) {
        NSArray *arrRow = [NSArray arrayWithObject:[arrCookie objectAtIndex:i]];
        NSLog(@"arrRow = %@",arrRow);
        if ([arrRow count] > 0 && [[arrRow objectAtIndex:0] length] > 0) {
            [arrSearch addObject:arrRow];
        }
    }
    
    
    
    //viewDimm.alpha = 0.0;
    viewGreenLine.center = CGPointMake(APPFULLWIDTH/4.0, viewGreenLine.center.y);

    
    tfSearch.text = @"";
    [tfSearch resignFirstResponder];
    
    intBeforeTag = BTN_RECENT_TAG;
    
    [btnLeft setTitle:GSSLocalizedString(@"search_recent_title") forState:UIControlStateNormal];
    [btnRight setTitle:GSSLocalizedString(@"search_popular_title") forState:UIControlStateNormal];
    lblNoSearchWord.text = GSSLocalizedString(@"search_recent_keyword_empty");
    tfSearch.placeholder = GSSLocalizedString(@"search_description_search_main");
    [btnClose setTitle:GSSLocalizedString(@"search_bar_close") forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(keyboardShow:)
    name:UIKeyboardDidShowNotification
    object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(keyboardHide:)
    name:UIKeyboardDidHideNotification
    object:nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tableviewTap:)];
        
    [self.tbvSearch addGestureRecognizer:tap];
    
    if(IS_IPHONE_X_SERISE) {
        viewSearchWordDelete.frame = CGRectMake(0, APPFULLHEIGHT-48-30, APPFULLWIDTH, 48+30);
    }
    else {
        viewSearchWordDelete.frame = CGRectMake(0, APPFULLHEIGHT-48, APPFULLWIDTH, 48);
    }
    
    // nami0342 - 0214
    [self.m_imgvTextInput.layer setCornerRadius:20];
    
    tfSearch.font = [UIFont systemFontOfSize:16.0];
    
        
    self.noAutoView.frame = CGRectMake(0, STATUSBAR_HEIGHT + 58 , APPFULLWIDTH, HEIGHT_TABLEAREA);
    self.noAutoView.hidden = YES;
    
    //추천연관검색어
    self.recommendedRelatedSearchList.frame = CGRectMake(0,(IS_IPHONE_X_SERISE?29:0) + viewTextFieldArea.frame.size.height ,APPFULLWIDTH,HEIGTH_RECOMMENEDED_RELATED_SEARCH);
    self.rrSList.dataSource = self;
    self.rrSList.delegate = self;
    self.recommendedRelatedSearchList.hidden = YES;
    
    // 추천검색어 말풍선
    UIImage *img = [UIImage imageNamed:@"img_search_tooltip"];
    UIImageView *tooltipImgView = [[UIImageView alloc] initWithImage: img];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"고객님의 최근 검색어 기반으로 추천합니다";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    label.frame = CGRectMake(16, 20, 233, 20);
    label.numberOfLines = 1;
    
    if (APPFULLWIDTH == 320.0) {
        viewRecommend.frame = CGRectMake(16, 22, 285, 52);
        tooltipImgView.frame = CGRectMake(0, 0, 285, 52);
    } else {
        viewRecommend.frame = CGRectMake(16, 22, 285, 52);
        tooltipImgView.frame = CGRectMake(0, 0, 285, 52);
    }
    [viewRecommend insertSubview:label atIndex:0];
    [viewRecommend insertSubview:tooltipImgView atIndex:0];
    viewRecommend.hidden = YES;
    rrc_H = 0;
}

- (void)tableviewTap:(UITapGestureRecognizer *)sender {
    //키보드 사라짐
    [self keyboardHide:nil];
    [tfSearch resignFirstResponder];
}


-(void)dealloc {
}


- (void)closeButtonClicked:(id)sender {
    [self closeWithAnimated:YES];
}


- (void)closeWithAnimated:(BOOL)animated {
    
    //[[UIApplication sharedApplication] setStatusBarStyle:statusBarStatus];
    
    [tfSearch resignFirstResponder];
    //viewDimm.alpha = 0.0;
    lblNoSearchWord.hidden = YES;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"NO" forKey:@"isForceStop"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDEALVIDEOPAUSENOTI object:nil userInfo:userInfo];

    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.frame = CGRectMake(self.frame.origin.x,  self.frame.origin.y, self.frame.size.width, 0.0);
                     }
                     completion:^(BOOL finished) {
                         self.alpha = 0.0;
                         [arrAuto removeAllObjects];
                         [arrSearch removeAllObjects];
                         [tbvSearch reloadData];
                     }];
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_START_SOCKET object:nil];
    
}

//연관 검색어 비노출
- (void)openWithAnimated:(BOOL)animated {
    [self openWithAnimated:animated showRelated:NO];
}


- (void)openWithAnimated:(BOOL)animated showRelated:(BOOL)show {
    //self.noAutoMaker.hidden = YES;
    self.noAutoView.hidden = YES;
    //statusBarStatus = [[UIApplication sharedApplication] statusBarStyle];
    //AB 테스트 기본값설정 , 아래 통신에 문제가 있거나 인기검색어 통신 전까지 응답이 없을경우 디폴트 사용
    [strABTest setString:@"df"];
    [self.currentOperation cancel];
    self.currentOperation = [ApplicationDelegate.gshop_http_core gsSearchABTest:^(NSString *strResult) {
                                 if([NCS(strResult) length] > 0 && ([strResult isEqualToString:@"a"]||[strResult isEqualToString:@"b"]||[strResult isEqualToString:@"df"] )) {
                                     [strABTest setString:strResult];
                                 }
                             }
                                                                        onError:^(NSError* error) {
                                                                            NSLog(@"error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                                       [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                        }];
    
    // 연관추천 검색어 노출 로직
    if(show) {
        if(ApplicationDelegate.HMV.recommendedRelatedSearchArray.count > 0) {
            self.recommendedRelatedSearchList.hidden = NO;
            viewRecommend.hidden = YES;
            rrc_H = HEIGTH_RECOMMENEDED_RELATED_SEARCH;
            [self.rrSList setContentOffset:CGPointZero];
            [self.rrSList reloadData];
        }
        else {
            self.recommendedRelatedSearchList.hidden = YES;
            viewRecommend.hidden = YES;
            rrc_H = 0;
        }
    }
    else {
        self.recommendedRelatedSearchList.hidden = YES;
        viewRecommend.hidden = YES;
        rrc_H = 0;
    }
    
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"YES" forKey:@"isForceStop"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDEALVIDEOPAUSENOTI object:nil userInfo:userInfo];
    tfSearch.text = @"";
    lblNoSearchWord.hidden = NO;
    
    //VOD매장용 PAUSE용
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOPAUSE object:nil userInfo:userInfo];
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    CGRect field = viewTextFieldArea.frame;
    viewTextFieldArea.frame = CGRectMake(field.origin.x,0,field.size.width,58 + STATUSBAR_HEIGHT);
    
    
    self.alpha = 1.0;
    viewTableViewArea.frame = CGRectMake(viewTableViewArea.frame.origin.x, viewTextFieldArea.frame.origin.y + viewTextFieldArea.frame.size.height + rrc_H, viewTableViewArea.frame.size.width,0.0);
    
    
    [UIView animateWithDuration:(animated ? 0.2 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                     }
                     completion:^(BOOL finished){
                         [self spreadTableAreaWithAnimated:animated];
                     }];
    //amplitude
    [ApplicationDelegate setAmplitudeEvent:@"View-매장-검색진입"];
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_STOP_SOCKET object:nil];
}

- (void)spreadTableAreaWithAnimated:(BOOL)animated {
    
    if([tfSearch.text length] > 0){
        tfSearch.font = [UIFont boldSystemFontOfSize:16.0];
    }
    else {
        tfSearch.font = [UIFont systemFontOfSize:16.0];
    }
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{

                         viewTableViewArea.frame = CGRectMake(viewTableViewArea.frame.origin.x, viewTextFieldArea.frame.origin.y + viewTextFieldArea.frame.size.height + rrc_H, viewTableViewArea.frame.size.width, HEIGHT_TABLEAREA - rrc_H);
                         //viewDimm.alpha = 0.7;
                     }
                     completion:^(BOOL finished){
                         
                         //lblNoSearchWord.center = CGPointMake(lblNoSearchWord.center.x,viewTabArea.frame.size.height +(viewTableViewArea.frame.size.height - viewTabArea.frame.size.height)/2.0);
                        lblNoSearchWord.frame = CGRectMake(0, viewTabArea.frame.size.height+100, APPFULLWIDTH, 20);
                         [self checkRecentSearchWord];
                         [tfSearch becomeFirstResponder];
                         
                     }];
    
}

- (IBAction)onBtnTextFieldClear:(id)sender {
    tfSearch.text = @"";
    btnClearAll.hidden = YES;
    tfSearch.font = [UIFont systemFontOfSize:16.0];
    [tfSearch becomeFirstResponder];
    //[tfSearch resignFirstResponder];
    //self.noAutoMaker.hidden = YES;
    self.noAutoView.hidden = YES;
    [self checkRecentSearchWord];
}

- (void)checkRecentSearchWord {
    NSArray *arrCookie = [CooKieDBManager getRecentKeywordCK];
    if ([arrCookie count] > 0) {
        [self onBtnTab:btnLeft];
    }
    else {
        [self onBtnTab:btnRight];
    }
}

- (IBAction)onBtnClose:(id)sender {
    [self closeWithAnimated:YES];
}

- (IBAction)onBtnSearchWordDelete:(id)sender {
    if(@available(iOS 11.0, *)) {
        NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
        for (NSHTTPCookie *cookie in gsCookies) {
            if([cookie.name isEqualToString:@"search"]) {
                [cookies deleteCookie:cookie];
                [[WKManager sharedManager] wkWebviewDeleteCookie:cookie OnCompletion:^(BOOL isSuccess) {
                    if(isSuccess) {
                        [arrSearch removeAllObjects];
                        tbvSearch.hidden = YES;
                        viewSearchWordDelete.hidden = YES;
                        [tbvSearch reloadData];
                    }
                }];
            }
        }
    }
    else {//구버전...
        [CooKieDBManager deleteAllRecentKeywordCK];
        [arrSearch removeAllObjects];
        tbvSearch.hidden = YES;        
        viewSearchWordDelete.hidden = YES;
        [tbvSearch reloadData];
    }
}

- (IBAction)onBtnTab:(id)sender {
    
    [self.currentOperation cancel];
    UIButton *btnSender = (UIButton *)sender;
    [arrAuto removeAllObjects];
    [arrSearch removeAllObjects];
    [tbvSearch reloadData];
    
    intBeforeTag = btnSender.tag;
    
    UIButton *btnOther = (UIButton *)[viewTableViewArea viewWithTag:(btnSender.tag == BTN_RECENT_TAG)?BTN_POPUALR_TAG:BTN_RECENT_TAG];
    
    btnSender.selected = YES;
    [btnSender.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    btnOther.selected = NO;
    [btnOther.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         viewGreenLine.center = CGPointMake(btnSender.center.x, viewGreenLine.center.y);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    if ([btnSender tag] == BTN_RECENT_TAG) { //최근검색어
        
        //[tfSearch resignFirstResponder]; //키패드 내림
        searchType = MainSearchModeRecent;
        NSArray *arrCookie = [CooKieDBManager getRecentKeywordCK];
        for (int i=0; i<[arrCookie count]; i++) {
            NSArray *arrRow = [NSArray arrayWithObject:[arrCookie objectAtIndex:i]];
            NSLog(@"arrRow = %@",arrRow);
            if ([arrRow count] > 0 && [[arrRow objectAtIndex:0] length] > 0) {
                [arrSearch addObject:arrRow];
            }
        }

        if ([arrSearch count] == 0 ) {
            tbvSearch.hidden = YES;
            viewSearchWordDelete.hidden = YES;
        }
        else {
            tbvSearch.hidden = NO;
            viewSearchWordDelete.hidden = NO;
           
        }
        
        [tbvSearch reloadData];
        viewTableViewArea.frame = CGRectMake(0.0, viewTextFieldArea.frame.origin.y + viewTextFieldArea.frame.size.height + rrc_H, APPFULLWIDTH, HEIGHT_TABLEAREA- rrc_H);
        CGFloat tbvHeight = viewTableViewArea.frame.size.height - viewTabArea.frame.size.height - (48+(IS_IPHONE_X_SERISE?30+50:0+20)) ;
        viewTabArea.hidden = NO;
        tbvSearch.frame = CGRectMake(tbvSearch.frame.origin.x, viewTabArea.frame.size.height, tbvSearch.frame.size.width, tbvHeight);
    }
    else {
        //인기검색어
        
        //[tfSearch resignFirstResponder];        
        viewTableViewArea.frame = CGRectMake(0.0, viewTextFieldArea.frame.origin.y + viewTextFieldArea.frame.size.height + rrc_H, APPFULLWIDTH, HEIGHT_TABLEAREA- rrc_H);
        CGFloat tbvHeight = viewTableViewArea.frame.size.height - viewTabArea.frame.size.height;
        viewTabArea.hidden = NO;
        tbvSearch.frame = CGRectMake(tbvSearch.frame.origin.x, viewTabArea.frame.size.height, tbvSearch.frame.size.width, tbvHeight);
        viewSearchWordDelete.hidden = YES;
        searchType = MainSearchModePopular;
        tbvSearch.hidden = NO;

        
        [self.currentOperation cancel];
        // nami0342 - urlsession
        self.currentOperation = [ApplicationDelegate.gshop_http_core gsHOTKEYWORDLISTURL:GSGETHOTKEYWORDURL
                                                                            onCompletion:^(NSDictionary *result) {
                                                                                NSLog(@"result = %@",result);
                                                                                NSArray *arrPopKeyWord = (NSArray *)[result objectForKey:@"popKeyword"];
                                                                                NSLog(@"arrPopKeyWord = %@",arrPopKeyWord);
                                                                                for (int i=0; i<[arrPopKeyWord count]; i=i+2) {
                                                                                    [arrSearch addObject:[arrPopKeyWord subarrayWithRange:NSMakeRange(i,(i+1== [arrPopKeyWord count]?1:2))]];
                                                                                }
                                                                                [tbvSearch reloadData];
                                                                            }
                                                                                 onError:^(NSError* error) {
                                                                                     NSLog(@"error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],[error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                                 }];
    }
}

- (IBAction)onBtnOpenTooltip:(UIButton *)sender {
    viewRecommend.hidden = !viewRecommend.hidden;
}

- (IBAction)onBtnCloseTooltip:(UIButton *)sender {
    viewRecommend.hidden = YES;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchType == MainSearchModeAuto) {
        return [arrAuto count];
    }
    else {
        return [arrSearch count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *MainSearchIdentifier = @"MainSearchCell";
    MainSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:MainSearchIdentifier];
    
    if (cell == nil) {
        cell = (MainSearchCell *)[[[NSBundle mainBundle] loadNibNamed:@"MainSearchCell" owner:self options:nil] firstObject];
        cell.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, cell.frame.size.height);
    }
    
    cell.target = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (searchType == MainSearchModeAuto) {
        NSLog(@"[arrAuto objectAtIndex:indexPath.row] = %@",[arrAuto objectAtIndex:indexPath.row]);
        [cell setCellInfoNDrawData:[arrAuto objectAtIndex:indexPath.row] type:searchType indexPath:indexPath searchWord:tfSearch.text];
    }
    else {
        if ([arrSearch count] > 0 && indexPath.row <= [arrSearch count]-1 ) {
            [cell setCellInfoNDrawData:[arrSearch objectAtIndex:indexPath.row] type:searchType indexPath:indexPath searchWord:@""];
        }
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (searchType == MainSearchModeAuto) {
        if ([[[arrAuto objectAtIndex:indexPath.row] objectAtIndex:0] isKindOfClass:[NSString class]]) {
            return 48.0;
        }
        else {
            return 48.0;
        }
    }
    else {
        return 48.0;
    }
}

#pragma mark - 스크롤뷰 액션

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self keyboardHide:nil];
    [tfSearch resignFirstResponder];
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)goWebViewWithSearchWord:(NSString *)strWord direct:(BOOL)isDirect {
    NSLog(@"strWord = %@",strWord);
    
    //- 최근검색어 : 401170
    //- 인기검색어 : 402848
    //- 다이렉트검색(돋보기) : 401172
    //- 연관검색어(자동완성) : 401171

    NSString *strMSEQ = nil;
    
    switch (searchType) {
        case MainSearchModeRecent:
            strMSEQ = GSSEARCHMSEQ1;
            break;
        case MainSearchModePopular:
            strMSEQ = GSSEARCHMSEQ2;
            break;
        case MainSearchModeAuto:
            strMSEQ = (isDirect)?GSSEARCHMSEQ3:GSSEARCHMSEQ4;
            break;
        default:
            break;
    }
    
        
    NSString *preitemString = [strWord urlEncodedString];//-2147482590
    NSString *itemString = [NSString stringWithFormat:@"%@",GSSEARCHURL(strMSEQ ,preitemString,strABTest) ];
       
    if([delegate respondsToSelector:@selector(goWebView:)]) {
        [self closeWithAnimated:NO];
        [delegate goWebView:itemString];
    }
}

//추천연관검색어 전용
-(void)goWebViewWithSearchWordOnlyRecommended:(NSString *)strWord isHome:(BOOL)ishome {
    NSLog(@"strWord = %@",strWord);
    NSString *preitemString = [strWord urlEncodedString];//-2147482590
    NSString *itemString = [NSString stringWithFormat:@"%@",GSSEARCHURL(ishome?GSSEARCHMSEQ6:GSSEARCHMSEQ5 ,preitemString,strABTest) ];
    if([delegate respondsToSelector:@selector(goWebView:)]) {
        [self closeWithAnimated:NO];
        [delegate goWebView:itemString];
    }
}



- (void)goWebViewWithCateUrl:(NSString *)strURL {
    NSLog(@"strURL = %@",strURL);
    //GSSEARCHMSEQ1 뭘까요?
    NSString *itemString = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//-2147482590
    
    NSLog(@"itemString = %@",itemString);
    if([delegate respondsToSelector:@selector(goWebView:)]) {
        [self closeWithAnimated:NO];
        [delegate goWebView:itemString];
    }
}

- (void)delRecentWord:(NSString *)strWord {
    NSLog(@"strWord = %@",strWord);
    [arrSearch removeAllObjects];
     if(@available(iOS 11.0, *)) {
        NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
        for (NSHTTPCookie *cookie in gsCookies) {
            if([cookie.name isEqualToString:@"search"]) {
                NSMutableArray *cookieProperties = [NSMutableArray arrayWithArray:[Mocha_Util explode:@"@" string: [[NSString stringWithFormat:@"%@",cookie.value ] stringByRemovingPercentEncoding] ] ];
                NSString* ckstr = [NSString string];
                int i = 0;
                for(NSString *gval in cookieProperties) {
                    if( [gval isEqualToString:strWord]  || [gval isEqualToString:[NSString stringWithFormat:@"%@",[Mocha_Util strReplace:@" " replace:@"+" string:strWord]] ]){
                        
                    }
                    else {
                        if(i == 0) {
                            ckstr = [NSString stringWithFormat:@"%@",gval];
                        }
                        else {
                            ckstr = [NSString stringWithFormat:@"%@@%@",ckstr,gval];
                        }
                    }
                    i++;
                }
                
                [cookies deleteCookie:cookie];
                NSMutableDictionary* cookiestrees = [NSMutableDictionary dictionary];
                [cookiestrees setObject:@"search" forKey:NSHTTPCookieName];
                //URL인코딩에 문제가 있어 변경
                [cookiestrees setObject:[ckstr urlEncodedString]  //[ckstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                                 forKey:NSHTTPCookieValue];
                [cookiestrees setObject:@".gsshop.com" forKey:NSHTTPCookieDomain];
                [cookiestrees setObject:@".gsshop.com" forKey:NSHTTPCookieOriginURL];
                [cookiestrees setObject:@"/" forKey:NSHTTPCookiePath];
                [cookiestrees setObject:@"0" forKey:NSHTTPCookieVersion];
                [cookiestrees setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
                
                NSHTTPCookie *neocookie = [NSHTTPCookie cookieWithProperties:cookiestrees];
                [cookies setCookie:neocookie];
                [[WKManager sharedManager] wkWebviewSetCookie:neocookie OnCompletion:^(BOOL isSuccess) {
                    if(isSuccess) {
                        NSArray *arrCookie = [CooKieDBManager getRecentKeywordCK];
                        for (int i=0; i<[arrCookie count]; i++) {
                            NSArray *arrRow = [NSArray arrayWithObject:[arrCookie objectAtIndex:i]];
                            NSLog(@"arrRow = %@",arrRow);
                            if ([arrRow count] > 0 && [[arrRow objectAtIndex:0] length] > 0) {
                                [arrSearch addObject:arrRow];
                            }
                        }
                        if([arrSearch count] == 0) {
                            tbvSearch.hidden = YES;
                            viewSearchWordDelete.hidden = YES;
                        }
                        [tbvSearch reloadData];
                    }
                }];
                break;
            }
            
        }
    }
    else {
        [CooKieDBManager deleteOneKeyRecentKeywordCK:strWord];
        NSArray *arrCookie = [CooKieDBManager getRecentKeywordCK];
        for (int i=0; i<[arrCookie count]; i++) {
            NSArray *arrRow = [NSArray arrayWithObject:[arrCookie objectAtIndex:i]];
            NSLog(@"arrRow = %@",arrRow);
            if ([arrRow count] > 0 && [[arrRow objectAtIndex:0] length] > 0) {
                [arrSearch addObject:arrRow];
            }
        }
        if([arrSearch count] == 0) {
            tbvSearch.hidden = YES;
            viewSearchWordDelete.hidden = YES;
        }
        [tbvSearch reloadData];
    }
}

#pragma mark UITextFieldDelegate



-(void)textFieldDidChange:(NSNotification*)aNotification {
    if ([tfSearch isFirstResponder]) {
        btnClearAll.hidden = ([tfSearch.text length] > 0)?NO:YES;
        if(btnClearAll.hidden) {
            tfSearch.font = [UIFont systemFontOfSize:16.0];
        }
        else {
            tfSearch.font = [UIFont boldSystemFontOfSize:16.0];
        }
        
        if ([tfSearch.text length] == 0) {
            [self onBtnTab:(intBeforeTag == BTN_RECENT_TAG)?btnLeft:btnRight];
            
            self.noAutoView.hidden = YES;
            [tfSearch becomeFirstResponder];
            return;
        }
        
        if([tfSearch.text isEqualToString:@"\n"] || [tfSearch.text isEqualToString:@"\r"] || [tfSearch.text isEqualToString:@""]){
            return;
        }
        
        CGFloat tbvHeight = viewTableViewArea.frame.size.height;
        viewTabArea.hidden = YES;
        tbvSearch.frame = CGRectMake(tbvSearch.frame.origin.x, 0.0, APPFULLWIDTH, tbvHeight);
        //tbvSearch.tableFooterView = nil;
        viewSearchWordDelete.hidden = YES;
        
        NSString *itemString = [tfSearch.text urlEncodedString];
        
        NSLog(@"itemString = %@",itemString);
        //[tbvSearch setBounces:YES];
        [self.currentOperation cancel];
        self.currentOperation = [ApplicationDelegate.gshop_http_core gsAUTOMAKELISTURL:GSSEARCHAUTOCOMPLETEURL(itemString)
                                                                          onCompletion:^(NSDictionary *result)  {
                                                                              NSLog(@"result = %@",result);
                                                                              //배열관리
                                                                              if(([(NSArray *)[result objectForKey:@"front"]  count] >0) || ([(NSArray *)[result objectForKey:@"back"]  count] >0) || ([(NSArray *)[result objectForKey:@"category"]  count] >0) ) {
                                                                                  //self.noAutoMaker.hidden = YES;
                                                                                  self.noAutoView.hidden = YES;
                                                                                  [arrAuto removeAllObjects];
                                                                                  [tbvSearch reloadData];
                                                                                  if ([tfSearch.text length] > 0) {
                                                                                      [self autoMaker:result];
                                                                                  }
                                                                              }
                                                                              else {
                                                                                  [arrAuto removeAllObjects];
                                                                                  [tbvSearch reloadData];
                                                                                  //해당 검색어의 자동완성어가 없습니다. 추가
//                                                                                  self.noAutoView.frame = CGRectMake(0, STATUSBAR_HEIGHT + 58 + rrc_H , APPFULLWIDTH, HEIGHT_TABLEAREA-rrc_H);
                                                                                  self.noAutoView.hidden = NO;
                                                                                  [self reloadTableTypeAuto];
                                                                              }
                                                                          }
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                                         [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                               }];

    }
}


- (void)autoMaker:(NSDictionary *)dic {
    
    lblNoSearchWord.hidden = NO;
    if(NCA([dic objectForKey:@"category"])) {
        NSArray *tarr = (NSArray *)[dic objectForKey:@"category"];
        for (NSUInteger j=0; j< [tarr count];j++ ) {
            NSLog(@"[(NSArray *)[dic objectForKey:@category] objectAtIndex:j] = %@",[tarr objectAtIndex:j]);
            [arrAuto addObject:[NSArray arrayWithObject:[tarr objectAtIndex:j]]];
        }
    }
    
    if (NCA([dic objectForKey:@"front"]) && [(NSArray *)[dic objectForKey:@"front"] count] > 0) {
        for (NSUInteger i=0; i< [(NSArray *)[dic objectForKey:@"front"] count];i++ ) {
            NSString *strFront = [[dic objectForKey:@"front"] objectAtIndex:i];
            NSString *strBack = @"";
            NSArray *arrAutoTemp = [NSArray arrayWithObjects:strFront,strBack, nil];
            NSLog(@"arrAutoTemp = %@",arrAutoTemp);
            [arrAuto addObject:arrAutoTemp];
        }
    }
    
    [self reloadTableTypeAuto];
}

-(void)reloadTableTypeAuto {
    
    if ([arrAuto count] == 0) {
        searchType = (intBeforeTag == BTN_RECENT_TAG)?MainSearchModeRecent:MainSearchModePopular;
    }
    else {
        tbvSearch.hidden = NO;
        searchType = MainSearchModeAuto;
    }
    
    if (APPFULLHEIGHT > 480) {
        if ([arrAuto count] < 6) {
            //[tbvSearch setBounces:NO];
            lblNoSearchWord.hidden = YES;
            int cntCate = 0;
            for(NSInteger i=0;i<[arrAuto count];i++) {
                if ([[[arrAuto objectAtIndex:i] objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    cntCate++;
                }
            }
        }
        else {
            //[tbvSearch setBounces:YES];
            viewTableViewArea.frame = CGRectMake(0.0, viewTextFieldArea.frame.origin.y + viewTextFieldArea.frame.size.height, APPFULLWIDTH, HEIGHT_TABLEAREA);
            
            tbvSearch.frame = CGRectMake(tbvSearch.frame.origin.x, 0.0, tbvSearch.frame.size.width, viewTableViewArea.frame.size.height);
        }
    }
    [tbvSearch reloadData];
}

- (void)insertCategoryData:(NSDictionary *)dic afterReload:(BOOL)isReload {
    
}

- (IBAction)onBtnSearchLeft:(id)sender {
    
    //20160112 검색시 스페이스 만 입력하여 검색되는것 막음
    NSString *spaceCheck = [tfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    // nami0342 - openDate 추가 // yunsang.jin openDate 수정
    // parksegun - SM14/TM14 컨버전 기능 추가
    
    if([spaceCheck hasPrefix:@"&openDate="])
    {
        NSArray *arrCheckNumber = [spaceCheck componentsSeparatedByString:@"&openDate="];
        
        NSLog(@"arrCheckNumber count = %ld",(long)[arrCheckNumber count]);
        
        
        if ([arrCheckNumber count] > 1) {
            
            NSString *strVaildDateCheck = [arrCheckNumber objectAtIndex:1];
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            
            if([NCS(strVaildDateCheck) length] == 0){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_OPEN_DATE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"openDate 해제"];
                [tfSearch setText:@""];
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return;
                
            }else if ( ([strVaildDateCheck length] == 14) && [strVaildDateCheck rangeOfCharacterFromSet:notDigits].location == NSNotFound){
                
                //14자리 문자에 모두 숫자일경우만
                [[NSUserDefaults standardUserDefaults] setObject:spaceCheck forKey:@"API_ADD_OPEN_DATE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:spaceCheck];
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return;
                
            }else{
                //숫자 이외의 것들도 들어왔음
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"openDate 값이 유효하지 않습니다." inView:ApplicationDelegate.window];
                return;
            }
            
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_OPEN_DATE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Mocha_ToastMessage toastWithDuration:2.0 andText:@"openDate 해제"];
            [tfSearch setText:@""];
            [self closeWithAnimated:NO];
            [ApplicationDelegate.HMV firstProc]; // 홈 초기화
            return;
        }
        
    }
    else if([spaceCheck hasPrefix:@"&brdTime="])
    {
        NSArray *arrCheckNumber = [spaceCheck componentsSeparatedByString:@"&brdTime="];
        
        NSLog(@"arrCheckNumber count = %ld",(long)[arrCheckNumber count]);
        
        
        if ([arrCheckNumber count] > 1) {
            
            NSString *strVaildDateCheck = [arrCheckNumber objectAtIndex:1];
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            
            if([NCS(strVaildDateCheck) length] == 0){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_BRD_TIME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"brdTime 해제"];
                [tfSearch setText:@""];
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return;
                
            }else if ( ([strVaildDateCheck length] == 14) && [strVaildDateCheck rangeOfCharacterFromSet:notDigits].location == NSNotFound){
                
                //14자리 문자에 모두 숫자일경우만
                [[NSUserDefaults standardUserDefaults] setObject:spaceCheck forKey:@"API_ADD_BRD_TIME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:spaceCheck];
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return;
                
            }else{
                //숫자 이외의 것들도 들어왔음
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"brdTime 값이 유효하지 않습니다." inView:ApplicationDelegate.window];
                return;
            }
            
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_BRD_TIME"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Mocha_ToastMessage toastWithDuration:2.0 andText:@"brdTime 해제"];
            [tfSearch setText:@""];
            [self closeWithAnimated:NO];
            [ApplicationDelegate.HMV firstProc]; // 홈 초기화
            return;
        }
    }
#if SM14 && !APPSTORE
    else if([spaceCheck.uppercaseString isEqualToString:@"SM21"] ||
            [spaceCheck.uppercaseString isEqualToString:@"TM14"] ||
            [spaceCheck.uppercaseString isEqualToString:@"MODE"] ||
            [spaceCheck.uppercaseString isEqualToString:@"DEV"] ) {
        devModeView *modeView = [[[NSBundle mainBundle] loadNibNamed:@"devModeView" owner:self options:nil] firstObject];
        modeView.frame = ApplicationDelegate.window.frame;
        [ApplicationDelegate.window addSubview:modeView];
        [tfSearch setText:@""];
        [self closeWithAnimated:NO];
        return;
    }
    else if ([spaceCheck.uppercaseString isEqualToString:@"DEVPOP"]) {
        
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Dev" bundle:[NSBundle mainBundle]];
        DevViewController * devVC = (DevViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"DevViewController"];
        [ApplicationDelegate.HMV.navigationController pushViewController:devVC animated:true];
        
        
        [tfSearch setText:@""];
        [self closeWithAnimated:NO];
        return ;
    }
#endif

    
    if ([spaceCheck length] > 0) {
        [self goWebViewWithSearchWord:tfSearch.text direct:YES];
    }
    else {
        [tfSearch resignFirstResponder];
        tfSearch.text = @"";
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"search_description_search_main") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        malert.tag=447;
        [ApplicationDelegate.window addSubview:malert];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //20160112 검색시 스페이스 만 입력하여 검색되는것 막음
    NSString *spaceCheck = [tfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // nami0342 - openDate 추가 // yunsang.jin openDate 수정
    
    if([spaceCheck hasPrefix:@"&openDate="])
    {
        NSArray *arrCheckNumber = [spaceCheck componentsSeparatedByString:@"&openDate="];
        
        NSLog(@"arrCheckNumber count = %ld",(long)[arrCheckNumber count]);
        
        
        if ([arrCheckNumber count] > 1) {
            
            NSString *strVaildDateCheck = [arrCheckNumber objectAtIndex:1];
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            
            if([NCS(strVaildDateCheck) length] == 0){
            
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_OPEN_DATE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"openDate 해제"];
                [tfSearch setText:@""];
                //tfSearch.backgroundColor = UIColor.clearColor;
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return NO;
            
            }else if ( ([strVaildDateCheck length] == 14) && [strVaildDateCheck rangeOfCharacterFromSet:notDigits].location == NSNotFound){
                
                //14자리 문자에 모두 숫자일경우만
                [[NSUserDefaults standardUserDefaults] setObject:spaceCheck forKey:@"API_ADD_OPEN_DATE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:spaceCheck];
                [tfSearch setText:@""];
                //tfSearch.backgroundColor = UIColor.redColor;
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                
                return NO;
                
            }else{
                //숫자 이외의 것들도 들어왔음
                NSLog(@"");
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"openDate 값이 유효하지 않습니다." inView:ApplicationDelegate.window];
                return NO;
            }
            
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_OPEN_DATE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Mocha_ToastMessage toastWithDuration:2.0 andText:@"openDate 해제"];
            [tfSearch setText:@""];
            tfSearch.backgroundColor = UIColor.clearColor;
            [self closeWithAnimated:NO];
            [ApplicationDelegate.HMV firstProc]; // 홈 초기화
            return NO;
        }
        
    }
    else if([spaceCheck hasPrefix:@"&brdTime="])
    {
        NSArray *arrCheckNumber = [spaceCheck componentsSeparatedByString:@"&brdTime="];
        
        NSLog(@"arrCheckNumber count = %ld",(long)[arrCheckNumber count]);
        
        
        if ([arrCheckNumber count] > 1) {
            
            NSString *strVaildDateCheck = [arrCheckNumber objectAtIndex:1];
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            
            if([NCS(strVaildDateCheck) length] == 0){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_BRD_TIME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"brdTime 해제"];
                [tfSearch setText:@""];
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return NO;
                
            }else if ( ([strVaildDateCheck length] == 14) && [strVaildDateCheck rangeOfCharacterFromSet:notDigits].location == NSNotFound){
                
                //14자리 문자에 모두 숫자일경우만
                [[NSUserDefaults standardUserDefaults] setObject:spaceCheck forKey:@"API_ADD_BRD_TIME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Mocha_ToastMessage toastWithDuration:2.0 andText:spaceCheck];
                [self closeWithAnimated:NO];
                [ApplicationDelegate.HMV firstProc]; // 홈 초기화
                return NO;
                
            }else{
                //숫자 이외의 것들도 들어왔음
                [Mocha_ToastMessage toastWithDuration:2.0 andText:@"brdTime 값이 유효하지 않습니다." inView:ApplicationDelegate.window];
                return NO;
            }
            
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"API_ADD_BRD_TIME"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Mocha_ToastMessage toastWithDuration:2.0 andText:@"brdTime 해제"];
            [tfSearch setText:@""];
            [self closeWithAnimated:NO];
            [ApplicationDelegate.HMV firstProc]; // 홈 초기화
            return NO;
        }
    }
#if SM14 && !APPSTORE
    else if([spaceCheck.uppercaseString isEqualToString:@"SM21"] ||
            [spaceCheck.uppercaseString isEqualToString:@"TM14"] ||
            [spaceCheck.uppercaseString isEqualToString:@"MODE"] ||
            [spaceCheck.uppercaseString isEqualToString:@"DEV"] ) {
        devModeView *modeView = [[[NSBundle mainBundle] loadNibNamed:@"devModeView" owner:self options:nil] firstObject];
        modeView.frame = ApplicationDelegate.window.frame;
        [ApplicationDelegate.window addSubview:modeView];
        [tfSearch setText:@""];
        [self closeWithAnimated:NO];
        return NO;
    }
    else if ([spaceCheck.uppercaseString isEqualToString:@"DEVPOP"]) {
        
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Dev" bundle:[NSBundle mainBundle]];
        DevViewController * devVC = (DevViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"DevViewController"];
        [ApplicationDelegate.HMV.navigationController pushViewController:devVC animated:true];
        
        
        
        
        [tfSearch setText:@""];
        [self closeWithAnimated:NO];
        return NO;
    }
#endif
    
    
    [textField resignFirstResponder];
    if ([spaceCheck length] > 0) {
        [self goWebViewWithSearchWord:tfSearch.text direct:YES];
    }
    else {
        [tfSearch resignFirstResponder];
        tfSearch.text = @"";
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"search_description_search_main") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        malert.tag=447;
        [ApplicationDelegate.window addSubview:malert];
    }
    return YES;
}

-(void)keyboardShow:(NSNotification *)notification {
    CGRect beginRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = beginRect.origin.y - endRect.origin.y;
   viewSearchWordDelete.frame = CGRectMake(0, APPFULLHEIGHT-keyBoardH-48, APPFULLWIDTH, 48);
}

-(void)keyboardHide:(NSNotification *)notification {
    viewSearchWordDelete.frame = CGRectMake(0, APPFULLHEIGHT-(48+(IS_IPHONE_X_SERISE?30:0)), APPFULLWIDTH, 48+(IS_IPHONE_X_SERISE?30:0));
}

#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if (alert.tag ==447){
        [tfSearch becomeFirstResponder];
    }
}

#pragma mark UICollectionViewDelegate


- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    recommendedRelatedSearchCell *cell = (recommendedRelatedSearchCell *)[self.rrSList dequeueReusableCellWithReuseIdentifier:@"recommendedRelatedSearchCell" forIndexPath:indexPath];
    
    if( ApplicationDelegate.HMV.recommendedRelatedSearchArray.count > indexPath.row) {
        NSDictionary *disDic = [ApplicationDelegate.HMV.recommendedRelatedSearchArray objectAtIndex:indexPath.row];
        [cell setDisplayDic:disDic index:indexPath.row];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if( ApplicationDelegate.HMV.recommendedRelatedSearchArray.count > indexPath.row) {
        NSDictionary *disDic = [ApplicationDelegate.HMV.recommendedRelatedSearchArray objectAtIndex:indexPath.row];
        [self goWebViewWithSearchWordOnlyRecommended:NCS([disDic objectForKey:@"rtq"]) isHome:NO];
    }
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ApplicationDelegate.HMV.recommendedRelatedSearchArray.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if( ApplicationDelegate.HMV.recommendedRelatedSearchArray.count > indexPath.row) {
        NSDictionary *dic = [ApplicationDelegate.HMV.recommendedRelatedSearchArray objectAtIndex:indexPath.row];
        NSString *value = NCS([dic objectForKey:@"rtq"]);
        CGFloat width = 16+16;
        
        if(value.length > 0) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.text = value;
            width += label.intrinsicContentSize.width;
        }
        else {
            width = 0;
        }
        
        return CGSizeMake(width, 32);
    }
    else {
        return CGSizeMake(0,0);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //top, left, bottom, right
    return UIEdgeInsetsMake(6.0, 0, 12.0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(16.0, 32);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(16.0, 32);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



@end
