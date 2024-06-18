//
//  IDownloadImage.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

public protocol IDownloadImage: ObservableObject {
    func download(from imageURL: String)
}


//MARK: Bind
public func getDownloader() -> any IDownloadImage {
    return ImageLoader()
}
