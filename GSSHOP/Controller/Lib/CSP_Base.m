//
//  CSP_Base.m
//  GSSHOP
//
//  Created by nami0342 on 16/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "CSP_Base.h"







@implementation CSP_Base


// nami0342 - CSP
@synthesize m_btnCSPIcon = _m_btnCSPIcon;
@synthesize m_btnMessageNLink = _m_btnMessageNLink;
@synthesize m_dicMsg = _m_dicMsg;
@synthesize strNavigationTabID = _strNavigationTabID;
@synthesize m_isGotDisconnectCallback = _m_isGotDisconnectCallback;
@synthesize m_socket = _m_socket, m_manager = _m_manager;
@synthesize objectCSP;
@synthesize dpSerialQueue = _dpSerialQueue;
@synthesize m_isRequestChatList = _m_isRequestChatList;



- (id) init
{
    self = [super init];
    
    if(self.objectCSP == nil) {
        self.objectCSP = [[NSMutableDictionary alloc] init];
    }

    self.dpSerialQueue = dispatch_queue_create("mobilelive.csp.serialqueue.gsshop.com", DISPATCH_QUEUE_SERIAL);
    
    return self;
}



// nami0342 - CSP : Connect to the CSP Socket Server
- (void) CSP_StartWithCustomerID : (NSString *) strCustNo
{
    
    // 버전 체크에서 실패하거나 서버 버전이 더 높을 경우 이 값이 0 이며, 동작 중지.
    if(self.m_lServerBuild == 0)
        return;
    
    
    if(strCustNo == nil || [strCustNo isKindOfClass:[NSString class]] == NO)
    {
        strCustNo = [NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo];
    }
    
    if(NCS(strCustNo).length == 0) {
        return;
    }

    
    
    // Set TabId
    //NSString * strTabID = @"54"; //탭아이디를 가지고 온다
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:@"GSSHOP", @"A", strCustNo, @"U", NCS(self.strNavigationTabID), @"P", nil];
    
    //#if DEBUG
    //    NSURL* url = [[NSURL alloc] initWithString:@"http://ec2-52-78-159-230.ap-northeast-2.compute.amazonaws.com:8080"];
    //#else
    NSURL* url = [[NSURL alloc] initWithString:@"https://csp.gsshop.com"];
    //#endif
    
    
    
    
    dispatch_async(_dpSerialQueue, ^{
        if(self.m_manager != nil && self.m_socket != nil)
        {
            [self CSP_Disconnect];
            return;
        }
        
        
        self.m_manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"connectParams":dicParam, @"forceWebsockets":@YES}];
        self.m_manager.reconnects = NO;
        
        NSString *strNamespace = @"/global";
        self.m_socket = [self.m_manager socketForNamespace:strNamespace];
        
        // nami0342 - Connect hanlder
        [self.m_socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            NSLog(@"😁 socket connected");
            
            // nami0342 - Tab 변경 시 마다 매장 탭 ID 알려주기
            [self CSP_JoinWithTabID:NCS(self.strNavigationTabID)];
            [self.delegate CSP_CallbackLOST:@"N"];
        }];
        
        
        // Message listener (Handler)
        /*
         {
         // data.MO : 메시지객체 (Object)
         // data.MO.MG : 메시지 텍스트 (Object)
         // data.MO.EM : 이모티콘 코드 (String)
         // data.UO : 고객객체  (Object)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         */
        [self.m_socket on:@"MSSG" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 MSG : %@", [dicReceived objectForKey:@"MG"]);
                
                
                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
               
                    // Callback
                    [self.delegate CSP_CallbackMSSG:dicReceived];
                }
            }
        }];
        
        // Noti listener
        /*
         function (data) {
         // data.MA : 메시지 텍스트 스트링배열 (Array<String>)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         */
        [self.m_socket on:@"NOTI" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 Banner : %@", [dicReceived objectForKey:@"I"]);
                
                
                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    [self.delegate CSP_CallbackNOTI:dicReceived];
                }
            }
        }];
        
        
        
        // Noti listener
        /*
         function (data) {
         // data.SO : 스탯 객체  (Object)
         // data.SO.PV : 방문자 카운트 (NUMBER)
         // data.SO.UV : 방문자 유니크 (NUMBER)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         });
         */
        [self.m_socket on:@"STAT" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 Banner : %@", [dicReceived objectForKey:@"I"]);
                
                
                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    
                    [self.delegate CSP_CallbackSTAT:dicReceived];
                }
            }
        }];
        
        [self.m_socket on:@"disconnect" callback:^(NSArray * arrdata , SocketAckEmitter * ack) {
            NSLog(@"___________ Socket Manager error : %@", arrdata);
            self.m_isGotDisconnectCallback = YES;
            [self.delegate CSP_CallbackLOST:@"Y"];
        }];
        
        // Socket connect
        [self.m_socket connect];
        
    });
}




#pragma mark
#pragma mark 모바일 라이브
///////////////////////////////////////////////////////////////////////////
    /////////////////////////  모바일 라이브 용  /////////////////////////
///////////////////////////////////////////////////////////////////////////
- (void) CSP_ConnectWithNameSpce : (NSString *) strNamespace customerID : (NSString *) strCustomerID liveNo : (NSString *) strLiveNo
{
    // 버전 체크에서 실패하거나 서버 버전이 더 높을 경우 이 값이 0 이며, 동작 중지.
//    if(self.m_lServerBuild == 0)
//        return;
    
    
    
    
    if(strCustomerID == nil || [strCustomerID isKindOfClass:[NSString class]] == NO)
    {
        strCustomerID = [NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo];
    }
    
    if(NCS(strCustomerID).length == 0) {
        return;
    }
    
#if DEBUG
//    strLiveNo = @"3217";
#endif
    
    // Set TabId
    //NSString * strTabID = @"54"; //탭아이디를 가지고 온다
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:@"GSSHOP", @"A", strCustomerID, @"U", strLiveNo, @"P", @"mobilelive", @"C", nil];
    
    #if DEBUG || SM14
        NSURL* url = [[NSURL alloc] initWithString:@"http://ec2-52-78-159-230.ap-northeast-2.compute.amazonaws.com:8080"];
    #else
        NSURL* url = [[NSURL alloc] initWithString:@"https://csp.gsshop.com"];
    #endif
    
    if(NCS(strNamespace).length == 0)
    {
        strNamespace = @"/chat";
    }
    
    
    dispatch_async(_dpSerialQueue, ^{
        if(self.m_manager != nil && self.m_socket != nil)
        {
            [self CSP_Disconnect];
            return;
        }
        
        
        self.m_manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"connectParams":dicParam, @"forceWebsockets":@YES}];
        self.m_manager.reconnects = YES;
//        self.m_manager.reconnectWait = 60*5;
        self.m_socket = [self.m_manager socketForNamespace:strNamespace];
        
        // nami0342 - Connect hanlder
        [self.m_socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            NSLog(@"😁 socket connected");
            [self.delegate CSP_CallbackLOST:@"N"];
            
            [self CSP_RequestChatlist];
            self.m_isRequestChatList = YES;
            // nami0342 - Tab 변경 시 마다 매장 탭 ID 알려주기
//            [self CSP_JoinWithTabID:NCS(strPosition)];
        }];
        
        
        // Receive any event
        [self.m_socket onAny:^(SocketAnyEvent * _Nonnull socketdata) {
            NSLog(@"!@#!@#!@# - %@ / %@ \n", socketdata.event, socketdata.items);
            
            if([socketdata.event isEqualToString:@"statusChange"] == YES && [socketdata.event isEqualToString:@"error"] == YES)
            {
                if(NCA(socketdata.items) == YES)
                {
                    NSLog(@"!@#!@#!@# => %@", [socketdata.items firstObject] );
                }
            }
        }];
        
        
        
        
        // Message listener (Handler)
        /*
         {
         // data.MO : 메시지객체 (Object)
         // data.MO.MG : 메시지 텍스트 (Object)
         // data.MO.EM : 이모티콘 코드 (String)
         // data.UO : 고객객체  (Object)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         */
        [self.m_socket on:@"MSSG" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 MSG : %@", [dicReceived objectForKey:@"MG"]);
                
                
                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    //
                    //                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                    
                    // Callback
                    [self.delegate CSP_CallbackMSSG:dicReceived];
                }
            }
        }];
        
        // Noti listener
        /*
         function (data) {
         // data.MA : 메시지 텍스트 스트링배열 (Array<String>)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         */
        [self.m_socket on:@"NOTI" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];

                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    //
                    //                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                    
                    [self.delegate CSP_CallbackNOTI:dicReceived];
                }
            }
        }];
        
        
        
        // Noti listener
        /*
         function (data) {
         // data.SO : 스탯 객체  (Object)
         // data.SO.PV : 방문자 카운트 (NUMBER)
         // data.SO.UV : 방문자 유니크 (NUMBER)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         });
         */
        [self.m_socket on:@"STAT" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];

                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    
                    //                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                    
                    [self.delegate CSP_CallbackSTAT:dicReceived];
                }
            }
        }];
        
        
        /*
         function (data) {
         // data.CO : 설정 객체  (Object)
         // data.CO.CHAT : 채팅 노출 여부 (STRING)
         // data.TS : 메시지 수신 시간 (Timestamp)
         });
         });
         */
        // 채팅 노출 여부 상태 정보 콜백
        [self.m_socket on:@"CONF" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 onReceivedConfig received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];

   
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    
                    //                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                    
                    [self.delegate CSP_CallbackCONF:dicReceived];
                }
            }
        }];
        
        
        // Chatting list
        [self.m_socket on:@"CHATS" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 chat received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 CHAT : %@", [dicReceived objectForKey:@"CA"]);
                
                
                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    //
                    //                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                    
                    // Callback
                    [self.delegate CSP_CallbackCHAT:dicReceived];
                }
            }
        }];
        
        [self.m_socket on:@"disconnect" callback:^(NSArray * arrdata , SocketAckEmitter * ack) {
            NSLog(@"___________ Socket Manager error : %@", arrdata);
            self.m_isGotDisconnectCallback = YES;
//            [self.delegate CSP_CallbackLOST:@"Y"];
        }];
        
        [self.m_socket on:@"connect_error" callback:^(NSArray * arrdata , SocketAckEmitter * ack) {
            NSLog(@"___________ Socket Manager error : %@", arrdata);
            self.m_isGotDisconnectCallback = YES;
            [self.delegate CSP_CallbackLOST:@"Y"];
        }];
        

        
        // Socket connect
        [self.m_socket connect];
        
    });
}



// nami0342 - Send TabID
- (void) CSP_JoinWithTabID : (NSString *) strTabID {
    
    if(self.m_lServerBuild == 0)
        return;
    
    /*
     1. 접속
     var position =  상품코드 or 방송번호
     var custNo = 고객번호
     io.connect('/chat?A=gsshop&U='+custNo+'&P='+position+'&C=mobilelive')
     */
    
    
    
    self.strNavigationTabID = strTabID;
    
    
    dispatch_async(_dpSerialQueue, ^{
        
        if(self.m_manager == nil || self.m_socket == nil) {
            [self CSP_StartWithCustomerID:[NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo]];
            return;
        }
        
        NSDictionary *dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:strTabID, @"P", nil];
        NSArray *arSendData = [NSArray arrayWithObjects:dicSendData, nil];
        
        [self.m_socket emit:@"join" with:arSendData];
        
    });
}


// nami0342 - Send CSP events.
- (void) CSP_SendEventWithView : (BOOL) isViewed
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        if(self.m_manager == nil || self.m_socket == nil) {
            return;
        }
        
        NSDictionary *dicSendData;
        if(isViewed == YES)
        {
            dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:[self.m_dicMsg objectForKey:@"AID"], @"AID", @"V", @"TP", nil];
        }
        else
        {
            dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:[self.m_dicMsg objectForKey:@"AID"], @"AID", @"C", @"TP", nil];
        }
        NSArray *arSendData = [NSArray arrayWithObjects:dicSendData, nil];
        
        [self.m_socket emit:@"activity" with:arSendData];
    });
}



// nami0342 - Disconnect
- (void) CSP_Disconnect
{
    dispatch_async(_dpSerialQueue, ^{
        if(self.m_manager != nil)
        {
            [self.m_socket disconnect];
            [self.m_manager disconnect];
            self.m_socket = nil;
            self.m_manager = nil;
        }
        
        //#if PROTO
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_ALL_CLEAR object:nil userInfo:nil];
        //#else
        //    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.m_btnCSPIcon.hidden = YES;
        //        self.m_btnMessageNLink.hidden = YES;
        //    });
        //#endif
    });
}



- (void) CSP_SendMSG : (NSDictionary *) dicMSG
{
    
    dispatch_async(_dpSerialQueue, ^{
        
        if(self.m_manager == nil || self.m_socket == nil) {
//            [self CSP_StartWithCustomerID:[NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo]];

        }
        
//        NSDictionary *dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:strTabID, @"P", nil];
        NSArray *arSendData = [NSArray arrayWithObjects:dicMSG, nil];
        
        [self.m_socket emit:@"send" with:arSendData];

    });
}



- (void) CSP_RequestChatlist
{
    dispatch_async(_dpSerialQueue, ^{
        if(self.m_socket != nil)
        {
            NSDictionary *dicTemp = [NSDictionary dictionary];
            NSArray *arSendData = [NSArray arrayWithObject:dicTemp];
            
            [self.m_socket emit:@"chats" with:arSendData];
        }
    });
}

@end
