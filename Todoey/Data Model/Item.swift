//
//  Item.swift
//  Todoey
//
//  Created by Blake Patenaude on 2019-06-11.
//  Copyright © 2019 Blake Patenaude. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
