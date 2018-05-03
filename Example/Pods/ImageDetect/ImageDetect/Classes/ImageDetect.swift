//
//  ImageDetect.swift
//  ImageDetect
//
//  Created by Arthur Sahakyan on 3/17/18.
//

import UIKit
import Vision

public enum DetectionType {
    case face
    case barcode
    case text
}

public enum ImageDetectResult<T> {
    case success([T])
    case notFound
    case failure(Error)
}

public struct ImageDetect<T> {
    let detectable: T
    init(_ detectable: T) {
        self.detectable = detectable
    }
}

public protocol ImageCroppable {
}

public extension ImageCroppable {
    var detector: ImageDetect<Self> {
        return ImageDetect(self)
    }
}

public extension ImageDetect where T: CGImage {
    
    func crop(type: DetectionType, completion: @escaping (ImageDetectResult<CGImage>) -> Void) {
        switch type {
        case .face:
            cropFace(completion)
        case .barcode:
            cropBarcode(completion)
        case .text:
            cropText(completion)
            break
        }
    }
    
    private func cropFace(_ completion: @escaping (ImageDetectResult<CGImage>) -> Void) {
        guard #available(iOS 11.0, *) else {
            return
        }
        let req = VNDetectFaceRectanglesRequest { request, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let faceImages = request.results?.map({ result -> CGImage? in
                guard let face = result as? VNFaceObservation else { return nil }
                
                let width = face.boundingBox.width * CGFloat(self.detectable.width)
                let height = face.boundingBox.height * CGFloat(self.detectable.height)
                let x = face.boundingBox.origin.x * CGFloat(self.detectable.width)
                let y = (1 - face.boundingBox.origin.y) * CGFloat(self.detectable.height) - height
                
                let croppingRect = CGRect(x: x, y: y, width: width, height: height)
                let faceImage = self.detectable.cropping(to: croppingRect)
                
                return faceImage
            }).compactMap { $0 }
            
            guard let result = faceImages, result.count > 0 else {
                completion(.notFound)
                return
            }
            
            completion(.success(result))
        }
        
        do {
            try VNImageRequestHandler(cgImage: self.detectable, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func cropBarcode(_ completion: @escaping (ImageDetectResult<CGImage>) -> Void) {
        guard #available(iOS 11.0, *) else {
            return
        }
        
        let req = VNDetectBarcodesRequest { request, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let codeImages = request.results?.map({ result -> CGImage? in
                guard let code = result as? VNBarcodeObservation else { return nil }
                
                let width = code.boundingBox.width * CGFloat(self.detectable.width)
                let height = code.boundingBox.height * CGFloat(self.detectable.height)
                let x = code.boundingBox.origin.x * CGFloat(self.detectable.width)
                let y = (1 - code.boundingBox.origin.y) * CGFloat(self.detectable.height) - height
                
                let croppingRect = CGRect(x: x, y: y, width: width, height: height)
                let codeImage = self.detectable.cropping(to: croppingRect)
                
                return codeImage
            }).compactMap { $0 }
            
            guard let result = codeImages, result.count > 0 else {
                completion(.notFound)
                return
            }
            
            completion(.success(result))
        }
        
        do {
            try VNImageRequestHandler(cgImage: self.detectable, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func cropText(_ completion: @escaping (ImageDetectResult<CGImage>) -> Void) {
        guard #available(iOS 11.0, *) else {
            return
        }
        
        let req = VNDetectTextRectanglesRequest { request, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let textImages = request.results?.map({ result -> CGImage? in
                guard let text = result as? VNTextObservation else { return nil }
                
                let width = text.boundingBox.width * CGFloat(self.detectable.width)
                let height = text.boundingBox.height * CGFloat(self.detectable.height)
                let x = text.boundingBox.origin.x * CGFloat(self.detectable.width)
                let y = (1 - text.boundingBox.origin.y) * CGFloat(self.detectable.height) - height
                
                let croppingRect = CGRect(x: x, y: y, width: width, height: height)
                let textImage = self.detectable.cropping(to: croppingRect)
                
                return textImage
            }).compactMap { $0 }
            
            guard let result = textImages, result.count > 0 else {
                completion(.notFound)
                return
            }
            
            completion(.success(result))
        }
        
        do {
            try VNImageRequestHandler(cgImage: self.detectable, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
}

public extension ImageDetect where T: UIImage {
    
    func crop(type: DetectionType, completion: @escaping (ImageDetectResult<UIImage>) -> Void) {
        guard #available(iOS 11.0, *) else {
            return
        }
        
        self.detectable.cgImage!.detector.crop(type: type) { result in
            switch result {
            case .success(let cgImages):
                let faces = cgImages.map { cgImage -> UIImage in
                    return UIImage(cgImage: cgImage)
                }
                completion(.success(faces))
            case .notFound:
                completion(.notFound)
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}

extension NSObject: ImageCroppable {}
extension CGImage: ImageCroppable {}
