//
//  BottomSheetViewController.swift
//  iOS_Test
//
//  Created by Aang on 31/07/24.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    @IBOutlet var statisticsLabel: UILabel!
    
    var statisticsText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let text = statisticsText{
            statisticsLabel.text = text
        }
    }
}
