//
//  DownloadImage.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import SwiftUI
import Kingfisher
import Combine

public struct ImageByURL: View {
    @StateObject private var downloader = ImageDownloader()
    let url: String

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

public class ImageDownloader: ObservableObject {
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
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let value):
                    self.imageCache.setObject(value.image, forKey: imageURL as NSString)
                    self.image = value.image
                case .failure:
                    self.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            }
        }
    }
}
