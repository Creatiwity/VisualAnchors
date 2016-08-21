//
//  ViewController.swift
//  VisualAnchors
//
//  Created by Julien Blatecky on 05/05/2016.
//  Copyright (c) 2016 Julien Blatecky. All rights reserved.
//

import UIKit
import VisualAnchors

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let greenView = UIView()
        greenView.backgroundColor = UIColor.green
        
        // Must be done before adding constraints
        view.addSubview(greenView)
        
        // Fill view with greenView with 10px margin all around
        greenView.anchors.fill = 10 + view.anchors.fill.ancestor(view)
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        greenView.addSubview(redView)
        
        // Centers redView in greenView
        redView.anchors.center = greenView.anchors.center.ancestor(greenView)
        redView.anchors.width = view.anchors.height.ancestor(view) / 2
        redView.anchors.height = view.anchors.width.ancestor(view) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

