//
//  PrimaryKey.swift
//  M-EKBS
//
//  Created by basar turan on 10.03.2020.
//  Copyright © 2020 Avatek Yazilim. All rights reserved.
//

import UIKit

class PrimaryKey {
    var keyName:String = "";
    var autoIncrement:Bool=false;
    init(key:String,inc:Bool) {
        keyName=key;
        autoIncrement=inc;
    }

}
