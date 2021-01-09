//
//  DeleteStatement.swift
//  M-EKBS
//
//  Created by basar turan on 12.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit
import SQLite3
class DeleteStatement {
    public func deleteAll(model:SqliteModel) {
        let deleteStatementString = "DELETE FROM "+model.getTableName();
        QueryWorker.ExecQuery(query: deleteStatementString);
    }
    public func deleteWithQuery(model:SqliteModel,whereQuery:String)
    {
        var deleteStatementString = "DELETE FROM "+model.getTableName();
        deleteStatementString+=" where "+whereQuery;
         QueryWorker.ExecQuery(query: deleteStatementString);
    }
    public func delete(model:SqliteModel)
    {
        var deleteStatementString = "DELETE FROM "+model.getTableName();
        deleteStatementString+=" where "+model.primaryKey.keyName+"=";
        deleteStatementString+=SqliteHelper.getValueForSqlite(member: SqliteHelper.getPropertyFromName(name: model.primaryKey.keyName, model: model).value);
        QueryWorker.ExecQuery(query: deleteStatementString);
    }
    
}
