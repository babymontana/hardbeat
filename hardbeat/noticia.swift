//
//  noticia.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 05/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit


class noticia{
    
    private var titulo : String?
    private var texto : String?
    private var fecha : String?
    private var data : Dictionary<String, AnyObject>?
    private var ref: String?
    private var image : UIImage?
    
    
    
    init (datos:Dictionary<String, AnyObject>,ref: FIRDatabaseReference?){
        
        self.ref = ref?.key
        self.titulo = datos["titulo"] as! String?
        self.texto = datos["texto"] as! String?
        self.fecha = datos["fecha"] as! String?
        
        self.data = [
            "titulo":self.titulo as AnyObject,
            "texto":self.texto as AnyObject,
            "fecha":self.fecha as AnyObject
        ]
     
    }
    
    
    
    var getData : Dictionary<String, AnyObject>{
        get{
            return self.data!
        }
    }

    
    var Texto : String{
        get{
            return self.texto!
        }
        
        set(newTexto){
            self.texto = newTexto
        }
    }
    
    
    var Image : UIImage{
        get{
            return self.image!
        }
        
        set(newImage){
            self.image = newImage
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

       
    
    
    
    
    
}
