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
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized  {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let photoJournalEntryVC = storyboard.instantiateViewController(identifier: "PhotoJournalEntryViewController") as! PhotoJournalEntryViewController
            
            photoJournalEntryVC.delegate = self
            photoJournalEntryVC.album = self.album

            self.present(photoJournalEntryVC, animated: true)
        } else {
            PHPhotoLibrary.requestAuthorization({status in
                switch status {
                case .authorized:
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let photoJournalEntryVC = storyboard.instantiateViewController(identifier: "PhotoJournalEntryViewController") as! PhotoJournalEntryViewController
                    
                    photoJournalEntryVC.delegate = self
                    photoJournalEntryVC.album = self.album
                    
                    self.present(photoJournalEntryVC, animated: true)
                    
                case .denied:
                    print("Go to settings to allow permissions")
                case .notDetermined:
                    print("Go to settings to allow permissions")
                case .restricted:
                    print("Go to settings to allow permissions")
                @unknown default:
                    print("Go to settings to allow permissions")
                }
            })
        }
        
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
        cell.nameLabel.text = "Name of photo: \(photo.name)"
        cell.dateLabel.text = "Date of photo: \(photo.date)"
        
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
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            let photoJournalEntryVC = self.storyboard?.instantiateViewController(identifier: "PhotoJournalEntryViewController") as! PhotoJournalEntryViewController
            self.present(photoJournalEntryVC, animated: true)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionsMenu.addAction(deleteAction)
        optionsMenu.addAction(editAction)
        optionsMenu.addAction(shareAction)
        optionsMenu.addAction(cancelAction)
        
        self.present(optionsMenu, animated: true, completion: nil)
    }
}

extension ViewController: PhotoJournalEntryDelegate {
    func reloadAlbum() {
        loadAlbum()
    }
}
