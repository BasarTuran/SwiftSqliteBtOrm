//
//  UpdateStatement.swift
//  M-EKBS
//
//  Created by basar turan on 12.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit
import SQLite3
class UpdateStatement {
    
    private func getUpdateQueryText(model:SqliteModel,addwhere:Bool)->String
    {
        var updateText:String="UPDATE "+model.getTableName()+" set ";
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
                updateText+=child.label!+"="+value+" ,";
                
            }
            else{
                updateText+=child.label!+"="+value;
            }
            
            index+=1;
        }
        if(addwhere)
        {
            updateText+=" where "+model.primaryKey.keyName+"=";
            updateText+=SqliteHelper.getValueForSqlite(member: SqliteHelper.getPropertyFromName(name: model.primaryKey.keyName, model: model).value);
        }
        return updateText;
    }
    func update(model:SqliteModel)
    {
        
        QueryWorker.ExecQuery(query: getUpdateQueryText(model: model,addwhere: true));
    }
    func updateWithQuery(model:SqliteModel,whereQuery:String)
    {
        let query=getUpdateQueryText(model: model, addwhere: false)+" where "+whereQuery;
        QueryWorker.ExecQuery(query: query);
    }
}
