//
//  Meal.swift
//  FoodTracker
//
//  Created by Lincoln Nguyen on 1/29/21.
//

import UIKit

class Meal {
    //MARK: Properties
    // Initialize name, optional photo, and rating variables
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Meal Failable Init
    // If name is empty or rating < 0 then return nil
    // Check name is not empty
    // Check rating is in [0, 5]
    // If so, initialize stored properties
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
}
