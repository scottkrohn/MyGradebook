//
//  AddSemesterViewController.swift
//  GradeBook
//
//  Created by Scott & Jen on 3/29/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

class AddSemesterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var semester: SemesterController = SemesterController();
    let pickerViewTermData = ["Fall", "Spring", "Summer"];
    let pickerViewYearData = [Int](2000...NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Year, fromDate: NSDate()));
    var selectedSemester: String!
    var selectedYear: Int!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var semesterPicker: UIPickerView!
    @IBOutlet weak var yearPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        semesterPicker.delegate = self;
        semesterPicker.dataSource = self;
        yearPicker.delegate = self;
        yearPicker.dataSource = self;
        semesterPicker.selectRow(1, inComponent: 0, animated: true)
        yearPicker.selectRow(pickerViewYearData.count-1, inComponent: 0, animated: true)
        
        // Set default picker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set the number of components in the picker view.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // Set the number of rows in the picker view.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return pickerViewTermData.count;
        }
        else {
            return pickerViewYearData.count;
        }
    }
    
    // Set the data for the picker views.
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return pickerViewTermData[row];
        }
        else {
            return String(pickerViewYearData[row]);
        }
    }
    
    // Called when the user clicks "Add".
    @IBAction func addClicked(sender: AnyObject) {
        // Create a term name from picker view inputs then add to Semester core data.
        let fullTermName = pickerViewTermData[semesterPicker.selectedRowInComponent(0)] +
            " " + String(pickerViewYearData[yearPicker.selectedRowInComponent(0)]);
        semester.addTerm(fullTermName);
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
    
}
