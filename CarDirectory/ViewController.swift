//
//  ViewController.swift
//  CarDirectory
//
//  Created by Григорий Бойко on 01.10.2020.
//  Copyright © 2020 Grigory Boyko. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cars: Results<Car>!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isAppAlreadyLaunchedOnce(){
            Car.createCars()
        }
        cars = realm.objects(Car.self)
        
        setupMainScreen()
    }
    // MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! CarTableViewCell
        let index = indexPath.row
        cell.nameLabel.text = cars[index].manufacturer! + " " + cars[index].model!
        cell.typeLabel.text = "Тип кузова: " + cars[index].typeOfBody!
        cell.yearLabel.text = "Год выпуска: \(cars[index].yearOfProduction)"
        if let imageData = cars[index].imageData {
            cell.thumbnailImageView.image = UIImage(data: imageData)
        }else {
            cell.thumbnailImageView.image = #imageLiteral(resourceName: "car_default_image")
        }
        
        return cell
    }
    
    // MARK: Table view delegate
    //Удаление по свайпу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let car = cars[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, _)  in
            
            StorageManager.deleteObject(car)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Убираем выделение
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let dvc = segue.destination as? DetailViewController else { return }
            
            if let indexPath = tableView.indexPathForSelectedRow {
                dvc.car = cars[indexPath.row]
                dvc.indexPath = indexPath
            }
       }
    }
    @IBAction func unwindSeque(_ segue: UIStoryboardSegue){
        let dvc = segue.source as! DetailViewController
        dvc.saveCar()
        tableView.reloadData()
    }
    @IBAction func deleteUnwindSeque(_ segue: UIStoryboardSegue){
        let dvc = segue.source as! DetailViewController
        dvc.deleteCar()
        tableView.deleteRows(at: [dvc.indexPath], with: .automatic)
    }
    
    private func setupMainScreen(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //Убираем полоски внизу
        tableView.tableFooterView = UIView()
        //Убираем последнюю полоску ячейки
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }

}
extension ViewController{
    //Проверка первого запуска
    private func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard

        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
}
