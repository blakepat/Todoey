//
//  Category.swift
//  Todoey
//
//  Created by Blake Patenaude on 2019-06-11.
//  Copyright © 2019 Blake Patenaude. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    let items = List<Item>()
    
    
    
    
    
    
    
    
    
}
