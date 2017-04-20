//
//  NoticiaInfoViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 06/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit

class NoticiaInfoViewController: UIViewController {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UITextView!
    
    var noticia : noticia!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagen.image = noticia.Image
        self.fecha.text = noticia.Fecha
        self.titulo.text = noticia.Titulo
        self.texto.text = noticia.Texto
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
