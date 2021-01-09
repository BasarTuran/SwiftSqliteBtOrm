//
//  SqliteHelper.swift
//  M-EKBS
//
//  Created by basar turan on 11.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit
import SQLite3
class SqliteHelper {
    public static func convertValueToType(value:Any)->String
    {
        var typedata:String=String(reflecting:type(of: value));
        typedata=typedata.replacingOccurrences(of: "Swift.", with: "");
        //debugPrint(typedata);
        if(typedata=="String")
        {
            return "TEXT";
        }
        else if(typedata=="Int")
        {
            return "INTEGER";
        }
        else if(typedata=="Float" || typedata=="Double")
        {
            
            return "REAL";
        }
        else if(typedata=="Bool")
        {
            
            return "NUMBER(1)";
        }
            else if(typedata=="Date")
            {
                
                return "NUMERIC";
            }
        else
        {
            return "BLOB";
        }
    }
    public static func getVariableType(value:Any)->String
    {
        var typedata:String=String(reflecting:type(of: value));
        typedata=typedata.replacingOccurrences(of: "Swift.", with: "");
        return typedata;
    }
    public static func getValueTagForSqlite(typedata:String)->String
    {       
        
        if(typedata=="String")
        {
            return "'";
        }
        else if(typedata=="Int")
        {
            return "";
        }
        else if(typedata=="Float" || typedata=="Double")
        {
            
            return "";
        }
        else if(typedata=="Bool" || typedata=="Date")
        {
            
            return "'";
        }
        else
        {
            return "'";
        }
    }
    public static func getValueForSqlite(member:Any)->String
    {
        let valueType:String=getVariableType(value: member);
        let valueTag:String=getValueTagForSqlite(typedata: valueType);
        var value:String=String.init();
        if(valueType=="String")
        {
            value=member as! String;
        }
        else if(valueType=="Int")
        {
            value=String(member as! Int);
        }
        else if(valueType=="Float" || valueType=="Double")
        {
            value=String(member as! Double);
        }
        else if(valueType=="Bool")
        {
            value=String(member as! Bool);
        }
        else if(valueType=="Date")
        {
            //value=String(child.value as! Date);
        }
        return valueTag+value+valueTag;
    }
    public static func getPropertyFromName(name:String,model:SqliteModel)->Mirror.Child{
           let m=model.getChildren();
           for child in m{
               if(child.label==name)
               {
                   return child;
               }
           }
           return Mirror.Child("","");
       }
}
