//
//  meterInterfaceController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 08/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity




class meterInterfaceController: WKInterfaceController,HKWorkoutSessionDelegate,WCSessionDelegate {
    @IBOutlet var titulo: WKInterfaceLabel!
    @IBOutlet var tiempo: WKInterfaceTimer!
    @IBOutlet var calorias: WKInterfaceLabel!
    @IBOutlet var frecuencia: WKInterfaceLabel!
    @IBOutlet var boton: WKInterfaceButton!
    
    var datos : Dictionary<String, AnyObject> = [:]
    
    var sesion:HKWorkoutSession!
    var healthStore:HKHealthStore!
    var actividad :HKWorkoutActivityType!
    
    var workoutFechaInicio:NSDate!
    var workoutFechaFinal:NSDate!
    var energiaActual:HKQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0.0)
    var consultaActualCalorias:HKQuery?
    var muestrasCalorias = [HKQuantitySample]()
    var muestraCalorica = [Double]()
    
    var frecuenciaActual:HKQuantity = HKQuantity(unit:  HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: 0.0)
    var consultaActualFrecuencia:HKQuery?
    var muestrasFrecuencia = [HKQuantitySample]()
    var muestraFrecuencia = [Double]()
    var totalFrecuencia : Double = 0.0
    var minFrecuencia : Double = 100.0
    var maxFrecuencia : Double = 0.0
    
    let defaults:UserDefaults = UserDefaults.standard
    
    var iniciado : Bool = false
    var session : WCSession!
    
    override func awake(withContext context: Any?) {
        self.datos=context as! Dictionary<String, AnyObject>
        titulo.setText(self.datos["titulo"] as! String?)
        let sharedDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        healthStore = sharedDelegate.healthStore
        calorias.setText("0.0 Kcal:")
        frecuencia.setText("0.0 Lpm")
       
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        

       
    }

    override func willActivate() {
        super.willActivate()
        
           }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    @IBAction func accion() {
        
        if iniciado {
            boton.setTitle("Iniciar")
            iniciado = false
            tiempo.stop()
            healthStore.end(sesion)
        }else{
            boton.setTitle("Detener")
            iniciado = true
            
            tiempo.setDate(NSDate() as Date)
            tiempo.start()
            
            reiniciarParametros()
            
            let type = datos["tipo"] as! String
            
            switch type{
            case "crossTraining":
                self.actividad = .crossTraining
            case "cycling":
                self.actividad = .cycling
            case "dance":
                self.actividad = .dance
            case "elliptical":
                self.actividad = .elliptical
            case "gymnastics":
                self.actividad = .gymnastics
            case "mindAndBody":
                self.actividad = .mindAndBody
            case "mixedMetabolicCardioTraining":
                self.actividad = .mixedMetabolicCardioTraining
            case "preparationAndRecovery":
                self.actividad = .preparationAndRecovery
            case "running":
                self.actividad = .running
            case "swimming":
                self.actividad = .swimming
            case "traditionalStrengthTraining":
                self.actividad = .traditionalStrengthTraining
            case "walking":
                self.actividad = .walking
            case "waterFitness":
                self.actividad = .waterFitness
            case "yoga":
                self.actividad = .yoga
            case "other":
                self.actividad = .other
            case "barre":
                self.actividad = .barre 
            case "coreTraining":
                self.actividad = .coreTraining 
            case "flexibility":
                self.actividad = .flexibility 
            case "highIntensityIntervalTraining":
                self.actividad = .highIntensityIntervalTraining
            case "jumpRope":
                self.actividad = .jumpRope 
            case "pilates":
                self.actividad = .pilates 
            case "stairs":
                self.actividad = .stairs 
            case "stepTraining":
                self.actividad = .stepTraining 
                
            default:
                self.actividad = .other

            }
            
            sesion = HKWorkoutSession(activityType:.running, locationType:.indoor)
            sesion.delegate = self
            healthStore.start(sesion)
        }
    
    }
    
    func reiniciarParametros() {
        energiaActual = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0.0)
        consultaActualCalorias = nil
        muestrasCalorias = []
        
        calorias.setText("Calorias:")
        
        
        frecuenciaActual = HKQuantity(unit:  HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: 0.0)
        consultaActualFrecuencia=nil
        muestrasFrecuencia = []
        totalFrecuencia = 0.0
        minFrecuencia = 0.0
        maxFrecuencia = 0.0
        frecuencia.setText("Frecuencia:")
    }
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func iniciarWorkout(fecha:NSDate) {
        workoutFechaInicio = fecha
        
        guard let caloriasType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else { return }
        
        guard let frecuenciaType : HKSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return }
        
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutFechaInicio as Date?, end: nil)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let procesarCalorias = { [unowned self] (samples: [HKQuantitySample]) -> Void in
            DispatchQueue.main.async { [unowned self] in
                
                let energiaInicial = self.energiaActual.doubleValue(for: HKUnit.kilocalorie())
                
                let processedResults: (Double, [HKQuantitySample]) = samples.reduce((energiaInicial, [])) { current, sample in
                    let accumulatedValue = current.0 + sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                    self.muestraCalorica.append(current.0)
                    let ourSample = HKQuantitySample(type: caloriasType, quantity: sample.quantity, start: sample.startDate, end: sample.endDate)
                    
                    return (accumulatedValue, current.1 + [ourSample])
                }
                
                self.energiaActual = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: processedResults.0)
                
                self.calorias.setText(String(format:"%0.2f Kcal", arguments:[processedResults.0]))
                
                self.muestrasCalorias += processedResults.1
            }
        }
        
        
        let consultaEnergia = HKAnchoredObjectQuery(type: caloriasType,predicate: predicate,anchor: nil,limit: Int(HKObjectQueryNoLimit),resultsHandler: { (query, newSamples, deletedSamples, newAnchor, error) in
            
            if let error = error {
                print("Ocurrió un error obteniendo las calorías: \(error.localizedDescription)")
                return
            }
            
            guard let nuevasMuestras = newSamples as? [HKQuantitySample] else { return }
            
            procesarCalorias(nuevasMuestras)
        })
        
        consultaEnergia.updateHandler = {
            (query, samples, deletedObject, ancho, error) in
            
            if let error = error {
                print("Ocurrió un error obteniendo las calorías: \(error.localizedDescription)")
                return
            }
            
            guard let nuevasMuestras = samples as? [HKQuantitySample] else { return }
            
            procesarCalorias(nuevasMuestras)
        }
        
        healthStore.execute(consultaEnergia)
        consultaActualCalorias = consultaEnergia
        
        let procesarFrecuencia = { [unowned self] (samples: [HKQuantitySample]) -> Void in
            DispatchQueue.main.async { [unowned self] in
                if samples.count > 0 {
                    self.frecuenciaActual = samples[0].quantity
                    self.totalFrecuencia += self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    self.muestrasFrecuencia += samples
                    self.frecuencia.setText("\(self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))) Lpm")
                    
                    self.muestraFrecuencia.append(self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())));
                    
                    if self.minFrecuencia > self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) && self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))>40.0{
                        self.minFrecuencia = self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    }
                    
                    if self.maxFrecuencia < self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())){
                        self.maxFrecuencia = self.frecuenciaActual.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    }
                    
                    
                    
                }
            }
        }
        
        let consultaFrecuencia = HKAnchoredObjectQuery(type: frecuenciaType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { query, samples, deletedObjects, anchor, error in
            if let error = error {
                print("Ocurrió un error obteniendo los pasos: \(error.localizedDescription)")
                return
            }
            
            guard let nuevasMuestras = samples as? [HKQuantitySample] else { return }
            procesarFrecuencia(nuevasMuestras)
        }
       
        consultaFrecuencia.updateHandler = {
            (query, samples, deletedObject, ancho, error) in
            
            if let error = error {
                print("Ocurrió un error obteniendo las calorías: \(error.localizedDescription)")
                return
            }
            
            guard let nuevasMuestrasFrec = samples as? [HKQuantitySample] else { return }
            
            procesarFrecuencia(nuevasMuestrasFrec)
        }
        
        healthStore.execute(consultaFrecuencia)
        consultaActualFrecuencia = consultaFrecuencia
 
    }
    
    func finalizarWorkout(fechaFinal:NSDate) {
        workoutFechaFinal = fechaFinal
        
        if let consultaCalorias = consultaActualCalorias {
            healthStore.stop(consultaCalorias)
        }
        
        if let consultaFrecuencia = consultaActualFrecuencia {
            healthStore.stop(consultaFrecuencia)
        }
        
        let promedioFrecuencia = self.totalFrecuencia/Double(self.muestrasFrecuencia.count)
        
        let energiaConsumida = self.energiaActual.doubleValue(for: HKUnit.kilocalorie())
        
        let date = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
        
       
        
            self.datos["fechaInicio"]=dateFormatter.string(from: workoutFechaInicio as Date) as AnyObject?
            self.datos["fechaFin"]=dateFormatter.string(from: workoutFechaFinal as Date) as AnyObject?
            self.datos["promedioFrecuencia"]=promedioFrecuencia as AnyObject?
            self.datos["frecuenciaMinima"]=minFrecuencia as AnyObject?
            self.datos["frecuenciaMaxima"]=maxFrecuencia as AnyObject?
            self.datos["caloriaConsumida"] = energiaConsumida as AnyObject?
            self.datos["frecuencias"]=muestraFrecuencia as AnyObject?
            self.datos["calorias"]=muestraCalorica as AnyObject?
            
     
        
        let rutinafinalizada = ["altaRutina":self.datos]
        session.sendMessage(rutinafinalizada, replyHandler: { replyMessage in
            //handle and present the message on screen
            let confirmacion = (replyMessage["confirmacion"] as! String?)!
            if confirmacion == "ok"{
                let mensaje:String = "Se han guardado los datos"
                let alerta:WKAlertAction = WKAlertAction(title: "Cerrar", style: .destructive, handler:{
                    
                    self.reiniciarParametros()
                    self.pushController(withName: "interfaceController",context : nil)
                    
                })
                
                WKExtension.shared().rootInterfaceController?.presentAlert(withTitle: "Ejercicio completado",message: mensaje, preferredStyle:WKAlertControllerStyle.alert,actions:[alerta])
                
           
            }
            
            
        }, errorHandler: {error in
            // catch any errors here
            print(error)
        })

        
        
        
    }
    
    
    // MARK: WorkoutSession Delegate
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
        switch toState {
        case .notStarted:
            print("Sesión no iniciada")
        case .ended:
            finalizarWorkout(fechaFinal: date as NSDate)
        default : iniciarWorkout(fecha: date as NSDate)
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Error \(error)")
    }
    

}
