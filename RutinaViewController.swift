//
//  RutinaViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 08/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit

class RutinaViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var duracion: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    var rutina: ProtocolRutina!
  
  
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icon.image = rutina.Icon
        titulo.text = rutina.Titulo
        fecha.text = rutina.Fecha
        duracion.text = rutina.Duracion
        descripcion.text = rutina.Descripcion
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
