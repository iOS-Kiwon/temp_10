//
//  DualPlayerView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 2. 9..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveTVAreaView.h"
#import "DualPlayerSubView.h"

#define widthDualView ((APPFULLWIDTH-4.0) / 2.0)
#define heightDualView  floor(widthDualView + 28.0 + 108.0 + 74.0 + 43.0)
#define heightDualViewPlayer floor((APPFULLWIDTH/(320.0/180.0)) + 63.0 + 40.0)

@interface DualPlayerView : UIView

@property (nonatomic,strong) LiveTVAreaView *viewPlayer;
@property (nonatomic,strong) IBOutlet UIView *viewBGPlayer;
@property (nonatomic,strong) IBOutlet UIView *viewBGLive;
@property (nonatomic,strong) IBOutlet UIView *viewBGMyShop;

@property (nonatomic,strong) DualPlayerSubView *viewSubLive;
@property (nonatomic,strong) DualPlayerSubView *viewSubMyShop;
@property (nonatomic,strong) Mocha_MPViewController * vc;

@property (nonatomic,strong) NSDictionary *dicLive;
@property (nonatomic,strong) NSDictionary *dicMyShop;
@property (nonatomic,strong) NSString *strSectionName;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lconstHeightBGPlayer;

@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSDictionary *rdic;


- (void)setCellInfoNDrawData:(NSDictionary*)dicLive andMyShop:(NSDictionary*)dicMyShop;
-(void)closeAndBackToDualView;
-(void)stopMoviePlayer;
-(void)onBtnPlayDualSub:(BOOL)isLive;
-(void)stopDualPlayerSubViewTimer;
-(void)stopDualPlayerPlayEnd;

- (void)btntouchWithLinkStrBD:(id)sender isDualLive:(BOOL)isDualLive;
- (void)playrequestLiveVideo: (NSString*)requrl andDic:(NSDictionary *)targetDic;
@end
