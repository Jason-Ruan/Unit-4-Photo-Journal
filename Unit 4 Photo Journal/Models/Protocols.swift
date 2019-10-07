//
//  Protocols.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 10/6/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import Foundation

protocol PhotoCellDelegate: AnyObject {
    func showActionSheet(tag: Int)
}

protocol PhotoJournalEntryDelegate: AnyObject {
    func reloadAlbum()
}
