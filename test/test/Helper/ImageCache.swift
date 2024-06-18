//
//  ImageCache.swift
//  test
//
//  Created by Dmitrii Imaev on 18.06.2024.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
    
    static func getImage(forKey key: String) -> UIImage? {
        return shared.object(forKey: key as NSString)
    }
    
    static func setImage(_ image: UIImage, forKey key: String) {
        shared.setObject(image, forKey: key as NSString)
    }
}
