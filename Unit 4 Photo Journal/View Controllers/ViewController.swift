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
        // Do any additional setup after loading the view.
    }


}

