//
//  SectionView+VODLIST.m
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 4. 8..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+VODLIST.h"
#import "VODListTableViewController.h"

@implementation SectionView (VODLIST)

- (void)ScreenDefineVODLIST{
    [self ScreenDefineVODLISTWith:NO];
}

- (void)ScreenReDefineVODLIST{
    [self ScreenDefineVODLISTWith:YES];
}

- (void)ScreenDefineVODLISTWith:(BOOL)isReDefine{
    
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
    
    apiURL = [self checkAdidRequest:apiURL];
    
#if APPSTORE
#else
    //치명
    //apiURL = [NSString stringWithFormat:@"%@&openDate=20151229010000",apiURL];
#endif
    
    
    // nami0342 - urlsession
    //무조건 새로고침
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                       isForceReload:YES
                                                                        onCompletion:^(NSDictionary *result) {
                                                                            self.homeSectionApiResult = result;
                                                                            //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.37.213:9999/app/main/tommBroad"];

                                                                            self.clipsToBounds = YES;
                                                                            
                                                                            if(self.vodTbv == nil) {
                                                                                self.vodTbv = [[VODListTableViewController alloc] initWithSectionResult:self.homeSectionApiResult sectioninfo:_sectioninfoDic];
                                                                                //self.vodTbv.sectioninfodata = _sectioninfoDic;
                                                                                
                                                                                self.vodTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                self.vodTbv.view.frame = self.bounds;
                                                                                self.vodTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                
                                                                                self.vodTbv.delegatetarget = (id)self;
                                                                                [self addSubview:self.vodTbv.view];
                                                                                NSLog(@"self.frameself.frame = %@",NSStringFromCGRect(self.frame));
                                                                                
                                                                            }
                                                                            else {
                                                                                //새로고침
                                                                                [self.vodTbv setApiResultDic:self.homeSectionApiResult];
                                                                                [self.vodTbv reloadAction];
                                                                            }
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                [self  bringSubviewToFront:self.btngoTop];
                                                                                
                                                                                
                                                                                // nami0342 - CSP
                                                                                //                                                                                  [self  bringSubviewToFront:self.btnSiren];
                                                                                [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                [self bringSubviewToFront:self.m_btnCSPIcon];
                                                                                
                                                                            });
                                                                            //새로고침 버튼이 있다면 삭제
                                                                            [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                            [ApplicationDelegate offloadingindicator];
                                                                            if(!isReDefine){
                                                                                //어떤 섹션이든 신규 로딩이 다 불리워지고 tbv가 addsubview 된 후에 scrollstotop 제어
                                                                                [delegatetarget latelysetscrollstotop];
                                                                            }
                                                                             
                                                                            // nami0342 - 새로고침 안내화면이 있다면 삭제
                                                                            [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                        }
                                                                             onError:^(NSError* error) {
                                                                                 NSLog(@"COMM ERROR");
                                                                                 
                                                                                 self.homeSectionApiResult = nil;
                                                                                 if(self.vodTbv == nil) {
                                                                                     self.vodTbv = [[VODListTableViewController alloc] initWithSectionResult:self.homeSectionApiResult sectioninfo:_sectioninfoDic];
                                                                                     self.vodTbv.sectioninfodata = _sectioninfoDic;
                                                                                     
                                                                                     self.vodTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                     self.vodTbv.view.frame = self.bounds;
                                                                                     self.vodTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                     
                                                                                     self.vodTbv.delegatetarget = (id)self;
                                                                                     [self addSubview:self.vodTbv.view];
                                                                                     NSLog(@"self.frameself.frame = %@",NSStringFromCGRect(self.frame));
                                                                                     
                                                                                 }
                                                                                 else {
                                                                                     //새로고침
                                                                                     [self.vodTbv setApiResultDic:self.homeSectionApiResult];
                                                                                     [self.vodTbv reloadAction];
                                                                                 }
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     [self  bringSubviewToFront:self.btngoTop];
                                                                                     
                                                                                     
                                                                                     // nami0342 - CSP
                                                                                     //                                                                                  [self  bringSubviewToFront:self.btnSiren];
                                                                                     [self bringSubviewToFront:self.m_btnMessageNLink];
                                                                                     [self bringSubviewToFront:self.m_btnMessageNLink2];
                                                                                     [self bringSubviewToFront:self.m_btnCSPIcon];
                                                                                     
                                                                                 });
                                                                                 
                                                                                 
                                                                                  //새로고침 안내화면이 있다면 삭제
                                                                                  [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                                  //실패시 새로고침 안내뷰
                                                                                  [self.vodTbv.view addSubview:[self RefreshGuideView] ];
                                                                                  
                                                                                 
                                                                                 [ApplicationDelegate offloadingindicator];
                                                                             }];
}

//프로팅 시킬 뷰
- (void)headerFlowViewDisplay:(BOOL)disp headerView:(UIView *) viewORD {
    
    if(self.headerFlowView == nil) {
        self.headerFlowView = [[UIView alloc] init];
        //self.headerFlowView.backgroundColor = [UIColor greenColor];
        self.headerFlowView.frame = CGRectMake(0, 0, APPFULLWIDTH, viewORD.frame.size.height);
        self.headerFlowView.hidden = YES;
        [self addSubview:self.headerFlowView];
    }
    if(disp) {
        if (self.headerFlowView.frame.origin.y == 0.0) {
            return;
        }
        self.headerFlowView.hidden = NO;
        [self.headerFlowView addSubview:viewORD];
        [UIView animateWithDuration:0.25 animations:^{
            self.headerFlowView.frame = CGRectMake(0, 0, APPFULLWIDTH, viewORD.frame.size.height);
        }];
        
    }
    else {
        if(self.headerFlowView.frame.origin.y == -self.headerFlowView.frame.size.height) {
            return;
        }
        [UIView animateWithDuration:0.25 animations:^{
                self.headerFlowView.frame = CGRectMake(0, -viewORD.frame.size.height, APPFULLWIDTH, viewORD.frame.size.height);
            }
            completion:^(BOOL finished) {
                self.headerFlowView.hidden = YES;
            }
         ];
    }
}

@end
