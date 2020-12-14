//
//  AB.h
//  DLActivateTester
//
//  Created by TehranSlippers on 7/16/15.
//  Copyright © 2015 TehranSlippers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABAttribution.h"
#import "ABState.h"
#import "ABPlacement.h"
#import "ABDeeplink.h"
#import "ABWebInterface.h"

#include "ABNetworkingTypedef.h"
#include "ABLogLevel.h"


@protocol ABTrackingDelegate <NSObject>

@optional
- (void)airbridgeUserAttributed:(ABAttribution *)attribution;

@end

@interface AirBridge : NSObject

@property (weak) id<ABTrackingDelegate> airbridgeTrackingDelegate;

/* state */
/**
 *  state return instance of ABState which can modify user-information.
 */
+ (ABState*) state;

/* placement */
/**
 *  placement return instance of ABPlacement which can open trackingLink.
 */
+ (ABPlacement*) placement;

/* deeplink */
/**
 *  deeplink return instance of ABDeeplink which can get deeplink from trackingLink.
 */
+ (ABDeeplink*) deeplink;

+ (ABWebInterface*) webInterface;


/* instance */
/**
 *  instance return singleton of AirBridge
 */
+ (AirBridge*)instance;

/**
 *  getInstance initialize AirBridge.
 *
 *  @discussion Install or Open Event is sent by this method.
 *
 *              Should be called on application:didFinishLaunchingWithOptions:
 *
 *  @param      appToken        can find it on dashboard
 *  @param      appName         can find it on dashboard
 *  @param      launchOptions   can get it from caller's paramemter
 */
+ (AirBridge*)getInstance:(NSString*)appToken appName:(NSString*)appName withLaunchOptions:(NSDictionary*)launchOptions;


/* airbridge options */
+ (void)setLogLevel:(ABLogLevel) level;

+ (void)setDebugNetworkMode:(BOOL)isDebug;


/* option */
/**
 *  isUserInfoHashed is state whether SDK hash user-information before send it to server.
 *
 *  @discussion default value is YES
 */
+ (BOOL)isUserInfoHashed;
+ (void)setIsUserInfoHashed:(BOOL)enable;

/**
 *  autoStartTrackingEnabled is state whether SDK automatically start tracking.
 *
 *  @discussion default value is YES
 */
+ (BOOL) autoStartTrackingEnabled;
+ (void) setAutoStartTrackingEnabled:(BOOL)enable;

+ (void) startTracking;

/**
 *  isTrackAirbridgeDeeplinkOnly whether SDK track airbridge-deeplink only
 *
 *  @discussion default value is NO
 */
+ (BOOL)isTrackAirbridgeDeeplinkOnly;
+ (void)setIsTrackAirbridgeDeeplinkOnly:(BOOL)enable;
/**
 *  isFacebookDeferredAppLinkEnabled fetch deferred app link from Facebook SDK
 *
 *  @discussion default value is NO
 */
+ (BOOL) isFacebookDeferredAppLinkEnabled;
+ (void) setIsFacebookDeferredAppLinkEnabled:(BOOL)enable;

/**
 *  setSessionTimeout set time-duration of session.
 *
 *  @discussion time-unit is millisecond
 */
+ (void)setSessionTimeout:(NSInteger)msec;

/**
 *  resetAirBridgeSDK reset all config and history of SDK
 */
+ (BOOL)resetAirBridgeSDK;
/**
 *  stopAirBridgeTracking stop SDK's tracking behavior
 */
+ (BOOL)stopAirBridgeTracking;


/* device */
/**
 *  deviceUUID return Device-Unique-Indentifier of AirBridge
 *
 *  @discussion It's format is UUID4
 */
+ (NSString*)deviceUUID;
/**
 *  isLimitADTracking return state of device's Limit-AD-Tracking
 */
+ (BOOL)isLimitADTracking;


/* ABR-DEPRECATED */
+ (AirBridge*)getInstance:(NSString*)appToken appName:(NSString*)appName __deprecated_msg("use - getInstance:appName:withLaunchOptions: instead.");
+ (AirBridge*)getInstance:(NSString*)appToken appName:(NSString*)appName facebookSDKInstalled:(BOOL)fbSet __deprecated_msg("use - getInstance:appName:withLaunchOptions: instead.");
+ (AirBridge*)getInstance:(NSString*)appToken appName:(NSString*)appName withLaunchOptions:(NSDictionary*)launchOptions facebookSDKInstalled:(BOOL)fbSet __deprecated_msg("use - getInstance:appName:withLaunchOptions: instead.");

- (void)goalWithCategory:(NSString*)category  __deprecated_msg("use ABInAppEvent instead.");
- (void)goalWithCategory:(NSString*)category customAttributes:(NSDictionary*)customAttributes  __deprecated_msg("use ABInAppEvent instead.");
- (void)goalWithCategory:(NSString*)category action:(NSString*)action label:(NSString*)label value:(NSNumber*)value customAttributes:(NSDictionary*)customAttributes  __deprecated_msg("use ABInAppEvent instead.");

- (void)setUser:(NSString*)ID  __deprecated_msg("use + state instead.");
- (void)setEmail:(NSString*)email __deprecated_msg("use + state instead.");
- (void)setPhone:(NSString*)phone __deprecated_msg("use + state instead.");
- (void)setUserAlias:(NSDictionary<NSString*, NSString*>*)alias __deprecated_msg("use + state instead.");
- (void)addUserAliasWithKey:(NSString*)key value:(NSString*)value __deprecated_msg("use + state instead.");

- (BOOL)turnOnAppboyIntegration __deprecated_msg("use - setAirbridgeTrackingDelegate: instead.");

@end
