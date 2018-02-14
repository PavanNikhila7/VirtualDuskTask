//
//  TabBarViewController.swift
//  VirtualDuskTask
//
//  Created by Pavankumar G on 14/02/18.
//  Copyright © 2018 Pavankumar G. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    //MARK: - View Life cycle method

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.selectedIndex=2
        
        
        
        
        
    }

    //MARK: - Memory Warning method

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
