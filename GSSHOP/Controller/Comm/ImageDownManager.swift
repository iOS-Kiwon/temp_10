//
//  ImageDownManager.swift
//  GSSHOP
//
//  Created by Kiwon on 04/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class ImageDownManager: NSObject {
    
    static let shared : ImageDownManager = {
        let instance = ImageDownManager()
        instance.m_oqImageDown = OperationQueue()
        return instance
    }()
    
    private var m_oqImageDown : OperationQueue!
    
    static func sharedInstance() -> ImageDownManager {
        return shared
    }
    /// 디스크  캐시
    @objc class func blockImageDownWithURL(_ strURL:NSString, responseBlock : @escaping GSHttpResponseBlock) {
        ImageDownManager.blockImageDownWithURL(strURL, isForce: false, useMemory: false, responseBlock: responseBlock)
    }
    
    /// 강제 다운로드 옵션 추가
    @objc class func blockImageDownWithURL(_ strURL:NSString, isForce: Bool, responseBlock : @escaping GSHttpResponseBlock) {
        ImageDownManager.blockImageDownWithURL(strURL, isForce: isForce, useMemory: false, responseBlock: responseBlock)
    }
    
    /// 강제 다운로드 + 메모리 사용 옵션 추가
    @objc class func blockImageDownWithURL(_ strURL:NSString, isForce: Bool, useMemory isUseMemory: Bool, responseBlock : @escaping GSHttpResponseBlock) {
        let opDwon = ImageDownOperation.init()
        opDwon.strURL = strURL as String
        opDwon.isForce = isForce
        opDwon.isUseMemory = isUseMemory
        opDwon.responseBlock = responseBlock
        ImageDownManager.shared.m_oqImageDown.addOperation(opDwon)
    }
    
    @objc class func clearCache() {
        ImageDownMemoryCache.sharedInstance.deleteAllMemory()
    }
}
