//
//  ViewController.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 9/29/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    //MARK: Properties
    var album: [PhotoObject] = [] {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //MARK: IBActions
    @IBAction func addNewEntryButtonPressed(_ sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    //MARK: LifeCycle Methods
    override func viewWillAppear(_ animated: Bool) {
        loadAlbum()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    //MARK: Custom Functions
    private func configureCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
    private func loadAlbum() {
        do {
            album = try PhotoObjectPersistenceHelper.manager.getAlbum()
        } catch {
            print(error)
        }
    }

}

//MARK: DataSource Methods
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = album[indexPath.row]
        
        cell.photoImageView.image = UIImage(data: photo.imageData)
        cell.nameLabel.text = "Name of photo: \(photo.imageData)"
        cell.dateLabel.text = "ID of photo: \(photo.id)"
        
        cell.optionsButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
}

//MARK: Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

//MARK: PhotoCell Delegate
extension ViewController: PhotoCellDelegate {
    func showActionSheet(tag: Int) {
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let currentObject = album[tag]
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            do {
                try PhotoObjectPersistenceHelper.manager.delete(photoID: currentObject.id)
                self.loadAlbum()
            } catch {
                print("Could not delete object")
            }
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default)
        
        let shareAction = UIAlertAction(title: "Share", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionsMenu.addAction(deleteAction)
        optionsMenu.addAction(editAction)
        optionsMenu.addAction(shareAction)
        optionsMenu.addAction(cancelAction)
        
        self.present(optionsMenu, animated: true, completion: nil)
    }
}

//MARK: ImagePicker & Navigation Delegates
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            print("Could not convert image to pngData")
            return
        }
        
        var id  = (album.max { (a, b) -> Bool in a.id < b.id })?.id ?? -1
        id += 1
        
        let photoObject = PhotoObject(imageData: imageData, id: id)
        album.append(photoObject)
        
        do {
            try PhotoObjectPersistenceHelper.manager.save(newPhotoObject: photoObject)
        } catch {
            print(error)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
