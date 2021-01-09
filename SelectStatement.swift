//
//  SelectStatement.swift
//  M-EKBS
//
//  Created by basar turan on 12.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit
import SQLite3
class SelectStatement {
    public static func find<T:SqliteModel> (classType :T,whereQuery:String)-> [SqliteModel]
    {
        let query:String="where "+whereQuery;
        return getDataFromSqlite(classType: classType, whereQuery: query);
    }
    public static func list<T:SqliteModel> (classType :T,query:String)-> [SqliteModel]
       {
           let query:String=" "+query;
           return getDataFromSqlite(classType: classType, whereQuery: query);
       }
    public static func listAll<T:SqliteModel> (classType :T)-> [SqliteModel]
    {
        
        return getDataFromSqlite(classType: classType, whereQuery: "");
    }
    public static func isExistInRows<T:SqliteModel> (classType :T)-> Bool
    {
        var exits:Bool=false;
        let model=classType as SqliteModel;
        var query="SELECT COUNT(*) FROM "+model.getTableName();
        query+=" where "+model.primaryKey.keyName+"=";
        query+=SqliteHelper.getValueForSqlite(member: SqliteHelper.getPropertyFromName(name: model.primaryKey.keyName, model: model).value);
        var queryStatement: OpaquePointer? = nil;
        if sqlite3_prepare_v2(DBHelper.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let count = sqlite3_column_int(queryStatement, 0);
                if(count>0)
                {
                    exits=true;
                }
                break;
            }
        }
        sqlite3_finalize(queryStatement);
        return exits;
    }
    private static func getDataFromSqlite<T:SqliteModel> (classType :T,whereQuery:String)-> [SqliteModel]  {
        
        let queryStatementString = "SELECT * FROM "+(classType as SqliteModel).getTableName()+" "+whereQuery+";"
        var queryStatement: OpaquePointer? = nil;
        var psns : [SqliteModel] = [];
        if sqlite3_prepare_v2(DBHelper.db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                //let m=tempModel.getChildren();
                //var index:Int32=0
                let tempModel = type(of: classType).init();
                let colSize=sqlite3_column_count(queryStatement);
                var finder:Bool=false;
                for index in 0...colSize-1{
                    
                    let clmn=sqlite3_column_name(queryStatement, index)!;
                    let colName = String(cString: clmn);
                    let temp=SqliteHelper.getPropertyFromName(name: colName,model:tempModel as SqliteModel);
                    
                    if(temp.label!.count>1)
                    {
                        finder=true;
                        let typedata:String=SqliteHelper.getVariableType(value: temp.value)
                        if(typedata=="String")
                        {
                            
                            let data = String(describing: String(cString: sqlite3_column_text(queryStatement, index)));
                            
                            tempModel.setValue(data, forKey: colName);
                            
                            
                            
                            
                        }
                        else if(typedata=="Int")
                        {
                            let data = sqlite3_column_int(queryStatement, index);
                            tempModel.setValue(data, forKey: colName);
                            
                            
                        }
                        else if(typedata=="Float" || typedata=="Double")
                        {
                            let data = sqlite3_column_double(queryStatement, index);
                            tempModel.setValue(data, forKey: colName);
                            
                            
                        }
                        else if(typedata=="Bool")
                        {
                            let data = String(describing: String(cString: sqlite3_column_text(queryStatement, index)));
                            tempModel.setValue(NSString(string: data).boolValue, forKey: colName);
                            
                        }
                        else{
                            let data =  sqlite3_column_blob(queryStatement, index);
                            tempModel.setValue(data, forKey: colName);
                            
                        }
                    }
                }
                if(finder)
                {
                    psns.append(tempModel as SqliteModel);
                }
            }
        } else {
            print("SELECT statement could not be prepared");
        }
        sqlite3_finalize(queryStatement);
        return psns;
    }
    private func getColumnValue(index: CInt, type: CInt, stmt: OpaquePointer) -> Any? {
        switch type {
        case SQLITE_INTEGER:
            let val = sqlite3_column_int(stmt, index)
            return Int(val)
        case SQLITE_FLOAT:
            let val = sqlite3_column_double(stmt, index)
            return Double(val)
        case SQLITE_BLOB:
            let data = sqlite3_column_blob(stmt, index)
            let size = sqlite3_column_bytes(stmt, index)
            let val = NSData(bytes:data, length: Int(size))
            return val
        case SQLITE_TEXT:
            let buffer = UnsafePointer<Int8>(sqlite3_column_value(stmt, index))
            let val = String(cString: buffer!);
            return val
        default:
            return nil
        }
    }
}
