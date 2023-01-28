//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-27.
//

import Foundation
import Combine
import SwiftUI

class ProfileImageServiceCombine {
    private let storage: FirebaseStorageWrapperCombine
    private let baseURL: String
    
    init() {
        self.baseURL = "ProfileImages/"
        self.storage = FirebaseStorageWrapperCombine(maxFileSize: 30 * 1024 * 1024)
    }
    
    func pushImage(fileName: String, img: UIImage, metaData: [String: String]? = nil) throws -> AnyPublisher<Void, Error> {
        let finalPath = self.baseURL + fileName
        
        guard let imageData = img.jpegData(compressionQuality: 0.2) else {
            throw FirebaseStorageError.unknownError
        }
        
        return storage.uploadData(fileName: finalPath, fileData: imageData, metaData: metaData)
    }
    
    func fetchImage(fileName: String) -> AnyPublisher<UIImage?, Error> {
        let finalPath = self.baseURL + fileName
        
        return storage.downloadData(fileName: finalPath)
            .map { data in
                if let d = data {
                    return UIImage(data: d)
                } else {
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func deleteImage(fileName: String) -> AnyPublisher<Void, Error> {
        let finalPath = self.baseURL + fileName
        return storage.deleteFile(fileName: finalPath)
    }
    
    func getMetaData(fileName: String) -> AnyPublisher<[String: String]?, Error> {
        let finalPath = self.baseURL + fileName
        return storage.getMetaData(fileName: finalPath)
            .map { meta in
                if let m = meta {
                    return m.customMetadata
                } else {
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func updateMeta(fileName: String, metadata: [String: String]) -> AnyPublisher<Void, Error> {
        let finalPath = self.baseURL + fileName
        return storage.updateMetaData(fileName: finalPath, metadata: metadata)
    }
}

