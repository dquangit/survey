//
//  UIImage+Ext.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(asset: ImageAsset) {
        self.init(named: asset.rawValue)
    }
    
    var isLight: Bool? {
        averageColor?.isLight
    }
    
    private var averageColor: UIColor? {
        guard let inputImage = self.ciImage ?? CIImage(image: self) else { return nil }
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: inputImage.extent)])
        else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [CIContextOption.workingColorSpace: kCFNull as Any])
        let outputImageRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func append(with image: UIImage) -> UIImage {
        let size = CGSize(width: (size.width), height: (size.height) + (image.size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(x:0, y:0, width:size.width, height: (size.height)))
        image.draw(in: CGRect(x:0, y:(image.size.height), width: size.width,  height: (image.size.height)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
       return newImage
    }
    
    func crop(rect: CGRect) -> UIImage? {
        guard let imageRef = cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: imageRef)
    }
}
