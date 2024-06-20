//
//  Base64ToImage.swift
//  Pods
//
//  Created by Felipe Assis on 20/6/2024.
//

import SwiftUI

extension Image {
   public func fromBase64(base64: String) -> Image {
         let defaultUIImage = UIImage(systemName: "exclamationmark.triangle.fill") ?? UIImage()
         let defaultImage = Image(uiImage: defaultUIImage)

        if let data = Data(base64Encoded: base64 ,options: .ignoreUnknownCharacters){
             let image = UIImage(data: data)
             return Image(uiImage: image ?? defaultUIImage)
         } else {
             return defaultImage
         }
    }
}
