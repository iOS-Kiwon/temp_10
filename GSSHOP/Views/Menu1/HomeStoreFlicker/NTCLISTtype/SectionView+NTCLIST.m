//
//  SectionView+NTCLIST.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+NTCLIST.h"
#import "NTCListTBViewController.h"

@implementation SectionView (NTCLIST)
- (void)ScreenDefineNTCLIST{
    [self ScreenDefineNTCWith:NO];
}
- (void)ScreenReDefineNTCLIST{
    [self ScreenDefineNTCWith:YES];
}
- (void)ScreenDefineNTCWith:(BOOL)isReDefine{
    //초기 디파인시 로딩인디게이터 ON
    if(isReDefine ==NO && ApplicationDelegate.appfirstLoading == NO ) {
        [ApplicationDelegate onloadingindicator];
    }
    
    if(self.currentOperation1 != nil){
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    
    NSString* apiURL = nil;
    
    if (NCA([_sectioninfoDic objectForKey:@"subMenuList"]) && [(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count] > 0) {
        apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:NCS([[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkUrl"])  ];
    }else{
        apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:NCS([_sectioninfoDic objectForKey:@"sectionLinkUrl"]) ];
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
    }else {
        apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
    }
    
    apiURL = [self checkAdidRequest:apiURL];
    
#if APPSTORE
#else
    //치명
    //apiURL = [NSString stringWithFormat:@"%@&openDate=20151229010000",apiURL];
#endif
    
    
    //무조건 새로고침
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:isReDefine
                                                                          onCompletion:^(NSDictionary *result)   {
                                                                              
                                                                              self.homeSectionApiResult = result;
#if APPSTROE
#else
                                                                              //치명
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.214.181/app/main/deptShop?version=2.9&pageIdx=1&pageSize=400&naviId=209"];
#endif
                                                                              
                                                                              
//                                                                              if(self.currentOperation1.isCachedResponse == YES ) {
//                                                                                  NSLog(@"캐시 리스폰스~~");
//                                                                              }
                                                                              
                                                                              
                                                                              
                                                                              if(self.nalTbv == nil){
                                                                                  
                                                                                  self.nalTbv = [[NTCListTBViewController alloc] initWithSectionResult:self.homeSectionApiResult  sectioninfo:_sectioninfoDic ];
                                                                                  self.nalTbv.sectionView = self;
                                                                                  
                                                                                  
                                                                                  [self.nalTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                  
                                                                                  self.nalTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                  self.nalTbv.view.frame = self.bounds;
                                                                                  
                                                                                  self.nalTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                  
                                                                                  
                                                                                  self.nalTbv.delegatetarget = (id)self;
                                                                                  self.nalTbv.tableView.scrollsToTop = NO;
                                                                                  
                                                                                  [self addSubview:self.nalTbv.view];
                                                                                  
                                                                                  
                                                                                  
                                                                              }else {
                                                                                  //새로고침
                                                                                  
                                                                                  
                                                                                  self.nalTbv.apiResultDic = self.homeSectionApiResult;
                                                                                  
                                                                                  [self.nalTbv reloadAction];
                                                                                  
                                                                                  
                                                                                  
                                                                              }
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  [self  bringSubviewToFront:self.btngoTop];
                                                                                  

                                                                                  
                                                                                  // nami0342 - CSP
                                                                                  // [self  bringSubviewToFront:self.btnSiren];
                                                                                  [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                  [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                  [self bringSubviewToFront:self.m_btnCSPIcon];

                                                                              });
                                                                              
                                                                              
                                                                              //새로고침 버튼이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              
                                                                              [ApplicationDelegate offloadingindicator];
                                                                              
                                                                              // nami0342 - 새로고침 안내화면이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                          }
                              
                              
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   
                                                                                   //새로고침실패시 테이블 컨텐츠 제거를 위한
                                                                                   self.nalTbv.apiResultDic = nil;
                                                                                   
                                                                                   
                                                                                   
                                                                                   if(self.nalTbv == nil){
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       self.nalTbv = [[NTCListTBViewController alloc] initWithSectionResult:nil sectioninfo:_sectioninfoDic ];
                                                                                       
                                                                                       
                                                                                       
                                                                                       [self.nalTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                       
                                                                                       self.nalTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                       self.nalTbv.view.frame = self.bounds;
                                                                                       
                                                                                       self.nalTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                       
                                                                                       self.nalTbv.delegatetarget = (id)self;
                                                                                       self.nalTbv.tableView.scrollsToTop = NO;
                                                                                       
                                                                                       
                                                                                       [self addSubview:self.nalTbv.view];
                                                                                       
                                                                                       if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                       {
                                                                                           [self  bringSubviewToFront:self.homeHeaderView];
                                                                                       }
                                                                                       
                                                                                   }else {
                                                                                       //새로고침
                                                                                       [self.nalTbv reloadAction];
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
                                                                                   [self.nalTbv.view addSubview:[self RefreshGuideView] ];
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                                   
                                                                               }];
        
    
    
}


@end
