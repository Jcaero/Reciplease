//
//  UIImageView.swift
//  Reciplease
//
//  Created by pierrick viret on 10/10/2023.
//

import Foundation
import UIKit
import Alamofire
import Combine

//class SearchImageCache {
//    
//    private let imageCache = NSCache<NSString, UIImage>()
//    
//    init() {
//        imageCache.countLimit = 75
//        imageCache.totalCostLimit = 50 * 1024 * 1024
//    }
//    
//    func save(image: UIImage) {
//        
//    }
//    
//    func getImage(for url: String) -> UIImage? {
//        
//    }
//}

class DownloadableImageView: UIImageView {

    private let imageCache = NSCache<NSString, UIImage>()
    private var cancellables: Set<AnyCancellable> = []

    func downloadImageWith( _ url: String) {
        imageCache.countLimit = 75
        imageCache.totalCostLimit = 50 * 1024 * 1024

        if let cachedImage = imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
        } else {
            AF.request(url, method: .get, parameters: nil)
                .publishData()
                .value()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        print("erreur reseau")
                    }
                } receiveValue: { [weak self] data in
                    guard let self = self, let image = UIImage(data: data) else {return}
                    self.imageCache.setObject(image, forKey: url as NSString)
                    self.image = image
                }.store(in: &cancellables)
        }
    }
}
