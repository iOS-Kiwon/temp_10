//
//  SectionView+TDCLIST.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//




#import "SectionView+TDCLIST.h"
#import "TDCLiveTBViewController.h"



@implementation SectionView (TDCLIST)


- (void)ScreenDefineTDCLIST
{
    
    [self ScreenDefineTDCWith:NO];
}


- (void)ScreenReDefineTDCLIST
{
    [self ScreenDefineTDCWith:YES];
}


- (void)ScreenDefineTDCWith:(BOOL)isReDefine
{
    //초기 디파인시 로딩인디게이터 ON
    if(isReDefine ==NO && ApplicationDelegate.appfirstLoading == NO ) {
        [ApplicationDelegate onloadingindicator];
    }
    
    if(self.currentOperation1 != nil){
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    
    
    NSString* apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:[_sectioninfoDic objectForKey:@"sectionLinkUrl"]];
    
    
    apiURL =  [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
    
    if ([NCS([_sectioninfoDic objectForKey:@"sectionLinkParams"]) length] > 0) {
        apiURL = [NSString stringWithFormat:@"%@?%@%@%@", apiURL, [_sectioninfoDic objectForKey:@"sectionLinkParams"],@"&reorder=true",ABTESTBULLETVERSTR([DataManager sharedManager].abBulletVer)];
    }else {
        apiURL = [NSString stringWithFormat:@"%@?%@%@", apiURL, @"reorder=true",ABTESTBULLETVERSTR([DataManager sharedManager].abBulletVer)];
    }
    
    apiURL = [self checkAdidRequest:apiURL];
    
#if APPSTORE
#else
    // 치명!!!
    
    // nami0342 - BRD time 적용
    NSString *strBrdTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_BRD_TIME"];
    if(NCS(strBrdTime).length > 0)
    {
        apiURL = [NSString stringWithFormat:@"%@%@", apiURL, strBrdTime];
    }
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015111419200000",apiLeftURL]; //렌탈 단품
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015111209200000",apiLeftURL]; //렌탈 복수
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015110717300000",apiLeftURL]; //휴대폰
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=201511112140000",apiLeftURL]; //보험
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015111004050000",apiLeftURL]; //공익방송
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015110802000000",apiLeftURL]; //여행상품
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015111109300000",apiLeftURL]; //80% 이상인것
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015112621400000",apiLeftURL]; //베스트 상품일경우 플레이 버튼 비노출
    
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2015112800000000",apiLeftURL]; //베스트 상품일경우 플레이 버튼 비노출
    //apiLeftURL = [NSString stringWithFormat:@"%@&openDate=20160225180000",apiLeftURL]; //3단베너
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=20160120134000",apiLeftURL]; //라이브톡
    
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2016040617400000",apiLeftURL]; //바로구매 렌탈상품
    //apiLeftURL = [NSString stringWithFormat:@"%@&brdTime=2017071809200000",apiLeftURL]; //--
    
#endif
    //TV쇼핑에서 라이브 영역 시간이 만료되어.  '하단 홈' 버튼을 클릭한 후 다시 TV쇼핑 매장으로 이동해도. 라이브 영역이 만료된 상태로 나옴.
    //무조건 새로고침 으로 수정 2018.09.19
    
    
    //20190130 조건추가 - 방송이 종료된 상태라면 캐시 안탐
    //방송이 종료되었는지 체크로직 추가 필요. // 이미 캐시 사용 안할꺼면 계속 사용 안함.
    if(self.specialSectionApiResult == nil && isReDefine == YES) {
        //당연히 새로고침
        isReDefine = YES;
    }
    else {
        NSDictionary *liveDic = [self.specialSectionApiResult objectForKey:@"tvLiveBanner"];
        NSDictionary *dataDic = [self.specialSectionApiResult objectForKey:@"dataLiveBanner"];
        
        if( NCO(liveDic) && NCO(dataDic) && ([self brdCloseTimeCheck:liveDic] || [self brdCloseTimeCheck:dataDic])) {
            isReDefine = NO;
        }
        else {
            isReDefine = YES;
        }
    }
    
    
    
    // nami0342 - urlsessioin
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL_NativeJSON:apiURL
                                                                                    isForceReload:isReDefine
                                                                                     onCompletion:^(NSDictionary *result) {
                                                                                         self.specialSectionApiResult = result;
                                                                                         if(self.tdcliveTbv == nil) {
                                                                                             
                                                                                             self.tdcliveTbv = [[TDCLiveTBViewController alloc] initWithSectionResult:self.specialSectionApiResult  sectioninfo:_sectioninfoDic ];
                                                                                             
                                                                                             [self.tdcliveTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                             self.tdcliveTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                             self.tdcliveTbv.view.frame = self.bounds;
                                                                                             self.tdcliveTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                             self.tdcliveTbv.delegatetarget = (id)self;
                                                                                             self.tdcliveTbv.tableView.scrollsToTop = NO;
                                                                                             [self addSubview:self.tdcliveTbv.view];
                                                                                         }
                                                                                         else {
                                                                                             self.tdcliveTbv.apiResultDic = self.specialSectionApiResult;
                                                                                             [self.tdcliveTbv reloadAction];
                                                                                         }
                                                                                         
                                                                                         
                                                                                         [self  bringSubviewToFront:self.btngoTop];
                                                                                         
                                                                                         // nami0342 - CSP
                                                                                         // [self  bringSubviewToFront:self.btnSiren];
                                                                                         [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                         [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                         [self bringSubviewToFront:self.m_btnCSPIcon];

                                                                                         //새로고침 버튼이 있다면 삭제
                                                                                         [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                                         
                                                                                         [ApplicationDelegate offloadingindicator];
                                                                                         
                                                                                         
                                                                                     }
                                                                                          onError:^(NSError* error) {
                                                                                              NSLog(@"COMM ERROR");
                                                                                              //새로고침실패시 테이블 컨텐츠 제거를 위한
                                                                                              self.tdcliveTbv.apiResultDic = nil;
                                                                                              if(self.tdcliveTbv == nil) {
                                                                                                  if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTDCLIST]  ) {
                                                                                                      self.tdcliveTbv = [[TDCLiveTBViewController alloc] initWithSectionResult:self.specialSectionApiResult sectioninfo:_sectioninfoDic];
                                                                                                      [self.tdcliveTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                                      self.tdcliveTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                                      self.tdcliveTbv.view.frame = self.bounds;
                                                                                                      self.tdcliveTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                                      
                                                                                                      self.tdcliveTbv.delegatetarget = (id)self;
                                                                                                      self.tdcliveTbv.tableView.scrollsToTop = NO;
                                                                                                      [self addSubview:self.tdcliveTbv.view];
                                                                                                  }
                                                                                                  else {
                                                                                                      //새로고침
                                                                                                      [self.tdcliveTbv reloadAction];
                                                                                                      [self  bringSubviewToFront:self.btngoTop];
                                                                                                      // nami0342 - CSP
                                                                                                      // [self  bringSubviewToFront:self.btnSiren];
                                                                                                      [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                                      [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                                      [self bringSubviewToFront:self.m_btnCSPIcon];
                                                                                                  }
                                                                                                  
                                                                                                  //새로고침 안내화면이 있다면 삭제
                                                                                                  [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                                                  
                                                                                                  //실패시 새로고침 안내뷰
                                                                                                  [self.tdcliveTbv.view addSubview:[self RefreshGuideView] ];
                                                                                                  [ApplicationDelegate offloadingindicator];
                                                                                              }
                                                                                          }];
}



-(UIView*)TDCRightRefreshGuideView {
    
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    [containView setCenter:CGPointMake(self.center.x, self.center.y+50)];
    containView.backgroundColor= [UIColor clearColor];
    containView.tag = TBREFRESHBTNVIEWRIGHT_TAG;
    //새로고침아이콘
    UIImageView* loadingimgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Network_error_icon.png"]];
    [loadingimgView setFrame:CGRectMake(150-37, 40, 75, 88)];
    [containView addSubview:loadingimgView];


    UILabel* gmentLabel = [[UILabel alloc] init];
    gmentLabel.text = [NSString stringWithFormat:@"%@", @"데이터 연결이 원활하지 않습니다."];
    gmentLabel.textAlignment = NSTextAlignmentCenter;
    gmentLabel.font = [UIFont boldSystemFontOfSize:17];
    gmentLabel.backgroundColor = [UIColor clearColor];
    gmentLabel.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.64] ;
    gmentLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [gmentLabel setFrame:CGRectMake(25, 147, 250, 24)];
    [containView addSubview:gmentLabel];

    // 2줄
    UILabel* gmentLabel1 = [[UILabel alloc] init];
    gmentLabel1.text = [NSString stringWithFormat:@"%@", @"잠시 후 다시 시도해 주시기 바랍니다."];
    gmentLabel1.textAlignment = NSTextAlignmentCenter;
    gmentLabel1.font = [UIFont boldSystemFontOfSize:14];
    gmentLabel1.backgroundColor = [UIColor clearColor];
    gmentLabel1.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.48] ;
    gmentLabel1.lineBreakMode = NSLineBreakByTruncatingTail;

    [gmentLabel1 setFrame:CGRectMake(25, 175, 250, 20)];
    [containView addSubview:gmentLabel1];

    //새로고침 버튼
    UIButton* cbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn1 setFrame:CGRectMake(containView.frame.size.width/2 - 85,205,70,32)];
    [cbtn1 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn1.backgroundColor = [UIColor whiteColor];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateNormal];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn1.layer.cornerRadius = 4.0f;
    [cbtn1.layer setMasksToBounds:NO];
    cbtn1.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn1.layer.shadowRadius = 0.0;
    cbtn1.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn1.layer.borderWidth = 1;
    cbtn1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn1.tag = 1;
    [containView addSubview:cbtn1];

    // nami0342 - [웹으로 보기] 버튼 추가
    UIButton* cbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn2 setFrame:CGRectMake(containView.frame.size.width/2 -7,205,85,32)];
    [cbtn2 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn2.backgroundColor = [UIColor whiteColor];
    [cbtn2 setTitle:GSSLocalizedString(@"View_on_the_web_text")  forState:UIControlStateNormal];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn2 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn2.layer.cornerRadius = 4.0f;
    [cbtn2.layer setMasksToBounds:NO];
    cbtn2.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn2.layer.shadowRadius = 0.0;
    cbtn2.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn2.layer.borderWidth = 1;
    cbtn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn2.tag = 2;
    [containView addSubview:cbtn2];

    return containView;
    
    return nil;
}


//NO이면 방송 종료
-(BOOL) brdCloseTimeCheck:(NSDictionary *) dicRowInfo {
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:[dicRowInfo objectForKey:@"broadCloseTime"]];
    int closestamp = [closeTime timeIntervalSince1970];
    double leftTimeSec = closestamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    return (leftTimeSec > 0.0) ? YES : NO;
}






@end
