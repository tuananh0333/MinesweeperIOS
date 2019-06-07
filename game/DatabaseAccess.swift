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
    private let databaseName: String = "highscores.sqlite"
    private var database: FMDatabase?
    
    //MARK: Table properties
    private let TABLE_NAME = "highscores"
    private let HIGHSCORE_ID = "_id"
    private let HIGHSCORE_VALUE = "score"
    private let HIGHSCORE_DATE = "date"
    
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
            + HIGHSCORE_ID + " Integer PRIMARY KEY AUTOINCREMENT, "
            + HIGHSCORE_VALUE + " Integer, "
            + HIGHSCORE_DATE + " TIMESTAMP"
        
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
    func createHighscore(highscore: HighscoreModel) {
        if (database != nil) {
            let sqlite = "INSERT INTO \(TABLE_NAME) ( \(HIGHSCORE_VALUE), \(HIGHSCORE_DATE) ) VALUES (?, ?)"
            

            if database!.executeUpdate(sqlite, withArgumentsIn: [highscore.value, highscore.date]) {
                os_log("Create highscore success")
            }
            else {
                os_log("Create highscore failed")
            }
        }
        else {
            os_log("Database is nil")
        }
    }
    
    func readMeal(highscoresList: inout [HighscoreModel]) {
        if database == nil {
            os_log("Database is nil")
            return
        }
        
        var result: FMResultSet?
        let sqlite = "SELECT * FROM \(TABLE_NAME) ORDER BY \(HIGHSCORE_VALUE) desc"
        
        do {
            try result = database!.executeQuery(sqlite, values: nil)
            os_log("Read success")
        } catch {
            os_log("Can't read highscore")
        }
        
        if result != nil {
            while (result?.next())! {
                guard let value = result?.string(forColumn: HIGHSCORE_VALUE) else {
                    os_log("Value not found")
                    return
                }
                guard let date = result?.string(forColumn: HIGHSCORE_DATE) else {
                    os_log("Date not found")
                    return
                }
                if let highscore = HighscoreModel(value: Int(value), date: Date(date)) {
                    meals.append(meal)
                }
            }
        }
        else {
            os_log("The database is empty")
        }
    }
}
