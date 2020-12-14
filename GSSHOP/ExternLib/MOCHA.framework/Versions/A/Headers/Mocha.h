//
//  Mocha.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//


/** @mainpage Mocha Framework for Objective-C
* 
* @section Developer
* - 김회천
* 
* @section Project Name
* - MOCHA IOS Appframework V2.0.0 2013.10.07
*
* @section 개발목적
* - 생산성 향상
* - 표준화 고려
*
* 
* 
* @section 추가정보
* - 제한사항...
* -   탭으로 들여씀
* -# 번호매기기는 '-#' 방식으로 할수 있다.
* -# 위와 같이 탭으로 들여쓸경우 하위 항목이 된다.
* -# 두번째 하위 항목 참조는 @ref MochaDefine 설정설명 
* - 버전 history
* -#iOS7, armv7,7s iOS7 대응버전 - V2.0.0
 2016.03.04 - new version
*/
// Mocha Framework의 기능을 전체 사용시 Mocha.h 를 import 
// 부분별 사용시 <Mocha/필요기능헤더> import 하여 사용하시면 됩니다.

#import <Foundation/Foundation.h>

#import "Mocha_Define.h"

//EXTERN
//#import "JSON.h"


//BASE
#import "Mocha_Alert.h"
//#import "Mocha_MutableGridView.h"
//#import "Mocha_LocalNotificationsScheduler.h"
#import "Mocha_Util.h"
#import "Mocha_DBManager.h"
#import "Mocha_ToastMessage.h"

//Security
#import "GSCryptoHelper.h"
#import "MochaValidator.h"




//Device
#import "Mocha_DeviceInfo.h"
#import "Mocha_DeviceHandle.h"
#import "Mocha_AudioPlayer.h"
#import "Mocha_Reachability.h"
//#import "ZBarSDK.h"
//Device---Camera
//#import "CaptureManager.h"
//#import "CaptureSessionManager.h"
//#import "ImageCropView.h"
//#import "UIImage+Utilities.h"


//Connection
//#import "JSONKit.h"
#import "XMLReader.h"
#import "MochaNetworkKit.h"
#import "Mocha_FileKit.h"

//Connection---SNS
//#import "Facebook.h"
//#import "MGTwitterEngine.h"
//#import "Mocha_SNSKit_Core.h"


//WEB
//#import "MochaWebBrowserController.h"


//UI
//#import "Mocha_GridView.h"
#import "UIImageReflection.h" //UIimage category Reflection효과
#import "PullRefreshTableViewController.h" //tableview 상단 새로고침 셀
#import "PTRWithSnowViewController.h"
#import "SnowEmitterView.h"
#import "UIImage+GIF.h"

#import "MochaUIRating.h" 
//#import "FXImageView.h"
//#import "iCarousel.h"





