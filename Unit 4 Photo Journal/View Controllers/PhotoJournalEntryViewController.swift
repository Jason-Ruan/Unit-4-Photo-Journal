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
    
    //MARK: IBOutlets
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
