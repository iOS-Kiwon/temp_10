//
//  MochaNetworkCore.m
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
#import "MochaNetworkCore.h"




#define kFreezableOperationExtension @"mochanetworkkitfrozenoperation"

#ifdef __OBJC_GC__
#error MochaNetworkKit does not support Objective-C Garbage Collection
#endif

@interface MochaNetworkCore ()

@property (strong, nonatomic) NSString *hostName;

@property (strong, nonatomic) NSDictionary *customHeaders;
@property (weak, nonatomic) Class customOperationSubclass;




// Cache 관련
@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@property (nonatomic, strong) NSMutableArray *memoryCacheKeys;
@property (nonatomic, strong) NSMutableDictionary *cacheInvalidationParams;
-(void) saveCache;
-(void) saveCacheData:(NSData*) data forKey:(NSString*) cacheDataKey;
-(void) checkAndRestoreFrozenOperations;
-(BOOL) isCacheEnabled;




@end

static NSOperationQueue *_sharedNetworkQueue;
int conCount = 0;

@implementation MochaNetworkCore

@synthesize hostName = _hostName;
@synthesize reachability = _reachability;
@synthesize customHeaders = _customHeaders;
@synthesize customOperationSubclass = _customOperationSubclass;


// Cache 관련
@synthesize memoryCache = _memoryCache;
@synthesize memoryCacheKeys = _memoryCacheKeys;
@synthesize cacheInvalidationParams = _cacheInvalidationParams;



@synthesize reachabilityChangedHandler = _reachabilityChangedHandler;
@synthesize portNumber = _portNumber;
@synthesize apiPath = _apiPath;




// Network Queue is a shared singleton object.
// no matter how many instances of MochaNetworkCore is created, there is one and only one network queue
// In theory an app should contain as many network engines as the number of domains it talks to

#pragma mark -
#pragma mark Initialization

+(void) initialize {
    
    if(!_sharedNetworkQueue) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedNetworkQueue = [[NSOperationQueue alloc] init];
            //KVO 옵저버 등록 = keyPath로등록된 NSOperation의 int값 operationCount 의 변화를 Noti받겠음.
            [_sharedNetworkQueue addObserver:[self self] forKeyPath:@"operationCount" options:0 context:NULL];
         //   [_sharedNetworkQueue setMaxConcurrentOperationCount:6];
            conCount = 0;
            
            
        });
    }
}
+(void)setConCount:(int)dct {
    conCount = dct;
}
+(int)conCount {
    return conCount;
}

- (id) initCoreHostName:(NSString*) hostName apiPath:(NSString*) apiPath customHeaderFields:(NSDictionary*) headers {
    
    if((self = [super init])) {
        
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //네트워크 실시간감지는 최초 인스턴스 생성시 한번이면 족함.
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification_Mocha
                                                       object:nil];
            
            self.reachability = [Mocha_Reachability reachabilityForInternetConnection];
            [self.reachability startNotifier];
            
            
            
            
        });
        
        
        /*
         //(주1)operation 구동 HUD 관련 Operation 작동여부감시 호스트별 - 인스턴스 생성시마다 옵저버 등록
         //TODO: hostName기준으로 Core instance생성되는부분을 추후 단일 Core 단일 Noti 가능토록 변경
         //instance별로 옵저버가 등록 되어 중복호출 문제외 operation비정상종료상황에서 발생되는 문제로 progressHud를 Core에서 제외하는 부분 제외 단 instance별 옵저버 등록하여 operation count를 delegate통지로 받아 사용가능
         
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(operatingtime:)
         name:kChangedMochaKVOOperationCount
         object:nil];
         
         
         */
        
        
        
        
        self.apiPath = apiPath;
        
        
        
        
        /*
         if(hostName) {
         
         self.hostName = hostName;
         
         //실시간 네트워크 감지하려면
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(reachabilityChanged:)
         name:kReachabilityChangedNotification
         object:nil];
         
         
         self.reachability = [Reachability reachabilityWithHostname:self.hostName];
         [self.reachability startNotifier];
         }
         
         */
        
        if(hostName) {
            
            self.hostName = hostName;
            
        }
        
        if([headers objectForKey:@"User-Agent"] == nil) {
            
            NSMutableDictionary *newHeadersDict = [headers mutableCopy];
            NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                         [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey],
                                         [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
            [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];
            self.customHeaders = newHeadersDict;
        } else {
            self.customHeaders = headers;
        }
        NSLog(@"유저스트 %@", [headers objectForKey:@"User-Agent"]);
        self.customOperationSubclass = [MochaNetworkOperation class];
    }
    
    return self;
}


#pragma mark -
#pragma mark Memory Mangement
/*
 -(void) dealloc {
 
 [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangedMochaKVOOperationCount object:nil];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
 }
 
 +(void) dealloc {
 
 [_sharedNetworkQueue removeObserver:[self self] forKeyPath:@"operationCount"];
 }
 */

#pragma mark -
#pragma mark KVO for network Queue

+ (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == _sharedNetworkQueue && [keyPath isEqualToString:@"operationCount"]) {
        //NSLog(@"keyPath %@",keyPath);
        
        NSLog(@"Operation 카운트 %lu",(unsigned long)[object operationCount] );
        //NSLog(@"change %@",change);
        //NSLog(@"context %@",context);
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangedMochaKVOOperationCount object:[NSNumber numberWithInteger:[_sharedNetworkQueue operationCount]]];
        
        
        
        
        /*
         dispatch_async(dispatch_get_main_queue(), ^{
         
         
         [[[UIAlertView alloc] initWithTitle:@"Operation count"
         message:[NSString stringWithFormat:@"%d", [_sharedNetworkQueue operationCount]]
         delegate:nil
         cancelButtonTitle:NSLocalizedString(@"닫기", @"dismiss")
         otherButtonTitles:nil] show];
         
         });
         */
        
#if TARGET_OS_IPHONE
        // nami0342 - UI 변경 처리는 Main Thread 에서 처리되게 수정
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIApplication sharedApplication].networkActivityIndicatorVisible =
//            ([_sharedNetworkQueue.operations count] > 0);
//        });
#endif
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

//(주1)의 이유로 잠정 사용하지 않음
/*
 #pragma mark -
 #pragma mark Operation process HUD related
 
 -(void) operatingtime:(NSNotification*) notification
 {
 
 if([_sharedNetworkQueue.operations count] == 0) {
 NSLog(@"콜 %d = === === %d", noteval, conCount);
 dispatch_async(dispatch_get_main_queue(), ^{ [self.progressHud hide:YES];});
 if(conCount != 0) {
 NSLog(@"닫음");
 [MochaNetworkCore setConCount:0];
 // self.progressHud  = [MBProgressHUD sharedInstance];
 dispatch_async(dispatch_get_main_queue(), ^{  [self.progressHud hide:YES];});
 }else {
 return;
 }
 
 }else {
 
 [MochaNetworkCore setConCount:[_sharedNetworkQueue operationCount]];
 
 // int dds =   [_sharedNetworkQueue.operations count] -1;
 
 
 MochaNetworkOperation *operation =  [_sharedNetworkQueue.operations objectAtIndex:([_sharedNetworkQueue.operations count])?[_sharedNetworkQueue.operations count]-1:0   ];
 //설정된 hostname과 다른 operation url은 처리하지 않음
 
 
 if([[operation url] rangeOfString:self.hostName].location == NSNotFound) {
 NSLog(@"리턴");
 return;
 }
 else {
 NSLog(@"매칭? = %d", [_sharedNetworkQueue.operations count]);
 
 //NSString *className = [NSString stringWithFormat:@"%s",   object_getClassName([super class])];
 if([operation sloader] != MochaNetworkOperationLINone) {
 //  NSLog(@"트루 %@",className);
 //[NSThread sleepForTimeInterval:0.5];
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 
 self.progressHud.labelText = [NSString stringWithFormat:@"ProcOperation count %d ",[_sharedNetworkQueue.operations count]];
 
 //self.progressHud.detailsLabelText = @"UI 변경필요...";
 [[UIApplication sharedApplication].delegate.window addSubview:self.progressHud];
 
 self.progressHud.userInteractionEnabled = NO;
 [self.progressHud show:YES];
 });
 NSLog(@"로딩1");
 //                                                   if (self.progressHud  == nil) {
 //
 //                                        }
 //                                        else {
 //                                             dispatch_async(dispatch_get_main_queue(), ^{
 //                                            self.progressHud.labelText = [NSString stringWithFormat:@"ProcOperation Operation count %d ",[_sharedNetworkQueue.operations count]];
 //                                            [self.progressHud show:YES];
 //                                                   });
 //                                               NSLog(@"돌아라2");
 //                                        }
 
 
 
 }
 //NSLog(@"ㅇㅇㅇㅇㅇ클래스  = %@, %@, %d    ", [operation url], self.hostName, [operation sloader] );
 }
 
 
 
 
 
 
 
 }
 
 
 
 }
 */

#pragma mark -
#pragma mark Reachability related

-(void) reachabilityChanged:(NSNotification*) notification
{
    //Mocha_Alert* alert = [[Mocha_Alert alloc] init];
    if([self.reachability currentReachabilityStatus] == ReachableViaWiFi)
    {
        NSLog(@"Server [%@] is reachable via Wifi", self.hostName);
        //  alert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"Server [%@]에 Wifi 접속되었습니다. max operation ct setting = 6", self.hostName] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
        //  alert.tag=1;
        
     //   [_sharedNetworkQueue setMaxConcurrentOperationCount:6];
        
        [self checkAndRestoreFrozenOperations];
    }
    else if([self.reachability currentReachabilityStatus] == ReachableViaWWAN)
    {
        NSLog(@"Server [%@] is reachable only via cellular data", self.hostName);
        // alert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"Server [%@]에 3G 접속되었습니다. max operation ct setting = 2", self.hostName] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
        // alert.tag=2;
      //  [_sharedNetworkQueue setMaxConcurrentOperationCount:2];
        [self checkAndRestoreFrozenOperations];
    }
    else if([self.reachability currentReachabilityStatus] == NotReachable)
    {
        NSLog(@"Server [%@] is not reachable", self.hostName);
        // alert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"Server [%@]접속불가. 네트워크 환경을 확인하세요. operation 취소", self.hostName] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
        // alert.tag=3;
        [self freezeOperations];
    }
    
    if(self.reachabilityChangedHandler) {
        NSLog(@"GG");
        self.reachabilityChangedHandler([self.reachability currentReachabilityStatus]);
    }
    
    // [([UIApplication sharedApplication].delegate).window addSubview:alert];
}

#pragma mark Freezing operations (Called when network connectivity fails)
-(void) freezeOperations {
    
    if(![self isCacheEnabled]) return;
    int i= 0 ;
    for(MochaNetworkOperation *operation in _sharedNetworkQueue.operations) {
        NSLog(@"취소카운트0 %d",i);
        
        // freeze only freeable operations.
        if(![operation freezable]) continue;
        
        if(!self.hostName) return;
        
        // freeze only operations that belong to this server
        if([[operation url] rangeOfString:self.hostName].location == NSNotFound) continue;
        
        NSString *archivePath = [[[self cacheDirectoryName] stringByAppendingPathComponent:[operation uniqueIdentifier]]
                                 stringByAppendingPathExtension:kFreezableOperationExtension];
        [NSKeyedArchiver archiveRootObject:operation toFile:archivePath];
        NSLog(@"취소카운트1 %d",i);
        [operation cancel];
        i++;
    }
    
}

-(void) checkAndRestoreFrozenOperations {
    
    if(![self isCacheEnabled]) return;
    
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryName] error:&error];
    if(error)
        NSLog(@"%@", error);
    
    NSArray *pendingOperations = [files filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *thisFile = (NSString*) evaluatedObject;
        return ([thisFile rangeOfString:kFreezableOperationExtension].location != NSNotFound);
    }]];
    
    for(NSString *pendingOperationFile in pendingOperations) {
        
        NSString *archivePath = [[self cacheDirectoryName] stringByAppendingPathComponent:pendingOperationFile];
        MochaNetworkOperation *pendingOperation = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        [self procqueueOperation:pendingOperation];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:archivePath error:&error];
        if(error)
            NSLog(@"%@", error);
    }
}

-(NSString*) readonlyHostName {
    
    return _hostName;
}

-(BOOL) isReachable {
    
    return ([self.reachability currentReachabilityStatus] != NotReachable);
}

#pragma mark -
#pragma mark Create methods

-(void) registerOperationSubclass:(Class) aClass {
    
    self.customOperationSubclass = aClass;
}

-(MochaNetworkOperation*) operationWithPath:(NSString*) path sloadertype:(MochaNetworkOperationLoadingType)ltype{
    
    return [self operationWithPath:path params:nil sloadertype:ltype];
}

-(MochaNetworkOperation*) operationWithPath:(NSString*) path
                                     params:(NSMutableDictionary*) body
                                sloadertype:(MochaNetworkOperationLoadingType)ltype {
    
    return [self operationWithPath:path
                            params:body
                        httpMethod:@"GET"
                       sloadertype:ltype];
}

-(MochaNetworkOperation*) operationWithPath:(NSString*) path
                                     params:(NSMutableDictionary*) body
                                 httpMethod:(NSString*)method
                                sloadertype:(MochaNetworkOperationLoadingType)ltype{
    
    return [self operationWithPath:path params:body httpMethod:method ssl:NO sloadertype:ltype];
}

-(MochaNetworkOperation*) operationWithPath:(NSString*) path
                                     params:(NSMutableDictionary*) body
                                 httpMethod:(NSString*)method
                                        ssl:(BOOL) useSSL
                                sloadertype:(MochaNetworkOperationLoadingType)ltype {
    
    if(self.hostName == nil) {
        
        NSLog(@"Hostname is nil, use operationWithURLString: method to create absolute URL operations");
        return nil;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@", useSSL ? @"https" : @"http", self.hostName];
    
    if(self.portNumber != 0)
        [urlString appendFormat:@":%d", self.portNumber];
    
    //apiPath 는 appdelegate에서 nil 로 정의되어있음.
    if(self.apiPath)
        [urlString appendFormat:@"/%@", self.apiPath];
    
    
    if(path != nil  ){
        //path앞에 /있는지 확인후 adding v4.6.1 수정사항
        if([path hasPrefix:@"/"]){
            [urlString appendFormat:@"%@", path];
            
        }else {
            [urlString appendFormat:@"/%@", path];
        }
    }else{
    }
    NSLog(@"요청 URL : %@",urlString);
    
    return [self operationWithURLString:urlString params:body httpMethod:method sloadertype:ltype];
}

-(MochaNetworkOperation*) operationWithURLString:(NSString*) urlString sloadertype:(MochaNetworkOperationLoadingType)ltype{
    
    return [self operationWithURLString:urlString params:nil httpMethod:@"GET" sloadertype:ltype];
}

-(MochaNetworkOperation*) operationWithURLString:(NSString*) urlString
                                          params:(NSMutableDictionary*) body
                                     sloadertype:(MochaNetworkOperationLoadingType)ltype{
    
    return [self operationWithURLString:urlString params:body httpMethod:@"GET" sloadertype:ltype];
}


-(MochaNetworkOperation*) operationWithURLString:(NSString*) urlString
                                          params:(NSMutableDictionary*) body
                                      httpMethod:(NSString*)method
                                     sloadertype:(MochaNetworkOperationLoadingType)ltype{
    
    MochaNetworkOperation *operation = [[self.customOperationSubclass alloc] initWithURLString:urlString params:body httpMethod:method sloadertype:ltype];
    
    [self prepareHeaders:operation];
    
    //이부분이 NON ARC기반 비동기 통신의 메모리 관리 맹점
    // 자동릴리즈된 operation return 시  bad access memory error 발생되므로 ARC기반 개발로 넘어갈때까지 감수하고 core subclass에서 통신완료후 release
    return operation;
}

-(void) prepareHeaders:(MochaNetworkOperation*) operation {
    
    [operation addHeaders:self.customHeaders];
}




-(NSData*) cachedDataForOperation:(MochaNetworkOperation*) operation {
    
    // nami0342 - self.memoryCache 이 nil 일 경우 체크
    if(self.memoryCache == nil)
    {
        self.memoryCache = [NSMutableDictionary dictionaryWithCapacity:MKNETWORKCACHE_DEFAULT_COST];
        return nil;
    }
    
    
    
    NSData *cachedData = [self.memoryCache objectForKey:[operation uniqueIdentifier]];
    if(cachedData) return cachedData;
    

    NSString *filePath = [[self cacheDirectoryName] stringByAppendingPathComponent:[operation uniqueIdentifier]];
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //NSLog(@"cached data 패스 %@", filePath);
        cachedData = [NSData dataWithContentsOfFile:filePath];
        [self saveCacheData:cachedData forKey:[operation uniqueIdentifier]]; // bring it back to the in-memory cache
        return cachedData;
    }
    
    return nil;
}







//procqueueOperation 은 Core 를 통해 초기화된 Operation 을 즉시 _sharedNetworkQueue에 붙여줌 - 이후 개별 오퍼레이션 수행
-(void) procqueueOperation:(MochaNetworkOperation*) operation {
    
    [self procqueueOperation:operation forceReload:NO];
}

-(void) procqueueOperation:(MochaNetworkOperation*) operation forceReload:(BOOL) forceReload {
    [self procqueueOperation:operation forceReload:forceReload hideFailedAlert:NO];
}

-(void) procqueueOperation:(MochaNetworkOperation*) operation forceReload:(BOOL) forceReload hideFailedAlert:(BOOL) sfalert {
    
    //sfalert = 통신실패 알럿 NO:노출 YES:미노출
    NSParameterAssert(operation != nil);
    
    
    
    [operation setHideFaildAlert:sfalert];
    
    
    
    // Grab on to the current queue (We need it later)
    dispatch_queue_t originalQueue = dispatch_get_current_queue();
    dispatch_retain(originalQueue);
    // Jump off the main thread, mainly for disk cache reading purposes
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //오퍼레이션 failed alert 노출유무
        
        
        [operation setCacheHandler:^(MochaNetworkOperation* completedCacheableOperation) {
            // if this is not called, the request would have been a non cacheable request
            //completedCacheableOperation.cacheHeaders;
            
            // nami0342 - response data nil 분기
            if(completedCacheableOperation == nil)
            {}
            else if([completedCacheableOperation responseData] == nil)
            {}
            else
            {
                NSString *uniqueId = [completedCacheableOperation uniqueIdentifier];
                [self saveCacheData:[completedCacheableOperation responseData]
                             forKey:uniqueId];
                
                [self.cacheInvalidationParams setObject:completedCacheableOperation.cacheHeaders forKey:uniqueId];
            }
        }];
        
        
        __block double expiryTimeInSeconds = 0.0f;
        
        if([operation isCacheable]) {
            
            if(!forceReload) {
                
                NSData *cachedData = [self cachedDataForOperation:operation];
                if(cachedData) {
                    
                    
                    
                    NSString *uniqueId = [operation uniqueIdentifier];
                    NSMutableDictionary *savedCacheHeaders = [self.cacheInvalidationParams objectForKey:uniqueId];
                    // there is a cached version.
                    // this means, the current operation is a "GET"
                    if(savedCacheHeaders) {
                        
                        @try {
                            
                            
                            
                            NSString *expiresOn = [savedCacheHeaders objectForKey:@"Expires"];
                            
                            if(expiresOn != nil) {
                                dispatch_sync(originalQueue, ^{
                                    NSDate *expiresOnDate = [NSDate dateFromRFC1123:expiresOn];
                                    expiryTimeInSeconds = [expiresOnDate timeIntervalSinceNow];
                                    
                                    
                                    //NSLog(@"현시간 기준 expiryTime = %@, %f", expiresOn, expiryTimeInSeconds);
                                     if(expiryTimeInSeconds >= 0) {
                                         dispatch_async(originalQueue, ^{
                                             
                                             
                                        // Jump back to the original thread here since setCachedData updates the main thread
                                        [operation setCachedData:cachedData];
                                           dispatch_release(originalQueue);
                                        });
                                     }
                                    
                                    
                                });
                                
                                //[headers objectForKey:@"Last-Modified"]  [headers objectForKey:@"ETag"]
                                //윗줄과같은 추가 헤더 변수를 request heder에 사용하려면 아랫줄
                                //[operation updateOperationBasedOnPreviousHeaders:savedCacheHeaders];
                                
                            }
                            
                        }@catch (NSException *exception) {
                            NSLog(@"saved Cached data not exist Expires info  : %@",exception);
                        }
                        
                        
                        
                    }
                }
            }
            
            
            
            
            
            
            dispatch_async(originalQueue, ^{
                
                NSUInteger index = [_sharedNetworkQueue.operations indexOfObject:operation];
                if(index == NSNotFound) {
                    
                    if(expiryTimeInSeconds <= 0) {
                        [_sharedNetworkQueue addOperation:operation]; //[operation release];
                    }
                    else if(forceReload){
                        [_sharedNetworkQueue addOperation:operation]; //[operation release];
                        // else don't do anything
                    }
                }
                else {
                    NSLog(@"중복 오퍼레이션");
                    
                    // nami0342 - 인덱스 아웃오브바운드 체크
                    if([_sharedNetworkQueue.operations count] >= index + 1)
                    {
                        // 오퍼레이션 중복 등록 방지 이미 처리중인 큐에 등록된 오퍼레이션은..
                        id idOps = (MochaNetworkOperation*) [_sharedNetworkQueue.operations objectAtIndex:index];
                        
                        if([idOps isKindOfClass:[MochaNetworkOperation class]] == YES)
                        {
                            if([idOps respondsToSelector:@selector(updateHandlersFromOperation:)] == YES)
                            {
                                [((MochaNetworkOperation *)idOps) updateHandlersFromOperation:operation];
                            }
                        }
                    }
                }
                
                
                dispatch_release(originalQueue);
            });
            
            
            
        } else {
            [_sharedNetworkQueue addOperation:operation];
        }
        
        if([self.reachability currentReachabilityStatus] == NotReachable){
            [self freezeOperations];
        }
        
    });
}

- (MochaNetworkOperation*)imageAtURL:(NSURL *)url sloadertype:(MochaNetworkOperationLoadingType)ltype onCompletion:(MCNKImageBlock) imageFetchedBlock
{
    
    //이미지 요청은 캐싱기본요구사항 Warning~
#ifdef DEBUG
    if(![self isCacheEnabled]) NSLog(@"imageAtURL:onCompletion: requires caching to be enabled.")
#endif
        if (url == nil || [[url absoluteString] isEqualToString:@""]) {
            return nil;
        }
    
    
    MochaNetworkOperation *op = [self operationWithURLString:[url absoluteString] sloadertype:ltype];
    
    // nami0342 - 이미지는 네트워크 오류 팝업 안뜨게 처리
    [self procqueueOperation:op forceReload:NO hideFailedAlert:YES];
    
    [op onCompletion:^(MochaNetworkOperation *completedOperation){
         
         UIImage *imgReturn = nil;
         
         if ([[url absoluteString] hasSuffix:@".gif"]) {
             imgReturn = [UIImage sd_animatedGIFWithData:[completedOperation responseData]];
         }else{
             imgReturn = [completedOperation responseImage];
         }        
        
         imageFetchedBlock(imgReturn,url,[completedOperation isCachedResponse]);
        
     }
     onError:^(NSError* error) {
         
         NSLog(@"%@", error);
     }];
    
    return op;
}










































#pragma mark -
#pragma mark Cache related

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:MKNETWORKCACHE_DEFAULT_DIRECTORY];
    return cacheDirectoryName;
}

-(int) cacheMemoryCost {
    
    
    return MKNETWORKCACHE_DEFAULT_COST;
}

-(void) saveCache {
    
    for(NSString *cacheKey in [self.memoryCache allKeys])
    {
        NSString *filePath = [[self cacheDirectoryName] stringByAppendingPathComponent:cacheKey];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            ErLog(error);
        }
        
        [[self.memoryCache objectForKey:cacheKey] writeToFile:filePath atomically:YES];
    }
    
    [self.memoryCache removeAllObjects];
    [self.memoryCacheKeys removeAllObjects];
    
    NSString *cacheInvalidationPlistFilePath = [[self cacheDirectoryName] stringByAppendingPathExtension:@"plist"];
    [self.cacheInvalidationParams writeToFile:cacheInvalidationPlistFilePath atomically:YES];
}

-(void) saveCacheData:(NSData*) data forKey:(NSString*) cacheDataKey
{
    @synchronized(self) {
        
        // nami0342 - Modify response memory cache logic.
        if(data == nil || cacheDataKey == nil)
            return;
        
        if(self.memoryCache == nil)
            self.memoryCache = [NSMutableDictionary dictionaryWithCapacity:MKNETWORKCACHE_DEFAULT_COST];
        
        if(self.memoryCacheKeys == nil)
            self.memoryCacheKeys = [NSMutableArray arrayWithCapacity:MKNETWORKCACHE_DEFAULT_COST];

        
        [self.memoryCache setObject:data forKey:cacheDataKey];
        
        NSUInteger index = [self.memoryCacheKeys indexOfObject:cacheDataKey];
        
        if(index != NSNotFound)
            [self.memoryCacheKeys removeObjectAtIndex:index];
    
        [self.memoryCacheKeys insertObject:cacheDataKey atIndex:0]; // remove it and insert it at start
        
        if([self.memoryCacheKeys count] >= [self cacheMemoryCost])
        {
            NSString *lastKey = [self.memoryCacheKeys lastObject];
            NSData *data = [self.memoryCache objectForKey:lastKey];
            NSString *filePath = [[self cacheDirectoryName] stringByAppendingPathComponent:lastKey];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                ErLog(error);
            }
            [data writeToFile:filePath atomically:YES];
            
            [self.memoryCacheKeys removeLastObject];
            @try {
                if(lastKey != nil) {
                    [self.memoryCache removeObjectForKey:lastKey];
                }
            }
            @catch (NSException *exception) {
                NSLog(@" MochaNetworkCore critical Error");
            }
            
            
        }
    }
}

/*
 - (BOOL) dataOldness:(NSString*) imagePath
 {
 NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePath error:nil];
 NSDate *creationDate = [attributes valueForKey:NSFileCreationDate];
 
 return abs([creationDate timeIntervalSinceNow]);
 }*/

-(BOOL) isCacheEnabled {
    
    BOOL isDir = NO;
    BOOL isCachingEnabled = [[NSFileManager defaultManager] fileExistsAtPath:[self cacheDirectoryName] isDirectory:&isDir];
    return isCachingEnabled;
}

-(void) useCache {
    
    self.memoryCache = [NSMutableDictionary dictionaryWithCapacity:MKNETWORKCACHE_DEFAULT_COST];
    self.memoryCacheKeys = [NSMutableArray arrayWithCapacity:MKNETWORKCACHE_DEFAULT_COST];
    self.cacheInvalidationParams = [NSMutableDictionary dictionary];
    
    NSString *cacheDirectory = [self cacheDirectoryName];
    BOOL isDirectory = YES;
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] && isDirectory;
    
    if (!folderExists)
    {
        
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *cacheInvalidationPlistFilePath = [cacheDirectory stringByAppendingPathExtension:@"plist"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheInvalidationPlistFilePath];
    
    if (fileExists)
    {
        NSLog(@"plist 있음 %@",cacheInvalidationPlistFilePath);
        self.cacheInvalidationParams = [NSMutableDictionary dictionaryWithContentsOfFile:cacheInvalidationPlistFilePath];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    
    
    
}

-(void) emptyCache {
    
    [self saveCache]; // ensures that invalidation params are written to disk properly
    NSError *error = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager]
                                  contentsOfDirectoryAtPath:[self cacheDirectoryName] error:&error];
    if(error) NSLog(@"%@", error);
    
    error = nil;
    for(NSString *fileName in directoryContents) {
        
        NSString *path = [[self cacheDirectoryName] stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if(error) NSLog(@"%@", error);
    }
   //plist 파일삭제 -20141212 plist 파일초기화를 
     error = nil;
     NSString *cacheInvalidationPlistFilePath = [[self cacheDirectoryName] stringByAppendingPathExtension:@"plist"];
    [[NSFileManager defaultManager] removeItemAtPath:cacheInvalidationPlistFilePath error:&error];
    if(error) NSLog(@"%@", error);
}
@end

