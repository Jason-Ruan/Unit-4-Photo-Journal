//
//  PhotoObjectPersistenceHelper.swift
//  Unit 4 Photo Journal
//
//  Created by Jason Ruan on 10/6/19.
//  Copyright © 2019 Jason Ruan. All rights reserved.
//

import Foundation

struct PhotoObjectPersistenceHelper {
    static let manager = PhotoObjectPersistenceHelper()

    func save(newPhotoObject: PhotoObject) throws {
        try persistenceHelper.save(newElement: newPhotoObject)
    }

    func delete(photoID: Int) throws {
        let elements = try getAlbum()
        let newElements = elements.filter { $0.id != photoID }
        let serializedData = try PropertyListEncoder().encode(newElements)
        try serializedData.write(to: persistenceHelper.url, options: Data.WritingOptions.atomic)
    }
    
    func update(updatedArray: [PhotoObject]) throws {
        try persistenceHelper.update(updatedArray: updatedArray)
    }
    
    func getAlbum() throws -> [PhotoObject] {
        return try persistenceHelper.getObjects()
    }

    private let persistenceHelper = PersistenceHelper<PhotoObject>(fileName: "photoObjects.plist")

    private init() {}
}
