//
//  Meal.swift
//  FoodTracker
//
//  Created by Lincoln Nguyen on 1/29/21.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    // MARK: Properties
    /*
     Initialize name, optional photo, and rating variables
     */
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    // MARK: Types
    /*
     Declare PropertyKey structure
         Declare static constant properties of structure (name, photo, rating)
     */
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // MARK: Failable Init
    /*
     Check name is not empty
     Check rating is in [0, 5]
     If so, initialize stored properties
     */
    init?(name: String, photo: UIImage?, rating: Int) {
        guard !name.isEmpty else {
            return nil
        }
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: NSCoding Data Persistence
    /*
     encode(with:) function
         Encode the value of each property of meal and store them with their corresponding key in PropertyKey
     implement failable conveience init required by NSObject subclass
         Guard unwrap optional and downcast decoded object for PropertyKey.name into constant
         Unwrap optional and downcast decoded object for PropertyKey.photo int constant
         Unarchive int for PropertyKey.rating into constant
         Call designated initializer
     */
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = decoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = decoder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating)
    }
}
