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

let imageCache = NSCache<NSString, UIImage>()

class DownloadableImageView: UIImageView {

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
                } receiveValue: { data in
                    guard let image = UIImage(data: data) else {return}
                    imageCache.setObject(image, forKey: url as NSString)
                    self.image = image
                }.store(in: &cancellables)
        }
    }
}
