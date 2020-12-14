//
//  MochaNetworkKit.h
//  TutorialMocha
//
//  Created by Mugunth Kumar (@mugunthkumar) on 11/11/11.
//  Copyright (C) 2011-2020 by Steinlogic

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#ifndef __IPHONE_4_0
#error "MochaNetworkKit uses features only available in iOS SDK 4.0 and later."
#endif
  
//자료형 변환 관련 Category 헤더 import
#import "NSString+Mocha.h"
#import "NSDictionary+RequestEncoding.h"
#import "NSDate+RFC1123.h"
#import "NSData+Base64.h"

//동기통신 담당
#import "NSURLConnection+Timeout.h"

//넷트워크 상태 runtime observer
#import "Mocha_Reachability.h"
//통신 operation 동작중 화면처리용 Loading indicator Lib
 
//네트워크 통신을 위한 초기화 클래스 (호스트명 정의 및 공통 작업큐 초기화 필수)
#import "MochaNetworkCore.h"
//개별 네트워크 통신 작업을 담당할 NSOperation 상속받은 순수 네트워크 작업단위 class
#import "MochaNetworkOperation.h"
 
//파일 확장자가 gif 일경우 animation 처리된 UIImage 로 return
#import "UIImage+GIF.h"

// operation 카운트 증감에따른 KeyValueObserving에 따른 변화 발생시 사용할 NSNotificationCenter NotificationName 정의
#define kChangedMochaKVOOperationCount @"kChangedMochaKVOOperationCount"

//MochaNetworkCore객체에서 캐시데이터 저장시 memoryCacheKeys(NSMutableArray)의 제한갯수(array 10개이상 시 삭제)
#define MKNETWORKCACHE_DEFAULT_COST 10
//cache저장 디렉토리명정의 (NSCachesDirectory 하위에생성됨)
#define MKNETWORKCACHE_DEFAULT_DIRECTORY @"MochaNetCache"

//Cache-Control 헤더에 존재하고 no-cache 인경우 유효시간 expireOnDate 설정은 5분
#define kMKNetworkKitDefaultCacheDuration 300 // 5 minute
//Get방식통신시(image다운로드포함) response헤더의 cache default 기간 정의(default = 1일기준)
//#define kMKNetworkKitDefaultImageHeadRequestDuration 3600*24*1
//ETag Last-Modified 헤더없는 이미지의 경우 유효기간 정의
//#define kMKNetworkKitDefaultImageCacheDuration 3600*24*7 // 1 day

//#### 아래 정의는 contentType=image/***  에만 적용됨
//Get방식통신시(image다운로드포함) response헤더의 cache default 기간 정의(default = 1시간 테스트)
//#define kMKNetworkKitDefaultImageHeadRequestDuration 3600
//ETag Last-Modified 헤더없는 이미지의 경우 유효기간 정의
#define kMKNetworkKitDefaultImageCacheDuration 600 // 10 minute


//통신 대기 시간 = 10초 이내
//대기시간 지난후 통신 operation 단위로 NSURLConnection delegates 프로토콜 메서드  (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 호출됨.
#define kMKNetworkKitRequestTimeOutInSeconds 10
 

