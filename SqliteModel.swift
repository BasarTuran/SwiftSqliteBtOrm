//
//  SqliteModel.swift
//  M-EKBS
//
//  Created by basar turan on 10.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit
import Foundation
import SQLite3
@objcMembers
class SqliteModel:NSObject{
    var primaryKey: PrimaryKey=PrimaryKey(key: "", inc: false);
    var id:Int=Int.init();
    required  override init() {
        if(primaryKey.keyName.count<2)
        {
            primaryKey.keyName="id";
            primaryKey.autoIncrement=true;
            //debugPrint(primaryKey.keyName)
        }
    }
   
    public func getTableName()-> String {
        let tblname:String = NSStringFromClass(type(of: self));
        return tblname.replacingOccurrences(of: ".", with: "");
    }
    
    
    
    public func getPrimaryKeyType()->String{
        let m = getChildren();
        for child in m{
            if (child.label==primaryKey.keyName)
            {
                
                return SqliteHelper.convertValueToType(value: child.value);
            }
        }
        return "";
    }
    public func isPrimaryExists()->Bool{
        let m = getChildren();
        var count:Int=0;
        for child in m{
            if (child.label==primaryKey.keyName)
            {
                
                count+=1;
            }
        }
        if(count>0){return true;}
        else {return false;}
    }
    public func  getChildrenCountWithOutPrimary()->Int{
        let m = getChildren();
        var count:Int=0;
        for child in m{
            if !(child.label==primaryKey.keyName)
            {
                count+=1;
            }
        }
        return count;
    }
    public func getSelfChildren()->Mirror.Children
    {
        return Mirror(reflecting: self).children;
    }
    public func  getChildren()->[Mirror.Child]{
        let mirror = Mirror(reflecting: self);
        var list:[Mirror.Child]=[] ;
        list.append(contentsOf: mirror.children)
        var finder:Bool=false;
        for child in mirror.children
        {
            if(primaryKey.keyName==child.label)
            {
                finder=true;
                break;
            }
        }
        if !(finder)
        {
            for child in mirror.superclassMirror!.children
            {
                if(child.label!==primaryKey.keyName)
                {
                    list.append(child);
                }
            }
        }
        
        return list;
    }
   
   
   
    
  
    
    
    func isExistInRows()->Bool
    {
        return SelectStatement.isExistInRows(classType: self);
    }
    func createTable()
    {
        CreateStatement().createTable(model: self);
    }
    func insert()
    {
        InsertStatement().insert(model: self);
    }
    func save()
    {
        if(isExistInRows())
        {
            update();
        }
        else{
            insert();
        }
    }
    func update()
    {
        UpdateStatement().update(model: self);
    }
    public static func updateWithQuery(whereQuery:String)
    {
        UpdateStatement().updateWithQuery(model: self.init(), whereQuery: whereQuery);
    }
    public static func deleteAll()
    {
        DeleteStatement().deleteAll(model:self.init());
    }
    func delete()
    {
        DeleteStatement().delete(model: self);
    }
    public static func deleteWithQuery(whereQuery:String)
    {
        DeleteStatement().deleteWithQuery(model: self.init(), whereQuery: whereQuery);
    }
    public static func listAll()-> [SqliteModel]  {
        return SelectStatement.listAll(classType: self.init());
    }
    public static func find(whereQuery:String)-> [SqliteModel]  {
        return SelectStatement.find(classType: self.init(),whereQuery: whereQuery);
    }
    public static func list(query:String)-> [SqliteModel]  {
        return SelectStatement.list(classType: self.init(),query: query);
    }
    func dropTable()
    {
        DropStatement().dropTable(model: self);
    }
}
