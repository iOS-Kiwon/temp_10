//
//  ApiManager.swift
//  GSSHOP
//
//  Created by Kiwon on 15/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

let TIMEOUT_INTERVAL_REQUEST:TimeInterval   = 5
let TIMEOUT_INTERVAL_RESPONSE: TimeInterval = 10

typealias ResponseBlock = (_ data: BaseMappable? ,_ error: Error?) -> ()
typealias ResponseArrayBlock = (_ datas: [BaseMappable]? ,_ error: Error?) -> ()
typealias NetworkReachabilityListener = (NetworkReachabilityStatus) -> Swift.Void

class ApiManager  {
    
    static let shared = ApiManager()
    
    private var manager: SessionManager = {
        let nameURL = "com.gsshop.memorycach.url"
        let memoryCapacity = 100 * 1024 * 1024; // 100 MB
        let diskCapacity = 100 * 1024 * 1024; // 100 MB
        
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nameURL)
        var defaultHeaders = SessionManager.default.session.configuration.httpAdditionalHeaders
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = cache
        // 메모리 warning시 캐시 삭제 Notification 등록
        NotificationCenter.default.addObserver(ApiManager.shared, selector: #selector(deleteAllMemory), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        return SessionManager(configuration: configuration)
    }()
    
    
    /// HTTPMethod : get
    static func GET(apiUrl: String, parameters: Parameters? = nil) -> DataRequest {
        return request(apiUrl: apiUrl, methord: .get, parameters: parameters)
    }
    
    /// HTTPMethod : post
    static func POST(apiUrl: String, parameters: Parameters? = nil) -> DataRequest {
        return request(apiUrl: apiUrl, methord: .post, parameters: parameters)
    }
    
    /// HTTPMethod : put
    static func PUT(apiUrl: String, parameters: Parameters? = nil) -> DataRequest {
        return request(apiUrl: apiUrl, methord: .put, parameters: parameters)
    }
    
    /// HTTPMethod : delete
    static func DELETE(apiUrl: String, parameters: Parameters? = nil) -> DataRequest {
        return request(apiUrl: apiUrl, methord: .delete, parameters: parameters)
    }
    
    /// HTTPMethod : HEAD
    static func HEAD(apiUrl: String, parameters: Parameters? = nil) -> DataRequest {
        return request(apiUrl: apiUrl, methord: .head, parameters: parameters)
    }
    
    static func request(apiUrl: String, methord: HTTPMethod, parameters: Parameters? = nil) -> DataRequest {
        ApiManager.setUserAgent()
        return Alamofire.request(apiUrl, method: methord, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
    }
    
    /// User-Agnet 설정
    private static func setUserAgent() {
        
        // User-Agnet 설정
        if let userAgent = UserDefaults.standard.object(forKey: "UserAgent") as? String {
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            headers["User-Agent"] = userAgent
        }
        
    }
    
    /// 메모리 Warning 시
    @objc func deleteAllMemory() {
        guard let cache = URLSessionConfiguration.default.urlCache else { return }
        cache.removeAllCachedResponses()
    }
}
