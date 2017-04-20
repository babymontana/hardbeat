//
//  protocolRutina.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 09/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import Foundation
import UIKit

protocol ProtocolRutina {
    
    
    var Titulo : String {get}
    var Descripcion : String {get}
    var Fecha : String {get}
    var Tipo : String {get}
    var Duracion : String {get}
    var Ref: String {get}
    var Icon : UIImage {get}
    var getData : Dictionary<String, AnyObject> {get}
    var DownCast : rutinaCompleta {get}
}
