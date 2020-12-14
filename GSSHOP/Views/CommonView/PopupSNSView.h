//
//  PopupSNSView.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SNS_ID @"snsScriptName"
#define SNS_TITLE @"snsTitle"
#define SNS_ICON @"snsIcon"
#define SNS_MESSAGE @"snsMessage"
#define SNS_CODE @"snsCode"
#define MSEQ @"mseq"

@interface PopupSNSView : UIView 
{
    NSString *snsUrl;
    NSString *snsImageUrl;
    NSString *snsMessage;
    NSInteger callerType;
    CGSize imageSize;
}

@property (nonatomic, weak) id target;
@property (nonatomic, strong)  IBOutlet UIView *dimm;
@property (nonatomic, strong)  IBOutlet UIView *popupView;
@property (nonatomic, strong)  IBOutlet UIView *subContentView;
@property (strong, nonatomic) IBOutlet UIButton *moerAppBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;


@property (nonatomic,strong) NSArray *arrSNS;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;


- (void)setSnsListData:(NSArray*)arrInfo;

- (IBAction)onBtnSnsButton:(id)sender;
- (IBAction)closeClick:(id)sender;
- (IBAction)moreAppClick:(id)sender;

// callType = 1:숏방 etc: 미정의 (솟방일때 mseq동작) // 사이즈 추가
- (void)openWithAnimated:(BOOL)animated withShareUrl:(NSString *)url ShareImage:(NSString *)imgUrl ShareMessage:(NSString *)message callType:(NSInteger)type imageSize:(CGSize)size;
- (void)closeWithAnimated:(BOOL)animated;

@end
