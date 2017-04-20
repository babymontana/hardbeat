//
//  InterfaceController.swift
//  hardbeat WatchKit Extension
//
//  Created by Emmanuel Paez on 02/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity



class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    var session : WCSession!
    var rutinas = [Dictionary<String, AnyObject>]()
    
    @IBOutlet var tabRutinas: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            self.cargarRutinas()
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex:
        Int) {

        self.pushController(withName: "infoInterfaceController", context: self.rutinas[rowIndex])
        
    }
    
  
       
    func cargarRutinas(){
        
        let mensajeRutinas = ["instruccion":"rutinas"]
        session.sendMessage(mensajeRutinas, replyHandler: { replyMessage in
            //handle and present the message on screen
            self.rutinas = (replyMessage["rutinas"] as! [Dictionary<String,AnyObject>]?)!
            self.tabRutinas.setNumberOfRows(self.rutinas.count, withRowType: "rutinaRow")
            var i = 0
            for rut in self.rutinas{
                let row = self.tabRutinas.rowController(at: i) as! rutinaRow
                row.titulo.setText(rut["titulo"] as! String?)
                row.icon.setImage(UIImage(named:(rut["tipo"] as! String?)!))
                i+=1
            }
        }, errorHandler: {error in
            // catch any errors here
            print(error)
        })
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
