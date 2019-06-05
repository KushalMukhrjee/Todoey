//
//  Item.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 02/06/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import Foundation
import RealmSwift

class ItemR:Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    
    var parentCategory=LinkingObjects(fromType: CategoryR.self, property: "items") //inverse relationship
    
}
