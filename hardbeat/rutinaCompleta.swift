//
//  rutinaCompleta.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 09/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class rutinaCompleta: ProtocolRutina{
    
    private var titulo : String?
    private var descripcion : String?
    private var fecha : String?
    private var tipo : String?
    private var duracion : String?
    private var data :Dictionary<String, AnyObject>?
    private var ref: String?
    private var icon : UIImage?
    private var caloriaConsumida:Double?
    private var fechaFin: String?
    private var fechaInicio: String?
    private var frecuenciaMaxima: Double?
    private var frecuenciaMinima: Double?
    private var promedioFrecuencia: Double?
    
     init (datos:Dictionary<String, AnyObject>){
        self.titulo = datos["titulo"] as! String?
        self.descripcion = datos["descripcion"]  as! String?
        self.fecha = datos["fecha"]  as! String?
        self.tipo = datos["tipo"]  as! String?
        self.duracion = datos["duracion"]  as! String?
        self.ref = datos["ref"]  as! String?
        self.caloriaConsumida = datos["caloriaConsumida"]  as! Double?
        self.fechaFin = datos["fechaFin"]  as! String?
        self.fechaInicio = datos["fechaInicio"]  as! String?
        self.frecuenciaMaxima = datos["frecuenciaMaxima"]  as! Double?
        self.frecuenciaMinima = datos["frecuenciaMinima"]  as! Double?
        self.promedioFrecuencia = datos["promedioFrecuencia"]  as! Double?
        
        self.data = datos
        self.icon = UIImage(named: self.tipo!)
        
        
    }
    
    internal var DownCast: rutinaCompleta{
        get{
            return self
        }
        
    }
    
    
    internal var getData : Dictionary<String, AnyObject>{
        get{
            return self.data!
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
    var Descripcion : String{
        get{
            return self.descripcion!
        }
        
        set(newDescripcion){
            self.descripcion = newDescripcion
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
    var Icon : UIImage{
        get{
            return self.icon!
        }
        
        set(newIcon){
            self.icon = newIcon
        }
    }
    var CaloriaConsumida : Double{
        get{
            return self.caloriaConsumida!
        }
        
        set(newCaloriaConsumida){
            self.caloriaConsumida = newCaloriaConsumida
        }
    }
    var FechaFin : String{
        get{
            return self.fechaFin!
        }
        
        set(newFechaFin){
            self.fechaFin = newFechaFin
        }
    }
    var FechaInicio : String{
        get{
            return self.fechaInicio!
        }
        
        set(newFechaInicio){
            self.fechaInicio = newFechaInicio
        }
    }
    var FrecuenciaMaxima : Double{
        get{
            return self.frecuenciaMaxima!
        }
        
        set(newFrecuenciaMaxima){
            self.frecuenciaMaxima = newFrecuenciaMaxima
        }
    }
    var FrecuenciaMinima : Double{
        get{
            return self.frecuenciaMinima!
        }
        
        set(newFrecuenciaMinima){
            self.frecuenciaMinima = newFrecuenciaMinima
        }
    }
    var PromedioFrecuencia : Double{
        get{
            return self.promedioFrecuencia!
        }
        
        set(newPromedioFrecuencia){
            self.promedioFrecuencia = newPromedioFrecuencia
        }
    }
    

    
}
