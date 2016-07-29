//
//  ViewController.swift
//  Arduino
//
//  Created by Jaime Capponi on 27-05-16.
//  Copyright © 2016 SimpleApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ViewController: UIViewController {


    var status: Int = 0
    @IBOutlet var textLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
   
    
    @IBAction func switchButtonChanged(sender: AnyObject) {
        
        //switchButton.userInteractionEnabled = false
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Cargando"
        
        // CAMBIAR el estado del switch
        
        if status == 0 {
            
            status = 1
            
        }
        else {
        
            status = 0
        
        }
        
        Alamofire.request(.POST, "http://ninjup.com/arduino/servicioArduino.php", parameters: ["status": status])
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.toggleSwitch()
                    //self.switchButton.userInteractionEnabled = true
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // aqui hacer el check inicialmente
        
        Alamofire.request(.GET, "http://ninjup.com/arduino/statusArduino.php", parameters: nil)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization

                if let JSONresponse = response.result.value {
                    var json = JSON(JSONresponse)
                    print(json["status"].intValue)
                    self.status = json["status"].intValue // 
                    
                    // se hace aqui porque el codigo es asincrono
                    if self.status == 0 {
                        
                        self.textLabel.text = "Apagado"
                        self.switchButton.on = false
                        
                    }
                    else {
                        
                        self.textLabel.text = "Encendido"
                        self.switchButton.on = true
                        
                    }
                }
        }
  
    }
    
    func toggleSwitch() {
    
        if status == 0 {
            
            textLabel.text = "Apagado"
            switchButton.on = false  // esto por si dentro del server cambio algo, para tener lo correcto
            
        }
        else {
            
            textLabel.text = "Encendido"
            switchButton.on = true  // esto por si dentro del server cambio algo, para tener lo correcto

        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

