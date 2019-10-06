//
//  ViewController.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 9/29/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    var album: [UIImage] = [UIImage()] {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    //MARK: Custom Functions
    private func configureCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = album[indexPath.row]
        
        cell.photoImageView.image = photo
        cell.nameLabel.text = "Name of photo"
        cell.dateLabel.text = "Date of photo"
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension ViewController: PhotoCellDelegate {
    func showActionSheet(tag: Int) {
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print(tag)
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        album.append(image)
        dismiss(animated: true, completion: nil)
    }
    
}
