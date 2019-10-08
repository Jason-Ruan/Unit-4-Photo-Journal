//
//  PhotoObject.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 10/6/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import Foundation

struct PhotoObject: Codable {
    var imageData: Data
    var id: Int
    var name: String
    var date: Date
}
