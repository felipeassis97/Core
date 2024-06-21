//
//  DownloadSvg.swift
//  Core
//
//  Created by Felipe Assis on 22/6/2024.
//

import SwiftUI
import Kingfisher
import Combine

public struct SvgByURL: View {
    @StateObject private var downloader = SVGImageDownloader()
    let url: String
    
    public init(url: String) {
        self.url = url
    }

    public var body: some View {
        Group {
            if downloader.isLoading {
                ProgressView()
            } else if let image = downloader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
            }
        }
        .onAppear {
            downloader.download(from: url)
        }
    }
}


public class SVGImageDownloader: ObservableObject {
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
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
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
