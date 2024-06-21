//
//  DownloadSvg.swift
//  Core
//
//  Created by Felipe Assis on 22/6/2024.
//


import SwiftUI
import Combine
import Kingfisher

public class DownloadSVGImage: ObservableObject {
    
    @Published public var image: UIImage? = nil
    @Published public var isLoading: Bool = false
    
    public let imageCache = NSCache<NSString, UIImage>()
    public var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func download(from imageURL: String) {
        guard let url = URL(string: imageURL) else {
            self.image = UIImage(systemName: "exclamationmark.triangle.fill")
            return
        }
        
        // Check if exists in cache
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            self.image = cachedImage
            return
        }
        
        // Start loading
        self.isLoading = true
        
        let resource = KF.ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let value):
                    if let data = value.image.pngData(), let renderedImage = self?.renderSVG(data: data) {
                        self?.imageCache.setObject(renderedImage, forKey: imageURL as NSString)
                        self?.image = renderedImage
                    } else {
                        self?.image = UIImage(systemName: "exclamationmark.triangle.fill")
                    }
                case .failure:
                    self?.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            }
        }
    }
    
    private func renderSVG(data: Data) -> UIImage? {
        guard let dataProvider = CGDataProvider(data: data as CFData),
              let cgImage = CGImage.svgSource(dataProvider) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

extension CGImage {
    static func svgSource(_ dataProvider: CGDataProvider) -> CGImage? {
        let options = [kCGImageSourceTypeIdentifierHint: "public.svg"] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithDataProvider(dataProvider, options),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options) else {
            return nil
        }
        return cgImage
    }
}

