//
//  DualPlayerView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 2. 9..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "DualPlayerView.h"
#import "TDCLiveTBViewController.h"

@implementation DualPlayerView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopMoviePlayer)
                                                 name:MAINSECTIONLIVEVIDEOALLKILL
                                               object:nil];
    
}

- (void)setCellInfoNDrawData:(NSDictionary*)dicLive andMyShop:(NSDictionary*)dicMyShop{
    
    self.dicMyShop = [dicMyShop copy];
    self.dicLive = [dicLive copy];
    
    
    if (self.viewSubLive != nil) {
        [self.viewSubLive removeFromSuperview];
        self.viewSubLive = nil;
    }
    if (self.viewSubMyShop != nil) {
        [self.viewSubMyShop removeFromSuperview];
        self.viewSubMyShop = nil;
    }
    
    //조건문
    
    if (NCO(self.dicLive) == YES && [self.dicLive isKindOfClass:[NSDictionary class]]) {
        self.viewSubLive = [[[NSBundle mainBundle] loadNibNamed:@"DualPlayerSubView" owner:self options:nil] firstObject];
        self.viewSubLive.frame = CGRectMake(0.0, 0.0, widthDualView, heightDualView);
        [self.viewBGLive addSubview:self.viewSubLive];
        self.viewSubLive.isDualTvLive = YES;
        self.viewSubLive.strSectionName = self.strSectionName;
        [self.viewSubLive setCellInfoNDrawData:self.dicLive];
        self.viewSubLive.target = self;
        self.viewSubLive.targetTableView = self.target;
    }
    
    
    if (NCO(self.dicMyShop) == YES && [self.dicMyShop isKindOfClass:[NSDictionary class]]) {
        
        self.viewSubMyShop = [[[NSBundle mainBundle] loadNibNamed:@"DualPlayerSubView" owner:self options:nil] firstObject];
        self.viewSubMyShop.frame = CGRectMake(0.0, 0.0,widthDualView, heightDualView);
        [self.viewBGMyShop addSubview:self.viewSubMyShop];
        self.viewSubMyShop.isDualTvLive = NO;
        self.viewSubMyShop.strSectionName = self.strSectionName;
        [self.viewSubMyShop setCellInfoNDrawData:self.dicMyShop];
        self.viewSubMyShop.target = self;
        self.viewSubMyShop.targetTableView = self.target;
    }
}

-(void)closeAndBackToDualView{
    if (self.viewPlayer != nil) {
        [self.viewPlayer stopMoviePlayer];
        [self.viewPlayer removeFromSuperview];
        self.viewPlayer = nil;
    }

    self.viewBGLive.hidden = NO;
    self.viewBGMyShop.hidden = NO;
    
    if ([self.target respondsToSelector:@selector(tableHeaderChangeSize:)]) {
        [self.target tableHeaderChangeSize:CGSizeMake(APPFULLWIDTH, heightDualView)];
    }
    
}

-(void)stopDualPlayerSubViewTimer{
    if (self.viewSubLive != nil) {
        [self.viewSubLive sectionReloadTimerRemove];
    }
    
    if (self.viewSubMyShop != nil) {
        [self.viewSubMyShop sectionReloadTimerRemove];
    }
}

-(void)onBtnPlayDualSub:(BOOL)isLive{
    
    if (self.viewPlayer != nil) {
        [self.viewPlayer stopMoviePlayer];
        [self.viewPlayer removeFromSuperview];
        self.viewPlayer = nil;
    }
    
    self.viewPlayer = [[[NSBundle mainBundle] loadNibNamed:@"LiveTVAreaView" owner:self options:nil] firstObject];
    self.viewPlayer.isTvShop = YES;
    self.viewPlayer.target = self;
    
    NSLog(@"heightDualViewPlayer = %f",heightDualViewPlayer);
    
    
    if (isLive) {
        self.viewPlayer.isDualLive = YES;
        [self.viewPlayer setCellInfoNDrawData:self.dicLive];
    }else{
        self.viewPlayer.isDualLive = NO;
        [self.viewPlayer setCellInfoNDrawData:self.dicMyShop];
    }
    
    self.viewBGLive.hidden = YES;
    self.viewBGMyShop.hidden = YES;
    
    self.lconstHeightBGPlayer.constant = heightDualViewPlayer;
    
    [self.viewBGPlayer addSubview:self.viewPlayer];
    
    self.viewPlayer.frame = CGRectMake(0,0,APPFULLWIDTH,heightDualViewPlayer);
    
    [self.viewPlayer onBtnMoviePlay:nil];
    
    if ([self.target respondsToSelector:@selector(tableHeaderChangeSize:)]) {
        [self.target tableHeaderChangeSize:CGSizeMake(APPFULLWIDTH, heightDualViewPlayer)];
    }
}

-(void)stopMoviePlayer{
    if (self.viewPlayer != nil) {
        [self.viewPlayer stopMoviePlayer];
        //[self.viewPlayer removeFromSuperview];
        //self.viewPlayer = nil;
    }
    
    
}

-(void)stopDualPlayerPlayEnd{

    if (self.viewPlayer != nil) {
        [self.viewPlayer stopMoviePlayerTVShop];
    }
    
}

- (void)btntouchWithLinkStrBD:(id)sender isDualLive:(BOOL)isDualLive{
    //오늘추천 생방송영역클릭
 
    NSDictionary *dicInfo = nil;
    
    if (isDualLive) {
        dicInfo = self.dicLive;
    }else{
        dicInfo = self.dicMyShop;
    }
    
    NSLog(@"sendersendersender = %@",sender);
    
    
    //GTMSendLog:: Area_Tracking, MC_홈_생방송_Main_Live, 0_[세실엔느] 3D보정 초밀착 팬티 패키지 7종
    if([sender tag] == 3007) {
        //상품 영역 클릭

        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live",self.strSectionName, (isDualLive)?@"생방송":@"데이터 홈쇼핑"]
                                   withLabel:[NSString stringWithFormat:@"0_%@", [dicInfo objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: [dicInfo objectForKey:@"linkUrl"] ];
        }

        
        
    } else if([sender tag] == 3008) {
        //오늘추천 생방송영역클릭
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live",self.strSectionName, (isDualLive)?@"생방송":@"데이터 홈쇼핑"]
                                   withLabel:[NSString stringWithFormat:@"0_%@", [dicInfo objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: [dicInfo objectForKey:@"linkUrl"] ];
        }
        
        
    }
    else if([sender tag] == 3009) {
        //라이브톡
        if ([NCS([dicInfo objectForKey:@"liveTalkUrl"]) length] > 0) {
            
            if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.target touchEventDualPlayerJustLinkStr: NCS([dicInfo objectForKey:@"liveTalkUrl"])];
            }
        }
    }
    else if([sender tag] == 3010) {
        //편성표 링크
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: NCS([dicInfo objectForKey:@"broadScheduleLinkUrl"])];
        }
    }
    else if([sender tag] == 3011) {
        //바로구매
        if(NCO([dicInfo objectForKey:@"btnInfo3"])) {
            if (NCS([[dicInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"]) && [[[dicInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                
                NSString *linkstr = [[[dicInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] substringFromIndex:11];
                NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                //[self.tableView setContentOffset:CGPointMake(0.0, tableheaderBANNERheight + tableheaderListheight) animated:YES];
                [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
            }
            else {
                NSString *linkstr = [[dicInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"];
                
                if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                    [self.target touchEventDualPlayerJustLinkStr:linkstr];
                }
                
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd",self.strSectionName]
                                       withLabel:[NSString stringWithFormat:@"%@",[[dicInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
            
        }
        else {
            
            if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.target touchEventDualPlayerJustLinkStr: [dicInfo objectForKey:@"rightNowBuyUrl"] ];
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd",self.strSectionName]
                                       withLabel:[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"rightNowBuyUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
        }
        
    }else if([sender tag] == 3012) {
        //편성표 링크
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: NCS([dicInfo objectForKey:@"totalPrdViewLinkUrl"])];
        }
    }
    
}


//생방송 재생
- (void)playrequestLiveVideo: (NSString*)requrl andDic:(NSDictionary *)targetDic{
    //생방송 영상
    
    self.rdic = targetDic;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    NSString *strReqURL = [NSString stringWithFormat:@"toapp://livestreaming?url=%@&targeturl=%@",requrl,[self.rdic objectForKey:@"linkUrl"]];
    self.vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:strReqURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.vc.moviePlayerController];
    self.vc.modalPresentationStyle =UIModalPresentationFullScreen;
    
    [ApplicationDelegate.window.rootViewController presentViewController:self.vc animated:YES completion:^{
    }];
    [self.vc playMovieStream:[NSURL URLWithString:requrl]];
}



- (void) playbackDidFinish:(NSNotification *)noti {
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    MPMoviePlayerController *player = [noti object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:NULL];
}


- (void)goWebView:(NSString *)url {
    
    @try {
        
        if (self.rdic != nil) {
            [self.target dctypetouchEventTBCell:self.rdic andCnum:0 withCallType:@""];
        }else{
            if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.target touchEventDualPlayerJustLinkStr:url];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@",exception);
    }
}
@end
