//
//  graficasViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 10/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase

class graficasViewController: UIViewController {

    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    var key : String?
    var caloriasData = [Double]()
    var frecuenciasData = [Double]()
    
   
    @IBOutlet weak var estadisticas: LineChartView!
    
    @IBOutlet weak var calorias: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = FIRDatabase.database().reference()
        databaseHandle = self.ref.child("rutinas").child((FIRAuth.auth()?.currentUser?.uid)!).child("completas").child(key!).child("calorias").observe(.value, with: { (snapshot) in
            var dataCaloriasEntries: [BarChartDataEntry] = []
            self.caloriasData = snapshot.value as! [Double]
            var i=0
            for cal in self.caloriasData{
                let dataEntry = BarChartDataEntry(x: Double(i), y: cal)
                dataCaloriasEntries.append(dataEntry)
                i+=1
            }
            
            let caloriasChartDataSet = LineChartDataSet(values: dataCaloriasEntries, label: "Calorias Quemadas")
            caloriasChartDataSet.circleColors = [UIColor(red: 0.8, green: 0, blue: 0.34, alpha: 1.0)]
            let caloriasChartData = LineChartData(dataSet: caloriasChartDataSet)
            self.calorias.data = caloriasChartData
            self.calorias.animate(xAxisDuration: 0.8)
            
          

            
        })

        
        databaseHandle = self.ref.child("rutinas").child((FIRAuth.auth()?.currentUser?.uid)!).child("completas").child(key!).child("frecuencias").observe(.value, with: { (snapshot) in
            self.frecuenciasData = snapshot.value as! [Double]
            var dataFrecuenciasEntries: [BarChartDataEntry] = []
            var i=0
            for frec in self.frecuenciasData{
                let dataEntry = BarChartDataEntry(x: Double(i), y: frec)
                dataFrecuenciasEntries.append(dataEntry)
                i+=1
            }
            
            let frecuenciasChartDataSet = LineChartDataSet(values: dataFrecuenciasEntries, label: "Frecuencia cardiaca")
            frecuenciasChartDataSet.circleColors = [UIColor(red: 0.8, green: 0, blue: 0.34, alpha: 1.0)]
            let frecuenciaChartData = LineChartData(dataSet: frecuenciasChartDataSet)
            self.estadisticas.data = frecuenciaChartData
            self.estadisticas.animate(xAxisDuration: 0.8)
            
            
        })
        
        
        
        
    


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      

    

}
