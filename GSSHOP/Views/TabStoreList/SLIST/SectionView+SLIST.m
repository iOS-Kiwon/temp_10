//
//  SectionView+SLIST.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 3. 28..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+SLIST.h"
#import "SListTBViewController.h"

@implementation SectionView (SLIST)

- (void)loadBroadTypeSLIST:(NSString *) type {
    [self ScreenDefineSLISTWith:YES broadType:type];
}

- (void)ScreenDefineSLIST{
    [self ScreenDefineSLISTWith:NO broadType:nil];
}

- (void)ScreenReDefineSLIST{
    [self ScreenDefineSLISTWith:YES broadType:nil];
}

- (void)ScreenDefineSLISTWith:(BOOL)isReDefine broadType:(NSString *)type {
    //초기 디파인시 로딩인디게이터 ON
    if(isReDefine ==NO && ApplicationDelegate.appfirstLoading == NO ) {
        [ApplicationDelegate onloadingindicator];
    }
    
    if(self.currentOperation1 != nil) {
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    
    NSString* apiURL = nil;
    if (NCA([_sectioninfoDic objectForKey:@"subMenuList"]) && [(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count] > 0) {
        apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:NCS([[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkUrl"])  ];
    }
    else {
        apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:NCS([_sectioninfoDic objectForKey:@"sectionLinkUrl"])];
    }
    
    //TESTBED 서버 대응
    apiURL =  [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
    
    if ([NCS([_sectioninfoDic objectForKey:@"sectionLinkParams"]) length] > 0) {
        apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, [_sectioninfoDic objectForKey:@"sectionLinkParams"]];
        apiURL = [NSString stringWithFormat:@"%@&%@", apiURL, @"reorder=true"];
    }
    else {
        apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
    }    
#if APPSTORE
#else
    //치명
    //apiURL = [NSString stringWithFormat:@"%@&openDate=20151229010000",apiURL];
#endif
    
    //broadType LIVE / DATA
    if(type != nil) {
        apiURL = [Common_Util makeUrlWithParam:apiURL parameter:[NSString stringWithFormat:@"broadType=%@",type]];
    }
    
    // nami0342 - BRD time 적용
    NSString *strBrdTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_BRD_TIME"];
    if(NCS(strBrdTime).length > 0)
    {
        apiURL = [NSString stringWithFormat:@"%@%@", apiURL, strBrdTime];
    }
    
    //무조건 새로고침
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:YES
                                                                          onCompletion:^(NSDictionary *result) {
                                                                              self.homeSectionApiResult = result;
                                                                              NSLog(@"self.homeSectionApiResult = %@",self.homeSectionApiResult);
//                                                                              if(self.currentOperation1.isCachedResponse == YES ) {
//                                                                                  NSLog(@"캐시 리스폰스~~");
//                                                                              }
#if APPSTROE
#else
                                                                              //치명
//                                                                              NSString *xapiURL = @"";
//                                                                              if(type != nil) {
//                                                                                  xapiURL = [NSString stringWithFormat:@"%@&broadType=%@", @"http://10.52.37.213:9999/app/main/broadSchedule?version=4.8", type];
//                                                                              }
//                                                                              else {
//                                                                                  xapiURL = [NSString stringWithFormat:@"%@", @"http://10.52.37.213:9999/app/main/broadSchedule?version=4.8"];
//                                                                              }
                                                                              
//                                                                              self.homeSectionApiResult = [self loadTestApiUrl:xapiURL];
#endif
                                                                              if(self.scheduleTbv == nil) {
                                                                                  self.scheduleTbv = [[SListTBViewController alloc] initWithNibName:@"SListTBViewController" bundle:nil];
                                                                                  self.scheduleTbv.sectioninfodata = _sectioninfoDic;
                                                                                  self.scheduleTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                  self.scheduleTbv.view.frame = self.bounds;
                                                                                  self.scheduleTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                  self.scheduleTbv.delegatetarget = (id)self;
                                                                                  self.scheduleTbv.tableLeftProduct.scrollsToTop = NO;
                                                                                  //self.scheduleTbv.tableRightTimeLine.scrollsToTop = NO;
                                                                                  [self addSubview:self.scheduleTbv.view];
                                                                                  [self.scheduleTbv setResultDic:self.homeSectionApiResult withAddType:ProcessTypeReload];
                                                                              }
                                                                              else {
                                                                                  //새로고침
                                                                                  [self.scheduleTbv setResultDic:self.homeSectionApiResult withAddType:ProcessTypeReload];
                                                                              }
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  [self  bringSubviewToFront:self.btngoTop];
                                                                                  

                                                                                  
                                                                                  // nami0342 - CSP
                                                                                  // [self  bringSubviewToFront:self.btnSiren];
                                                                                  [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                  [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                  [self bringSubviewToFront:self.m_btnCSPIcon];

                                                                              });
                                                                              
                                                                              [self.scheduleTbv setScrollToTopLeftTableView];
                                                                              self.scheduleTbv.strReloadUrl = [apiURL copy];
                                                                              //새로고침 버튼이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              [ApplicationDelegate offloadingindicator];
                                                                              if(!isReDefine){
                                                                                 //어떤 섹션이든 신규 로딩이 다 불리워지고 tbv가 addsubview 된 후에 scrollstotop 제어
                                                                                  [delegatetarget latelysetscrollstotop];
                                                                              }
                                                                              
                                                                              // nami0342 - 새로고침 안내화면이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              
                                                                              
                                                                              if (NCO(self.homeSectionApiResult) == NO) {
                                                                                  //실패시 새로고침 안내뷰
                                                                                  [self.scheduleTbv.view addSubview:[self RefreshGuideView] ];
                                                                              }
                                                                          }
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   if(self.scheduleTbv == nil) {
                                                                                       self.scheduleTbv = [[SListTBViewController alloc] initWithNibName:@"SListTBViewController" bundle:nil];
                                                                                       self.scheduleTbv.sectioninfodata = _sectioninfoDic;
                                                                                       self.scheduleTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                       self.scheduleTbv.view.frame = self.bounds;
                                                                                       self.scheduleTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                       self.scheduleTbv.delegatetarget = (id)self;
                                                                                       self.scheduleTbv.tableLeftProduct.scrollsToTop = NO;
                                                                                       //self.scheduleTbv.tableRightTimeLine.scrollsToTop = NO;
                                                                                       [self addSubview:self.scheduleTbv.view];
                                                                                       [self.scheduleTbv setResultDic:self.homeSectionApiResult withAddType:ProcessTypeNetError];
                                                                                   }
                                                                                   else {
                                                                                       //새로고침
                                                                                       [self.scheduleTbv setResultDic:self.homeSectionApiResult withAddType:ProcessTypeNetError];
                                                                                       [self  bringSubviewToFront:self.btngoTop];

                                                                                       // nami0342 - CSP
                                                                                       // [self  bringSubviewToFront:self.btnSiren];
                                                                                       [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                       [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                       [self bringSubviewToFront:self.m_btnCSPIcon];

                                                                                   }
                                                                                   [self.scheduleTbv setScrollToTopLeftTableView];
                                                                                   //새로고침 안내화면이 있다면 삭제
                                                                                   [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                                   self.scheduleTbv.strReloadUrl = [apiURL copy];
                                                                                   //실패시 새로고침 안내뷰
                                                                                   [self.scheduleTbv.view addSubview:[self RefreshGuideView] ];
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                               }];
}

@end
