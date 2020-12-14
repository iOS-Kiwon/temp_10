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
//Apple spec:
//
//addOperation:
//
//...
//
//operation
//
//The operation object to be added to the queue. In memory-managed applications, this object is retained by the operation queue. In garbage-collected applications, the queue strongly references the operation object.
//
//Once added, the specified operation remains in the queue until it finishes executing.

#import "MochaNetworkOperation.h" 


@class MochaNetworkOperation;
/**
 * @brief MochaNetworkCore 
 * 통신 공유 작업큐 생성 및 init - 네트워크 클래스 초기화 담당 class - MochaNetworkKit은 MKNetworkit 을 기본으로 수정 작업된 class. 각 메서드별 원문 description유지 및 MKNetworkkit 참조.
 */
@interface MochaNetworkCore : NSObject
/*!
 *  @abstract HostName of the engine
 *  @property readonlyHostName
 *  
 *  @discussion
 *	Returns the host name of the engine
 *  This property is readonly cannot be updated. 
 *  You normally initialize an engine with its hostname using the initCoreHostName:customHeaders: method
 */
@property (readonly, strong, nonatomic) NSString *readonlyHostName;

/*!
 *  @abstract Port Number that should be used by URL creating factory methods
 *  @property portNumber
 *  
 *  @discussion
 *	Set a port number for your engine if your remote URL mandates it.
 *  This property is optional and you DON'T have to specify the default HTTP port 80
 */
@property (assign, nonatomic) int portNumber;

/*!
 *  @abstract Sets an api path if it is different from root URL
 *  @property apiPath
 *  
 *  @discussion
 *	You can use this method to set a custom path to the API location if your server's API path is different from root (/) 
 *  This property is optional
 */
@property (strong, nonatomic) NSString* apiPath;

 




/*!
 *  @abstract Handler that you implement to monitor reachability changes
 *  @property reachabilityChangedHandler
 *  
 *  @discussion
 *	The framework calls this handler whenever the reachability of the host changes.
 *  The default implementation freezes the queued operations and stops network activity
 *  You normally don't have to implement this unless you need to show a HUD notifying the user of connectivity loss
 */
@property (copy, nonatomic) void (^reachabilityChangedHandler)(NetworkStatus ns);

@property (strong, nonatomic) Mocha_Reachability *reachability;

/*!
 *  @abstract Registers an associated operation subclass
 *  
 *  @discussion
 *	When you override both MochaNetworkCore and MochaNetworkOperation, you might want the engine's factory method
 *  to prepare operations of your MochaNetworkOperation subclass. To create your own MochaNetworkOperation subclasses from the factory method, you can register your MochaNetworkOperation subclass using this method.
 *  This method is optional. If you don't use, factory methods in MochaNetworkCore creates MochaNetworkOperation objects.
 */
-(void) registerOperationSubclass:(Class) aClass;

/*!
 *  @abstract Checks current reachable status
 *  
 *  @discussion
 *	This method is a handy helper that you can use to check for network reachability.
 */
-(BOOL) isReachable;



-(void) freezeOperations;






- (id) initCoreHostName:(NSString*) hostName apiPath:(NSString*) apiPath customHeaderFields:(NSDictionary*) headers;


//requestURL과 함께 간단한 Get오퍼레이션 생성

-(MochaNetworkOperation*) operationWithPath:(NSString*) path sloadertype:(MochaNetworkOperationLoadingType)ltype;
/*!
 *  @abstract Creates a simple GET Operation with a request URL and parameters
 *  
 *  @discussion
 *	Creates an operation with the given URL path.
 *  The default headers you specified in your MochaNetworkCore subclass gets added to the headers
 *  The body dictionary in this method gets attached to the URL as query parameters
 *  The HTTP Method is implicitly assumed to be GET
 *  
 */
-(MochaNetworkOperation*) operationWithPath:(NSString*) path
                                     params:(NSMutableDictionary*) body 
                                sloadertype:(MochaNetworkOperationLoadingType)ltype;

/*!
 *  @abstract Creates a simple GET Operation with a request URL, parameters and HTTP Method
 *  
 *  @discussion
 *	Creates an operation with the given URL path.
 *  The default headers you specified in your MochaNetworkCore subclass gets added to the headers
 *  The params dictionary in this method gets attached to the URL as query parameters if the HTTP Method is GET/DELETE
 *  The params dictionary is attached to the body if the HTTP Method is POST/PUT
 *  The HTTP Method is implicitly assumed to be GET
 */
-(MochaNetworkOperation*) operationWithPath:(NSString*) path
                                     params:(NSMutableDictionary*) body
                                 httpMethod:(NSString*)method 
                                sloadertype:(MochaNetworkOperationLoadingType)ltype;

/*!
 *  @abstract Creates a simple GET Operation with a request URL, parameters, HTTP Method and the SSL switch
 *  
 *  @discussion
 *	Creates an operation with the given URL path.
 *  The ssl option when true changes the URL to https.
 *  The ssl option when false changes the URL to http.
 *  The default headers you specified in your MochaNetworkCore subclass gets added to the headers
 *  The params dictionary in this method gets attached to the URL as query parameters if the HTTP Method is GET/DELETE
 *  The params dictionary is attached to the body if the HTTP Method is POST/PUT
 *  The previously mentioned methods operationWithPath: and operationWithPath:params: call this internally
 */
-(MochaNetworkOperation*) operationWithPath:(NSString*) path
                                     params:(NSMutableDictionary*) body
                                 httpMethod:(NSString*)method 
                                        ssl:(BOOL) useSSL
                                sloadertype:(MochaNetworkOperationLoadingType)ltype;

/*!
 *  @abstract Creates a simple GET Operation with a request URL
 *  
 *  @discussion
 *	Creates an operation with the given absolute URL.
 *  The hostname of the engine is *NOT* prefixed
 *  The default headers you specified in your MochaNetworkCore subclass gets added to the headers
 *  The HTTP method is implicitly assumed to be GET.
 */

-(MochaNetworkOperation*) operationWithURLString:(NSString*) urlString sloadertype:(MochaNetworkOperationLoadingType)ltype;
/*!
 *  @abstract Creates a simple GET Operation with a request URL and parameters
 *  
 *  @discussion
 *	Creates an operation with the given absolute URL.
 *  The hostname of the engine is *NOT* prefixed
 *  The default headers you specified in your MochaNetworkCore subclass gets added to the headers
 *  The body dictionary in this method gets attached to the URL as query parameters
 *  The HTTP method is implicitly assumed to be GET.
 */

-(MochaNetworkOperation*) operationWithURLString:(NSString*) urlString
                                          params:(NSMutableDictionary*) body 
                                     sloadertype:(MochaNetworkOperationLoadingType)ltype;
/*!
 *  @abstract Creates a simple Operation with a request URL, parameters and HTTP Method
 *  
 *  @discussion
 *	Creates an operation with the given absolute URL.
 *  The hostname of the engine is *NOT* prefixed
 *  The default headers you specified in your MochaNetworkCore subclass gets added to the headers
 *  The params dictionary in this method gets attached to the URL as query parameters if the HTTP Method is GET/DELETE
 *  The params dictionary is attached to the body if the HTTP Method is POST/PUT
 *	This method can be over-ridden by subclasses to tweak the operation creation mechanism.
 *  You would typically over-ride this method to create a subclass of MochaNetworkOperation (if you have one). After you create it, you should call [super prepareHeaders:operation] to attach any custom headers from super class.
 *  @seealso
 *  prepareHeaders:
 */

-(MochaNetworkOperation*) operationWithURLString:(NSString*) urlString
                                          params:(NSMutableDictionary*) body
                                      httpMethod:(NSString*)method 
                                     sloadertype:(MochaNetworkOperationLoadingType)ltype;
/*!
 *  @abstract adds the custom default headers
 *  
 *  @discussion
 *	This method adds custom default headers to the factory created MochaNetworkOperation.
 *	This method can be over-ridden by subclasses to add more default headers if necessary.
 *  You would typically over-ride this method if you have over-ridden operationWithURLString:params:httpMethod:.
 *  @seealso
 *  operationWithURLString:params:httpMethod:
 */

-(void) prepareHeaders:(MochaNetworkOperation*) operation;
/*!
 *  @abstract Handy helper method for fetching images
 *  
 *  @discussion
 *	Creates an operation with the given image URL.
 *  The hostname of the engine is *NOT* prefixed.
 *  The image is returned to the caller via MCNKImageBlock callback block. 
 */
- (MochaNetworkOperation*)imageAtURL:(NSURL *)url sloadertype:(MochaNetworkOperationLoadingType)ltype onCompletion:(MCNKImageBlock) imageFetchedBlock  ;
/*!
 *  @abstract Enqueues your operation into the shared queue
 *  
 *  @discussion
 *	The operation you created is enqueued to the shared queue. If the response for this operation was previously cached, the cached data will be returned.
 *  @seealso
 *  procqueueOperation:forceReload:
 */
-(void) procqueueOperation:(MochaNetworkOperation*) request;

/*!
 *  @abstract Enqueues your operation into the shared queue.
 *  
 *  @discussion
 *	The operation you created is enqueued to the shared queue. 
 *  When forceReload is NO, this method behaves like procqueueOperation:
 *  When forceReload is YES, No cached data will be returned even if cached data is available.
 *  @seealso
 *  procqueueOperation:
 */
-(void) procqueueOperation:(MochaNetworkOperation*) operation forceReload:(BOOL) forceReload;

/*!
 *  @abstract Enqueues your operation into the shared queue.
 *
 *  @discussion
 *	The operation you created is enqueued to the shared queue.
 *  When forceReload is NO, this method behaves like procqueueOperation:
 *  When forceReload is YES, No cached data will be returned even if cached data is available.
 *  (BOOL)sfalert YES:None failed Mocha_Alert view, NO : Show failed Mocha_Alert view
 *  @seealso
 *  procqueueOperation:
 */
-(void) procqueueOperation:(MochaNetworkOperation*) operation forceReload:(BOOL) forceReload hideFailedAlert:(BOOL) sfalert;








































///////////////////  Cache 관련 ////////////////////
/*!
 *  @abstract 캐시 디렉토리 네임
 *  
 *  @discussion
 *  이 메서드는 캐시디렉토리를 인스턴스별로 재정의할 수 있습니다.
 *	
 *  케시디렉토리는 MochaNetworkKit.h에 MKNETWORKCACHE_DEFAULT_DIRECTORY 로 정의 되어있으며 선택적으로 다른방법에 의해 재정의 할 수 있습니다.
 * The default directory (MKNetworkKitCache) within the NSCaches directory will be used otherwise
 *  Overriding this method is optional
 */
-(NSString*) cacheDirectoryName;

/*!
 *  @abstract Cache Directory In Memory Cost
 *  
 *  @discussion
 *	This method can be over-ridden by subclasses to provide an alternative in memory cache size.
 By default, MKNetworkKit caches 10 recent requests in memory
 The default size is 10
 Overriding this method is optional
 */
-(int) cacheMemoryCost;

/*!
 *  @abstract 캐시 사용 여부
 
 *    @discussion
 * 	This method should be called explicitly to enable caching for this engine.
 *   By default, MKNetworkKit doens't cache your requests.
 *   The cacheMemoryCost and cacheDirectoryName will be used when you turn caching on using this method
 */
-(void) useCache;
/** 중요
 ArticleListViewController: 기사 목록 출력 용 인터페이스,
 LPCustomTableViewController 커스텀 컨트롤러를 상속 받음.
 */

/*!
 *  @abstract Empties previously cached data
 *  
 *  @discussion
 *	This method is a handy helper that you can use to clear cached data.
 *  By default, MKNetworkKit doens't cache your requests. Use this only when you enabled caching
 *  @seealso
 *  useCache
 */
-(void) emptyCache;




@end

