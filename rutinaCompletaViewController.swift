//
//  rutinaCompletaViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 09/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import MBCircularProgressBar

class rutinaCompletaViewController: UIViewController {
    @IBOutlet weak var titulo: UILabel!
 var rutina: rutinaCompleta!
    
    @IBOutlet weak var FreqMinChart: MBCircularProgressBarView!
  
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var duracion: UILabel!
    
    @IBOutlet weak var freqMin: UILabel!
    @IBOutlet weak var freqMax: UILabel!
    
    @IBOutlet weak var freqProm: UILabel!
    
    @IBOutlet weak var calorias: UILabel!

    @IBOutlet weak var descripcion: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
            self.icon.image = rutina.Icon
            self.titulo.text = rutina.Titulo
            self.freqMin.text =  String(format: "%.2f",rutina.FrecuenciaMinima)
            self.freqMax.text =  String(format: "%.2f",rutina.FrecuenciaMaxima)
            self.freqProm.text =  String(format: "%.2f",rutina.PromedioFrecuencia)
            self.calorias.text =  String(format: "%.2f",rutina.CaloriaConsumida)
            self.descripcion.text = rutina.Descripcion
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "estadisticasSegue" {
            let nextScene = segue.destination as? graficasViewController
            nextScene?.key = rutina.Ref
            
        }
    }

}
