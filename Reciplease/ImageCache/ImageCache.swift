//
//  SearchImageCache.swift
//  Reciplease
//
//  Created by pierrick viret on 17/10/2023.
//

import Foundation
import UIKit

 class ImageCache {

     // MARK: - Singleton
     static let shared = ImageCache()

     // MARK: - Propertie
     private let imageCache = NSCache<NSString, UIImage>()

     // MARK: - INIT
    private init() {
         imageCache.countLimit = 75
         imageCache.totalCostLimit = 50 * 1024 * 1024
     }

     // MARK: - Function
     func save(image: UIImage, forKey url: String) {
         self.imageCache.setObject(image, forKey: url as NSString)
     }

     func getImage(for url: String) -> UIImage? {
         return imageCache.object(forKey: url as NSString)
     }
 }
