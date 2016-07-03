//
//  PickupContainerViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class PickupContainerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let pickerData = ["All American Grille", "Bombay Indian Food", "China Tradition", "Italian Eatery", "Mediterranean Cafe", "Persian Palace", "Soup and Salad Village", "Thai King"]
    
    @IBOutlet weak var spacePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spacePickerView.dataSource = self
        spacePickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
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
        //myLabel.text = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            //pickerLabel.backgroundColor = UIColor( red: CGFloat(211) / 255.0, green: CGFloat(67) / 255.0, blue: CGFloat(6) / 255.0, alpha: 1.0 )
            pickerLabel.backgroundColor = UIColor.whiteColor()
        }
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Roboto", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        return pickerLabel
    }

    

}
