//
//  Food.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 5/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit

class Food: NSObject {

    var userID: String
    var foodName: String
    var foodDescription: String
    var foodDate: String
    var imageURL: String
    
    override init() {
        self.userID = ""
        self.foodName = ""
        self.foodDescription = ""
        self.foodDate = ""
        self.imageURL = "Blank"
    }
    
    init(userID: String, foodName: String, foodDescription: String, foodDate: String, imageURL: String)
    {
        self.userID = userID
        self.foodName = foodName
        self.foodDescription = foodDescription
        self.foodDate = foodDate
        self.imageURL = imageURL
    }
}
