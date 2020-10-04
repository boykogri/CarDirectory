//
//  StorageManager.swift
//  CarDirectory
//
//  Created by Григорий Бойко on 03.10.2020.
//  Copyright © 2020 Grigory Boyko. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ car: Car) {
        
        try! realm.write {
            realm.add(car)
        }
    }
    
    static func deleteObject(_ car: Car) {
        
        try! realm.write {
            realm.delete(car)
        }
    }
}
