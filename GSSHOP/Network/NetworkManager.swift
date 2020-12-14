//
//  NetworkManager.swift
//  GSSHOP
//
//  Created by Kiwon on 15/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

@objc enum NetworkReachabilityStatus: Int {
    case unknown          = -1
    case notReachable     = 0
    case viaWWAN = 1
    case viaWiFi = 2
}

@objc class NetworkManager: NSObject {
    
    /// shared instance
    @objc static var shared = NetworkManager()
    /// 상태 매니저
    let reachabilityManager = NetworkReachabilityManager(host: "www.gsshop.com")
    
    /// 네트워크 상태값 가져오기
    @objc func currentReachabilityStatus() -> NetworkReachabilityStatus {
        let status  = reachabilityManager?.networkReachabilityStatus
        
        switch status {
        case .none:
            return .notReachable
        case .unknown:
            return .unknown
        case .reachable(.wwan):
            return .viaWWAN
        case .reachable(.ethernetOrWiFi):
            return .viaWiFi
        default:
            print("[네트워크] reachabilityManager is \(reachabilityManager == nil ? "nil!!!!!!!!!" : "not nil") ")
            return .notReachable
        }
    }
    
    /// 네트워크 상태값이 Wifi 인지 확인
    @objc func isReachableViaWiFi() -> Bool {
        return currentReachabilityStatus() == .viaWiFi
    }
    
    /// 네트워크 상태값이 WWAN 인지 확인
    @objc func isReachableViaWWAN() -> Bool {
        return currentReachabilityStatus() == .viaWWAN
    }
    
    /// 네트워크 상태값 리스너 설정
    @objc func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { status in
            switch status {
                
            case .notReachable:
                print("[네트워크] ERROR - 연결되지 않음")
                
            case .unknown :
                print("[네트워크] ERROR - unknown")
                
            case .reachable(.ethernetOrWiFi):
                print("[네트워크] WiFi connection")
                
            case .reachable(.wwan):
                print("[네트워크] WWAN connection")
                
            }
            let _ = self.currentReachabilityStatus()
            
            NotificationCenter.default.post(Notification.init(name: Notification.Name.NetworkReachabilityDidChange))
        }
        // start listening
        reachabilityManager?.startListening()
    }
    
    /// 메인 그룹매장 화면구조 조회
    static func getGroupUiList(completion: @escaping ResponseBlock) {
        
        let strUrl = ServerUrl() + Const.Url.API_GROUP_LIST.url + APP_NAVI_VERSION
        ApiManager.GET(apiUrl: strUrl)
            .responseObject { (response: DataResponse<Module>) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    /// Product 데이터 조회
    static func getProduct(apiUrl: String, parameters: Parameters? = nil, completion: @escaping ResponseBlock) {
        var strUrl = apiUrl   // strUrl =  /app/section/flxblTab.gs?version=6.1&naviId=487&mseq=A00487-A-0&listtype=L&reorder=true
        #if DEBUG
        strUrl = "http://m.gsshop.com//app/section/flxbl/868?version=6.1&naviId=487&mseq=A00487-A-1&listtype=L&parentCateNo=799&reorder=true"
        #endif
        if !apiUrl.hasPrefix("http") {
            strUrl = ServerUrl() + strUrl
        }
        
        ApiManager.GET(apiUrl: strUrl, parameters: parameters)
            .responseObject { (response: DataResponse<Module>) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    /// 예시 API
    /// result 데이터가 Array 형태일 경우
    static func getArraySomeDatas(apiUrl: String, parameters: Parameters? = nil, completion: @escaping ResponseArrayBlock) {
        let testAPI = "http://m.gsshop.com//app/section/flxbl/868?version=6.1&naviId=487&mseq=A00487-A-1&listtype=L&parentCateNo=799&reorder=true"
        ApiManager.GET(apiUrl: testAPI, parameters: parameters)
            .responseArray { (response: DataResponse<[Module]>) in
                switch response.result {
                case .success(let datas):
                    completion(datas, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    
    /// 일부 URL에 대한 필터 함수
    static func filterServerURL(_ url: String) -> String {
        var apiUrl = url.replacingOccurrences(of: ServerUrl(), with: "")
        
        for serverUrl in Const.NetworkFilterURL.all {
            apiUrl = apiUrl.replacingOccurrences(of: serverUrl.url, with: "")
        }
        return apiUrl
    }
    
    ///
    static func sendSessionSynchronousRequest(_ request: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {

        var resultData : Data? = nil
        var resultResponse: URLResponse? = nil
        var resultError: Error? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            resultData = data
            resultResponse = response
            resultError = error
            
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return (resultData, resultResponse, resultError)
    }
}
