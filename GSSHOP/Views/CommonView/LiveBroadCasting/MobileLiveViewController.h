//
//  MobileLiveViewController.h
//  GSSHOP
//
//  Created by nami0342 on 04/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSP_Base.h"
#import "MobileLiveProduct.h"
#import "AutoLoginViewController.h"

//@protocol playerViewDelegate <NSObject>
//@optional
//- (void)playerViewZoomButtonClicked:(LiveBCPlayer*)view;
//- (void)playerFinishedPlayback:(LiveBCPlayer*)view;
//- (BOOL)isAgree3G;
//- (void)setAgree3GYES;
//@end


@class AFNetworkReachabilityManager;
@interface MobileLiveViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MobileLiveProductDelegate, UIScrollViewDelegate, CSP_BaseDelegate, LoginViewCtrlPopDelegate>
{
    
}
@property (nonatomic, strong) CSP_Base              *m_cspChat;
@property (nonatomic, strong) NSString              *strCSP_ID;
@property (nonatomic, strong) IBOutlet UITableView  *tvChat;
@property (nonatomic, strong) NSURL                 *m_contentURL;
@property (nonatomic, strong) NSString              *m_toappString;


- (void) setLiveTimer;





@end
