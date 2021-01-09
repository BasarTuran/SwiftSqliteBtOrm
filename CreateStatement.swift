//
//  CreateStatement.swift
//  M-EKBS
//
//  Created by basar turan on 12.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//


import UIKit
import Foundation
import SQLite3
class CreateStatement {
    private func getCreateTableText(model:SqliteModel)->String{
        var query:String="(";
        if( model.isPrimaryExists() && model.primaryKey.keyName.count>1)
        {
            query+=model.primaryKey.keyName+" "+model.getPrimaryKeyType();
            query+=" UNIQUE PRIMARY KEY ";
            if(model.primaryKey.autoIncrement)
            {
                query+="AUTOINCREMENT ";
            }
            if(model.getChildrenCountWithOutPrimary()>0)
            {
                query+=", ";
            }
        }
        let m=model.getChildren();
        var i:Int=0;
        var childCount:Int=m.count;
        if(model.isPrimaryExists() && model.getChildrenCountWithOutPrimary()>0)
        {
            childCount-=1;
        }
        for child in m
        {
            debugPrint(child.label!);
            if !(child.label==model.primaryKey.keyName)
            {
                if(i<childCount-1)
                {
                    query+=child.label!+" "+SqliteHelper.convertValueToType(value: child.value)+", ";
                }
                else{
                    query+=child.label!+" "+SqliteHelper.convertValueToType(value: child.value);
                }
                i+=1;
            }
            
        }
        query+=");";
        //debugPrint(query)
        return query;
    }
    func createTable(model:SqliteModel) {
        let createTableString = "CREATE TABLE IF NOT EXISTS "+model.getTableName()+self.getCreateTableText(model: model);
        QueryWorker.ExecQuery(query: createTableString);
    }
}
