//
//  SectionView+FXCLIST.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 23..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+FXCLIST.h"
#import "FXCListTBViewController.h"

@implementation SectionView (FXCLIST)

- (void)ScreenDefineFXCLIST
{
    
    [self ScreenDefineFXCWith:NO];
}


- (void)ScreenReDefineFXCLIST
{
    [self ScreenDefineFXCWith:YES];
}



- (void)ScreenDefineFXCWith:(BOOL)isReDefine {
    
    //초기 디파인시 로딩인디게이터 ON
    if(isReDefine ==NO && ApplicationDelegate.appfirstLoading == NO ) {
        [ApplicationDelegate onloadingindicator];
    }
    
    //20190227 parksegun GS X 브랜드는 캐시 안함.
    //("navigationId": 210)
    if([[_sectioninfoDic objectForKey:@"navigationId"] isEqualToNumber:[NSNumber numberWithInt:210]]) {
        isReDefine = YES;
    }
    
    if(self.currentOperation1 != nil){
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
       
    NSString* apiURL = nil;
    
    if (NCA([_sectioninfoDic objectForKey:@"subMenuList"]) && [(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count] > 0) {
        apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:[[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkUrl"]  ];
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
    
        if (NCA([_sectioninfoDic objectForKey:@"subMenuList"]) && [(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count] > 0) {
            NSLog(@"[_sectioninfoDic objectForKey:@subMenuList] count] =%lu",(long)[(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count]);
            if (NCO([[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex]) && [NCS([[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkParams"]) length] > 0) {
                apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, [[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkParams"] ];
                apiURL = [NSString stringWithFormat:@"%@&%@", apiURL, @"reorder=true"];
            }
            else {
                apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
            }
            
        }
        else {
            if ([NCS([_sectioninfoDic objectForKey:@"sectionLinkParams"]) length] > 0) {
                apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, [_sectioninfoDic objectForKey:@"sectionLinkParams"]];
                apiURL = [NSString stringWithFormat:@"%@&%@", apiURL, @"reorder=true"];
            }
            else {
                apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
            }
        }
    
    //20180711 parksegun 푸시정보 요청 파라메터 pushReceiveYn=
    if([Mocha_Util strContain:@"pushReceiveYn=" srcstring:apiURL]) {
        NSURLComponents *components = [NSURLComponents componentsWithString:apiURL];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSURLQueryItem * newQueryItem = [[NSURLQueryItem alloc] initWithName:@"pushReceiveYn" value:[userDefaults valueForKey:GS_PUSH_RECEIVE]];
        NSMutableArray * newQueryItems = [NSMutableArray arrayWithCapacity:[components.queryItems count] + 1];
        for (NSURLQueryItem * qi in components.queryItems) {
            if (![qi.name isEqual:newQueryItem.name]) {
                [newQueryItems addObject:qi];
            }
        }
        [newQueryItems addObject:newQueryItem];
        [components setQueryItems:newQueryItems];
        apiURL = components.string;
        //2019 캐싱 재적용
        //isReDefine = YES; //캐싱하면 안됨.. /로그인이나, 설정 변경시 갱신됨.
        //NSLog(@"GS_PUSH_RECEIVE : %@",[userDefaults valueForKey:GS_PUSH_RECEIVE]);
        //NSLog(@"GS_PUSH_RECEIVE apiURL : %@",apiURL);
    }
    
    apiURL = [self checkAdidRequest:apiURL];
    
#if APPSTORE
#else
    //치명
    //apiURL = [NSString stringWithFormat:@"%@&openDate=20151229010000",apiURL];
#endif
    
    
    // nami0342 - urlsession
    //무조건 새로고침
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:isReDefine
                                                                          onCompletion:^(NSDictionary *result)   {
                                                                              
                                                                              self.homeSectionApiResult = result;
#if APPSTROE
#else
//
//                                                                              self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.38.223:8080/app/section/flxblTab.gs?naviId=444&version=3.8&pageIdx=1&pageSize=400&openDate=20170830000000"];
#endif
                                                                              
                                                                              //NSLog(@"self.homeSectionApiResult = %@",self.homeSectionApiResult);
                                                                              
//                                                                              if(self.currentOperation1.isCachedResponse == NO ) {
//                                                                              }
//                                                                              else {
//                                                                                  NSLog(@"캐싱");
//                                                                              }
                                                                              
                                                                              
                                                                              
//                                                                              NSLog(@"HOME EACH SECTION LIST \n%@", result);
                                                                              if(self.fxcTbv == nil) {
                                                                                  
                                                                                  self.fxcTbv = [[FXCListTBViewController alloc] initWithSectionResult:self.homeSectionApiResult  sectioninfo:_sectioninfoDic ];
                                                                                  self.fxcTbv.sectionView = self;
                                                                                  self.fxcTbv.indexFXC = self.currentCateinfoindex;
                                                                                  
                                                                                  [self.fxcTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                  self.fxcTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                  self.fxcTbv.view.frame = self.bounds;
                                                                                  self.fxcTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                  
                                                                                  
                                                                                  self.fxcTbv.delegatetarget = (id)self;
                                                                                  self.fxcTbv.tableView.scrollsToTop = NO;
                                                                                  
                                                                                  [self addSubview:self.fxcTbv.view];
                                                                                  
                                                                                  
                                                                                  
                                                                              }
                                                                              else
                                                                              {
                                                                                  //새로고침
                                                                                  self.fxcTbv.apiResultDic = self.homeSectionApiResult;
                                                                                  
                                                                                  self.fxcTbv.indexFXC = self.currentCateinfoindex;
                                                                                  
                                                                                  [self.fxcTbv reloadAction];
                                                                              }
                                                                              
                                                                              [self  bringSubviewToFront:self.btngoTop];
                                                                              

                                                                              
                                                                              // nami0342 - CSP
                                                                              // [self  bringSubviewToFront:self.btnSiren];
                                                                              [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                              [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                              [self bringSubviewToFront:self.m_btnCSPIcon];

                                                                              
                                                                              //새로고침 버튼이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              
                                                                              
                                                                              [self.fxcTbv checkFPCMenu];
                                                                              
                                                                              [ApplicationDelegate offloadingindicator];
                                                                              
                                                                              // nami0342 - 새로고침 안내화면이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              
                                                                          }
                              
                              
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   
                                                                                   //새로고침실패시 테이블 컨텐츠 제거를 위한
                                                                                   self.fxcTbv.apiResultDic = nil;
                                                                                   
                                                                                   
                                                                                   
                                                                                   if(self.fxcTbv == nil){
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       self.fxcTbv = [[FXCListTBViewController alloc] initWithSectionResult:nil sectioninfo:_sectioninfoDic ];
                                                                                       
                                                                                       
                                                                                       
                                                                                       [self.fxcTbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                       
                                                                                       self.fxcTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                       self.fxcTbv.view.frame = self.bounds;
                                                                                       
                                                                                       self.fxcTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                       
                                                                                       self.fxcTbv.delegatetarget = (id)self;
                                                                                       self.fxcTbv.tableView.scrollsToTop = NO;
                                                                                       

                                                                                       
                                                                                       [self addSubview:self.fxcTbv.view];
                                                                                       
                                                                                       if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                       {
                                                                                           [self  bringSubviewToFront:self.homeHeaderView];
                                                                                       }
                                                                                       
                                                                                   }else {
                                                                                       //새로고침
                                                                                       [self.fxcTbv reloadAction];
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
                                                                                   [self.fxcTbv.view addSubview:[self RefreshGuideView] ];
                                                                                   
                                                                                   
                                                                                   [self.fxcTbv checkFPCMenu];
                                                                                   
                                                                                   
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                                   
                                                                               }];
        
}



#pragma Protocol Method
//선택타입 선택
-(void)SELECTEDFXCCATEGORYWITHTAG:(NSNumber*)tnum; {

    
    self.currentCateinfoindex = [tnum intValue];
    [self  ScreenDefineFXCLIST];
//    [ApplicationDelegate offloadingindicator];
    
    
    @try {
        
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_%@_Tab", [_sectioninfoDic objectForKey:@"sectionName"] ]
                               withLabel: [NSString stringWithFormat:@"%d_%@", (int)self.currentCateinfoindex, [[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionName"]]
         ];
        
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"tab Change Exception: %@", exception);
    }
    @finally {
        
    }
    
    NSLog(@"[[[_sectioninfoDic objectForKey:@subMenuList] objectAtIndex:self.currentCateinfoindex] objectForKey:@wiseLogUrl] = %@",[[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"wiseLogUrl"]);
    ////탭바제거
    [ApplicationDelegate wiseAPPLogRequest:[[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"wiseLogUrl"]];
}




@end
