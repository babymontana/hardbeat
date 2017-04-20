//
//  rutina.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 06/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class rutina: ProtocolRutina{
    private var titulo : String?
    private var descripcion : String?
    private var fecha : String?
    private var tipo : String?
    private var duracion : String?
    private var data :Dictionary<String, AnyObject>?
    private var ref: String?
    private var icon : UIImage?
    
    

        init (datos:Dictionary<String, AnyObject>,ref: FIRDatabaseReference?){
            
            self.ref = ref?.key
            self.titulo = datos["titulo"] as! String?
            self.descripcion = datos["descripcion"] as! String?
            self.fecha = datos["fecha"] as! String?
            self.tipo = datos["tipo"] as! String?
            self.duracion = datos["duracion"] as! String?
            
            self.data = [
                "ref" : self.ref as AnyObject,
                "titulo":self.titulo as AnyObject,
                "descripcion":self.descripcion as AnyObject,
                "fecha":self.fecha as AnyObject,
                "tipo":self.tipo as AnyObject,
                "duracion":self.duracion as AnyObject
            ]
            
            self.icon = UIImage(named: self.tipo!)
            
        }
    
    
    internal var getData : Dictionary<String, AnyObject>{
        get{
            return self.data!
        }
    }
    
    internal var DownCast: rutinaCompleta{
        get{
            return rutinaCompleta(datos: [:])
        }
        
    }
    
    
    var Descripcion : String{
        get{
            return self.descripcion!
        }
        
        set(newDescripcion){
            self.descripcion = newDescripcion
        }
    }

    
    var Tipo : String{
        get{
            return self.tipo!
        }
        
        set(newTipo){
            self.tipo = newTipo
        }
    }
    
    var Duracion : String{
        get{
            return self.duracion!
        }
        
        set(newDuracion){
            self.duracion = newDuracion
        }
    }


    
    var Ref : String{
        get{
            return self.ref!
        }
        
        set(newRef){
            self.ref = newRef
        }
    }
    
    
    var Fecha : String{
        get{
            return self.fecha!
        }
        
        set(newFecha){
            self.fecha = newFecha
        }
    }
    
    var Titulo : String{
        get{
            return self.titulo!
        }
        
        set(newTitulo){
            self.titulo = newTitulo
        }
    }

    
    var Icon : UIImage{
        get{
            return self.icon!
        }
        
        set(newIcon){
            self.icon = newIcon
        }
    }
    
   

        
    
    
}
