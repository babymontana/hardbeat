//
//  infoInterfaceController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 08/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import WatchKit
import Foundation


class infoInterfaceController: WKInterfaceController {

    @IBOutlet var fecha: WKInterfaceLabel!
    @IBOutlet var titulo: WKInterfaceLabel!
    @IBOutlet var duracion: WKInterfaceLabel!
    @IBOutlet var icon: WKInterfaceImage!
    var datos : Dictionary<String, AnyObject> = [:]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.datos = (context as? Dictionary<String, AnyObject>)!
        fecha.setText(datos["fecha"] as! String?)
        titulo.setText(datos["titulo"] as! String?)
        duracion.setText(datos["duracion"] as! String?)
        icon.setImage(UIImage(named: (datos["tipo"] as! String?)!))
        
    }
    
    
    @IBAction func empezar() {
        self.pushController(withName: "meterInterfaceController", context: self.datos)

        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
