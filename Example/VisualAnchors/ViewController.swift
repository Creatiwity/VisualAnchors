//
//  ViewController.swift
//  VisualAnchors
//
//  Created by Julien Blatecky on 11/06/2015.
//  Copyright (c) 2015 Julien Blatecky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let greenView = UIView()
        greenView.backgroundColor = UIColor.greenColor()
        
        //greenView.anchors.fill = view.anchors.fill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

