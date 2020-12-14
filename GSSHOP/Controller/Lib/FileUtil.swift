//
//  FileUtil.swift
//  GSSHOP
//
//  Created by Kiwon on 03/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class FileUtil: NSObject {
    
    private static let CACHE_DICTORY_NAME = "GSSHOPImages"

    // MARK:- file-related functions
    @objc public static func pathForPathType(_ type: PathType) -> String? {
        
        var directory : FileManager.SearchPathDirectory!
        
        switch type {
        case .document:
            directory = .documentDirectory
        case .library:
            directory = .libraryDirectory
        case .bundle:
            return Bundle.main.bundlePath
        case .resource:
            return Bundle.main.resourcePath
        case .temp:
            return NSTemporaryDirectory()
        case .cache:
            directory = .cachesDirectory
        }
        
        guard let path = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first else { return nil }
        return path
    }
    
    @objc public static func pathOfFile(filename: String, withPathType type: PathType) -> String? {
        guard let path = self.pathForPathType(type) else { return nil }
        return path.appending(filename)
    }
    
    @objc public static func fileExistsAtPath(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    @objc public static func copyFileFromPath(_ path: String, toPath: String) -> Bool {
        do {
            try FileManager.default.copyItem(atPath: path, toPath: toPath)
        } catch (let error) {
            print("Fail: copy item at \(path) to \(toPath): \(error)")
            return false
        }
        return true
    }
    
    @objc public static func deleteFileAtPath(_ path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch (let error) {
            print("Fail: remove item at \(path): \(error)")
            return false
        }
        return true
    }
    
    @objc public static func createDirectoryAtPath(_ path: String, withAttributes attributes: Dictionary<FileAttributeKey, Any>?) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attributes)
        } catch (let error) {
            print("Fail: create Directory at \(path): \(error)")
            return false
        }
        return true
    }

    @objc public static func createFileAtPath(_ path: String, withData data: Data?, withAttributes attributes: Dictionary<FileAttributeKey, Any>?) -> Bool {
        return  FileManager.default.createFile(atPath: path, contents: data, attributes: attributes)
    }
    
    @objc public static func dataFromPath(_ path: String) -> Data? {
        return FileManager.default.contents(atPath: path)
    }
    
    @objc public static func contentsOfDirectoryAtPath(_ path: String) -> [String]? {
        do {
            let contents =  try FileManager.default.contentsOfDirectory(atPath: path)
            return contents
        } catch (let error) {
            print("Fail: contentsOfDirectory at \(path): \(error)")
            return nil
        }
    }
    
    @objc public static func filesizeWithPath(_ path: String) -> NSNumber? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            guard let fileSizeNumber = fileAttributes[FileAttributeKey.size] as? NSNumber else { return nil }
            return fileSizeNumber
        } catch (let error) {
            print("Fail: filesizeWithPath at \(path): \(error)")
            return nil
        }
    }

    @objc public static func saveLocalCachePath(_ strFileName: String, withData data: Data) {
        
        guard let documentsDirectory = FileUtil.pathForPathType(.cache) else { return }
        let cacheDirName = documentsDirectory.stringByAppendingPathComponent(path: CACHE_DICTORY_NAME)
        let fullPath = String(format: "%@/%@", cacheDirName, strFileName)
        let url = URL.init(fileURLWithPath: fullPath)
        do {
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Fail to write: \(fullPath), error: \(error.localizedDescription)")
        }
    }
    
    @objc public static func getLocalCachePath(_ strFileName: String) -> String? {
        guard let documentsDirectory = FileUtil.pathForPathType(.cache) else { return nil}
        let cacheDirName = documentsDirectory.stringByAppendingPathComponent(path: CACHE_DICTORY_NAME)
        let fullPath = String(format: "%@/%@", cacheDirName, strFileName)
        if FileUtil.fileExistsAtPath(fullPath) {
            return fullPath
        }
        return nil
    }
    
    @objc public static func removeLocalCache() {
        guard let documentsDirectory = FileUtil.pathForPathType(.cache) else { return }
        let cacheDirName = documentsDirectory.stringByAppendingPathComponent(path: CACHE_DICTORY_NAME)
        do {
            try FileManager.default.removeItem(atPath: cacheDirName)
        } catch (let error) {
            print("Fail: remove Local Cache\nMessage : \(error.localizedDescription)")
        }
    }
}
