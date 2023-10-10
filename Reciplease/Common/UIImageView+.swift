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
var cancellables: Set<AnyCancellable> = []

extension UIImageView {

    func downloadImageWith( _ url: String) {
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
                self.image = UIImage(data: data)
            }.store(in: &cancellables)
    }
}
