//
//  DatabaseAccess.swift
//  FoodManagement
//
//  Created by CNTT-MAC on 6/1/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import Foundation
import UIKit
import os.log

class DatabaseAccess {
    //MARK: Properties
    private var databasePath: String
    private let databaseName: String = "meals.sqlite"
    private var database: FMDatabase?
    
    //MARK: Table properties
    private let TABLE_NAME = "meals"
    private let MEAL_ID = "_id"
    private let MEAL_NAME = "name"
    private let MEAL_IMAGE = "image"
    private let MEAL_RATING = "rating"
    
    //MARK: Initialization
    init() {
        let directories: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        databasePath = directories[0] + "/" + databaseName
        
        // Create database
        database = FMDatabase(path: databasePath)
        
        if database != nil {
            os_log("Create database success")
        }
        else {
            os_log("Create database failed")
        }
    }
    
    //MARK: Definition of Primitives
    func createTable() -> Bool {
        if database == nil {
            os_log("Cannot access to database")
            
            return false
        }
        
        let sqlite = "CREATE TABLE " + TABLE_NAME + "("
            + MEAL_ID + " Integer PRIMARY KEY AUTOINCREMENT, "
            + MEAL_NAME + " TEXT, "
            + MEAL_IMAGE + " TEXT, "
            + MEAL_RATING + " Integer)"
        
        if (database?.executeStatements(sqlite))! {
            os_log("Table is created")
            return true
        }
        else {
            os_log("Failed to execute statement")
            return false
        }
    }
    
    func open() -> Bool {
        if (database == nil) {
            os_log("Cannot access to database")
            
            return false
        }
        
        if (database?.open())! {
            os_log("Open success")
            return true
        }
        else {
            os_log("Open failed")
            return false
        }
    }
    
    func close() {
        if (database != nil) {
            database?.close()
            os_log("Database is closed")
        }
        else {
            os_log("Database is nil")
        }
    }
    
    //MARK: Definition of APIs
    func createMeal(meal: MealModel) {
        if (database != nil) {
            let sqlite = "INSERT INTO \(TABLE_NAME) ( \(MEAL_NAME), \(MEAL_IMAGE), \(MEAL_RATING) ) VALUES (?, ?, ?)"
            
            // Transform image to string
            let dataImage: NSData = UIImagePNGRepresentation(meal.mealImage!)! as NSData
            let stringImage: String = dataImage.base64EncodedString(options: .lineLength64Characters)
            
            if database!.executeUpdate(sqlite, withArgumentsIn: [meal.mealName, stringImage, meal.mealRating]) {
                os_log("Create meal success")
            }
            else {
                os_log("Create meal failed")
            }
        }
        else {
            os_log("Database is nil")
        }
    }
    
    func updateMeal(oldMeal: MealModel, newMeal: MealModel) {
        if (database != nil) {
            let sqlite = "UPDATE \(TABLE_NAME) SET \(MEAL_NAME) = ?, \(MEAL_IMAGE) = ?, \(MEAL_RATING) = ? WHERE \(MEAL_NAME) = ? AND \(MEAL_RATING) = ?"
            
            // Transform image to string
            let dataImage: NSData = UIImagePNGRepresentation(newMeal.mealImage!)! as NSData
            let stringImage: String = dataImage.base64EncodedString(options: .lineLength64Characters)
            
            do {
                try database!.executeUpdate(sqlite, values: [newMeal.mealName, stringImage, newMeal.mealRating, oldMeal.mealName, oldMeal.mealRating])
                os_log("Update meal success")
            } catch {
                os_log("Update meal failed")
            }
        }
        else {
            os_log("Database is nil")
        }
    }
    
    func deleteMeal(meal: MealModel) {
        if database == nil {
            os_log("Database is nil")
            return
        }
        
        let sqlite = "DELETE FROM \(TABLE_NAME) WHERE \(MEAL_NAME) = ? AND \(MEAL_RATING) = ?"
        
        do {
            try database!.executeUpdate(sqlite, values: [meal.mealName, meal.mealRating])
            os_log("Delete success")
        } catch {
            os_log("Can't delete meal")
        }
    }
    
    func readMeal(meals: inout [MealModel]) {
        if database == nil {
            os_log("Database is nil")
            return
        }
        
        var result: FMResultSet?
        let sqlite = "SELECT * FROM \(TABLE_NAME)"
        
        do {
            try result = database!.executeQuery(sqlite, values: nil)
            os_log("Read success")
        } catch {
            os_log("Can't read meal")
        }
        
        if result != nil {
            while (result?.next())! {
                guard let mealName = result?.string(forColumn: MEAL_NAME) else {
                    os_log("Name not found")
                    return
                }
                guard let stringImage = result?.string(forColumn: MEAL_IMAGE) else {
                    os_log("Image not found")
                    return
                }
                guard let mealRating = result?.string(forColumn: MEAL_RATING) else {
                    os_log("Rating not found")
                    return
                }
                // Convert string to UIImage
                let dataImage: Data = Data(base64Encoded: stringImage, options: .ignoreUnknownCharacters)!
                let mealImage = UIImage(data: dataImage)
                
                if let meal = MealModel(mealName: mealName, mealImage: mealImage, mealRating: Int(mealRating)!, mealMaxRating: 5) {
                    meals.append(meal)
                }
            }
        }
        else {
            os_log("The database is empty")
        }
    }
}
