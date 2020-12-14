//
//  SectionView+NSTFCLIST.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+NSTFCLIST.h"
#import "NSTFCListTBViewController.h"

@implementation SectionView (NSTFCLIST)

- (void)ScreenDefineNSTFCLIST{
    [self ScreenDefineNSTFCWith:NO];
}
- (void)ScreenReDefineNSTFCLIST{
    [self ScreenDefineNSTFCWith:YES];
}
- (void)ScreenDefineNSTFCWith:(BOOL)isReDefine{
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
    }else {
        apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
    }
    
    apiURL = [self checkAdidRequest:apiURL];
    
#if APPSTORE
#else
    //치명
    //apiURL = [NSString stringWithFormat:@"%@&openDate=20151229010000",apiURL];
#endif
    
    
//    날방 리스트
//    http://10.52.164.237/test/app/nalbang.jsp
//    날방 상세 리스트
//    http://10.52.164.237/test/app/nalbang2.jsp
    
    
    // nami0342 - urlsession
    //무조건 새로고침
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:isReDefine
                                                                          onCompletion:^(NSDictionary *result)   {
                                                                              
                                                                              self.homeSectionApiResult = result;

//                                                                              if(self.currentOperation1.isCachedResponse == YES ) {
//                                                                                  NSLog(@"캐시 리스폰스~~");
//                                                                              }
                                                                              
#if APPSTROE
#else
                                                                              //치명
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.164.237/test/app/videobanglist2.jsp"];
#endif
                                                                              
                                                                              
                                                                              
                                                                              
                                                                              if(self.shortTbv == nil){
                                                                                  
                                                                                  //self.shortTbv = [[NSTFCListTBViewController alloc] initWithSectionResult:self.homeSectionApiResult  sectioninfo:_sectioninfoDic ];
                                                                                  
                                                                                  self.shortTbv = [[NSTFCListTBViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                                                                  self.shortTbv.apiResultDic = self.homeSectionApiResult;
                                                                                  self.shortTbv.sectioninfodata = _sectioninfoDic;
                                                                                  
                                                                                  self.shortTbv.sectionView = self;
                                                                                  
                                                                                  
                                                                                  [self.shortTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                  
                                                                                  self.shortTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                  self.shortTbv.view.frame = self.bounds;
                                                                                  
                                                                                  self.shortTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                  
                                                                                  
                                                                                  self.shortTbv.delegatetarget = (id)self;
                                                                                  self.shortTbv.tableView.scrollsToTop = NO;
                                                                                  
                                                                                  [self addSubview:self.shortTbv.view];
                                                                                  
                                                                                  
                                                                                  
                                                                              }else {
                                                                                  //새로고침
                                                                                  
                                                                                  
                                                                                  self.shortTbv.apiResultDic = self.homeSectionApiResult;
                                                                                  
                                                                                  [self.shortTbv reloadAction];
                                                                                  
                                                                                  
                                                                                  
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
                                                                                   self.shortTbv.apiResultDic = nil;
                                                                                   
                                                                                   
                                                                                   
                                                                                   if(self.shortTbv == nil){
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       self.shortTbv = [[NSTFCListTBViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                                                                       self.shortTbv.apiResultDic = self.homeSectionApiResult;
                                                                                       self.shortTbv.sectioninfodata = _sectioninfoDic;
                                                                                       
                                                                                       self.shortTbv.sectionView = self;
                                                                                       
                                                                                       
                                                                                       [self.shortTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                       
                                                                                       self.shortTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                       self.shortTbv.view.frame = self.bounds;
                                                                                       
                                                                                       self.shortTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                       
                                                                                       self.shortTbv.delegatetarget = (id)self;
                                                                                       self.shortTbv.tableView.scrollsToTop = NO;
                                                                                       
                                                                                       
                                                                                       [self addSubview:self.shortTbv.view];
                                                                                       
                                                                                       if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                       {
                                                                                           [self  bringSubviewToFront:self.homeHeaderView];
                                                                                       }
                                                                                       
                                                                                   }else {
                                                                                       //새로고침
                                                                                       [self.shortTbv reloadAction];
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
                                                                                   [self.shortTbv.view addSubview:[self RefreshGuideView] ];
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                                   
                                                                               }];
    
    
    
}



@end
