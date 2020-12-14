//
//  NetCore_GSSHOP_Comm.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDefine.h"

@interface NetCore_GSSHOP_Comm  : NSObject

//리턴 자료형 정의

typedef void (^ResponseDicBlock)(NSDictionary *respstr);
typedef void (^ResponseStrBlock)(NSString *respstr);


//섹션별화면 UI
//-(MochaNetworkOperation*) gsSECTIONUILISTURL:(NSString*)apiurl
//                               isForceReload:(BOOL)isreload
//                                onCompletion:(ResponseDicBlock) completionBlock
//                                     onError:(MCNKErrorBlock) errorBlock;
-(NSURLSessionDataTask*) gsSECTIONUILISTURL:(NSString*)apiurl
                               isForceReload:(BOOL)isreload
                                onCompletion:(ResponseDicBlock) completionBlock
                                     onError:(MCNKErrorBlock) errorBlock;


//섹션별화면 APPLE JSON 용
//-(MochaNetworkOperation*) gsSECTIONUILISTURL_NativeJSON:(NSString*)apiurl
//                               isForceReload:(BOOL)isreload
//                                onCompletion:(ResponseDicBlock) completionBlock
//                                     onError:(MCNKErrorBlock) errorBlock;
-(NSURLSessionDataTask*) gsSECTIONUILISTURL_NativeJSON:(NSString*)apiurl
                                          isForceReload:(BOOL)isreload
                                           onCompletion:(ResponseDicBlock) completionBlock
                                                onError:(MCNKErrorBlock) errorBlock;


//
//-(nullable NSURLSessionDataTask*) gsSECTIONCONTENTSPAGINGLISTURL:(NSString*)apiurl
//                                           isForceReload:(BOOL)isreload
//                                            onCompletion:(ResponseDicBlock) completionBlock
//                                                 onError:(MCNKErrorBlock) errorBlock;



//
//-(nullable NSURLSessionDataTask*) gsTVCCELLINFOAPIURL:(NSString*)apiurl
//                                 onCompletion:(ResponseDicBlock) completionBlock
//                                      onError:(MCNKErrorBlock) errorBlock;




-(NSURLSessionDataTask*) gsGETBADGEURL:(ResponseDicBlock) completionBlock
                                onError:(MCNKErrorBlock) errorBlock;





//인기검색어 201406~
-(NSURLSessionDataTask*) gsHOTKEYWORDLISTURL:(NSString*) targetURL
                                 onCompletion:(ResponseDicBlock) completionBlock
                                      onError:(MCNKErrorBlock) errorBlock;





//프로모션 검색어 20150413
-(NSURLSessionDataTask*) gsPROMOKEYWORDLISTURL:(ResponseDicBlock) completionBlock
                                        onError:(MCNKErrorBlock) errorBlock;



////카테고리M리스트
//-(nullable NSURLSessionDataTask*) gsCATEGORYMLISTURL:(ResponseDicBlock) completionBlock
//                                     onError:(MCNKErrorBlock) errorBlock;


//브랜드리스트
-(NSURLSessionDataTask*) gsBRANDLISTURL:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock;

-(NSURLSessionDataTask*) gsSKTUserCheck:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock;

//-(nullable NSURLSessionDataTask*) gsForeignUserCheck:(ResponseDicBlock) completionBlock
//                                     onError:(MCNKErrorBlock) errorBlock;


//옵션정보
-(NSURLSessionDataTask*) gsOptionInfo:(ResponseDicBlock) completionBlock
                               onError:(MCNKErrorBlock) errorBlock;

//구 테스트 서버용


-(NSURLSessionDataTask*) gsAUTOMAKELISTURL:(NSString*) targetURL
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock;

//-(nullable NSURLSessionDataTask*) gsGetAppVERSION:(ResponseStrBlock) completionBlock
//                                  onError:(MCNKErrorBlock) errorBlock;


//-(nullable NSURLSessionDataTask*) gsGetAppVERSIONMENTNORMAL:(ResponseStrBlock) completionBlock
//                                            onError:(MCNKErrorBlock) errorBlock;
//-(nullable NSURLSessionDataTask*) gsGetAppVERSIONMENTFORCE:(ResponseStrBlock) completionBlock
//                                           onError:(MCNKErrorBlock) errorBlock;


//신규 SNS 연동 2017.03.30
//로그인
-(NSURLSessionDataTask*) gsTOKENLOGINURL:(NSString*) uname
                                userpass : (NSString*) upass
                             simplelogin :(NSString*)slogin
                          snsAccessToken : (NSString *)snsAccessToken
                         snsRefreshToken : (NSString *)snsRefreshToken
                                 snsType : (NSString *)snsType
                               loginType : (NSString *)loginType
                             onCompletion:(ResponseDicBlock) completionBlock
                                  onError:(MCNKErrorBlock) errorBlock;


//신규 SNS 연동 2017.03.30
//SNS 연동 여부 확인
-(NSURLSessionDataTask*) gsSnsAccountCheck:(NSString*) custNo
                             onCompletion:(ResponseDicBlock) completionBlock
                                  onError:(MCNKErrorBlock) errorBlock;

//SNS 연동 해제
-(NSURLSessionDataTask*) gsSnsAccountClose:(NSString*) custNo
                                    snsType:(NSString*) snsTyp
                             onCompletion:(ResponseDicBlock) completionBlock
                                  onError:(MCNKErrorBlock) errorBlock;
//2018.07.19 배포
//SNS 연동 연결등록
-(NSURLSessionDataTask*) gsSnsAccountOpenCustNo:(NSString*) custNo
                                   snsType:(NSString*) snsTyp
                            snsAccessToken:(NSString*) accessToken
                           snsRefreshToken:(NSString*) refreshToken
                              onCompletion:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock;


//로그아웃
-(NSURLSessionDataTask*) gsTOKENLOGOUTPROC: (NSString*) loginid
                                 serieskey : (NSString*) skey
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock ;

//인증
-(NSURLSessionDataTask*) gsTOKENAUTHURL:(NSString*) loginid
                              serieskey : (NSString*) skey
                               authtken : (NSString*) atoken
                                 snsTyp : (NSString*) snsTyp
                            onCompletion:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock;

-(NSURLSessionDataTask*) gsTOKENAUTHURL_Retry:(NSString*) loginid
                             serieskey : (NSString*) skey
                              authtken : (NSString*) atoken
                                snsTyp : (NSString*) snsTyp
                           onCompletion:(ResponseDicBlock) completionBlock
                                onError:(MCNKErrorBlock) errorBlock;


//App wiselog 호출
-(NSURLSessionDataTask*) gsAPPWISELOGREQPROC: (NSString*) requrlstr
                                 onCompletion:(ResponseDicBlock) completionBlock
                                      onError:(MCNKErrorBlock) errorBlock;

//
// 메인 그룹매장 화면구조 api 수신
-(NSURLSessionDataTask*) gsGROUPUILISTURL:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock;
////메인 그룹매장 화면구조 api 수신 재시도용
//-(nullable NSURLSessionDataTask*) gsGROUPUILISTURL_forRetry:(ResponseDicBlock) completionBlock
//                                            onError:(MCNKErrorBlock) errorBlock;


//
// 그룹매장 섹션별 화면 api 수신
//-(nullable NSURLSessionDataTask*) gsGROUPSECTIONUILISTURL:(NSString*)apiurl
//                                    isForceReload:(BOOL)isreload
//                                     onCompletion:(ResponseDicBlock) completionBlock
//                                          onError:(MCNKErrorBlock) errorBlock;

//
// 나의 찜 상품 추가
-(NSURLSessionDataTask*) gsFAVORITEREGURL:(NSString*)prodCd
                              onCompletion:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock;


//인트로 이미지 조회
//-(nullable NSURLSessionDataTask*) gsIntroWithSystemOS:(NSString*)OS
//                          deviceHeight:(NSString *)height
//                          deviceWidth:(NSString *)width
//                           deviceDensity:(NSString *)density
//                              onCompletion:(ResponseDicBlock) completionBlock
//                                   onError:(MCNKErrorBlock) errorBlock;


// 검색 AB TEST
-(NSURLSessionDataTask*) gsSearchABTest:(ResponseStrBlock)completionBlock onError:(MCNKErrorBlock) errorBlock;


//사이드 매뉴용 네비게이션 , 카테고리 호출
- (NSURLSessionDataTask*) gsLeftNavigation:(NSString *)apiurl isForceReload:(BOOL) isreload onCompletion:(ResponseDicBlock) completionBlock onError:(MCNKErrorBlock) errorBlock;


//마이쇼핑 알림함 리얼맴버쉽
-(NSURLSessionDataTask*) gsMyShopRealMemberCustNo:(NSString*)strCustNo
                               isForceReload:(BOOL)isreload
                              onCompletion:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock;

- (void)SwitchSSLPort;
-(void)setDefaultCommPort;

//TV편성표 매장 생방송 시간 조회
-(NSURLSessionDataTask*) gsTVScheduleOnAirRequestOnCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock;

//TV편성표 매장 알람설정
//-(nullable NSURLSessionDataTask*) gsTVScheduleAlarmProcess:(NSString *)strProcess
//                                        alarmPrdId:(NSString *)strPrdId
//                                      alarmPrdName:(NSString *)strPrdName
//                                       alarmPeriod:(NSString *)strPeriod
//                                          alarmCnt:(NSString *)strCnt
//                                     isForceReload:(BOOL)isreload
//                                      onCompletion:(ResponseDicBlock) completionBlock
//                                           onError:(MCNKErrorBlock) errorBlock;

-(NSURLSessionDataTask*) gsREGAUTOAUTHURL:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock;

-(NSURLSessionDataTask*)gsProductTopNative:(NSString *)strNumber isPrd:(BOOL)isPrd OnCompletion:(ResponseDicBlock) completionBlock onError:(MCNKErrorBlock) errorBlock;
@end
