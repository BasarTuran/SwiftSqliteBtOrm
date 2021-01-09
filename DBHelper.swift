//
//  DBHelper.swift
//  M-EKBS
//
//  Created by basar turan on 10.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
       
    public static let dbPath: String = "mkebs.v.1.0.0.2.sqlite"
    public static var db:OpaquePointer?
    
    public static func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath);
        var db: OpaquePointer? = nil;
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database");
            return nil;
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)");
            return db;
        }
        
    }
    public static func deleteDatabase()
    {
        let fm = FileManager.default;
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath);
        do {
            try! fm.removeItem(at: fileURL);
            print("Database Deleted!")
        }
    }
    
    public static func closeDatabase()
    {
        sqlite3_close(db);
    }
    
    
    
}

