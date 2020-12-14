//
//  SectionView+NFXCLIST.m
//  GSSHOP
//
//  Created by gsshop iOS on 13/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "SectionView+NFXCLIST.h"

@implementation SectionView (NFXCLIST)

- (void)ScreenDefineNFXCLIST{
    [self ScreenDefineNFXCLISTWith:NO];
}
- (void)ScreenReDefineNFXCLIST{
    [self ScreenDefineNFXCLISTWith:YES];
}
- (void)ScreenDefineNFXCLISTWith:(BOOL)isReDefine{
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

                                                                            self.clipsToBounds = YES;
                                                                            
                                                                            if(self.nfxcTbv2 == nil) {
                                                                                NSString * sectionName = NCS([_sectioninfoDic  objectForKey:@"sectionName"]);
                                                                                self.nfxcTbv2 = [[NFXCListViewController alloc] initWithStyle:UITableViewStylePlain sectionName: sectionName];
                                                                                self.nfxcTbv2.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                self.nfxcTbv2.view.frame = self.bounds;
                                                                                self.nfxcTbv2.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                self.nfxcTbv2.delegatetarget = (id)self;
                                                                                self.nfxcTbv2.tableView.scrollsToTop = NO;
                                                                                [self addSubview:self.nfxcTbv2.view];
                                                                                NSLog(@"self.frameself.frame = %@",NSStringFromCGRect(self.frame));
                                                                                [self.nfxcTbv2 setResultDic:self.homeSectionApiResult];
                                                                            }
                                                                            else {
                                                                                //새로고침
                                                                                [self.nfxcTbv2 setResultDic:self.homeSectionApiResult];
                                                                                [self.nfxcTbv2 reloadAction];
                                                                            }
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                [self  bringSubviewToFront:self.btngoTop];
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
                                                                                 self.clipsToBounds = YES;
                                                                                 self.homeSectionApiResult = nil;
                                                                                 if(self.nfxcTbv2 == nil) {
                                                                                     NSString * sectionName = NCS([_sectioninfoDic  objectForKey:@"sectionName"]);
                                                                                     self.nfxcTbv2 = [[NFXCListViewController alloc] initWithStyle:UITableViewStylePlain sectionName: sectionName];
                                                                                     self.nfxcTbv2.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                     self.nfxcTbv2.view.frame = self.bounds;
                                                                                     self.nfxcTbv2.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                     self.nfxcTbv2.delegatetarget = (id)self;
                                                                                     self.nfxcTbv2.tableView.scrollsToTop = NO;
                                                                                     [self addSubview:self.nfxcTbv2.view];
                                                                                     [self.nfxcTbv2 setResultDic:self.homeSectionApiResult];
                                                                                 }
                                                                                 else {
                                                                                     //새로고침
                                                                                     [self.nfxcTbv2 setResultDic:self.homeSectionApiResult];
                                                                                     [self.nfxcTbv2 reloadAction];
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
                                                                                  [self.nfxcTbv2.view addSubview:[self RefreshGuideView] ];
                                                                                 
                                                                                 
                                                                                 [ApplicationDelegate offloadingindicator];
                                                                             }];
}


//프로팅 시킬 뷰
- (void)displayFreezePanesView:(BOOL)disp viewToAdd:(UIView*)viewAdd viewFrame:(CGRect)viewFrame{
    if(disp) {
        viewAdd.frame = viewFrame;
        [self addSubview:viewAdd];
    }
}
@end
