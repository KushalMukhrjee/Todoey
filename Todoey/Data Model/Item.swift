//
//  Item.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 20/05/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import Foundation

class Item{
    
    var title : String
    var done : Bool = false
    
    init(title:String) {
        self.title=title
    }
    
}
