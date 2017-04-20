//
//  usuario.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 03/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Usuario{
    
    
    private var nombre: String?
    private var peso : String?
    private var altura : String?
    private var edad : String?
    private var sexo : String?
    private var data : Dictionary<String, AnyObject>
 
    
    
    convenience init(datos:Dictionary<String, AnyObject>){
        self.init(nombre: datos["nombre"]! as! String,peso: datos["peso"]! as! String,altura: datos["altura"]! as! String, edad: datos["edad"]! as! String,sexo: datos["sexo"]! as! String,datos: datos)
       
    }

    convenience init(nombre:String , peso:String, altura:String, edad:String,sexo:String){
        self.init(nombre: nombre,peso: peso,altura: altura, edad: edad,sexo: sexo,datos:[:])
        
    }

    
    init(nombre:String , peso:String, altura:String, edad:String,sexo:String,datos:Dictionary<String, AnyObject>){
        
        self.nombre = nombre
        self.peso = peso
        self.altura = altura
        self.edad = edad
        self.sexo = sexo
        
            self.data = [
                "nombre":self.nombre as AnyObject,
                "peso":self.peso   as AnyObject,
                "altura":self.altura as AnyObject,
                "edad":self.edad as AnyObject,
                "sexo":self.sexo as AnyObject,
            ]
        
    }
    
    
    
    var getData : Dictionary<String, AnyObject>{
        get{
          return self.data
        }
    }
    
    var Nombre : String{
        get{
            return self.nombre!
        }
        
        set(newNombre){
            self.nombre = newNombre
        }
    }
    
    var Peso : String{
        get{
            return self.peso!
        }
        
        set(newPeso){
            self.peso = newPeso
        }
    }
    var Altura : String{
        get{
            return self.altura!
        }
        
        set(newAltura){
            self.altura = newAltura
        }
    }
    var Edad : String{
        get{
            return self.edad!
        }
        
        set(newEdad){
            self.edad = newEdad
        }
    }
    var Sexo : String{
        get{
            return self.sexo!
        }
        
        set(newSexo){
            self.sexo = newSexo
        }
    }
   
  
    
}
