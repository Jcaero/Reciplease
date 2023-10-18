//
//  ImageCache.swift
//  Reciplease
//
//  Created by pierrick viret on 18/10/2023.
//

import Foundation
import UIKit
import Alamofire
import Combine

class DownloadImage {

    private let cacheRepository = ImageCache.shared

    func downloadImageWith( _ url: String) -> AnyPublisher<UIImage, Error> {
        if let cacheImage = cacheRepository.getImage(for: url) {
            return Just(cacheImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AF.request(url, method: .get, parameters: nil)
                .publishData()
                .value()
                .receive(on: DispatchQueue.main)
                .tryMap { [weak self] data in
                    guard let self = self, let image = UIImage(data: data) else { throw URLError(.badServerResponse)}
                    self.cacheRepository.save(image: image, forKey: url)
                    return image
                }.eraseToAnyPublisher()
        }
    }
}
