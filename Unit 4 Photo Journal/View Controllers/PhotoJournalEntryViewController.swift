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
    var userWantsToEdit = false
    var tag: Int?
    
    var photoJournalEntry: PhotoObject?
    
    var photoName: String?
    var photoImageData: Data?
    var photoDate: Date?
    var idNumber: Int?
    
    
    
    //MARK: IBOutlets
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        entryImageView.image = UIImage(named: "placeHolderImageView")
        setUpViews()
        entryTextView!.delegate = self
    }
    
    //MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let photoName = photoName, let photoImageData = photoImageData, let photoDate = photoDate, let idNumber = idNumber else {
            print("Missing a parameter for photoObject")
            return
        }
        
        let photoObject = PhotoObject(imageData: photoImageData, id: idNumber, name: photoName, date: photoDate)
        
        newPhotoObject = photoObject
        
        do {
            try PhotoObjectPersistenceHelper.manager.save(newPhotoObject: newPhotoObject!)
        } catch {
            print(error)
        }
        
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
    
    //MARK: Custom Functions
    private func setUpViews() {
        if let tag = tag {
            let currentPhotoObject = album[tag]
            
            entryTextView.text = currentPhotoObject.name
            photoImageData = currentPhotoObject.imageData
            photoDate = currentPhotoObject.date
            idNumber = currentPhotoObject.id
            
            entryImageView.image = UIImage(data: currentPhotoObject.imageData)
        }
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
        
        if photoName == nil {
            photoName = assetResources.first!.originalFilename
        }
        
        if let date = asset.creationDate {
            photoDate = date
        }
        
        if let imageData = image.pngData() {
            photoImageData = imageData
        }
        
        idNumber = (album.max { (a, b) -> Bool in a.id < b.id })?.id ?? -1
        idNumber! += 1
        
        self.entryImageView.image = UIImage(data: photoImageData!)
        
        self.entryTextView.text = photoName
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoJournalEntryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        photoName = textView.text
    }
}
