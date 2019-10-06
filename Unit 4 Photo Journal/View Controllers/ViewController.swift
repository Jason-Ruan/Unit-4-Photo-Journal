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
        let newEntryVC = storyboard?.instantiateViewController(identifier: "NewEntryGalleryViewController") as! NewEntryGalleryViewController
        navigationController?.pushViewController(newEntryVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    //MARK: Custom Functions
    private func configureCollectionView() {
        photoCollectionView.dataSource = self
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.nameLabel.text = "Name of photo"
        cell.dateLabel.text = "Date of photo"
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
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
