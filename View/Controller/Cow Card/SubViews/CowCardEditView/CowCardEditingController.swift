//
//  CowCardEditingController.swift
//  Herd Tracking
//
//  Created by ibrahim eryılmaz on 10.10.2022.
//


import Foundation
import UIKit
import SwiftUI



class CowCardEditingController : UIView , NibInitializable {
    
    
    
    // MARK: - Properties
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var earTagEditingTextField: UITextField!
    @IBOutlet weak var cowNameEditingTextField: UITextField!
    @IBOutlet weak var dateOfBirthEditingTextField: UITextField!
    @IBOutlet weak var cowBreedEditingTextFiedl: UITextField!
    @IBOutlet weak var genderEditingTextfield: UITextField!
    @IBOutlet weak var groupNoTextField: UITextField!
    
    var delegate:CowCardEditingProtocol?
    var nibName: String = "CowCardEditingViewScreen"
    var editingCow : CowModel = CowModel()
    let breedPickerView = UIPickerView()
    let genderPickerView = UIPickerView()
    let datePicker = UIDatePicker()
    let cowViewModel = CowViewModel()
    let newCow = CowModel()
    
    
    // MARK: - Initializers
    
    
    required init?(coder: NSCoder ) {
        
        super.init(coder: coder)
        self.initiliaze(withNibName: self.nibName, self.postInitialize)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initiliaze(withNibName: self.nibName, self.postInitialize)
        
    }
    
    private func postInitialize(_ view: UIView) {}
    
    override func layoutSubviews() {
        setTextField()
        createPickerView(textField: genderEditingTextfield, pickerView: genderPickerView)
        createPickerView(textField: cowBreedEditingTextFiedl, pickerView: breedPickerView)
        createDatePicker()
        
    }
    
    // MARK: - Setup
    
    private func setup(){}
    
    func createPickerView(textField : UITextField , pickerView : UIPickerView){
        textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        datePicker.preferredDatePickerStyle = .wheels
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(cancelButtonClicked))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonClicked))
        toolbar.setItems([cancelButton,.flexibleSpace() ,doneButton], animated: true)
        dateOfBirthEditingTextField.inputAccessoryView = toolbar
        dateOfBirthEditingTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    // MARK: - Actions
    
    @IBAction func saveButton(_ sender: Any) {
        
        if delegate != nil {
            if earTagEditingTextField.text == "" {
                UIWindow.showAlert(title: Constants.Alert.title, message: Constants.Alert.earRing)
            }else{
                if dateOfBirthEditingTextField.text == ""{
                    UIWindow.showAlert(title: Constants.Alert.title, message: Constants.Alert.birthOfDate)
                }else{
//                    LocaleService.shared.updateCow(cow: delegate.cowCardEditinCow(), name: cowNameEditingTextField.text ?? "", earTag: earTagEditingTextField.text ?? "", dateOfBirth: dateOfBirthEditingTextField.text ?? "", cowBreed: cowBreedEditingTextFiedl.text ?? "", gender: genderEditingTextfield.text ?? "")
        
                    guard let earTag = earTagEditingTextField.text else {return}
                    newCow.earTag = earTag
                    guard let cowName = cowNameEditingTextField.text else {return}
                    newCow.cowName = cowName
                    guard let dateOfBirth = dateOfBirthEditingTextField.text else {return}
                    newCow.dateOfBirth = dateOfBirth
                    guard let cowBreed = cowBreedEditingTextFiedl.text else {return}
                    newCow.cowBreed = cowBreed
                    guard let gender = genderEditingTextfield.text else {return}
                    newCow.gender = gender
                    guard let group = groupNoTextField.text else {return}
                    newCow.groupNo = group
                    
                    cowViewModel.generalUpdate(cow: editingCow, addCow: newCow)
                    
                    UIWindow.showAlert(title: Constants.Alert.successTitle, message: Constants.Alert.successfullUpdate)
                    delegateViewFunc()
                }
            }
            
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        delegateViewFunc()
    }
    
    // MARK: - Methods
    
    
    func delegateViewFunc () {
        if let delegate = delegate {
            delegate.closeCowCardEditingView()
            
        }
    }
    
    func setTextField (){
        if let delegate = delegate {
            editingCow = delegate.cowCardEditinCow()
        }
        earTagEditingTextField.text = editingCow.earTag
        cowNameEditingTextField.text = editingCow.cowName
        dateOfBirthEditingTextField.text = editingCow.dateOfBirth
        cowBreedEditingTextFiedl.text = editingCow.cowBreed
        genderEditingTextfield.text = editingCow.gender
        groupNoTextField.text = editingCow.groupNo
        
    }
    
    @objc func doneButtonClicked(){
        
        if let datePickerView = self.datePicker.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.dateOfBirthEditingTextField.text = dateString
            self.dateOfBirthEditingTextField.resignFirstResponder()
        }
    }
    
    @objc func cancelButtonClicked(){
        self.dateOfBirthEditingTextField.resignFirstResponder()
    }
}

extension CowCardEditingController: UIPickerViewDataSource , UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerView == breedPickerView ? Constants.Arrays.cowBreedArray.count : Constants.Arrays.genderArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == breedPickerView ? Constants.Arrays.cowBreedArray[row] : Constants.Arrays.genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == breedPickerView{
            cowBreedEditingTextFiedl.text = Constants.Arrays.cowBreedArray[row]
            cowBreedEditingTextFiedl.resignFirstResponder()
        }else if pickerView == genderPickerView{
            genderEditingTextfield.text = Constants.Arrays.genderArray[row]
            genderEditingTextfield.resignFirstResponder()
        }
        
    }
    
}


