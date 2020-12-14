//
//  SectionView+SUPLIST.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionView+SUPLIST.h"
#import "SUPListTableViewController.h"

@implementation SectionView (SUPLIST)

- (void)ScreenDefineSUPLIST{
    [self ScreenDefineSUPLISTWith:NO];
}

- (void)ScreenReDefineSUPLIST{
    [self ScreenDefineSUPLISTWith:YES];
}

- (void)ScreenDefineSUPLISTWith:(BOOL)isReDefine{
    NSLog(@"ScreenDefineSUPLISTWith");
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

    NSString *strMartDeliFlag = NCS([CooKieDBManager getMartDeliFlag]);
    if ([strMartDeliFlag length] > 0) {
        apiURL = [NSString stringWithFormat:@"%@&martDeliFlag=%@", apiURL, strMartDeliFlag];
    }
    
    NSLog(@"!!!!apiURLapiURLapiURL = %@",apiURL);
    // nami0342 - urlsession
    //무조건 새로고침
     self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                       isForceReload:YES
                                                                        onCompletion:^(NSDictionary *result) {
                                                                            self.homeSectionApiResult = result;
//                                                                            if(self.currentOperation1.isCachedResponse == YES ) {
//                                                                                NSLog(@"캐시 리스폰스~~");
//                                                                            }
                                                                            
#if APPSTROE
#else
                                                                            //치명
                                                                            //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.38.223:8080/app//main/CollaboShop.gs?companyCd=29CM"];
                                                                            //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.37.213:9999/app/main/broadSchedule"];
                                                                            //self.homeSectionApiResult = [self loadTestApiUrl:@"http://sm20.gsshop.com/app/main/broadSchedule"];
#endif
                                                                            
                                                                            if(self.supTbv == nil) {
                                                                                self.supTbv = [[SUPListTableViewController alloc] initWithNibName:@"SUPListTableViewController" bundle:nil];
                                                                                self.supTbv.sectioninfodata = _sectioninfoDic;
                                                                                
                                                                                self.supTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                self.supTbv.view.frame = self.bounds;
                                                                                self.supTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                
                                                                                self.supTbv.delegatetarget = (id)self;
                                                                                [self addSubview:self.supTbv.view];
                                                                                NSLog(@"self.frameself.frame = %@",NSStringFromCGRect(self.frame));
                                                                                [self.supTbv setResultDic:self.homeSectionApiResult];
                                                                            }
                                                                            else {
                                                                                //새로고침
                                                                                [self.supTbv setResultDic:self.homeSectionApiResult];
                                                                                [self.supTbv reloadAction];
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
                                                                                 if(self.supTbv == nil) {
                                                                                     self.supTbv = [[SUPListTableViewController alloc] initWithNibName:@"SUPListTableViewController" bundle:nil];
                                                                                     self.supTbv.sectioninfodata = _sectioninfoDic;
                                                                                     
                                                                                     self.supTbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                     self.supTbv.view.frame = self.bounds;
                                                                                     self.supTbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                     self.supTbv.delegatetarget = (id)self;
                                                                                     [self addSubview:self.supTbv.view];
                                                                                     [self.supTbv setResultDic:self.homeSectionApiResult];
                                                                                 }
                                                                                 else {
                                                                                     //새로고침
                                                                                     [self.supTbv setResultDic:self.homeSectionApiResult];
                                                                                     [self.supTbv reloadAction];
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
                                                                                 [self.supTbv.view addSubview:[self RefreshGuideView] ];
                                                                                 
                                                                                 
                                                                                 [ApplicationDelegate offloadingindicator];
                                                                             }];
}

@end

