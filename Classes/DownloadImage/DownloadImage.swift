//
//  DownloadImage.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation
import UIKit

struct DownloadImage: IDownloadImage {
    func download(from imageURL: String) async throws -> UIImage? {
        
        let imageCache = NSCache<NSString, UIImage>()
        guard let url = URL(string: imageURL) else {
            return UIImage(systemName: "exclamationmark.triangle.fill")
        }
        
        //Check if exists in cache
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image =  UIImage(data: data) else {
                return UIImage(systemName: "exclamationmark.triangle.fill")
            }
            //Save in cache
            imageCache.setObject(image, forKey: imageURL as NSString)
            return image
        }
        catch {
            print("Error when download image: \(error)")
            return UIImage(systemName: "exclamationmark.triangle.fill")
        }
    }
}
