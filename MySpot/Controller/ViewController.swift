//
//  ViewController.swift
//  MySpot
//
//  Created by Kamil Pawlak on 21/09/2021.
//

import UIKit

class ViewController: UIViewController {
  
   
    var mySpotNetworking = MySpotNetworking()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mySpotNetworking.delegate = self
        
    }
    
   

}

extension ViewController: MySpotNetworkingDelegate {
    
    func didUpdate(_ thisIsFrom: MySpotNetworking, mySpotModel: MySpotModel) {
        print("hey")
    }

}

