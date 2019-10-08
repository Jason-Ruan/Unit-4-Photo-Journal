//
//  NewEntryGalleryViewController.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 9/30/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import UIKit
import Photos

class PhotoJournalEntryViewController: UIViewController {
    //MARK: Properties
    var album: [PhotoObject]!
    weak var delegate: PhotoJournalEntryDelegate?
    
    var photoName: String? {
        didSet {
            entryTextView.text = self.photoName
        }
    }
    
    var photoImageData: Data?
    var photoDate: Date?
    var idNumber: Int?
    
    var newPhotoObject: PhotoObject?
    
    //MARK: IBOutlets
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        entryImageView.image = UIImage(named: "placeHolderImageView")
        entryTextView!.delegate = self
    }
    
    //MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.reloadAlbum()
        self.dismiss(animated: true)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        self.present(imagePickerVC, animated: true)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}


//MARK: ImagePicker & Navigation Delegates
extension PhotoJournalEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        guard let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset  else {
            print("Could not get asset")
            return
        }
        
        let assetResources = PHAssetResource.assetResources(for: asset)
        
        let name = assetResources.first!.originalFilename
        let date = asset.creationDate!
        
        guard let imageData = image.pngData() else {
            print("Could not convert image to pngData")
            return
        }
        
        var id  = (album.max { (a, b) -> Bool in a.id < b.id })?.id ?? -1
        id += 1
        
        let photoObject = PhotoObject(imageData: imageData, id: id, name: name, date: date)
        album.append(photoObject)
        
        do {
            try PhotoObjectPersistenceHelper.manager.save(newPhotoObject: photoObject)
        } catch {
            print(error)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
