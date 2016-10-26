//
//  CreateEventViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/25/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate {

    var pickerData: [String]!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descrTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var typePicker: UIPickerView!
    
    var locationDataDelegate: CLLocationManagerDelegate?
    var invitions: String?
    
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround()
        
        pickerData = AvailableCategories.getTextValues()
        typePicker.dataSource = self
        typePicker.delegate = self
        
        datePicker.minimumDate = NSDate()
        
        self.titleTextField.delegate = self;
        self.descrTextField.delegate = self;
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func createBtn(sender: AnyObject) {
        
        if let alertMessage = validateData()  {
            let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let doubt = UIAlertAction(title: "OK",
                                      style: .Default, handler: nil )
            
            alertController.addAction(doubt)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let title = titleTextField.text
        let descr = descrTextField.text ?? ""
        let date = Utils.combineDateWithTime( datePicker.date, time: timePicker.date )
        let invitionsTmp = self.invitions ?? ""
        let owner_uid = Model.getInstance().currentUser.uid
        let selectedCategory = pickerData[typePicker.selectedRowInComponent(0)]
        let category = AvailableCategories.getValueFromWord( selectedCategory )
        let location = "\(FakeData.getFakeCoordinate()),\(FakeData.getFakeCoordinate())"//locationDataDelegate.lo
        
        Model.getInstance().createAndSaveEvent( owner_uid!, title: title!, descr: descr, date: date!, invitions: invitionsTmp, category: category, location: location )
        
    }
    
    func validateData() -> String? {
        let title = titleTextField.text
        if title == nil || title!.isEmpty {
            return "The title have not entered"
        }
        
//        let currentDate = NSDate()
//        let dateComparisionResult:NSComparisonResult = currentDate.compare(datePicker.date)
//        
//        if dateComparisionResult == NSComparisonResult.OrderedDescending {
//            return "Дата события раньше текущей даты"
//        }
        
        return nil
    }
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
//        typePicker.text = pickerData[row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "ShowMapSegue" {
            if let destinController = segue.destinationViewController as? CreateEventMapViewController {
                
                destinController.location = Model.getInstance().getCurrentGeolocation()
                locationDataDelegate = destinController as CLLocationManagerDelegate
            }
        }
        
        if segue.identifier == "showPeopleSelectView" {
            if let destinController = segue.destinationViewController as? CreateEventPeopleViewController {
                
                destinController.returnResultsCallback = returnResultsCallback
            }
        }
    }
    
    func returnResultsCallback( invitions: [String] ) {
        self.invitions = invitions.joinWithSeparator(",")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

