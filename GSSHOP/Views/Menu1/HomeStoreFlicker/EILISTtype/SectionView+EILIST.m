//
//  SectionView+EILIST.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 25..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+EILIST.h"
#import "EIListPSCViewController.h"

@implementation SectionView (EILIST)


- (void)ScreenDefineEILIST{
    [self ScreenDefineEIWith:NO];
}
- (void)ScreenReDefineEILIST{
    [self ScreenDefineEIWith:YES];
}

- (void)ScreenDefineEIWith:(BOOL)isReDefine{
    //초기 디파인시 로딩인디게이터 ON
    if(isReDefine ==NO && ApplicationDelegate.appfirstLoading == NO ) {
        [ApplicationDelegate onloadingindicator];
    }
    
    if(self.currentOperation1 != nil){
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    
    NSString* apiURL = nil;
    

    apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:NCS([_sectioninfoDic objectForKey:@"sectionLinkUrl"])];

    
    
    //TESTBED 서버 대응
    apiURL =  [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    
    /*
     if ([(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count] > 0) {
     
     NSLog(@"[_sectioninfoDic objectForKey:@subMenuList] count] =%lu",(long)[(NSArray *)[_sectioninfoDic objectForKey:@"subMenuList"] count]);
     
     if (NCO([[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex]) && [NCS([[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkParams"]) length] > 0) {
     
     apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, [[[_sectioninfoDic objectForKey:@"subMenuList"] objectAtIndex:self.currentCateinfoindex] objectForKey:@"sectionLinkParams"] ];
     
     
     
     apiURL = [NSString stringWithFormat:@"%@&%@", apiURL, @"reorder=true"];
     
     
     
     }else {
     apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
     }
     
     
     
     
     }else{
     
     
     */
    if ([NCS([_sectioninfoDic objectForKey:@"sectionLinkParams"]) length] > 0) {
        
        apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, [_sectioninfoDic objectForKey:@"sectionLinkParams"]];
        
        apiURL = [NSString stringWithFormat:@"%@&%@", apiURL, @"reorder=true"];
        
        
    }else {
        apiURL = [NSString stringWithFormat:@"%@?%@", apiURL, @"reorder=true"];
    }
    //    }
    
    
    
    apiURL = [self checkAdidRequest:apiURL];
    
    NSLog(@"apiURL = %@",apiURL);
    
    // nami0342 - urlsession
    //무조건 새로고침
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core   gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:isReDefine
                                                                          onCompletion:^(NSDictionary *result)   {
                                                                              
                                                                              self.homeSectionApiResult = result;
                                                                              
//                                                                              if(self.currentOperation1.isCachedResponse == NO ) {
//                                                                              }else {
//                                                                                  NSLog(@"캐심");
//                                                                              }
                                                                              
                                                                              
                                                                              
                                                                              if(self.eiPcv == nil){
                                                                                  
                                                                                  NSLog(@"");
                                                                                  
                                                                                  self.eiPcv = [[EIListPSCViewController alloc] initWithSectioninfo:_sectioninfoDic ];
                                                                                  self.eiPcv.sectionView = self;
                                                                                  //임시
                                                                                  
                                                                                  
                                                                                  if (NCA([self.homeSectionApiResult objectForKey:@"productList"])) {
                                                                                      
                                                                                      NSArray *arrPrdList = (NSArray *)[self.homeSectionApiResult objectForKey:@"productList"];
                                                                                      
                                                                                      if([arrPrdList count] > self.currentCateinfoindex &&
                                                                                         NCO([arrPrdList objectAtIndex:self.currentCateinfoindex]) &&
                                                                                         [[arrPrdList objectAtIndex:self.currentCateinfoindex] isKindOfClass:[NSDictionary class]]){
                                                                                          
                                                                                          NSDictionary *dicForViewType = (NSDictionary *)[arrPrdList objectAtIndex:self.currentCateinfoindex];
                                                                                          
                                                                                          if([NCS([dicForViewType objectForKey:@"viewType"]) isEqualToString:@"SUB_EVT_HOME"]){
                                                                                              
                                                                                              self.eiPcv.tableViewType = collectionType;
                                                                                          }else{
                                                                                              self.eiPcv.tableViewType = tableType;
                                                                                          };
                                                                                          
                                                                                      }
                                                                                      
                                                                                      
                                                                                  }else{
                                                                                      self.eiPcv.tableViewType = tableType;
                                                                                  }
                                                                                  
                                                                                  
                                                                                  [self addSubview:self.eiPcv.view];
                                                                                  self.eiPcv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                  self.eiPcv.view.frame = self.bounds;
                                                                                  
                                                                                  self.eiPcv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                  
                                                                                  
                                                                                  self.eiPcv.delegatetarget = (id)self;
                                                                                  self.eiPcv.pscView.scrollsToTop = NO;
                                                                                  self.eiPcv.eiTableView.scrollsToTop = NO;
                                                                                  
                                                                                  self.eiPcv.apiResultDic = self.homeSectionApiResult;
                                                                                  
                                                                                  
                                                                                  
                                                                                  
                                                                              }else {
                                                                                  
                                                                                  if (NCA([self.homeSectionApiResult objectForKey:@"productList"])) {
                                                                                      
                                                                                      NSArray *arrPrdList = (NSArray *)[self.homeSectionApiResult objectForKey:@"productList"];
                                                                                      
                                                                                      if([arrPrdList count] > self.currentCateinfoindex &&
                                                                                         NCO([arrPrdList objectAtIndex:self.currentCateinfoindex]) &&
                                                                                         [[arrPrdList objectAtIndex:self.currentCateinfoindex] isKindOfClass:[NSDictionary class]]){
                                                                                          
                                                                                          NSDictionary *dicForViewType = (NSDictionary *)[arrPrdList objectAtIndex:self.currentCateinfoindex];
                                                                                          
                                                                                          if([NCS([dicForViewType objectForKey:@"viewType"]) isEqualToString:@"SUB_EVT_HOME"]){
                                                                                              
                                                                                              self.eiPcv.tableViewType = collectionType;
                                                                                          }else{
                                                                                              self.eiPcv.tableViewType = tableType;
                                                                                          };
                                                                                          
                                                                                      }
                                                                                      
                                                                                      
                                                                                  }else{
                                                                                      NSLog(@"");
                                                                                      self.eiPcv.tableViewType = tableType;
                                                                                  }
                                                                                  
                                                                                  self.eiPcv.apiResultDic = self.homeSectionApiResult;
                                                                                  
                                                                                  NSLog(@"새로고침요");
                                                                                  
                                                                                  [self.eiPcv reloadAction];
                                                                                  
                                                                                  
                                                                                  
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
                                                                              
                                                                              // nami0342 - 새로고침 안내화면이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                          }
                              
                              
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   
                                                                                   //새로고침실패시 테이블 컨텐츠 제거를 위한
                                                                                   self.eiPcv.apiResultDic = nil;
                                                                                   
                                                                                   
                                                                                   if(self.eiPcv == nil){
                                                                                       
                                                                                       self.eiPcv = [[EIListPSCViewController alloc] initWithSectioninfo:_sectioninfoDic ];
                                                                                       
                                                                                       self.eiPcv.sectionView = self;
                                                                                       
                                                                                       
                                                                                       if (NCA([self.homeSectionApiResult objectForKey:@"productList"])) {
                                                                                           
                                                                                           NSArray *arrPrdList = (NSArray *)[self.homeSectionApiResult objectForKey:@"productList"];
                                                                                           
                                                                                           if([arrPrdList count] > self.currentCateinfoindex &&
                                                                                              NCO([arrPrdList objectAtIndex:self.currentCateinfoindex]) &&
                                                                                              [[arrPrdList objectAtIndex:self.currentCateinfoindex] isKindOfClass:[NSDictionary class]]){
                                                                                               
                                                                                               NSDictionary *dicForViewType = (NSDictionary *)[arrPrdList objectAtIndex:self.currentCateinfoindex];
                                                                                               
                                                                                               if([NCS([dicForViewType objectForKey:@"viewType"]) isEqualToString:@"SUB_EVT_HOME"]){
                                                                                                   
                                                                                                   self.eiPcv.tableViewType = collectionType;
                                                                                               }else{
                                                                                                   self.eiPcv.tableViewType = tableType;
                                                                                               };
                                                                                               
                                                                                           }
                                                                                           
                                                                                           
                                                                                       }else{
                                                                                           self.eiPcv.tableViewType = tableType;
                                                                                       }
                                                                                       
                                                                                       
                                                                                       self.eiPcv.apiResultDic = self.homeSectionApiResult;
                                                                                       
                                                                                       self.eiPcv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                       self.eiPcv.view.frame = self.bounds;
                                                                                       
                                                                                       self.eiPcv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                       
                                                                                       self.eiPcv.delegatetarget = (id)self;
                                                                                       self.eiPcv.pscView.scrollsToTop = NO;
                                                                                       self.eiPcv.eiTableView.scrollsToTop = NO;
                                                                                       
                                                                                       [self addSubview:self.eiPcv.view];
                                                                                       [self.eiPcv reloadAction];
                                                                                       
                                                                                       if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                       {
                                                                                           [self  bringSubviewToFront:self.homeHeaderView];
                                                                                       }
                                                                                       
                                                                                   }else {
                                                                                       if (NCA([self.homeSectionApiResult objectForKey:@"productList"])) {
                                                                                           
                                                                                           NSArray *arrPrdList = (NSArray *)[self.homeSectionApiResult objectForKey:@"productList"];
                                                                                           
                                                                                           if([arrPrdList count] > self.currentCateinfoindex &&
                                                                                              NCO([arrPrdList objectAtIndex:self.currentCateinfoindex]) &&
                                                                                              [[arrPrdList objectAtIndex:self.currentCateinfoindex] isKindOfClass:[NSDictionary class]]){
                                                                                               
                                                                                               NSDictionary *dicForViewType = (NSDictionary *)[arrPrdList objectAtIndex:self.currentCateinfoindex];
                                                                                               
                                                                                               if([NCS([dicForViewType objectForKey:@"viewType"]) isEqualToString:@"SUB_EVT_HOME"]){
                                                                                                   
                                                                                                   self.eiPcv.tableViewType = collectionType;
                                                                                               }else{
                                                                                                   self.eiPcv.tableViewType = tableType;
                                                                                               };
                                                                                               
                                                                                           }
                                                                                           
                                                                                           
                                                                                       }else{
                                                                                           self.eiPcv.tableViewType = tableType;
                                                                                       }
                                                                                       
                                                                                       self.eiPcv.apiResultDic = self.homeSectionApiResult;
                                                                                       
                                                                                       
                                                                                       [self.eiPcv reloadAction];
                                                                                       
                                                                                   }
                                                                                   
                                                                                   [self  bringSubviewToFront:self.btngoTop];
                                                         

                                                                                   // nami0342 - CSP
                                                                                   // [self  bringSubviewToFront:self.btnSiren];
                                                                                   [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                   [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                   [self bringSubviewToFront:self.m_btnCSPIcon];

                                                                                   
                                                                                   //새로고침 안내화면이 있다면 삭제
                                                                                   [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                                   
                                                                                   
                                                                                   //실패시 새로고침 안내뷰
                                                                                   [self.eiPcv.view addSubview:[self RefreshGuideView] ];
                                                                                   
                                                                                   [ApplicationDelegate offloadingindicator];
                                                                                   
                                                                               }];
    
}

//protocol method
-(void)RELOADEICATEGORYWITHTAG:(NSNumber*)tnum{
    self.currentCateinfoindex = [tnum intValue];
    
    if (NCA([self.homeSectionApiResult objectForKey:@"productList"])) {
        
        NSArray *arrPrdList = (NSArray *)[self.homeSectionApiResult objectForKey:@"productList"];
        
        if([arrPrdList count] > self.currentCateinfoindex &&
           NCO([arrPrdList objectAtIndex:self.currentCateinfoindex]) &&
           [[arrPrdList objectAtIndex:self.currentCateinfoindex] isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *dicForViewType = (NSDictionary *)[arrPrdList objectAtIndex:self.currentCateinfoindex];
            
            @try {
                
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_Tab", [_sectioninfoDic objectForKey:@"sectionName"] ]
                                       withLabel: [NSString stringWithFormat:@"%d_%@", (int)self.currentCateinfoindex, [dicForViewType objectForKey:@"productName"]]
                 ];
                
                
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"tab Change Exception: %@", exception);
            }
            @finally {
                
            }
            
    
        }
    }
    
    
    
    [self  ScreenReDefineEILIST];
    
    [ApplicationDelegate offloadingindicator];
    
    
    
}




@end
