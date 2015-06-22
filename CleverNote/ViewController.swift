//
//  ViewController.swift
//  CleverNote
//
//  Created by Eugene Yurtaev on 22/06/15.
//  Copyright (c) 2015 dpfbop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    var counter: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        counterLabel.text = "\(counter)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonTapped(sender: AnyObject) {
        counter += 1
        counterLabel.text = "\(counter)"
    }
}

