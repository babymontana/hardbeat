//
//  SignUpViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 03/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import HealthKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nombre: UITextField!
    
    @IBOutlet weak var correo: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    let healthStore:HKHealthStore = HKHealthStore()
    
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    
    var edad = "Edad no disponible"
    var altura = "Altura no disponible"
    var sexo = "Sexo no disponible"
    var peso = "Peso no disponible"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        solicitarPermisos()
        obtenerDatos()
        ref = FIRDatabase.database().reference()
        
           }
   
    @IBAction func registrar(_ sender: Any) {
    
    if password.text == confirmPassword.text{
        if correo.text == "" || password.text == "" || nombre.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Porfavor escribe en todos los campos", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: correo.text!, password: password.text!) { (user, error) in
                
                if error == nil {
                    let newUser = Usuario(nombre: self.nombre.text!, peso: self.peso, altura: self.altura, edad: self.edad,sexo: self.sexo)
                     self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(newUser.getData)

                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }else{
        let alertController = UIAlertController(title: "Error", message: "Las contraseñas no coinciden", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        }
 
    
 
    
}
   
    @IBAction func next(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func editando(_ sender: Any) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    @IBAction func finEditando(_ sender: Any) {
        animateViewMoving(up:false, moveValue: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        
        view.endEditing(true)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func solicitarPermisos() {

        if HKHealthStore.isHealthDataAvailable() {
            
            let lectura = Set([
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
                ])
            
            healthStore.requestAuthorization(toShare: nil, read: lectura) { (success, error) -> Void in
                if success == false {
                    print("Permisos no entregados")
                }
            }
            
        }
    }
    
    func obtenerDatos() {
 
        do {
            let fecha = try healthStore.dateOfBirth()
            let units: Set<Calendar.Component> = [.year,.month]
            let calendar = Calendar.current.dateComponents(units, from: fecha)
            let calendar2 = Calendar.current.dateComponents(units, from: NSDate() as Date)
            var year = calendar2.year! - calendar.year!
            if calendar2.month! < calendar.month!{
                year-=1
            }
            self.edad = "\(year) años"
                if let biologicalSex =  try? healthStore.biologicalSex(){
                    switch biologicalSex.biologicalSex {
                    case .female:
                        self.sexo =  "Femenino"
                    case .male:
                       self.sexo = "Masculino"
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
                        self.altura = "\(valorAltura) m"
                    } else {
                        self.altura = "Altura No disponible"
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
                        
                        self.peso = "\(valorPeso) kg";
                    }
                    
                }
            }
            
           
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


}
