//
//  DownloadImage.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import SwiftUI
import Combine

public class DownloadImage: ObservableObject {
    
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
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: UIImage(systemName: "exclamationmark.triangle.fill"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                self?.isLoading = false
                if let image = downloadedImage {
                    self?.imageCache.setObject(image, forKey: imageURL as NSString)
                    self?.image = image
                } else {
                    self?.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            }
            .store(in: &cancellables)
    }
}
