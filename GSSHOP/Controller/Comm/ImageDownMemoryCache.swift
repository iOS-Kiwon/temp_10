//
//  ImageDownMemoryCache.swift
//  GSSHOP
//
//  Created by Kiwon on 31/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

@objc class ImageDownMemoryCache: NSObject {
    
    private var cache = NSCache<NSString, UIImage>()
    
    static let MEMORY_CACHE_NAME            = "com.gsshop.memorycach.image"
    static let MEMORY_CACHE_MAX_SIZE        = 104857600   // 100Mb
    
    /// Singleton 변수
    static let sharedInstance: ImageDownMemoryCache = {
        var instance = ImageDownMemoryCache()
        instance.cache.name = MEMORY_CACHE_NAME
        instance.cache.totalCostLimit = MEMORY_CACHE_MAX_SIZE
        NotificationCenter.default.addObserver(instance, selector: #selector(deleteAllMemory), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        return instance
    }()
    
    @objc func setImage(_ image: UIImage, forKey strKey: String) {
        let cost = Int(image.size.height * image.size.width * image.scale)
        ImageDownMemoryCache.sharedInstance.cache.setObject(image, forKey: strKey as NSString, cost: cost)
    }
    
    @objc func getImageWithKey(_ strKey: String) -> UIImage? {
        return ImageDownMemoryCache.sharedInstance.cache.object(forKey: strKey as NSString)
    }
    
    
    /// 메모리 워닝 발생시 Notification Post로 호출
    @objc func deleteAllMemory() {
        FileUtil.removeLocalCache()
        self.cache.removeAllObjects()
    }
}
