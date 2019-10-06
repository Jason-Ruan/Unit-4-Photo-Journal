//
//  PhotoCollectionViewCell.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 9/29/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    weak var delegate: PhotoCellDelegate?
    
    //MARK: IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: IBActions
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        delegate?.showActionSheet(tag: sender.tag)
    }
    
}
