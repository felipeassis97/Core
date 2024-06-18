//
//  DownloadImage.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import UIKit
import SwiftUI

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


//struct DownloadImageKingFisher: IDownloadImage {
//    func download(from imageURL: String) -> UIImage? {
//        let imageCache = NSCache<NSString, UIImage>()
//        var uiImage: UIImage?
//        
//        guard let url = URL(string: imageURL) else {
//            return UIImage(systemName: "exclamationmark.triangle.fill")
//        }
//        
//        //Check if exists in cache
//        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
//            return cachedImage
//        }
//        
//        let _ =  KFImage.url(url)
//            .placeholder({
//                Rectangle()
//                    .scaledToFill()
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .foregroundStyle(.gray.opacity(0.1))
//                    .padding(.horizontal, 24)
//            })
//            .onSuccess { result in
//                guard let data = result.image.pngData() else {
//                    return
//                }
//                
//                if let imageData = UIImage(data: data) {
//                    uiImage = imageData
//                    imageCache.setObject(imageData, forKey: imageURL as NSString)
//                }
//            }
//        
//        if(uiImage != nil) {
//            return uiImage
//        } else {
//            return UIImage(named: "exclamationmark.triangle.fill")
//        }
//    }
//}
