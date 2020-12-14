//
//  LiveTalkSnsShareView.h
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SNSID @"snsScriptName "
#define SNSTITLE @"snsTitle "
#define SNSICONURL @"snsIconUrl "


@protocol snsShareViewDelegate <NSObject>
@optional
-(void)callShareSnsWithString:(NSString*)seletedString;
@end

@interface LiveTalkSnsShareView : UIView {
    
}

@property (nonatomic,strong) NSArray *arrSNS;
//@property (nonatomic,strong) IBOutlet UIView *viewSnsList;
@property (nonatomic,weak) id <snsShareViewDelegate> delegate;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;

@property (nonatomic, strong) IBOutlet UIView *dimm;
@property (nonatomic, strong) IBOutlet UIView *popupView;
@property (nonatomic, strong) IBOutlet UIView *subContentView;
@property (strong, nonatomic) IBOutlet UIButton *moerAppBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;



- (id)initWithDelegate:(id)target;
- (void)setSnsListData:(NSArray*)arrInfo;
- (IBAction)closeClick:(id)sender;
-(IBAction)onBtnSnsButton:(id)sender;
- (void)closeWithAnimated:(BOOL)animated;


@end
