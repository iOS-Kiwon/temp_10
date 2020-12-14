//
//  ImageDownOperation.swift
//  GSSHOP
//
//  Created by Kiwon on 17/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import SDWebImage

typealias GSHttpResponseBlock = (_ httpStatusCode: Int, _ fetchedImage: UIImage?, _ strInputURL: String , _ isInCache: NSNumber, _ error: NSError?) -> Void

fileprivate let TIMEOUT_INTERNAL : TimeInterval             = 5.0
fileprivate let HTTP_METHOD : String                        = "GET"

@objc class ImageDownOperation : Operation {
    var responseBlock : GSHttpResponseBlock?
    /// timeout
    var timoutInterval:TimeInterval = .zero
    /// Request URL
    var strURL : String = ""
    /// HTTP method (GET, POST, PUT, etc) - String type
    var strHttpMethod : String = ""
    /// HTTP header fields (Dictionary in Array)
    var arHttpHeaderField : NSArray?
    /// Unique string for operation handling.
    var strToken : String = ""
    /// Force download not use cache.
    var isForce : Bool = false
    /// Memory cache used option.
    var isUseMemory : Bool = false
    /// URL request
    private var m_request : URLRequest!
    /// NSURL
    private var m_url : URL?
    
    override init() {
        super.init()
        self.timoutInterval = TIMEOUT_INTERNAL
        self.strHttpMethod = HTTP_METHOD
        self.isForce = false
        self.isUseMemory = false
        
    }
    
    init(url : String = "", isforce : Bool = false, useMemory : Bool = false) {
        super.init()
        self.timoutInterval = TIMEOUT_INTERNAL
        self.strHttpMethod = HTTP_METHOD
        self.strURL = url
        self.isForce = isforce
        self.isUseMemory = useMemory
    }
    
    
    override func main() {
        if self.strURL.isEmpty { return }
        var strSHA1 : String
        
        strSHA1 = GSCryptoHelper.sharedInstance()!.sha1(self.strURL)
        
        if self.isForce == false{

            // Use a memory cache
            if self.isUseMemory == true{
                if let image = ImageDownMemoryCache.sharedInstance.getImageWithKey(strSHA1) {
                    DispatchQueue.main.async(execute: {
                        self.responseBlock!(200, image, self.strURL, true, nil)
                    })
                    return;
                }
            }
            
            // Use a file cache
            if let strSavedPath = FileUtil.getLocalCachePath(strSHA1),
                let dSavedFile = try? Data.init(contentsOf: URL(fileURLWithPath: strSavedPath)) {
                
                // 로컬데이터 사이즈 비교
                self.checkImageSizeWithServer(self.strURL, strSha1: strSHA1)
                
                var imgReturn : UIImage?
                // GIF file
                if self.strURL.lowercased() .hasSuffix(".gif") {
//                    imgReturn = UIImage.sd_animatedGIF(with: dSavedFile)
                } else {
                    imgReturn = UIImage.init(data: dSavedFile)
                }
                
                if imgReturn != nil {
                    DispatchQueue.main.async(execute: {
                        self.responseBlock!(200, imgReturn, self.strURL, true, nil)
                    });
                    return;
                }
            }
        }
        
        self.downloadImage(strSha1: strSHA1)
    }
    
    private func downloadImage(strSha1 strSHA1: String) {
        
        //2020/09/14 휴먼 애러도 방어하기위해 리퀘스트 직전에 trim 추가 (기존 로직 수정 안하려고 리퀘스트 할때에만 trim)
        guard let url = URL.init(string: self.strURL.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            // 정상적인 URL이 아님
            DispatchQueue.main.async(execute: {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "정상적인 URL이 아닙니다"])
                self.responseBlock!(error.code, nil, self.strURL, false, error)
            })
            return
        }
        self.m_url = url
        
        if self.timoutInterval <= 0.0 {
            self.timoutInterval = 10.0
        }
        
        if self.strHttpMethod.isEmpty {
            self.strHttpMethod = HTTP_METHOD
        }
         
        self.m_request = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.timoutInterval)
        self.m_request.httpMethod = self.strHttpMethod
        
        
        let task = URLSession.shared.dataTask(with: self.m_request) { (data, response, error) in
            
            guard let imgData = data else {
                DispatchQueue.main.async(execute: {
                    self.responseBlock!(0, nil, self.strURL, false, error as NSError?)
                })
                return
            }
            
            var imgReturn : UIImage?
            
            // GIF
            if self.strURL.lowercased().hasSuffix(".gif") == true{
//                imgReturn = UIImage.sd_animatedGIF(with: imgData)
            }
            else{
                imgReturn = UIImage.init(data: imgData)
            }
            
            if imgReturn == nil{
                DispatchQueue.main.async {
                    self.responseBlock!(0, nil, self.strURL, false, error as NSError?)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.responseBlock!(200, imgReturn, self.strURL, false, nil)
                // save file
                FileUtil.saveLocalCachePath(strSHA1, withData: imgData)
                if self.isUseMemory == true && imgReturn != nil {
                    ImageDownMemoryCache.sharedInstance.setImage(imgReturn!, forKey: strSHA1)
                }
            }
        }
        task.resume()
    }
    
    /// 별도 큐로 이미지 헤더 정보를 체크하고 다를 경우 저장하는 처리
    private func checkImageSizeWithServer(_ strUrl: String, strSha1 strSHA1: String) {
        
        DispatchQueue.init(label: "ImageCheckQueue").async {
            guard let strSavedFilePath = FileUtil.getLocalCachePath(strSHA1) else { return }
            guard let url = URL(string: strUrl.trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
            //2020/09/14 휴먼 애러도 방어하기위해 리퀘스트 직전에 trim 추가 (기존 로직 수정 안하려고 리퀘스트 할때에만 trim)
            
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
            request.httpMethod = "HEAD"
            let result: (data: Data?, response: URLResponse?, error: Error?) = ImageDownOperation.sendSessionSynchronousRequest(request)
            
            guard let httpUrlResponse = result.response as? HTTPURLResponse else {  return }
            
            let dicHeader = httpUrlResponse.allHeaderFields
            if let strFileSize = dicHeader["Content-Length"] as? String,
                let serverFileSize = Int.init(strFileSize),
                let localFileSize = FileUtil.filesizeWithPath(strSavedFilePath) {
                
                if(serverFileSize != localFileSize.intValue) {
                    // 다른 용량이라면 로컬에 저장 받는다.
                    
                    // GET방식으로 이미지 다운로드
                    request.httpMethod = "GET"
                    let downResult: (data: Data?, response: URLResponse?, error: Error?) = ImageDownOperation.sendSessionSynchronousRequest(request)
                    
                    if let imgData = downResult.data {
                        // 새이미지 저장
                        FileUtil.saveLocalCachePath(strSHA1, withData: imgData)
                    }
                    return
                }
            }
        }
    }
}

/// 네트워크 관련 -> 추후 Extension.Swift 또는 NetworkManager.Swift로 이동예정.
extension ImageDownOperation {
    /// Session Sync request
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
