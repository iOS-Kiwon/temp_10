//
//  MochaNetworkOperation.m
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

#import "MochaNetworkOperation.h"

#import "Mocha_Alert.h"
//#import "JSONKit.h"
#import "XMLReader.h"
#import "Mocha_Define.h"


@interface MochaNetworkOperation ()

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSHTTPURLResponse *response;

@property (strong, nonatomic) NSMutableDictionary *fieldsToBePosted;
@property (strong, nonatomic) NSMutableArray *filesToBePosted;
@property (strong, nonatomic) NSMutableArray *dataToBePosted;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSMutableArray *responseBlocks;
@property (strong, nonatomic) NSMutableArray *errorBlocks;

@property (nonatomic, assign) MochaNetworkOperationState state;
@property (nonatomic, assign) BOOL isCancelled;

@property (strong, nonatomic) NSMutableData *mutableData;
@property (assign, nonatomic) NSUInteger downloadedDataSize;

@property (nonatomic, strong) NSMutableArray *uploadProgressChangedHandlers;
@property (nonatomic, strong) NSMutableArray *downloadProgressChangedHandlers;
@property (nonatomic, copy) MCNKEncodingBlock postDataEncodingHandler;

@property (nonatomic, assign) NSInteger startPosition;

@property (nonatomic, strong) NSMutableArray *downloadStreams;
@property (nonatomic, strong) NSData *cachedResponse;
@property (nonatomic, copy) MCNKResponseBlock cacheHandlingBlock;

#if TARGET_OS_IPHONE    
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
#endif

@property (strong, nonatomic) NSError *error;

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)body
             httpMethod:(NSString *)method
            sloadertype:(MochaNetworkOperationLoadingType)ltype;

-(NSData*) bodyData;

-(NSString*) encodedPostDataString;
- (void) showLocalNotification;
- (void) endBackgroundTask;

@end

@implementation MochaNetworkOperation
@synthesize postDataEncodingHandler = _postDataEncodingHandler;

@synthesize stringEncoding = _stringEncoding;
@dynamic freezable;
@synthesize hideFaildAlert = _hideFaildAlert;
@synthesize uniqueId = _uniqueId; // freezable operations have a unique id

@synthesize connection = _connection;

@synthesize request = _request;
@synthesize response = _response;

@synthesize fieldsToBePosted = _fieldsToBePosted;
@synthesize filesToBePosted = _filesToBePosted;
@synthesize dataToBePosted = _dataToBePosted;

@synthesize username = _username;
@synthesize password = _password;
@synthesize clientCertificate = _clientCertificate;
@synthesize authHandler = _authHandler;
@synthesize operationStateChangedHandler = _operationStateChangedHandler;

@synthesize responseBlocks = _responseBlocks;
@synthesize errorBlocks = _errorBlocks;

@synthesize isCancelled = _isCancelled;
@synthesize mutableData = _mutableData;
@synthesize downloadedDataSize = _downloadedDataSize;

@synthesize uploadProgressChangedHandlers = _uploadProgressChangedHandlers;
@synthesize downloadProgressChangedHandlers = _downloadProgressChangedHandlers;

@synthesize downloadStreams = _downloadStreams;

@synthesize cachedResponse = _cachedResponse;
@synthesize cacheHandlingBlock = _cacheHandlingBlock;
@synthesize credentialPersistence = _credentialPersistence;

@synthesize startPosition = _startPosition;

#if TARGET_OS_IPHONE    
@synthesize backgroundTaskId = _backgroundTaskId;
@synthesize localNotification = localNotification_;
@synthesize shouldShowLocalNotificationOnError = shouldShowLocalNotificationOnError_;
#endif

@synthesize cacheHeaders = _cacheHeaders;
@synthesize error = _error;

@synthesize sloader = _sloader;

// A RESTful service should always return the same response for a given URL and it's parameters.
// this means if these values are correct, you can cache the responses
// This is another reason why we check only GET methods.
// even if URL and others are same, POST, DELETE, PUT methods should not be cached and should not be treated equal.

-(BOOL) isCacheable {
    //http 요청메소드가 GET인 것만 현재는 캐쉬가능 컨텐츠로 처리 추가 변경.
    return [self.request.HTTPMethod isEqualToString:@"GET"];
}


//=========================================================== 
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//=========================================================== 
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey 
{
    BOOL automatic;
    
    if ([theKey isEqualToString:@"postDataEncoding"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    
    return automatic;
}

//=========================================================== 
//  postDataEncoding 
//=========================================================== 
- (MCNKPostDataEncodingType)postDataEncoding
{
    return _postDataEncoding;
}
- (void)setPostDataEncoding:(MCNKPostDataEncodingType)aPostDataEncoding
{
    if (_postDataEncoding != aPostDataEncoding) {
        [self willChangeValueForKey:@"postDataEncoding"];
        _postDataEncoding = aPostDataEncoding;
        
        NSString *charset = ( NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
        
        switch (self.postDataEncoding) {
                
            case MCNKPostDataEncodingTypeURL: {
                [self.request setValue:
                 [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset]
                    forHTTPHeaderField:@"Content-Type"];
            }
                break;
            case MCNKPostDataEncodingTypeJSON: {
                //if([NSJSONSerialization class]) {
                [self.request setValue:
                 [NSString stringWithFormat:@"application/json; charset=%@", charset]
                    forHTTPHeaderField:@"Content-Type"];
                //} else {
                //    [self.request setValue:
                //     [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset]
                //        forHTTPHeaderField:@"Content-Type"];
                // }
            }
                break;
            case MCNKPostDataEncodingTypePlist: {
                [self.request setValue:
                 [NSString stringWithFormat:@"application/x-plist; charset=%@", charset]
                    forHTTPHeaderField:@"Content-Type"];
            }
                
            default:
                break;
        }
        [self didChangeValueForKey:@"postDataEncoding"];
    }
}

-(NSString*) encodedPostDataString {
    
    NSString *returnValue = @"";
    if(self.postDataEncodingHandler)
        returnValue = self.postDataEncodingHandler(self.fieldsToBePosted);    
    else if(self.postDataEncoding == MCNKPostDataEncodingTypeURL)
        returnValue = [self.fieldsToBePosted urlEncodedKeyValueString];    
    else if(self.postDataEncoding == MCNKPostDataEncodingTypeJSON)
        returnValue = [self.fieldsToBePosted jsonEncodedKeyValueString];
    else if(self.postDataEncoding == MCNKPostDataEncodingTypePlist)
        returnValue = [self.fieldsToBePosted plistEncodedKeyValueString];
    
    NSLog(@"인코딩포스트데이터 : %@", returnValue);
    return returnValue;
}

-(void) setCustomPostDataEncodingHandler:(MCNKEncodingBlock) postDataEncodingHandler forType:(NSString*) contentType {
    
    NSString *charset = ( NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    self.postDataEncoding = MCNKPostDataEncodingTypeCustom;
    self.postDataEncodingHandler = postDataEncodingHandler;
    [self.request setValue:
     [NSString stringWithFormat:@"%@; charset=%@", contentType, charset]
        forHTTPHeaderField:@"Content-Type"];
}
//=========================================================== 
//  freezable 
//=========================================================== 
- (BOOL)freezable
{
    return _freezable;
}

-(NSString*) url {
    
    return [[self.request URL] absoluteString];
}

-(NSURLRequest*) readonlyRequest {
    
    return self.request;
}

-(NSHTTPURLResponse*) readonlyResponse {
    
    return self.response ;
}

- (NSDictionary *) readonlyPostDictionary {
    
    return self.fieldsToBePosted;
}

-(NSString*) HTTPMethod {
    
    return self.request.HTTPMethod;
}

-(NSInteger) HTTPStatusCode {
    
    if(self.response)
        return self.response.statusCode;
    else
        return 0;
}

- (void)setFreezable:(BOOL)flag
{
    // get method cannot be frozen. 
    // No point in freezing a method that doesn't change server state.
    if([self.request.HTTPMethod isEqualToString:@"GET"] && flag) return;
    _freezable = flag;
    
    if(_freezable && self.uniqueId == nil)
        self.uniqueId = [NSString uniqueString];
}


- (void)setHideFaildAlert:(BOOL)flag
{
    
    _hideFaildAlert = flag;
    
}

-(BOOL) isEqual:(id)object {
    
    if([self.request.HTTPMethod isEqualToString:@"GET"] || [self.request.HTTPMethod isEqualToString:@"HEAD"]) {
        
        MochaNetworkOperation *anotherObject = (MochaNetworkOperation*) object;
        return ([[self uniqueIdentifier] isEqualToString:[anotherObject uniqueIdentifier]]);
    }
    
    return NO;
}


-(NSString*) uniqueIdentifier {
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@", self.request.HTTPMethod, self.url];
    
    /*
    if(self.username || self.password) {
        
        [str appendFormat:@" [%@:%@]",
         self.username ? self.username : @"",
         self.password ? self.password : @""];
    }
    */
    
    
    if(self.freezable) {
        
        [str appendString:self.uniqueId];
    }
    
    //return  str;
    return [str md5];
}

-(BOOL) isCachedResponse {
    
    return self.cachedResponse != nil;
}

-(void) notifyCache {
    
    if(![self isCacheable]) return;
    if(!([self.response statusCode] >= 200 && [self.response statusCode] < 300)) return;
    
    if(![self isCancelled])   
        self.cacheHandlingBlock(self);
}

-(MochaNetworkOperationState) state {
    
    return _state;
}

-(void) setState:(MochaNetworkOperationState)newState {
    
    switch (newState) {
        case MochaNetworkOperationStateReady:
            [self willChangeValueForKey:@"isReady"];
            break;
        case MochaNetworkOperationStateExecuting:
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
            break;
        case MochaNetworkOperationStateFinished:
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            break;
    }
    
    _state = newState;
    
    switch (newState) {
        case MochaNetworkOperationStateReady:
            [self didChangeValueForKey:@"isReady"];
            break;
        case MochaNetworkOperationStateExecuting:
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        case MochaNetworkOperationStateFinished:
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            break;
    }
    
    if(self.operationStateChangedHandler) {
        self.operationStateChangedHandler(newState);
    }
}



#pragma NSObject override
- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeInteger:self.stringEncoding forKey:@"stringEncoding"];
    [encoder encodeObject:self.uniqueId forKey:@"uniqueId"];
    [encoder encodeObject:self.request forKey:@"request"];
    [encoder encodeObject:self.response forKey:@"response"];
    [encoder encodeObject:self.fieldsToBePosted forKey:@"fieldsToBePosted"];
    [encoder encodeObject:self.filesToBePosted forKey:@"filesToBePosted"];
    [encoder encodeObject:self.dataToBePosted forKey:@"dataToBePosted"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.clientCertificate forKey:@"clientCertificate"];
    
    self.state = MochaNetworkOperationStateReady;
    [encoder encodeInt32:_state forKey:@"state"];
    [encoder encodeBool:self.isCancelled forKey:@"isCancelled"];
    [encoder encodeObject:self.mutableData forKey:@"mutableData"];
    [encoder encodeInteger:self.downloadedDataSize forKey:@"downloadedDataSize"];
    [encoder encodeObject:self.downloadStreams forKey:@"downloadStreams"];
    [encoder encodeInteger:self.startPosition forKey:@"startPosition"];
    [encoder encodeInteger:self.credentialPersistence forKey:@"credentialPersistence"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        [self setStringEncoding:[decoder decodeIntegerForKey:@"stringEncoding"]];
        self.request = [decoder decodeObjectForKey:@"request"];
        self.uniqueId = [decoder decodeObjectForKey:@"uniqueId"];
        
        self.response = [decoder decodeObjectForKey:@"response"];
        self.fieldsToBePosted = [decoder decodeObjectForKey:@"fieldsToBePosted"];
        self.filesToBePosted = [decoder decodeObjectForKey:@"filesToBePosted"];
        self.dataToBePosted = [decoder decodeObjectForKey:@"dataToBePosted"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.clientCertificate = [decoder decodeObjectForKey:@"clientCertificate"];
        [self setState:[decoder decodeInt32ForKey:@"state"]];
        self.isCancelled = [decoder decodeBoolForKey:@"isCancelled"];
        self.mutableData = [decoder decodeObjectForKey:@"mutableData"];
        self.downloadedDataSize = [decoder decodeIntegerForKey:@"downloadedDataSize"];
        self.downloadStreams = [decoder decodeObjectForKey:@"downloadStreams"];
        self.startPosition = [decoder decodeIntegerForKey:@"startPosition"];
        self.credentialPersistence = [decoder decodeIntegerForKey:@"credentialPersistence"];
    }
    return self;
}
/*
- (id)copyWithZone:(NSZone *)zone
{
    MochaNetworkOperation *theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setStringEncoding:self.stringEncoding];
    [theCopy setUniqueId:[self.uniqueId copy]];
    
    [theCopy setConnection:[self.connection copy]];
    [theCopy setRequest:[self.request copy]];
    [theCopy setResponse:[self.response copy]];
    [theCopy setFieldsToBePosted:[self.fieldsToBePosted copy]];
    [theCopy setFilesToBePosted:[self.filesToBePosted copy]];
    [theCopy setDataToBePosted:[self.dataToBePosted copy]];
    [theCopy setUsername:[self.username copy]];
    [theCopy setPassword:[self.password copy]];
    [theCopy setClientCertificate:[self.clientCertificate copy]];
    [theCopy setResponseBlocks:[self.responseBlocks copy]];
    [theCopy setErrorBlocks:[self.errorBlocks copy]];
    [theCopy setState:self.state];
    [theCopy setIsCancelled:self.isCancelled];
    [theCopy setMutableData:[self.mutableData copy]];
    [theCopy setDownloadedDataSize:self.downloadedDataSize];
    [theCopy setUploadProgressChangedHandlers:[self.uploadProgressChangedHandlers copy]];
    [theCopy setDownloadProgressChangedHandlers:[self.downloadProgressChangedHandlers copy]];
    [theCopy setDownloadStreams:[self.downloadStreams copy]];
    [theCopy setCachedResponse:[self.cachedResponse copy]];
    [theCopy setCacheHandlingBlock:self.cacheHandlingBlock];
    [theCopy setStartPosition:self.startPosition];
    [theCopy setCredentialPersistence:self.credentialPersistence];
    
    return theCopy;
}
*/
 
-(void) dealloc {
    //ARC
     [_connection cancel];
  
    
   /*
    @synchronized(self){
    [_connection cancel];
    [_connection release];  _connection = nil;
    self = nil;
        
    }
    */
/*
    [_uniqueId release]; _uniqueId = nil;
     [_request release]; _request = nil;
     [_response release]; _response = nil;
     [_fieldsToBePosted release]; _fieldsToBePosted = nil;
     [_filesToBePosted release]; _filesToBePosted = nil;
     [_dataToBePosted release]; _dataToBePosted = nil;
     [_username release]; _username = nil;
     [_password release]; _password = nil;
     [_responseBlocks release]; _responseBlocks = nil;
     [_errorBlocks release]; _errorBlocks = nil;
     [_mutableData release]; _mutableData = nil;
    [_cachedResponse release]; _cachedResponse = nil;
    [_downloadStreams release]; _downloadStreams = nil;
    [_uploadProgressChangedHandlers release]; _uploadProgressChangedHandlers = nil;
    [_downloadProgressChangedHandlers release]; _downloadProgressChangedHandlers = nil;
    
     [_postDataEncodingHandler release]; _postDataEncodingHandler = nil;
     [_cacheHandlingBlock release]; _cacheHandlingBlock = nil;
 
    NSLog("오퍼디얼록2");
 
    [super dealloc];
 
 */
}

-(void) updateHandlersFromOperation:(MochaNetworkOperation*) operation {
    
    [self.responseBlocks addObjectsFromArray:operation.responseBlocks];
    [self.errorBlocks addObjectsFromArray:operation.errorBlocks];
    [self.uploadProgressChangedHandlers addObjectsFromArray:operation.uploadProgressChangedHandlers];
    [self.downloadProgressChangedHandlers addObjectsFromArray:operation.downloadProgressChangedHandlers];
    [self.downloadStreams addObjectsFromArray:operation.downloadStreams];
}

-(void) setCachedData:(NSData*) cachedData {
    
    self.cachedResponse = cachedData;    
    [self operationSucceeded];
}

-(void) updateOperationBasedOnPreviousHeaders:(NSMutableDictionary*) headers {
    
    NSString *lastModified = [headers objectForKey:@"Last-Modified"];
    NSString *eTag = [headers objectForKey:@"ETag"];
    if(lastModified) {
        [self.request setValue:lastModified forHTTPHeaderField:@"IF-MODIFIED-SINCE"];
    }
    
    if(eTag) {
        [self.request setValue:eTag forHTTPHeaderField:@"IF-NONE-MATCH"];
    }    
}
/*
-(void) setUsername:(NSString*) username password:(NSString*) password {
    
    self.username = username;
    self.password = password;
}

-(void) setUsername:(NSString*) username password:(NSString*) password basicAuth:(BOOL) bYesOrNo {
    
    [self setUsername:username password:password];
    NSString *base64EncodedString = [[[NSString stringWithFormat:@"%@:%@", self.username, self.password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    [self setAuthorizationHeaderValue:base64EncodedString forAuthType:@"Basic"];
}
*/

-(void) onCompletion:(MCNKResponseBlock) response onError:(MCNKErrorBlock) error {
    
    [self.responseBlocks addObject:[response copy]];
    [self.errorBlocks addObject:[error copy]];
}

-(void) onUploadProgressChanged:(MCNKProgressBlock) uploadProgressBlock {
    
    [self.uploadProgressChangedHandlers addObject:[uploadProgressBlock copy]];
}

-(void) onDownloadProgressChanged:(MCNKProgressBlock) downloadProgressBlock {
    
    [self.downloadProgressChangedHandlers addObject:[downloadProgressBlock copy]];
}

-(void) setUploadStream:(NSInputStream*) inputStream {
    
 
    self.request.HTTPBodyStream = inputStream;
}

-(void) addDownloadStream:(NSOutputStream*) outputStream {
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.downloadStreams addObject:outputStream];
}

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params
             httpMethod:(NSString *)method
            sloadertype:(MochaNetworkOperationLoadingType)ltype

{	
    if((self = [super init])) {
        self.sloader = (MochaNetworkOperationLoadingType)ltype;
        self.responseBlocks = [NSMutableArray array];
        self.errorBlocks = [NSMutableArray array];        
        
        self.filesToBePosted = [NSMutableArray array];
        self.dataToBePosted = [NSMutableArray array];
        self.fieldsToBePosted = [NSMutableDictionary dictionary];
        
        self.uploadProgressChangedHandlers = [NSMutableArray array];
        self.downloadProgressChangedHandlers = [NSMutableArray array];
        self.downloadStreams = [NSMutableArray array];
        
        self.credentialPersistence = NSURLCredentialPersistenceForSession;
        
        NSURL *finalURL = nil;
        
        if(params)
            self.fieldsToBePosted = params;
        //shawn 인코딩세팅
   //     self.stringEncoding = -2147481280; // use a delegate to get these values later
        
        self.stringEncoding = NSUTF8StringEncoding; // use a delegate to get these values later
        
        
        if ([method isEqualToString:@"GET"])
            self.cacheHeaders = [NSMutableDictionary dictionary];
        
        if (([method isEqualToString:@"GET"] ||
             [method isEqualToString:@"DELETE"]) && (params && [params count] > 0)) {
            
            finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", aURLString, 
                                             [self encodedPostDataString]]];
        }  else {
            finalURL = [NSURL URLWithString:aURLString];
        }
        
        self.request = [NSMutableURLRequest requestWithURL:finalURL                                                           
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                            
                                           timeoutInterval:kMKNetworkKitRequestTimeOutInSeconds];
        
        
        
        [self.request setHTTPMethod:method];
        
        [self.request setValue:[NSString stringWithFormat:@"%@, en-us", 
                                [[NSLocale preferredLanguages] componentsJoinedByString:@", "]
                                ] forHTTPHeaderField:@"Accept-Language"];
        
        
 
        
        if (([method isEqualToString:@"POST"] ||
             [method isEqualToString:@"PUT"]) && (params && [params count] > 0)) {
            
            self.postDataEncoding = MCNKPostDataEncodingTypeJSON;
        }
        
        self.state = MochaNetworkOperationStateReady;
    }
    
    return self;
}

// nami0342 - set timeout interval
- (void) setTimeoutInterval : (NSTimeInterval) interval
{
    self.request.timeoutInterval = interval;
}



-(void) addHeaders:(NSDictionary*) headersDictionary {
    
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.request addValue:obj forHTTPHeaderField:key];
    }];
}

/*
-(void) setAuthorizationHeaderValue:(NSString*) token forAuthType:(NSString*) authType {
    
    [self.request setValue:[NSString stringWithFormat:@"%@ %@", authType, token] 
        forHTTPHeaderField:@"Authorization"];
}
*/
/*
 Printing a MochaNetworkOperation object is printed in curl syntax
 */

-(NSString*) description {
    
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@\nRequest\n-------\n%@", 
                                      [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]],
                                      [self curlCommandLineString]];
    
    NSString *responseString = [self responseString];    
    if([responseString length] > 0) {
        [displayString appendFormat:@"\n--------\nResponse\n--------\n%@\n", responseString];
    }
    
    return displayString;
}

-(NSString*) curlCommandLineString
{
    __weak NSMutableString *displayString = [NSMutableString stringWithFormat:@"curl -X %@", self.request.HTTPMethod];
    
    if([self.filesToBePosted count] == 0 && [self.dataToBePosted count] == 0) {
        [[self.request allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop)
         {
             [displayString appendFormat:@" -H \"%@: %@\"", key, val];
         }];
    }
    
    [displayString appendFormat:@" \"%@\"",  self.url];
    
    if ([self.request.HTTPMethod isEqualToString:@"POST"] || [self.request.HTTPMethod isEqualToString:@"PUT"]) {
        
        NSString *option = [self.filesToBePosted count] == 0 ? @"-d" : @"-F";
        if(self.postDataEncoding == MCNKPostDataEncodingTypeURL) {
            [self.fieldsToBePosted enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                [displayString appendFormat:@" %@ \"%@=%@\"", option, key, obj];    
            }];
        } else {
            [displayString appendFormat:@" -d \"%@\"", [self encodedPostDataString]];
        }
        
        
        [self.filesToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *thisFile = (NSDictionary*) obj;
            [displayString appendFormat:@" -F \"%@=@%@;type=%@\"", [thisFile objectForKey:@"name"],
             [thisFile objectForKey:@"filepath"], [thisFile objectForKey:@"mimetype"]];
        }];
        
        /* Not sure how to do this via curl
         [self.dataToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         
         NSDictionary *thisData = (NSDictionary*) obj;
         [displayString appendFormat:@" --data-binary \"%@\"", [thisData objectForKey:@"data"]];
         }];*/
    }
    
    return displayString;
}


-(void) addData:(NSData*) data forKey:(NSString*) key {
    
    [self addData:data forKey:key mimeType:@"application/octet-stream" fileName:@"file"];
}

-(void) addData:(NSData*) data forKey:(NSString*) key mimeType:(NSString*) mimeType fileName:(NSString*) fileName {
    
    [self.request setHTTPMethod:@"POST"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          data, @"data",
                          key, @"name",
                          mimeType, @"mimetype",
                          fileName, @"filename",     
                          nil];
    
    [self.dataToBePosted addObject:dict];    
}

-(void) addFile:(NSString*) filePath forKey:(NSString*) key {
    
    [self addFile:filePath forKey:key mimeType:@"application/octet-stream"];
}

-(void) addFile:(NSString*) filePath forKey:(NSString*) key mimeType:(NSString*) mimeType {
    
    [self.request setHTTPMethod:@"POST"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          filePath, @"filepath",
                          key, @"name",
                          mimeType, @"mimetype",     
                          nil];
    
    [self.filesToBePosted addObject:dict];    
}

-(NSData*) bodyData {
    
    if([self.filesToBePosted count] == 0 && [self.dataToBePosted count] == 0) {
        
        return [[self encodedPostDataString] dataUsingEncoding:self.stringEncoding];
    }
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSMutableData *body = [NSMutableData data];
    __block NSUInteger postLength = 0;    
    
    [self.fieldsToBePosted enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                     boundary, key, obj];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];        
    
    [self.filesToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *thisFile = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     boundary, 
                                     [thisFile objectForKey:@"name"], 
                                     [[thisFile objectForKey:@"filepath"] lastPathComponent], 
                                     [thisFile objectForKey:@"mimetype"]];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];         
        [body appendData: [NSData dataWithContentsOfFile:[thisFile objectForKey:@"filepath"]]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];
    
    [self.dataToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *thisDataObject = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     boundary, 
                                     [thisDataObject objectForKey:@"name"],
                                     [thisDataObject objectForKey:@"filename"], 
                                     [thisDataObject objectForKey:@"mimetype"]];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];         
        [body appendData:[thisDataObject objectForKey:@"data"]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];
    
    if (postLength >= 1)
        [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postLength] forHTTPHeaderField:@"content-length"];
    
    [body appendData: [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.stringEncoding]];
    
    NSString *charset = ( NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    
    if(([self.filesToBePosted count] > 0) || ([self.dataToBePosted count] > 0)) {
        [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundary] 
            forHTTPHeaderField:@"Content-Type"];
        
        [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    }
    
    return body;
}


-(void) setCacheHandler:(MCNKResponseBlock) cacheHandler {
    
    self.cacheHandlingBlock = cacheHandler;
}

#pragma mark -
#pragma Main method
-(void) main {
    //ARC 용
    /*
    @autoreleasepool {
        [self start];
    }
     */
    @autoreleasepool {
        [self start];
    }
 
}

-(void) endBackgroundTask {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }
    });
            
    
}

- (void) start
{
    
    //작업도중 백그라운드로 들어가거나 종료 될경우 operation cancel
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"실행???");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backgroundTaskId != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
                self.backgroundTaskId = UIBackgroundTaskInvalid;
                [self cancel];
            }
        });
    }];
    
    
    
    if(!self.isCancelled) {
        NSLog(@"작업중");
        if ([self.request.HTTPMethod isEqualToString:@"POST"] || [self.request.HTTPMethod isEqualToString:@"PUT"]) {            
            
            [self.request setHTTPBody:[self bodyData]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.connection = [[NSURLConnection alloc] initWithRequest:self.request 
                                                              delegate:self 
                                                      startImmediately:NO]; 
            
            [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                       forMode:NSRunLoopCommonModes];
            
            [self.connection start];
        });
        
        self.state = MochaNetworkOperationStateExecuting;
    }
    else {
        NSLog(@"캔슬됨");
        self.state = MochaNetworkOperationStateFinished;
        [self endBackgroundTask];
    }
}

#pragma -
#pragma mark NSOperation stuff

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady {
    
    return (self.state == MochaNetworkOperationStateReady);
}

- (BOOL)isFinished 
{
    return (self.state == MochaNetworkOperationStateFinished);
}

- (BOOL)isExecuting {
    
    return (self.state == MochaNetworkOperationStateExecuting);
}

-(void) cancel {
    
    if([self isFinished]) 
        return;
    
    @synchronized(self) {
        self.isCancelled = YES;
        
        [self.connection cancel];
        
        [self.responseBlocks removeAllObjects];
        self.responseBlocks = nil;
        
        [self.errorBlocks removeAllObjects];
        self.errorBlocks = nil;
        
        [self.uploadProgressChangedHandlers removeAllObjects];
        self.uploadProgressChangedHandlers = nil;
        
        [self.downloadProgressChangedHandlers removeAllObjects];
        self.downloadProgressChangedHandlers = nil;
        
        for(NSOutputStream *stream in self.downloadStreams)
            [stream close];
        
        [self.downloadStreams removeAllObjects];
        self.downloadStreams = nil;
        
        self.authHandler = nil;    
        self.mutableData = nil;
        self.downloadedDataSize = 0;
        
        self.cacheHandlingBlock = nil;
        
        if(self.state == MochaNetworkOperationStateExecuting)
            self.state = MochaNetworkOperationStateFinished; // This notifies the queue and removes the operation.
        // if the operation is not removed, the spinner continues to spin, not a good UX
        
        [self endBackgroundTask];

    }
    [super cancel];
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //Mocha Alert 한번만
    BOOL isthereMochaAlert = NO;
    for (UIView *subview in [([UIApplication sharedApplication].delegate).window subviews]) {
        if([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"Mocha_Alert"]){
            isthereMochaAlert =YES;
           // NSLog(@"Appdelegate Mocha_Alert !!!!   \n\n \n\n ");
        }
    }
    BOOL isImagerequest = [Mocha_Util strContain:@"image.gsshop.com" srcstring:[NSString stringWithFormat:@"%@",self.request.URL]];
    if(self.request.URL != nil)
    {
         NSLog(@"ooo requestURL: %@",  self.request.URL);
            
        if ((!isthereMochaAlert) && (!isImagerequest) && !(_hideFaildAlert==YES))
        {
            Mocha_Alert *alert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"네트워크 연결이 원활하지 않습니다.\n잠시 후 다시 실행해 주십시오."] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
            alert.tag=369; 
            [([UIApplication sharedApplication].delegate).window addSubview:alert];
        }
        
    }
    
    self.state = MochaNetworkOperationStateFinished;
    self.mutableData = nil;
    self.downloadedDataSize = 0;
    for(NSOutputStream *stream in self.downloadStreams)
        [stream close];
    
    [self operationFailedWithError:error];
    [self endBackgroundTask];
}

// SSL relate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    NSLog(@"잘못된 인증서? = %i",[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]);
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

// Connection Error를 내지 않기 위한 조치 
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"잘못된 인증서여부=%i  domain=%@",[challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust],challenge.protectionSpace.host);
    
  //  if(([challenge.protectionSpace.host isEqualToString:kTrustGSHttpsServer1]) || ([challenge.protectionSpace.host isEqualToString:kTrustGSHttpsServer2])|| ([challenge.protectionSpace.host isEqualToString:kTrustGSHttpsServer3])|| ([challenge.protectionSpace.host isEqualToString:kTrustGSHttpsServer4])|| ([challenge.protectionSpace.host isEqualToString:kTrustGSHttpsServer5])){
    
    
    BOOL isTrustrequest = [Mocha_Util strContain:kTrustGSHttpsServer1 srcstring:[NSString stringWithFormat:@"%@",challenge.protectionSpace.host]];
    if(isTrustrequest){
        
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
            
            if([challenge previousFailureCount] == 0)
                [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];            
            //신뢰https 로 정의된 경우 challenge.sender에게 continuewithout... 던져서 통과
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
            
        }
    
    }
    
    //}
}


//https 인증 관련부 요청예제 IOS 5.o
/*
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"인증!!!!!!!sssssssssssss");
    if ([challenge previousFailureCount] == 0) {
        
        if (((challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault) ||
             (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic) ||
             (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPDigest) ||
             (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM)) && 
            (self.username && self.password))
        {
            
            // for NTLM, we will assume user name to be of the form "domain\\username"
            NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username 
                                                                     password:self.password
                                                                  persistence:self.credentialPersistence];
            
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
        else if ((challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) && self.clientCertificate) {
             
            NSData *certData = [[NSData alloc] initWithContentsOfFile:self.clientCertificate];
            //내 인증서를 사용한 서버 인증시
#warning method not implemented. Don't use client certicate authentication for now.
            SecIdentityRef myIdentity;  // ???
            
            SecCertificateRef myCert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
            SecCertificateRef certArray[1] = { myCert };
            CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
            CFRelease(myCert);
            NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity
                                                                     certificates:(__bridge NSArray *)myCerts
                                                                      persistence:NSURLCredentialPersistencePermanent];
            CFRelease(myCerts);
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
        else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
#warning method not tested. proceed at your own risk
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            SecTrustResultType result;
            SecTrustEvaluate(serverTrust, &result);
           
            if(result == kSecTrustResultProceed) {
                NSLog(@"서버 trust인증??" );
                [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
            }
            else if(result == kSecTrustResultConfirm) {
                
                // ask user
                BOOL userOkWithWrongCert = NO; // (ACTUALLY CHEAT., DON'T BE A F***ING BROWSER, USERS ALWAYS TAP YES WHICH IS RISKY)
                if(userOkWithWrongCert) {
                    
                    // Cert not trusted, but user is OK with that
                    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
                } else {
                    
                    // Cert not trusted, and user is not OK with that. Don't proceed
                    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
                }
            } 
            else {
                
                // invalid or revoked certificate
                //[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
                [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        }        
        else if (self.authHandler) {
            
            // forward the authentication to the view controller that created this operation
            // If this happens for NSURLAuthenticationMethodHTMLForm, you have to
            // do some shit work like showing a modal webview controller and close it after authentication.
            // I HATE THIS.
            self.authHandler(challenge);
        }
        else {
            
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    } else {
        //  apple proposes to cancel authentication, which results in NSURLErrorDomain error -1012, but we prefer to trigger a 401
        //        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    long long size = [self.response expectedContentLength] < 0 ? 0 : [self.response expectedContentLength];
    self.response = (NSHTTPURLResponse*) response;
    
    // dont' save data if the operation was created to download directly to a stream.
    if([self.downloadStreams count] == 0)
        self.mutableData = [NSMutableData dataWithCapacity:[[NSNumber numberWithLongLong:size] intValue]];
    else
        self.mutableData = nil;
    
    for(NSOutputStream *stream in self.downloadStreams)
        [stream open];
    
    NSDictionary *httpHeaders = [self.response allHeaderFields];
    NSLog(@" 헤더 확인  %@  %@", self.url, httpHeaders);
    
    // if you attach a stream to the operation, MochaNetworkKit will not cache the response.
    // Streams are usually "big data chunks" that doesn't need caching anyways.
    
    //&& ([[httpHeaders objectForKey:@"Content-Type"] rangeOfString:@"image"].location != NSNotFound) 
    if([self.request.HTTPMethod isEqualToString:@"GET"] && [self.downloadStreams count] == 0 ){
        
        NSLog(@"캐시 헤더 세팅 작업수행");
        
        // 모든 httprequest에대해  캐시처리는  혼란을 발생시킬 여지가 있어 오로지 GET request에만 캐시처리. 캐시를 사용하려면 GET.
        //NSString *lastModified = [httpHeaders objectForKey:@"Last-Modified"];
        //NSString *eTag = [httpHeaders objectForKey:@"ETag"];
        //NSString *expiresOn = [httpHeaders objectForKey:@"Expires"];
        
        NSString *contentType = [httpHeaders objectForKey:@"Content-Type"];
        // if contentType is image, 
        
        NSDate *expiresOnDate = nil;
        
        if([contentType rangeOfString:@"image"].location != NSNotFound) {
            
            //이미지인경우 eTag 없거나 lastModified 없는 경우든 아니든 3600초 한시간 유효기간
           //서버 헤더 정보 무시하고 3600초 한시간캐시
           // if(!eTag && !lastModified)
                expiresOnDate = [[NSDate date] dateByAddingTimeInterval:kMKNetworkKitDefaultImageCacheDuration];
            
            
        }else {
            
            //서버 헤더 정보  무시 강제 생성 현시간부터 kMKNetworkKitDefaultCacheDuration
            expiresOnDate = [[NSDate date] dateByAddingTimeInterval:kMKNetworkKitDefaultCacheDuration];
        }
        
        /* //서버 헤더 정보 무시
        NSString *cacheControl = [httpHeaders objectForKey:@"Cache-Control"]; // max-age, must-revalidate, no-cache
        NSArray *cacheControlEntities = [cacheControl componentsSeparatedByString:@","];
        
        for(NSString *substring in cacheControlEntities) {
            
            NSLog(@"없음 안탐");
            
             if([substring rangeOfString:@"max-age"].location != NSNotFound) {
             
             // do some processing to calculate expiresOn
             NSString *maxAge = nil;
             NSArray *array = [substring componentsSeparatedByString:@"="];
             if([array count] > 1)
             maxAge = [array objectAtIndex:1];
             
             expiresOnDate = [[NSDate date] dateByAddingTimeInterval:[maxAge intValue]];
             }
            if([substring rangeOfString:@"no-cache"].location != NSNotFound) {
                
                // Don't cache this request  // adding말고 음수가 되게 하자
                expiresOnDate = [[NSDate date] dateByAddingTimeInterval:kMKNetworkKitDefaultCacheDuration];
            }
        }
         */
        
        // if there was a cacheControl entity, we would have a expiresOnDate that is not nil.        
        // "Cache-Control" headers take precedence over "Expires" headers
        
        NSString *expiresOn = [expiresOnDate rfc1123String];
        
        NSLog(@"추가시간 %@", expiresOn);
        // now remember lastModified, eTag and expires for this request in cache
        if(expiresOn)
            [self.cacheHeaders setObject:expiresOn forKey:@"Expires"];
       // if(lastModified)
       //     [self.cacheHeaders setObject:lastModified forKey:@"Last-Modified"];
       // if(eTag)
       //     [self.cacheHeaders setObject:eTag forKey:@"ETag"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if ([self.mutableData length] == 0 || [self.downloadStreams count] > 0) {
        // This is the first batch of data
        // Check for a range header and make changes as neccesary
        NSString *rangeString = [[self request] valueForHTTPHeaderField:@"Range"];
        if ([rangeString hasPrefix:@"bytes="] && [rangeString hasSuffix:@"-"]) {
            NSString *bytesText = [rangeString substringWithRange:NSMakeRange(6, [rangeString length] - 7)];
            self.startPosition = [bytesText integerValue];
            self.downloadedDataSize = self.startPosition;
            NSLog(@"Resuming at %ld bytes", (long)self.startPosition);
        }
    }
    
    if([self.downloadStreams count] == 0)
        [self.mutableData appendData:data];
    
    for(NSOutputStream *stream in self.downloadStreams) {
        
        if ([stream hasSpaceAvailable]) {
            const uint8_t *dataBuffer = [data bytes];
            [stream write:&dataBuffer[0] maxLength:[data length]];
        }        
    }
    
    self.downloadedDataSize += [data length];
    
    for(MCNKProgressBlock downloadProgressBlock in self.downloadProgressChangedHandlers) {
        
        if([self.response expectedContentLength] > 0) {
            
            double progress = (double)(self.downloadedDataSize) / (double)(self.startPosition + [self.response expectedContentLength]);
            NSLog(@"지속적인 다운로드 버퍼 = %.2f",progress);
            downloadProgressBlock(progress);
        }        
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten 
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    for(MCNKProgressBlock uploadProgressBlock in self.uploadProgressChangedHandlers) {
        
        if(totalBytesExpectedToWrite > 0) {
            uploadProgressBlock(((double)totalBytesWritten/(double)totalBytesExpectedToWrite));
        }
    }
}

// http://stackoverflow.com/questions/1446509/handling-redirects-correctly-with-nsurlconnection
- (NSURLRequest *)connection: (NSURLConnection *)inConnection
             willSendRequest: (NSURLRequest *)inRequest
            redirectResponse: (NSURLResponse *)inRedirectResponse;
{
    if (inRedirectResponse) {
        NSMutableURLRequest *r = [self.request mutableCopy];
        [r setURL: [inRequest URL]];
        NSLog(@"Redirected to %@", [[inRequest URL] absoluteString]);
        return r;
    } else {
        return inRequest;
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self isCancelled]) 
        return;
    
    self.state = MochaNetworkOperationStateFinished;    
    
    for(NSOutputStream *stream in self.downloadStreams)
        [stream close];
    
    if (self.response.statusCode >= 200 && self.response.statusCode < 300 && ![self isCancelled]) {
        
        self.cachedResponse = nil; // remove cached data
        [self notifyCache];        
        [self operationSucceeded];
        
    } 
    if (self.response.statusCode >= 300 && self.response.statusCode < 400) {
        
        if(self.response.statusCode == 301) {
            NSLog(@"%@ has moved to %@", self.url, [self.response.URL absoluteString]);
        }
        else if(self.response.statusCode == 304) {
            NSLog(@"%@ not modified", self.url);
        }
        else if(self.response.statusCode == 307) {
            NSLog(@"%@ temporarily redirected", self.url);
        }
        else {
            NSLog(@"%@ returned status %d", self.url, (int) self.response.statusCode);
        }
        
    } else if (self.response.statusCode >= 400 && self.response.statusCode < 600 && ![self isCancelled]) {                        
        
        [self operationFailedWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                           code:self.response.statusCode
                                                       userInfo:self.response.allHeaderFields]];
    }  
    [self endBackgroundTask];
    
}

#pragma mark -
#pragma mark Our methods to get data

-(NSData*) responseData {
    
    if([self isFinished])
        return self.mutableData;
    else if(self.cachedResponse)
        return self.cachedResponse;
    else
        return nil;
}

-(NSString*)responseString {
    
    return [self responseStringWithEncoding:self.stringEncoding];
}

-(NSString*) responseStringWithEncoding:(NSStringEncoding) encoding {
    //메모리릭 
    return [[NSString alloc] initWithData:[self responseData] encoding:encoding];
    
}

-(UIImage*) responseImage {
    
    if([[self responseData] isKindOfClass:[NSData class]] == YES ||
       [[self responseData] isKindOfClass:[NSMutableData class]] == YES)
    {
        return [UIImage imageWithData:[self responseData]];
    }
    else
    {
        return nil;
    }
}
-(NSDictionary*) responseXML {
    
    if([self responseData] == nil) return nil;
    
    NSError *error =nil;

    return [XMLReader dictionaryForXMLData:[self responseData] error:&error];
}

-(NSDictionary*) responseJSON {
    //NSLog(@"셀프 결과 : %@",[self responseData]); 
    if([self responseData] == nil) return nil;
    
    NSError *error =nil;
    
    // nami0342
//    return  [[JSONDecoder decoder] objectWithData:[self responseData] error:&error];
    return [NSJSONSerialization JSONObjectWithData:[self responseData] options:NSJSONReadingMutableContainers  error:&error];
    
}


#pragma mark -
#pragma mark Overridable methods

-(void) operationSucceeded {
    
    for(MCNKResponseBlock responseBlock in self.responseBlocks)
        responseBlock(self);
    
    //중요수정
    self.responseBlocks = nil;
    self.cachedResponse = nil;
    //[self.responseBlocks removeAllObjects];
    
 
}




#pragma mark -
#pragma mark Error LocalNoti methods

-(void) showLocalNotification {
#if TARGET_OS_IPHONE
    
    if(self.localNotification) {
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:self.localNotification];
    } else if(self.shouldShowLocalNotificationOnError) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.alertBody = [self.error localizedDescription];
        localNotification.alertAction = NSLocalizedString(@"Dismiss", @"");	
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
#endif
}

-(void) operationFailedWithError:(NSError*) error {
    
    self.error = error;
    NSLog(@"%@, [%@]", self, [self.error localizedDescription]);
    for(MCNKErrorBlock errorBlock in self.errorBlocks)
        errorBlock(error);  
    
    
    [self.errorBlocks removeAllObjects];

#if TARGET_OS_IPHONE
    NSLog(@"State: %ld", (unsigned long)[[UIApplication sharedApplication] applicationState]);
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        [self showLocalNotification];
#endif
    
}

@end

