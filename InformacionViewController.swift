//
//  InformacionViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 03/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import HealthKit

class InformacionViewController: UIViewController {
    
    @IBOutlet weak var sexo: UILabel!
    @IBOutlet weak var peso: UILabel!
    @IBOutlet weak var altura: UILabel!
    @IBOutlet weak var edad: UILabel!
    @IBOutlet weak var nombre: UILabel!
    
    let healthStore:HKHealthStore = HKHealthStore()
    var usuario:Usuario!
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //solicitarPermisos()
        ref = FIRDatabase.database().reference()
        obtenerDatos()


    }
    
    @IBAction func actualizar(_ sender: Any) {
        solicitarPermisos()
        obtenerDatosMedicos()
        
        
    }
    
    func solicitarPermisos() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let lectura = Set([
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
                ])
            
            healthStore.requestAuthorization(toShare: nil, read: lectura) { (success, error) -> Void in
                if success == false {
                    print("Permisos no entregados")
                }
            }
            
        }
    }

    
    func obtenerDatos(){
        databaseHandle = self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: { (snapshot) in
            self.usuario = Usuario(datos:snapshot.value as! Dictionary<String, AnyObject>)
            self.peso.text = self.usuario.Peso
            self.altura.text = self.usuario.Altura
            self.edad.text = self.usuario.Edad
            self.nombre.text = self.usuario.Nombre
            self.sexo.text = self.usuario.Sexo
        })

    }
    
    func obtenerDatosMedicos() {
        
        do {
            let fecha = try healthStore.dateOfBirth()
            let units: Set<Calendar.Component> = [.year,.month]
            let calendar = Calendar.current.dateComponents(units, from: fecha)
            let calendar2 = Calendar.current.dateComponents(units, from: NSDate() as Date)
            var year = calendar2.year! - calendar.year!
            if calendar2.month! < calendar.month!{
                year-=1
            }
            self.edad.text = "\(year) años"
            if let biologicalSex =  try? healthStore.biologicalSex(){
                switch biologicalSex.biologicalSex {
                case .female:
                    self.sexo.text =  "Femenino"
                case .male:
                    self.sexo.text = "Masculino"
                default: break
                    
                }
            }
            
            if let tipoAltura:HKSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) {
                
                self.obtenerUltimaMuestra(tipo: tipoAltura, resultado: { (altura:HKSample?, error:NSError?) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let muestraAltura = altura as? HKQuantitySample {
                        let valorAltura = muestraAltura.quantity.doubleValue(for: HKUnit.meter())
                        self.altura.text = "\(valorAltura) m"
                    } else {
                        self.altura.text = "Altura No disponible"
                    }
                })
            }
            
            if let tipoPeso:HKSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) {
                self.obtenerUltimaMuestra(tipo: tipoPeso) { (peso:HKSample?, error:NSError?) in
                    if error != nil {
                        print("Error al obtener peso")
                        return
                    }
                    
                    if let muestraPeso = peso as? HKQuantitySample {
                        let valorPeso = muestraPeso.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                        
                        self.peso.text = "\(valorPeso) kg";
                    }
                    
                }
            }
            
            //Actualizamos Firebase
            self.usuario = Usuario(nombre: self.nombre.text!, peso: self.peso.text!, altura: self.altura.text!, edad: self.edad.text!,sexo: self.sexo.text!)
            self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(usuario.getData)
            let alertController = UIAlertController(title: "Datos actualizados", message: "Tus datos han sido actualizados", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func obtenerUltimaMuestra(tipo:HKSampleType , resultado: ((HKSample?, NSError?) -> Void)!){
        
        let desde = NSDate.distantPast
        let ahora = NSDate()
        let predicado = HKQuery.predicateForSamples(withStart: desde, end:ahora as Date, options: [])
        
        let ordenDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        
        let consultaMuestras = HKSampleQuery(sampleType: tipo, predicate: predicado, limit: 1, sortDescriptors: [ordenDescriptor])
        {(consulta, resultados, error) -> Void  in
            
            let muestraReciente = resultados?.first as? HKQuantitySample
            
            if resultado != nil {
                resultado(muestraReciente, nil)
            }
        }
        
        self.healthStore.execute(consultaMuestras)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
