//
//  IDownloadImage.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

public protocol IDownloadImage {
    func download(from imageURL: String)
}


//MARK: Bind
public func getDownloader() -> IDownloadImage {
    return ImageLoader()
}
