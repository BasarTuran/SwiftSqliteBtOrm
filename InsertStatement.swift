//
//  InsertStatement.swift
//  M-EKBS
//
//  Created by basar turan on 11.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit
import Foundation
import SQLite3

class InsertStatement {
    private func getInsertQueryText(model:SqliteModel)->String
    {
        var insertText:String="(";
        var valuesText:String=" VALUES (";
        let m=model.getSelfChildren();
        var index:Int=0;
        
        for child in m{
            let size:Int=m.count-1;
            if(model.primaryKey.autoIncrement && model.primaryKey.keyName==child.label)
            {
                index+=1;
                continue;
            }
            let value=SqliteHelper.getValueForSqlite(member: child.value);            
            
            if(index<size)
            {
                insertText+=child.label!+" ,";
                valuesText+=" "+value+",";//" ?,";//
            }
            else{
                insertText+=child.label!+" ";
                valuesText+=" "+value;//" ?";//
            }
            
            index+=1;
        }
        insertText+=")";
        valuesText+=");";
        return "INSERT INTO "+model.getTableName()+insertText+valuesText;
    }
    func insert(model:SqliteModel)
    {
        let insertStatementString:String=getInsertQueryText(model: model);
        //debugPrint(insertStatementString);
        QueryWorker.ExecQuery(query: insertStatementString);
    }
}
