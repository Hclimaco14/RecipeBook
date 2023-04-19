//
//  Extensions.swift
//  RecipeBook
//
//  Created by Hector Climaco on 15/04/23.
//

import UIKit
import SDWebImage
import CoreLocation

extension UIImageView {
    func downloaded(from urlString : String, placeholderImage: UIImage? = nil) {
        guard let url = URL(string: urlString) else { return }
        self.sd_setImage(with: url,placeholderImage: placeholderImage)
    }
}

public extension Encodable {
    func toData() -> Data? {
        let enconder = JSONEncoder()
        guard let data = try? enconder.encode(self) else { return nil }
        return data
        
    }
}

public extension CLLocationCoordinate2D {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
