//
//  CreateEventTypeViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 2/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateEventTypeViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var pickerData: [String]!
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    var selectedCategory = AvailableCategories.NONE
    var key = CreateEventItemsKeys.NONE
    var returnResultsCallback: ((CreateEventItemsKeys, AnyObject)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerData = AvailableCategories.getTextValues()
        typePicker.dataSource = self
        typePicker.delegate = self
        typePicker.selectRow(selectedCategory.rawValue, inComponent: 0, animated: true)
        
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear( animated )
        self.tabBarController?.tabBar.isHidden = false
        
        let selectedCategory = pickerData[typePicker.selectedRow(inComponent: 0)]
        if returnResultsCallback != nil {
            returnResultsCallback!( key, AvailableCategories.getValueFromWord(selectedCategory) as AnyObject )
        }
        
        print( "Selected type \(selectedCategory)" )
    }
    
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
    }

    func setupNavigationItem() {
        
        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( CreateEventPeopleViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func popToRoot() {
        navigationController!.popViewController(animated: true)
    }
}
