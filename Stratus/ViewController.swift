//
//  ViewController.swift
//  Stratus
//
//  Created by student on 2/8/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StratusObserver {

    @IBOutlet weak var testOut: UILabel!
    var fetcher = StratusDataFetcher.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetcher.attachObserver( observer: self )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update( stratusData: StratusDataFetcher.StratusDataStruct ) {
        testOut.text = String(stratusData.battery) + "HOLLA"
    }
}

