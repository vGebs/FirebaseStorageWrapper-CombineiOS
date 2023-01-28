//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-27.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {
    
    private let imageService = ProfileImageServiceCombine()
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
    
    func pushImage() {
        if let img = UIImage(named: "avengers") {
            do {
                try imageService.pushImage(fileName: "0/img1", img: img)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("Image pushed")
                        case .failure(let e):
                            print(e)
                        }
                    } receiveValue: { _ in }
                    .store(in: &cancellables)
            } catch {
                print(error)
            }
        } else {
            print("image not there")
        }
    }
    
    func fetchImage() {
        imageService.fetchImage(fileName: "0/img1")
            .sink { completion in
                switch completion {
                case .finished:
                    print("Image fetched")
                case .failure(let e):
                    print(e)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func deleteImage() {
        imageService.deleteImage(fileName: "0/img1")
            .sink { completion in
                switch completion {
                case .finished:
                    print("Image deleted")
                case .failure(let e):
                    print(e)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func fetchMeta() {
        imageService.getMetaData(fileName: "0/img1")
            .sink { completion in
                switch completion {
                case .finished:
                    print("meta fetched")
                case .failure(let e):
                    print(e)
                }
            } receiveValue: { meta in
                if let m = meta {
                    print(m)
                } else {
                    print("meta empty")
                }
            }
            .store(in: &cancellables)
    }
    
    func updateMeta() {
        let meta = ["name": "Avengers"]
        
        imageService.updateMeta(fileName: "0/img1", metadata: meta)
            .sink { completion in
                switch completion {
                case .finished:
                    print("meta updated")
                case .failure(let e):
                    print(e)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
