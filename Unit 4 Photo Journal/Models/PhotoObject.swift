//
//  PhotoObject.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 10/6/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import Foundation

struct PhotoObject: Codable {
    let imageData: Data
    let id: Int
    let name: String
    let date: Date
}
