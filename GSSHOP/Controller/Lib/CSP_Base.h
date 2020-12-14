//
//  CSP_Base.h
//  GSSHOP
//
//  Created by nami0342 on 16/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SocketIO;



@protocol CSP_BaseDelegate<NSObject>
- (void) CSP_CallbackMSSG : (nullable NSDictionary *) dicData;
- (void) CSP_CallbackNOTI : (nullable NSDictionary *) dicData;
- (void) CSP_CallbackSTAT : (nullable NSDictionary *) dicData;
- (void) CSP_CallbackLOST : (nullable NSString *) strYN;
- (void) CSP_CallbackCONF : (nullable NSDictionary *) dicData;
- (void) CSP_CallbackCHAT : (nullable NSDictionary *) dicData;
@optional
@end


@interface CSP_Base : NSObject


@property (nonatomic, weak, nullable) id <CSP_BaseDelegate> delegate;

// nami0342 - Connect Service Platform
// nami0342 - CSP
@property (nonatomic, strong, nullable) SocketManager  *m_manager;
@property (nonatomic, strong, nullable) SocketIOClient *m_socket;
@property (nonatomic, strong, nullable) UIButton      *m_btnCSPIcon;
@property (nonatomic, strong, nullable) UIButton      *m_btnMessageNLink;
//@property (nonatomic, strong) UIImageView   *m_imgArrow;
@property (nonatomic, strong, nullable) NSDictionary  *m_dicMsg;
@property (nonatomic, readwrite) BOOL       m_isAnimating;
@property (nonatomic, readwrite) BOOL       m_isGotDisconnectCallback;
@property (nonatomic, readwrite) long       m_lServerBuild;
@property (nonatomic, strong, nullable) NSString *strNavigationTabID;
@property (strong, nonatomic, nullable) NSMutableDictionary *objectCSP;
@property (readwrite, nullable) dispatch_queue_t dpSerialQueue;
@property (nonatomic, readwrite) BOOL m_isRequestChatList;


- (void) CSP_ConnectWithNameSpce : (NSString * _Nullable) strNamespace customerID : (NSString * _Nullable) strCustomerID liveNo : (NSString * _Nullable) strLiveNo;
- (void) CSP_StartWithCustomerID : (nullable NSString *) strCustNo;  // 고객번호와 함께 CSP 시작
- (void) CSP_JoinWithTabID : (nullable NSString *) strTabID;         // 탭 이동 시마다 탭 아이디 전달
- (void) CSP_SendEventWithView : (BOOL) isViewed;                   // 뷰, 클릭 이벤트

- (void) CSP_SendMSG : (nullable NSDictionary *) dicMSG;
- (void) CSP_RequestChatlist;                                       // 채팅 리스트 요청
- (void) CSP_Disconnect;




@end




