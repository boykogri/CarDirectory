//
//  Car.swift
//  CarDirectory
//
//  Created by Григорий Бойко on 02.10.2020.
//  Copyright © 2020 Grigory Boyko. All rights reserved.
//

import RealmSwift
class Car: Object {
    @objc dynamic var yearOfProduction: Int = 0
    @objc dynamic var manufacturer: String? = ""
    @objc dynamic var model: String? = ""
    @objc dynamic var typeOfBody: String? = ""
    @objc dynamic var imageData: Data? = nil
    @objc dynamic var date = Date()
    static let carNames = ["Nissan X-Trail", "Kia Ceed", "Toyota Land Cruiser Prado"]
    
    convenience init(manufacturer: String, model: String, typeOfBody: String, year: Int, image: Data? = nil) {
        self.init()
        self.manufacturer = manufacturer
        self.model = model
        self.typeOfBody = typeOfBody
        self.yearOfProduction = year
        self.imageData = image
    }
    static func createCars(){
        StorageManager.saveObject(Car(manufacturer: "Nissan", model: "X-Trail", typeOfBody: "кроссовер", year: 2013, image: UIImage(named: carNames[0])!.pngData()))
        StorageManager.saveObject(Car(manufacturer: "Kia", model: "Ceed", typeOfBody: "универсал", year: 2010, image: UIImage(named: carNames[1])!.pngData()))
        StorageManager.saveObject(Car(manufacturer: "Toyota", model: "Land Cruiser Prado", typeOfBody: "внедорожник", year: 2017, image: UIImage(named: carNames[2])!.pngData()))
        
    }
}
