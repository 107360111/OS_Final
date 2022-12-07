//
//  UIImage+.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit

extension UIImage {
    // 彩色轉換灰階
    var noir: UIImage? {
        /// CICategoryColorEffect
        /// CIPhotoEffectNoir 仿黑白攝影 濾鏡
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        /// CIContext  圖像的過濾處理   可以指定使用 GPU or CPU 為執行程式碼的處理器
        guard let output = currentFilter.outputImage, let cgImage = CIContext(options: nil).createCGImage(output, from: output.extent) else { return nil }
        /// scale：縮放比例    imageOrientation：圖片方向
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return imageColored
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
      let size = self.size
      let widthRatio  = targetSize.width  / size.width
      let heightRatio = targetSize.height / size.height
      let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
      let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
      self.draw(in: rect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage!
    }
    
    func resizeImage(limit: CGFloat) -> UIImage {
        
        let originWidth = self.size.width
        let originHeight = self.size.height
        
        if originWidth > originHeight {
            guard originWidth > limit else { return self }
            return resizeImage(targetSize: CGSize(width: limit, height: (limit * originHeight / originWidth)))
            
        } else {
            guard originHeight > limit else { return self }
            return resizeImage(targetSize: CGSize(width: (limit * originWidth / originHeight), height: limit))
        }
    }
    
    static func create(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage()}
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func saveImage() {
        let fileName = "\(UUID().uuidString)-image.jpg"
        guard let documentsDirectory = FileHelper.getDocumentsDirectory() else { return }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let data = self.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
}
