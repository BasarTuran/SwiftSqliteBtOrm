//
//  DropStatement.swift
//  M-EKBS
//
//  Created by basar turan on 12.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//


import UIKit
import Foundation
import SQLite3
class DropStatement {
  
    func dropTable(model:SqliteModel)
    {
        let dropTableString = "DROP TABLE "+model.getTableName()+";"
        QueryWorker.ExecQuery(query: dropTableString);
    }
    func dropTable(tablename:String)
    {
        let dropTableString = "DROP TABLE "+tablename+";"
        QueryWorker.ExecQuery(query: dropTableString);
    }
}
