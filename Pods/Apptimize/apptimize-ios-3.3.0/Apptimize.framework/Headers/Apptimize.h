//
//  Apptimize.h
//  Apptimize 3.3.0
//
//  Copyright (c) 2014 Apptimize, Inc. All rights reserved.
//

#import <Availability.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_1
#error "The Apptimize library uses features only available in iOS SDK 5.1 and later."
#endif

#ifndef APPTIMIZE_EXTERN
#define APPTIMIZE_VISIBLE __attribute__((visibility("default")))
#define APPTIMIZE_EXTERN APPTIMIZE_VISIBLE extern
#endif

@class ApptimizeCodeBlock;
@protocol ApptimizeTestInfo;
@protocol ApptimizeInstantUpdateOrWinnerInfo;

// All the public constants are non-null
NS_ASSUME_NONNULL_BEGIN

/**
 * @name Log Level Options
 */

/**
 * @see `+[Apptimize setLogLevel:]`
 *
 * Log level option to show all possible logging output.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelVerbose;

/**
 * @see `+[Apptimize setLogLevel:]`
 *
 * Log level option to show additional information to aid with debugging.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelDebug;

/**
 * @see `+[Apptimize setLogLevel:]`
 *
 * Log level option to show information in addition to warnings and errors.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelInfo;

/**
 * @see `+[Apptimize setLogLevel:]`
 *
 * Log level option to show all warnings and errors.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelWarn;

/**
 * @see `+[Apptimize setLogLevel:]`
 *
 * Log level option to show only errors.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelError;

/**
 * @see `+[Apptimize setLogLevel:]`
 *
 * Log level option to disable logging entirely.
 *
 * This is the default option.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelOff;

/**
 * @name Run Test Options
 */

/**
 * Sets the amount of time to wait in milliseconds until metadata is available.
 * If this is set to 0, Apptimize will block until metadata is available.
 * If this option is omitted, Apptimize will not block for metadata.
 *
 * @see `+[Apptimize runTest:withBaseline:variations:andOptions:]`
 * @see `+[Apptimize runTest:withBaseline:apptimizeCodeBlocks:andOptions:]`
 */
APPTIMIZE_EXTERN NSString *const ApptimizeUpdateMetadataTimeoutOption;

/**
 * @name Info.plist Options
 */

/**
 * This option controls whether Apptimize will attempt to pair with the development server.
 *
 * `Info.plist`: ApptimizeDevicePairingEnabled (Boolean, default YES)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeDevicePairingOption;

/**
 * This option controls the amount of logging the Apptimize SDK will output.
 *
 * `Info.plist`: ApptimizeLogLevel (String, [verbose, debug, info, warn, error, off], default "error")
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelOption;

/**
 * This option controls how long (in milliseconds) Apptimize will wait for tests and their associated data to download.
 *
 * `Info.plist`: ApptimizeDelayUntilTestsAreAvailable (Integer, milliseconds, default 0)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeDelayUntilTestsAreAvailableOption;

/**
 * This option controls whether Apptimize will automatically import events from third-party analytics frameworks.
 *
 * `Info.plist`: ApptimizeEnableThirdPartyEventImporting (Boolean, default YES)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnableThirdPartyEventImportingOption;

/**
 * This option controls whether Apptimize will automatically export events to third-party analytics frameworks.
 *
 * `Info.plist`: ApptimizeEnableThirdPartyEventExporting (Boolean, default YES)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnableThirdPartyEventExportingOption;

/**
 * This option governs whether Apptimize will automatically log events for button clicks and table cell activations.
 *
 * `Info.plist`: ApptimizeEnableInteractionEventCollection (Boolean, default NO)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnableInteractionEventCollectionOption;

/**
 * This option governs whether Apptimize will disable all visual experiments and modifications.
 *
 * `Info.plist`: ApptimizeEnableVisualSupport (Boolean, default YES)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnableVisualSupportOption;

/**
 * This option governs whether Apptimize will show winning variants and instant updates when forceVariant is used.
 *
 * `Info.plist`: ApptimizeForceVariantsShowWinnersAndInstantUpdates (Boolean, default NO)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeForceVariantsShowWinnersAndInstantUpdatesOption;

/**
 * @name Notifications
 */

/**
 * A notification with this name is posted whenever an Apptimize test runs. The notification carries a dictionary
 * which contains the following keys: `ApptimizeTestNameUserInfoKey`, `ApptimizeVariantNameUserInfoKey` and `ApptimizeTestFirstRunUserInfoKey`.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeTestRunNotification;

/**
 * The name of the test that caused this notification in string format.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeTestNameUserInfoKey;

/**
 * The name of the variant that caused this notification in string format.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeVariantNameUserInfoKey;

/**
 * Whether this is the first time Apptimize has run this variant since enrollment in boolean format.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeTestFirstRunUserInfoKey;

/**
 * This notification is posted whenever an Apptimize recalculates its configuration. The enrolled tests may or may not have changed.
 *
 * The dynamic variable values may or may not have changed.
 *
 * This happens at various times:
 *
 * - new information from server
 * - device properties or custom attributes changed
 * - and a few other cases
 */
APPTIMIZE_EXTERN NSString *const ApptimizeTestsProcessedNotification;




/**
 * This notification is posted whenever a user has participated in an experiment. The notification carries a dictionary
 * which contains the following keys: `ApptimizeTestInfoKey`, `ApptimizeFirstParticipationKey`
 */
APPTIMIZE_EXTERN NSString *const ApptimizeParticipatedInExperimentNotification;

/**
 * This notification is posted whenever a user becomes enrolled in an experiment. The notification carries a dictionary
 * which contains the following key: `ApptimizeTestInfoKey`
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnrolledInExperimentNotification;

/**
 * This notification is posted whenever a user becomes unenrolled from an experiment. The notification carries a dictionary
 * which contains the following keys: `ApptimizeTestInfoKey`, and `ApptimizeUnenrollmentReasonKey`.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeUnenrolledInExperimentNotification;

/**
 * This notification is posted whenever Apptimize is fully initialized and tests are available to be run.
 * This notification fires one time after initialization and will not fire if setup fails
 * or tests fail to be downloaded.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeInitializedNotification;

/**
 * Information about the experiment that caused this notification as an instance of the `ApptimizeTestInfo` class.
 */
APPTIMIZE_EXTERN NSString *const ApptimizeTestInfoKey;

/**
 * The reason for the unenrollment that caused the notification as an `NSInteger`
 */
APPTIMIZE_EXTERN NSString *const ApptimizeUnenrollmentReasonKey;

/**
 * Indicates this is the first time the user has participated in the experiment as a boolean `NSNumber`
 */
APPTIMIZE_EXTERN NSString *const ApptimizeFirstParticipationKey;

NS_ASSUME_NONNULL_END

/**
 * The Apptimize interface is the main interaction point with the Apptimize SDK for developers.
 *
 * **Getting Started**
 *
 * Add your Apptimize App Key to your application's Info.plist e.g.
 *
 *     ApptimizeAppKey = "AaaaABbbbBCcccCDdddDEeeeEFfffF" // Type: String; Without quotes.
 *
 * For more information on how to get started using the Apptimize Library see:
 * https://apptimize.com/docs/installation/ios-installation.html
 */
APPTIMIZE_VISIBLE @interface Apptimize : NSObject

/**
 * @name Starting and stopping Apptimize
 */

/**
 * Start Apptimize with the default options.
 *
 * Apptimize should be started on the main thread and can be safely started more than once.
 *
 * @see `+[Apptimize startApptimizeWithApplicationKey:options:]`
 *
 * @param applicationKey The application key for this app as provided by the Apptimize dashboard.
 */
+ (void)startApptimizeWithApplicationKey:(nonnull NSString *)applicationKey;

/**
 * Start Apptimize with custom options.
 *
 * Apptimize should be started on the main thread and can be safely started more than once.
 *
 * Startup may be delayed whenever device file protection has locked files Apptimize needs
 * to start up. This can happen if your application is launched in the background before the
 * device has been unlocked for the first time after a reboot, or if the default file protection
 * level for the app has been modified to be more secure. In this case, listening for the
 * `ApptimizeInitializedNotification` will ensure that apptimize is available.
 *
 * @param applicationKey The application key for this app as provided by the Apptimize dashboard.
 * @param options A dictionary containing some combination of `ApptimizeDevicePairingOption`, `ApptimizeLogLevelOption`,
 *                `ApptimizeDelayUntilTestsAreAvailableOption`, `ApptimizeEnableThirdPartyEventImportingOption`,
 *                `ApptimizeEnableThirdPartyEventExportingOption`, `ApptimizeEnableInteractionEventCollectionOption`,
 *                `ApptimizeForceVariantsShowWinnersAndInstantUpdatesOption`,
 *                and their respective values. May be nil.
 */
+ (void)startApptimizeWithApplicationKey:(nullable NSString *)applicationKey options:(nullable NSDictionary<NSString*,id> *)options;

/**
 * Set the current customer-specified user ID.
 *
 * User IDs are arbitrary strings, except that they cannot be the empty string ("").
 * When the customer-specified user ID is nil, then Apptimize creates and uses an
 * anonymous user ID for tracking purposes. If the customerUserID is set to a non-nil
 * value, then set back to nil, Apptimize will use the same anonymous user ID as before.
 *
 * The initial default value of the customer-specified user ID is nil.
 *
 * Note: If startup is delayed due to data protection locking files, the customer
 * id change will also be delayed until startup is completed. This means that the
 * change will not be persisted or available via the customerUserID until startup
 * is completed.
 *
 * @param customerUserID An NSString object containing the user ID to set. If this is nil, the
 *        user ID is set to be anonymous.
 */
+ (void)setCustomerUserID:(nullable NSString *)customerUserID;

/**
 * Get the current customer-specified user ID.
 *
 * Note: If startup is delayed due to data protection locking files, the current customer user ID
 * will be unavailable and this function will return nil.
 *
 * @return Returns an NSString object containing the currently set customer user ID. If the user
 *         is currently anonymous, nil will be returned.
 */
+ (nullable NSString*)customerUserID;

/**
 * Get the current Apptimize-created anonymous user ID.
 *
 * This anonymous user ID will be used if-and-only-if the customer-specified user ID is nil. A
 * single anonymous user ID is created. If the customer user ID is set to a non-nil value, then
 * set back to nil, Apptimize will use the same anonymous user ID as before.
 *
 * Note: If startup is delayed due to data protection locking files, the current anonymous user ID
 * will be unavailable and this function will return nil.
 *
 * @return Returns an NSString object containing the generated anonymous user ID. This value will
 * only be nil if startup is delayed.
 */
+ (nullable NSString*)apptimizeAnonUserID;

/**
 * Disable Apptimize and all of its features for one application session.
 * No tests will run, no data will be logged, and no results will be posted to the Apptimize dashboard.
 *
 * *Use with caution.*
 */
+ (void)disable;

/**
  * @name Configuring Apptimize
  */

/**
 * Set Apptimize to run in offline mode. In offline mode, all network traffic is disabled.
 *
 * Specifically, the app will not receive metadata, upload results, or (for debug builds)
 * be able to pair with the Apptimize web dashboard.
 *
 * This setting is persistent and stays in effect across sessions.
 *
 * You may call setOffline before calling `+startApptimizeWithApplicationKey:`.
 *
 * @param offlineFlag YES to enable offline mode, NO to disable offline mode.
 */
+ (void)setOffline:(BOOL)offlineFlag;

/**
 * Get the current value of the offline setting
 *
 * @return Returns YES if Apptimize is currently in offline mode, or NO if Apptimize is not currently set to offline mode.
 */
+ (BOOL)isOffline;

/**
 * Set the log level of the Apptimize library.
 *
 * @param logLevel One of `ApptimizeLogLevelVerbose`, `ApptimizeLogLevelDebug`, `ApptimizeLogLevelInfo`,
 *                 `ApptimizeLogLevelWarn`, `ApptimizeLogLevelError` or `ApptimizeLogLevelOff`.
 */
+ (void)setLogLevel:(nonnull NSString *)logLevel;

/**
 * @name Event handling
 */

/**
 * Generate an event.
 *
 * @param eventName The name of the event.
 */
+ (void)track:(nonnull NSString *)eventName;

/**
 * Generate an event with an associated numeric value.
 *
 * @param eventName The name of the event.
 * @param value The value associated with the event.
 */
+ (void)track:(nonnull NSString *)eventName value:(double)value;

/**
  * @name SDK information.
  */

/**
 * @return Returns the version number of the Apptimize library as a string formatted as *major.minor.build* (e.g., 1.2.0).
 */
+ (nonnull NSString *)libraryVersion;

/**
 * @return Returns the ID used by Apptimize to uniquely identify users of the current app.
 */
+ (nonnull NSString *)userID;

/**
 * @name Piloting
 */

/**
 * Sets the pilotTargetingID in order to use the pilot targeting feature available on the Apptimize web dashboard.
 *
 * Pilot targeting allows you to select specific pilot targeting IDs and groups of pilot targeting IDs in the Apptimize web dashboard
 * for the purposes of targeting experiments and feature flags to specific app/user instances.
 *
 * Setting this value will cause pilot targeting to be recalculated if applicable.
 *
 * @param pilotTargetingID The string ID to use for targeting pilot users.
 */
+ (void)setPilotTargetingID:(nonnull NSString *)pilotTargetingID;

/**
 * Retrieves the currently set pilot targeting ID.
 *
 * Pilot targeting allows you to select specific pilot targeting IDs and groups of pilot targeting IDs in the Apptimize web dashboard
 * for the purposes of targeting experiments and feature flags to specific app/user instances.
 *
 * Setting this value will cause pilot targeting to be recalculated if applicable.
 *
 * @return Returns the pilot targeting ID. By default this value is nil. It should be set by your application
 *         to enable pilot targeting for the device.
 */
+ (nullable NSString *)pilotTargetingID;

/**
 * @name Experiments
 */

/**
 * Run a code block A/B test.
 *
 * When this method is called, one of the code block variants or the default code block will be run sychronously in accordance with the
 * A/B test variant this user/device is enrolled in.
 *
 * @param testName The name of the test to run.
 * @param baselineBlock The default code block to execute if we are enrolled in the default variant.
 * @param variations A dictionary containing code blocks keyed using strings. The string keys must match the name of the variant set in the Apptimize dashboard.
 * @param options Nil or a dictionary containing `ApptimizeUpdateMetadataTimeoutOption` and a value in milliseconds.
 *
 * @see *Note:* For Swift, use `+[Apptimize runTest:withBaseline:apptimizeCodeBlocks:andOptions:]`
 */
+ (void)runTest:(nonnull NSString *)testName withBaseline:(nonnull void (^)(void))baselineBlock
                                               variations:(nonnull NSDictionary<NSString*,void (^)(void)>*)variations
                                               andOptions:(nullable NSDictionary<NSString*,NSNumber*>*)options
    NS_SWIFT_UNAVAILABLE("Use runTest:withBaseline:codeBlocks:andOptions: instead");

/**
 * Run a code block A/B test.
 *
 * This is the same as calling `+[Apptimize runTest:withBaseline:variations:andOptions:]` with nil for options.
 *
 * When this method is called, one of the code block variants or the default code block will be run sychronously in accordance with the
 * A/B test variant this user/device is enrolled in.
 *
 * @param testName The name of the test to run.
 * @param baselineBlock The default code block to execute if we are enrolled in the default variant.
 * @param variations A dictionary containing code blocks keyed using strings. The string keys correspond to the name of the variant set in the Apptimize dashboard.
 *
 * @see *Note:* For Swift, use `+[Apptimize runTest:withBaseline:apptimizeCodeBlocks:andOptions:]`
 */
+ (void)runTest:(nonnull NSString *)testName withBaseline:(nonnull void (^)(void))baselineBlock
                                            andVariations:(nonnull NSDictionary<NSString*, void (^)(void)>*)variations
    NS_SWIFT_UNAVAILABLE("Use runTest:withBaseline:codeBlocks:andOptions: instead");

/**
 * Run a code block A/B test.
 *
 * This is the same as `+runTest:withBaseline:variations:andOptions:` except that instead of taking a dictionary of Objective-C code blocks,
 * it takes an array of `ApptimizeCodeBlock` objects. This is useful for Swift where using `+runTest:withBaseline:variations:andOptions` is
 * problematic due to bridging issues.
 *
 * When this method is called, one of the code block variants or the default code block will be run sychronously in accordance with the
 * A/B test variant this user/device is enrolled in.
 *
 * @param testName The name of the test to run.
 * @param baselineBlock The default code block to execute if we are enrolled in the default variant.
 * @param codeBlocks An array containing `ApptimizeCodeBlock` objects. The name of each object corresponds to the name of the variant set in the Apptimize dashboard.
 * @param options Nil or a dictionary containing `ApptimizeUpdateMetadataTimeoutOption` and a value in milliseconds.
 */
+ (void)runTest:(nonnull NSString *)testName withBaseline:(nonnull void (^)(void))baselineBlock
                                      apptimizeCodeBlocks:(nonnull NSArray<ApptimizeCodeBlock*> *)codeBlocks
                                               andOptions:(nullable NSDictionary<NSString*, NSNumber*> *)options;

/**
 * Run a code block A/B test.
 *
 * This is the same as calling `+runTest:withBaseline:apptimizeCodeBlocks:andOptions:` with nil for options.
 *
 * When this method is called, one of the code block variants or the default code block will be run sychronously in accordance with the
 * A/B test variant this user/device is enrolled in.
 *
 * @param testName The name of the test to run.
 * @param baselineBlock The default code block to execute if we are enrolled in the default variant.
 * @param codeBlocks An array containing `ApptimizeCodeBlock` objects. The name of each object corresponds to the name of the variant set in the Apptimize dashboard.
 */
+ (void)runTest:(nonnull NSString *)testName withBaseline:(nonnull void (^)(void))baselineBlock
                                   andApptimizeCodeBlocks:(nonnull NSArray<ApptimizeCodeBlock*> *)codeBlocks;

/**
 * Check whether a given feature flag is enabled or not.
 *
 * @return Returns YES if the feature flag is on, NO if it is not.
 */
+ (BOOL)isFeatureFlagOn:(nonnull NSString *)featureFlagName;

/**
 * Get information about all Apptimize A/B tests and Feature Flags that the device is
 * enrolled in.
 *
 * *Note:* this does **not** include information about Apptimize A/B tests
 * or Feature Flags that are running but that the device is not enrolled in.
 *
 * @return Returns a dictionary whose keys are the names of all A/B tests and Feature Flags
 *         the device is enrolled in, and whose values are `ApptimizeTestInfo` objects containing
 *         information about the test or Feature Flag. If this device is enrolled in no tests, an empty
 *         dictionary is returned. If `+startApptimizeWithApplicationKey:` has not been called yet, nil is returned.
 */
+ (nullable NSDictionary<NSString*,id<ApptimizeTestInfo>>*)testInfo;

/**
 * Get information about all winning A/B tests and instant updates that the device will show.
 *
 * @return Returns a dictionary whose keys are the names of all A/B tests and instant updates
 *         the device has active, and whose values are `ApptimizeInstantUpdateOrWinnerInfo` objects containing
 *         information about the test or instant update. If there are no winners or instant updates, an empty
 *         dictionary is returned. If `+startApptimizeWithApplicationKey:` has not been called yet, nil is returned.
 */
+ (nullable NSDictionary<NSString*,id<ApptimizeInstantUpdateOrWinnerInfo>>*)instantUpdateAndWinnerInfo;

/**
 * Wait for the initial set of tests to become available. This method will block for `timeout`
 * milliseconds (up to 8000) while Apptimize attempts to fetch tests and any related assets.
 *
 * This is meant to be used as part of application initialization, usually during a loading screen.
 *
 * @param timeout The amount of time to wait before giving up and enrolling in the default variants. Capped at 8000 milliseconds.
 */
+ (BOOL)waitForTestsToBecomeAvailable:(NSTimeInterval)timeout;

@end

/**
 * @name User Attributes
 */

/**
 * User Attributes for Targeting, Filtering and Segmentation.
 *
 * Attributes will be uploaded with your data so you can filter and segment on them in the Apptimize
 * results browser. You can also use them to target users via the Apptimize front-end. If you want to
 * do targeting of users based on these attributes, you should ideally set your attributes before
 * returning from application:didFinishLaunchingWithOptions:
 */
@interface Apptimize (UserAttributes)

/**
 * Set a user attribute string to be used for targeting, filtering and segmentation.
 *
 * @param attributeValue The attribute string to set for this app instance.
 * @param attributeName The name of the attribute to set.
 */
+ (void)setUserAttributeString:(nonnull NSString *)attributeValue forKey:(nonnull NSString *)attributeName;

/**
 * Set a user attribute integer to be used in targeting, filtering and segmentation.
 *
 * @param attributeValue The attribute integer to set for this app instance.
 * @param attributeName The name of the attribute to set.
 */
+ (void)setUserAttributeInteger:(NSInteger)attributeValue forKey:(nonnull NSString *)attributeName;

/**
 * Set a user attribute double to be used in targeting, filtering and segmentation.
 *
 * @param attributeValue The attribute double to set for this app instance.
 * @param attributeName The name of the attribute to set.
 */
+ (void)setUserAttributeDouble:(double)attributeValue forKey:(nonnull NSString *)attributeName;

/**
 * Set a user attribute boolean to be used in targeting, filtering and segmentation.
 *
 * @param attributeValue The attribute boolean to set for this app instance.
 * @param attributeName The name of the attribute to set.
 */
+ (void)setUserAttributeBool:(BOOL)attributeValue forKey:(nonnull NSString *)attributeName;

/**
 * Remove the user defined attribute for a given for key.
 *
 * @param attributeName The name of the attribute to remove.
 */
+ (void)removeUserAttributeForKey:(nonnull NSString *)attributeName;

/**
 * Remove all user defined attributes.
 */
+ (void)removeAllUserAttributes;

/**
 * Get the currently set string value for an attribute.
 *
 * @param attributeName The name of the attribute to query.
 *
 * @return Returns the string value associated with the supplied attribute name.
 */
+ (nullable NSString *)userAttributeStringForKey:(nonnull NSString *)attributeName;

/**
 * Get the currently set integer value for an attribute.
 *
 * @param attributeName The name of the attribute to query.
 *
 * @return Returns the integer value associated with the supplied attribute name.
 */
+ (NSInteger)userAttributeIntegerForKey:(nonnull NSString *)attributeName;

/**
 * Get the currently set double value for an attribute.
 *
 * @param attributeName The name of the attribute to query.
 *
 * @return Returns the double value associated with the supplied attribute name.
 */
+ (double)userAttributeDoubleForKey:(nonnull NSString *)attributeName;

/**
 * Get the currently set boolean value for an attribute.
 *
 * @param attributeName The name of the attribute to query.
 *
 * @return Returns the boolean value associated with the supplied attribute name.
 */
+ (BOOL)userAttributeBoolForKey:(nonnull NSString *)attributeName;

@end

/**
 * @name View Attributes
 */
@interface Apptimize (ViewAttributes)

/**
 * Set an attribute on a view to a value. Apptimize will use these attributes to gather more information about views for visual editing.
 *
 * @param value The value to set for the attribute on the view.
 * @param attributeName The name identifying the attribute to set on the view.
 * @param view The view to set the attribute on.
 */
+ (void)setValue:(nonnull NSString *)value forAttribute:(nonnull NSString *)attributeName onView:(nonnull UIView *)view;

@end

/**
 * @name Variant Overrides
 */
@interface Apptimize (VariantOverrides)

/**
 * Force a variant with a given ID to be enabled.
 *
 * Once `forceVariant` is called, Apptimize is placed in a special test mode where it will only enable variants that are
 * forced by `forceVariant`.  All other Feature Flags, A/B Experiments and Instant Updates will appear disabled/off unless
 * a specific variant is forced for those projects.  Call `forceVariant` for each of the variants you want to apply.
 *
 * @see `+[Apptimize clearAllForcedVariants]` to return Apptimize to normal operation.
 * @see `+[Apptimize clearForcedVariant:]`
 * @see `+[Apptimize getVariants]`
 *
 * All variants forced using this method will be treated as though they underwent experiment selection, and will be
 * reflected on your results dashboard.  Forced variants are persistent across application launches and will not be reset
 * except by calls to `+clearForcedVariant:variantID:` or `+clearAllForcedVariants:`.
 *
 * Note that `ApptimizeForceVariantsShowWinnersAndInstantUpdatesOption` determines
 * whether winners and instant-updates will be shown. By default, this setting is off,
 * so change your call to `+startApptimizeWithApplicationKey:options:`, or via Info.plist to turn it on as needed. The
 * "Advanced Verify" feature on the dashboard will only work when winners and instant-updates
 * are being shown, because "Advanced Verify" works by sending an instant update to the paired device.
 *
 * @param variantID The numeric ID of the variant to forcibly enable.
 */
+ (void)forceVariant:(NSInteger)variantID;

/**
 * Cancel a forced variant.
 *
 * @param variantID The numeric ID of the variant to cancel force enabling for.
 */

+ (void)clearForcedVariant:(NSInteger)variantID;

/**
 * Cancel all forced variants.
 */
+ (void)clearAllForcedVariants;

/**
 * Get a dictionary of information about all available variants.
 *
 * The returned dictionary is a mapping of variant IDs (in string format) to another dictionary with
 * the following mappings:
 *
 * Key              | Value                                                         | Type
 * -----------------|---------------------------------------------------------------|--------
 * `variantName`    | The name of this variant                                      | String
 * `variantID`      | The numeric ID of this variant                                | Integer
 * `experimentName` | The name of the experiment associated with this variant       | String
 * `experimentID`   | The numeric ID of the experiment associated with this variant | Integer
 *
 * @return Returns a dictionary describing each available variant for this app in the format described above.
 *         The returned dictionary will be empty if there are no available variants.  
 *         Returns nil if `+startApptimizeWithApplicationKey:` has not been called.
 */
+ (nullable NSDictionary<NSString*, NSDictionary<NSString*, id>*>*)getVariants;
@end

/**
 * @name Apptimize Code Block
 */

/**
 * Wraps a code block with its corresponding name.
 *
 * Useful in Swift for passing closures to
 * `+runTest:withBaseline:apptimizeCodeBlocks:andOptions:`
 */
@interface ApptimizeCodeBlock : NSObject

/**
 * Name to give this code block. Should match variant name associated with this code block.
 */
@property (nonatomic, copy, nonnull) NSString *name;

/**
 * Code block to execute when enrolled in a variant matching `name`.
 */
@property (nonatomic, copy, nonnull) void (^block)(void);

/**
 * Initialize an ApptimizeCodeBlock that contains block and corresponding name
 *
 * @param name The name of the code block, should match the variant name this code block is associated with.
 * @param block The code block to execute when enrolled in the variant matching `name`.
 *
 * @return Returns a new ApptimizeCodeBlock containing a named closure.
 */
- (nonnull instancetype)initWithName:(nonnull NSString *)name andBlock:(nonnull void (^)(void))block;
@end


/**
 * @enum      ExperimentType
 * @abstract  This enumerated type is used to indicate the type of experiment that the ApptimizeTestInfo
 *            class refers to.
 */
typedef NS_ENUM(NSInteger, ExperimentType)
{
    ExperimentTypeCodeBlock,
    ExperimentTypeFeatureFlag,
    ExperimentTypeDynamicVariables,
    ExperimentTypeVisual,
    ExperimentTypeUnknown,
};

/**
 * @name Test Information
 */

/**
 * Information about a single A/B test or feature flag this device is enrolled in.
 */
@protocol ApptimizeTestInfo <NSObject>
/**
 * @return The name of the test.
 */
- (nonnull NSString *)testName;

/**
 * @return The name of the variant of the test that this device is enrolled in.
 */
- (nonnull NSString *)enrolledVariantName;

/**
 * @return The unique numeric ID of the test.
 */
- (nonnull NSNumber *)testID;

/**
 * @return The unique numeric ID of the currently enrolled test variant.
 */
- (nonnull NSNumber *)enrolledVariantID;

/**
 * *Note:* this is the time as reported by Apptimize's servers and is not
 * affected by changes in the device's clock.
 *
 * @return The date this Apptimize test was started.
 */
- (nonnull NSDate *)testStartedDate;

/**
 * *Note:* unlike the return value for `testStartedDate`,
 * this is the time as reported by the device, and not the time as
 * reported by Apptimize's server. This difference is relevant if the
 * device's clock is inaccurate.
 *
 * @return The date this device was enrolled into this test.
 */
- (nonnull NSDate *)testEnrolledDate;

/**
 * @return The cycle ID of this test. This is 1 if it's the initial test run, and
 *         increments by 1 each time the test is restarted or for if a non-proportional
 *         allocation change is made.
 */
- (nonnull NSNumber *)cycle;

/**
 * @return The current phase of this test. This is 1 if the test has not been modified
 *         since creation, and increments by 1 each time the test is modified (such as
 *         when the test's allocations have been changed). The phase ID does not reset
 *         when a test is restarted.
 */
- (nonnull NSNumber *)currentPhase;

/**
 * @return The first phase in which this device participated in this test for this cycle.
 *         If this test has not been participated in during this cycle, this value will be 0.
 */
- (nonnull NSNumber *)participationPhase;

/**
 * Returns whether the user has participated in this test in this cycle since enrollment.
 * 
 * - For code block tests, this indicates that a codeblock has been executed for this test.
 * - For visual tests, this indicates that at least one changed element has been seen.
 * - For dynamic variable tests, this indicates that the value of a variable has
 *   been queried.
 *
 * @return Returns YES if the user has participated in this test, or NO if they have not.
 */
- (BOOL)userHasParticipated;

/**
 * @return The user id of the currently enrolled user. If the user has not been set then
 * the anonymous user id is used.
 */
- (nullable NSString *)userID;

/**
 * @return The anonymous user id currently assigned to this apptimize instance.
 */
- (nonnull NSString *)anonymousUserID;

/**
 * @return The experiment type this test info represents.
 */
- (ExperimentType)experimentType;

@end

/**
 * @name Winning Test Information
 *
 * This API is not currently available publically but if we decide to we can move this to Apptimize.h
 */

/**
 * Information about a single winning A/B test or instant update this device will display.
 */
@protocol ApptimizeInstantUpdateOrWinnerInfo <NSObject>
/**
 * @return Returns YES if this info represents an instant update, otherwise this object represents a
 * winning experiment.
 */
- (BOOL)isInstantUpdate;

/**
 * @return The experiment name of the winning experiment.
 */
- (nonnull NSString *)winningExperimentName;

/**
 * @return The experiment id of the winning experiment.
 */
- (nonnull NSNumber *)winningExperimentID;

/**
 * @return The name of the instant update.
 */
- (nonnull NSString *)instantUpdateName;

/**
 * @return The id of the instant update.
 */
- (nonnull NSNumber *)instantUpdateID;

/**
 * @return If this is a winner, then this is the name of the winning variant. Otherwise it is null.
 */
- (nonnull NSString *)winningVariantName;

/**
 * @return If this is a winner, then this is the unique numeric ID of the winning variant. Otherwise it is null.
 */
- (nonnull NSNumber *)winningVariantID;

/**
 * @return The date this device would start showing the winning variant or instant update.
 */
- (nullable NSDate *)startDate;

/**
 * @return The user id of the user that will be shown the winning variant or instant update. If the user has not been
 *  set then the anonymous user id is used.
 */
- (nullable NSString *)userID;

/**
 * @return The anonymous user id currently assigned to this apptimize instance.
 */
- (nonnull NSString *)anonymousUserID;

@end


/**
 * @enum      UnenrollmentReason
 * @abstract  This enumerated type is used to indicate why the user has been unenrolled from a
 *            given experiment.
 */
typedef NS_ENUM(NSInteger, UnenrollmentReason)
{
    /** The experiment has been stopped in the dashboard. */
    UnenrollmentReasonExperimentStopped,
    
    /** The experiment has been stopped and a winner selected in the dashboard. */
    UnenrollmentReasonExperimentWinnerSelected,
    
    /** The variant that the user has been enrolled in has changed, therefore the user
     *  has been unenrolled from the old variant.
     */
    UnenrollmentReasonVariantChanged,
    
    /** The user ID has been changed by calling the setUserId method. */
    UnenrollmentReasonUserIdChanged,
    
    /** The user is no longer enrolled in the experiment for some other reason, such
     *  as a change in the device or custom properties.
     */
    UnenrollmentReasonOther,
    
    /** The reason for unenrollment could not be determined. */
    UnenrollmentReasonUnknown
};

// Include compatibility aliases and deprecated methods, these should not be used in new code.
#import "Apptimize+Compatibility.h"

#import "Apptimize+Variables.h"

#import "Apptimize+Segment.h"

