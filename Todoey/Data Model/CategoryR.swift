//
//  Category.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 02/06/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import Foundation
import RealmSwift
class CategoryR:Object{
    @objc dynamic var name: String = ""
    let items=List<ItemR>() //forward relationshilp
    
    
    
    
}
