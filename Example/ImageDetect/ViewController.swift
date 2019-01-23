//
//  ViewController.swift
//  ImageDetect
//
//  Created by Arthur Sahakyan on 03/17/2018.
//  Copyright (c) 2018 Arthur Sahakyan. All rights reserved.
//

import UIKit
import ImageDetect
import Photos

class ViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var images: [UIImage] = []
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization({ (status) in
        })
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        activityIndicator.hidesWhenStopped = true
    }
    
    private func cropFaces() {
        guard let image = imageView.image else { return }
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            // `type` in this method can be face, barcode or text
            image.detector.crop(type: .face) { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let croppedImages):
                        // When the `Vision` successfully find type of object you set and successfuly crops it.
                        self?.images = croppedImages
                        self?.collectionView.reloadData()
                    case .notFound:
                        // When the image doesn't contain any type of object you did set, `result` will be `.notFound`.
                        print("Not Found")
                    case .failure(let error):
                        // When the any error occured, `result` will be `failure`.
                        print(error.localizedDescription)
                    }
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction private func changeImageTapped(_ sender: UIButton) {
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        self.images = []
        self.collectionView.reloadData()
        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imageView.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        cropFaces()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
