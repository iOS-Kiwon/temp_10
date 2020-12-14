//
//  AutoLoginViewController.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MOCHA/MochaNetworkKit.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "UINavigationController+Category.h"
#import "PMS.h"
#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>

#import "SectionTBViewFooter.h"
#import "emailCell.h"
#import <AuthenticationServices/AuthenticationServices.h>

//@import LocalAuthentication;
@protocol LoginViewCtrlPopDelegate;

@interface AutoLoginViewController : UIViewController<UITextFieldDelegate  ,NaverThirdPartyLoginConnectionDelegate, UITableViewDelegate, UITableViewDataSource, ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding> {
    IBOutlet UILabel *label_htitle;
    IBOutlet UILabel *label_keepauth;
    UIButton* Chkbutton;    //자동 로그인 체크박스 버튼
    NSString *userId;       //입력받을 아이디 변수
    NSString *userPass;     //입력받을 패스워드 변수
    IBOutlet UIButton *sw_autologin;
    IBOutlet UIButton *btn_naviBack;
    
    IBOutlet UIView *view_forcenter;
    IBOutlet UIView *viewTopHeader;
    IBOutlet UIScrollView *scrview_baseforcenter;
    IBOutlet UIView *viewContents;
    //간편로그인 관련
    IBOutlet UIButton *btn_gologin;
    NSDictionary *simpleiddic;
    IBOutlet UIButton *btn_gocustomercenter;
    IBOutlet UILabel *lblInfo01;
    IBOutlet UILabel *lblInfo02;
    
    BOOL isFirstTimeAccess; //데이터베이스에 처음으로 엑세스 하는지 여부
    NSString *DBName;//db name
    NSString *DBPath; //데이터베이스 경로
    NSMutableArray *DBData; //데이터베이스에서 읽은 메모를 가져온다.
    UIButton* btnLogin;//로그인 버튼
    BOOL isLogining;  //현재 페이지의 로그인 상태 저장
    
    IBOutlet UIButton *btn_foot1;
    IBOutlet UIButton *btn_foot2;
    IBOutlet UIButton *btn_foot3;
    
    IBOutlet UIView *viewNonMemberBorder;
    IBOutlet UIView *viewNonMemberCenterLine;
    IBOutlet UIButton *btnNonMemberOrder;
    IBOutlet UIButton *btnNonMemberTracking;
    
    IBOutlet UIView *viewFootLine01;
        
    IBOutlet UIView *infoSet;
    id<LoginViewCtrlPopDelegate> __weak delegate;
    UITextField *resignTextField;
    //호대폰로그인버튼
    IBOutlet UIButton *btnPhonelogin;
    //2017/03 yunsang.jin 네이버 카카오 연동
    IBOutlet UIButton* btnKakao;
    IBOutlet UIButton* btnNaver;
    IBOutlet UIButton* btnFinger;
    IBOutlet UIButton* btnAppleID;
    IBOutlet UIView     *LoginButtonBaseView;
    IBOutlet UIView     *m_AppleIDView;
    NaverThirdPartyLoginConnection *_thirdPartyLoginConn;
    
    
    
    IBOutlet UIView *viewMemberInput;
    IBOutlet UIView *viewMiddleButtons;
    IBOutlet UIView *viewFooter;
    
    
    NSMutableString *strAccessToken;
    NSMutableString *strRefreshToken;
    NSMutableString *strSNSType;
    NSMutableString *strLoginType;
    NSMutableArray *emailTemplite;
    NSArray *emailSet;
    BOOL privateFingerprintUseFlag; // 지문인식 할래요.
    BOOL snsLoginFlag; //SNS로그인용 플래그
    
    IBOutlet UIView *viewTopSNSLoginAndKeyboard;
    
}

@property (nonatomic, strong) IBOutlet UIButton *btn_naviBack;
@property (strong, nonatomic) NSURLSessionDataTask *currentOperation1;
@property (nonatomic ,strong)NSString *userId;
@property (nonatomic ,strong)NSString *userPass;
@property (nonatomic, strong) NSString *DBName;
@property (nonatomic, strong) NSString *DBPath;
@property (nonatomic, strong) NSMutableArray *DBData;
@property (nonatomic, assign) BOOL isFirstTimeAccess;
@property (nonatomic, strong) NSString *deletargetURLstr;
@property (nonatomic, weak) id<LoginViewCtrlPopDelegate> delegate;
@property (nonatomic, strong)UIButton* btnLogin;
@property (assign) BOOL isLogining;
@property (assign) NSInteger loginViewType;
//하단버튼변경관련-비회원주문관련
@property (assign) NSInteger loginViewMode;
//20170508 parksegun 패스워드 보이기 숨기기
//@property (weak, nonatomic) IBOutlet UIImageView *pwShowOrHideByIcon;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPass;
//@property (weak, nonatomic) IBOutlet UILabel *pwShowOrHideByText;
@property (weak, nonatomic) IBOutlet UITextField *textFieldId; //텍스트 입력 컨트롤
@property (weak, nonatomic) IBOutlet UIButton *btnClearId;
@property (weak, nonatomic) IBOutlet UIButton *btnClearPass;
@property (weak, nonatomic) IBOutlet UIView *emailInputSupport;
@property (weak, nonatomic) IBOutlet UITableView *emailTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailInputSupportHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseforcenterTopMargin;
@property (nonatomic, strong) NSTimer *timerKeyboard;
@property (nonatomic, strong) IBOutlet UILabel *lblErrorMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblIDErrorMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IDerrorH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PWerrorH;


@property (weak, nonatomic) IBOutlet UIView *idView;
@property (weak, nonatomic) IBOutlet UIView *pwView;


@property (nonatomic, assign) NSInteger cntLoginFailed;
@property (nonatomic, assign) CGFloat heightContents;

@property (nonatomic, assign) BOOL isEditingTextField;
@property (nonatomic, assign) BOOL isLogoutProcess;
@property (nonatomic, strong) NSString *pushAnimation; // 아래서 위로 올라오는 애니메이션 구분을 위해 존재
@property (weak, nonatomic) IBOutlet UIView *loginNmView;


- (void)saveNormalLoginUserData:(NSDictionary *)result;
- (void)hideLoginView;
- (IBAction)pregoLogin;
- (void)goLogin;
- (IBAction)textFiledDidChangeIdPw:(id)txtfield;
- (IBAction)GoBack:(id)sender;
// -- 2012.02.27
- (NSString *)ReplaceString:(NSString*)OriginalString findString:(NSString *)findstr replaceString:(NSString *)replstr;

//20170508 parksegun 패스워드 보이기 숨기기
//- (IBAction)pwShowOrHide:(id)sender;
- (IBAction)goTVUserLogin:(id)sender;

- (void)textFieldCancel;
- (void)textFieldNext:(UIBarButtonItem *)sender;
- (IBAction)btn_ok_Press:(id)sender;
- (IBAction)goJoinMember:(id)sender;
- (IBAction)goCustomerCenter:(id)sender;
- (IBAction)goEmailAuth:(id)sender;
-(IBAction)goURL_Action:(id)sender;
-(BOOL)isQuickorderReg;



-(void)onCursorTextFieldId;
-(IBAction)onBtnKakaoLogin:(id)sender;
- (IBAction)onBtnNaverLogin:(id)sender;

//footer action
- (void)btntouchAction:(id)sender;
- (void)setAuthType:(NSString *)strType;
- (void)snsAccessUrlMove:(NSString *)strUrl;
- (void)setAuthClean;
- (IBAction)onFingerPrint:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nonMemberTrakingLeading;

- (void)clearTextFields;

@end




@protocol LoginViewCtrlPopDelegate
@required
- (void) hideLoginViewController:(NSInteger)loginviewtype;
- (NSString*) definecurrentUrlString;

@end
