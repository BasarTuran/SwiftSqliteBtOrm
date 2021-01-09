//
//  QueryWorker.swift
//  M-EKBS
//
//  Created by basar turan on 12.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit

import Foundation
import SQLite3
class QueryWorker {
 
    public static func ExecQuery(query:String)
    {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(DBHelper.db, query, -1, &queryStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(queryStatement) == SQLITE_DONE
            {
                print("Query Executed");
            } else {
                print("query could not be executed.");
            }
        } else {
            print("Query statement could not be prepared.");
        }
        sqlite3_finalize(queryStatement);
    }
}
