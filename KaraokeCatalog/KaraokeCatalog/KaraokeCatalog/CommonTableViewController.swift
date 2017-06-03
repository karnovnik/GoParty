//
//  CommonTableViewController.swift
//  KaraokeCatalog
//
//  Created by Karnovskiy on 2/19/17.
//  Copyright © 2017 Karnovskiy. All rights reserved.
//

import UIKit

class CommonTableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var ddlBtn: UIButton!
    @IBOutlet weak var ddlPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataAndDelegate: SongsTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataAndDelegate = SongsTableViewDelegate()
        dataAndDelegate.source = Model.TheModel.getFilteredSongs()
        
        tableView.dataSource = dataAndDelegate!
        tableView.delegate = dataAndDelegate!
        
        tableView.tableFooterView = UIView()
        
        ddlBtn.addTarget(self, action:#selector(CommonTableViewController.ddlBtnClick), for:UIControlEvents.touchUpInside)
        ddlBtn.setTitle( ENations.textValues[ Model.TheModel.nationFilter ], for: .normal )
        
        ddlPicker.dataSource = self
        ddlPicker.delegate = self
        
        let nationName = ENations.getTextValues()
        let index = nationName.index(of: ENations.textValues[ Model.TheModel.nationFilter ]! )
        ddlPicker.selectRow(index!, inComponent: 0, animated: true)
        
        ddlPicker.backgroundColor = UIColor.white
        ddlPicker.layer.cornerRadius = 6.0
        ddlPicker.layer.borderColor = UIColor.gray.cgColor
        ddlPicker.layer.borderWidth = 0.5
        ddlPicker.clipsToBounds = true
        
        searchBar.delegate = self
        
        Model.TheModel.addListener(name: "CommonTableViewController", listener: eventHandler )
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func eventHandler( event: String ) {
        if event == EVENT_UPDATE {
            ReloadData()
        }
    }
    
    func ReloadData() {
        dataAndDelegate.source = Model.TheModel.getFilteredSongs()
        tableView.reloadData()
    }
    
    func ddlBtnClick() {
        
        self.ddlPicker.isHidden = !self.ddlPicker.isHidden
    }
    
    @IBAction func FavoriteBtn(_ sender: UIButton) {
        Model.TheModel.favoriteFilter = !Model.TheModel.favoriteFilter
        sender.alpha = Model.TheModel.favoriteFilter ? 1 : 0.5
        ReloadData()
    }
    
    // Picker interface
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return ENations.getTextValues().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return ENations.getTextValues()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let nationName = ENations.getTextValues()[row]
        Model.TheModel.nationFilter = ENations.getValueFromWord(nationName)
        ReloadData()
        self.ddlBtn.setTitle( nationName, for: .normal )
        self.ddlPicker.isHidden = true
    }
    
    // Search interface
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Model.TheModel.searchFilter = ""
        ReloadData()
        searchBar.endEditing(true)
        resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
        resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != Model.TheModel.searchFilter {
            Model.TheModel.searchFilter = searchText
            ReloadData()
        }
    }
}
