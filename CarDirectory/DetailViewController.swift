//
//  DetailViewController.swift
//  CarDirectory
//
//  Created by Григорий Бойко on 01.10.2020.
//  Copyright © 2020 Grigory Boyko. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var car: Car!
    var indexPath: IndexPath!
    
    @IBOutlet var carImageView: UIImageView!
    @IBOutlet var keyLabels: [UILabel]!
    @IBOutlet var valueTFs: [UITextField]!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var saveButton: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEditScreen()
        
        //Распознователь нажатий
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        carImageView.isUserInteractionEnabled = true
        carImageView.addGestureRecognizer(tapGestureRecognizer)
        
        valueTFs[0].addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        valueTFs[1].addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        valueTFs[2].addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        valueTFs[3].addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        saveButton.isEnabled = false
    }
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        chooseImagePicker(source: .photoLibrary)
    }
    // MARK: Storage methods
    func saveCar() {
        let image = carImageView.image
        let imageData = image?.pngData()
        let newCar = Car(manufacturer: valueTFs[0].text!, model: valueTFs[1].text!, typeOfBody: valueTFs[2].text!, year: Int(valueTFs[3].text!)!, image: imageData)
        
        if car != nil {
            try! realm.write {
                car.manufacturer = newCar.manufacturer
                car.model = newCar.model
                car.typeOfBody = newCar.typeOfBody
                car.yearOfProduction = newCar.yearOfProduction
                car.imageData = newCar.imageData

            }
        } else {
            StorageManager.saveObject(newCar)
        }
    }
    func deleteCar(){
        StorageManager.deleteObject(car)
    }
    // MARK: Private methods
    private func setupEditScreen() {
        if car != nil {
            title = (car.manufacturer ?? "") + " " + (car.model ?? "")
            
            //Убираем кнопку отмены
            navigationItem.leftBarButtonItem = nil
            
            saveButton.isEnabled = true
            
            valueTFs[0].text = car.manufacturer
            valueTFs[1].text = car.model
            valueTFs[2].text = car.typeOfBody
            valueTFs[3].text = "\(car.yearOfProduction)"
            if let imageData = car.imageData, let image = UIImage(data: imageData){
                carImageView.image = image
            }else { carImageView.image = #imageLiteral(resourceName: "car_default_image")}
        }
        else{
            carImageView.image = #imageLiteral(resourceName: "car_default_image")
            deleteButton.isHidden = true
        }
        //Убираем последнюю полоску ячейки
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    private func areFieldsEmpty() -> Bool{
        valueTFs[0].text?.isEmpty == false && valueTFs[1].text?.isEmpty == false && valueTFs[2].text?.isEmpty == false && valueTFs[3].text?.isEmpty == false
    }
    
}
// MARK: Text field delegate
extension DetailViewController: UITextFieldDelegate {
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if areFieldsEmpty(){
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
//MARK: Work with image
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        carImageView.image = info[.editedImage] as? UIImage
        if areFieldsEmpty(){
            saveButton.isEnabled = true
        }
        dismiss(animated: true)
    }
}
