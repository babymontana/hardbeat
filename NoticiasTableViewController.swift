//
//  NoticiasTableViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 05/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class NoticiasTableViewController: UITableViewController {
    
    var items = [noticia]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        startObservingDatabase()
       

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticiaCell", for: indexPath) as! NoticiaTableViewCell
        let item = items[indexPath.row]
        cell.titulo?.text = item.Titulo
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://examen-1474333334103.appspot.com/")
        let imgRef = storageRef.child("noticias/"+item.Ref+"/image.png")
        imgRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
               print(error)
            } else {
               item.Image = UIImage(data: data!)!
               cell.img.image = item.Image
            }
        }
        
        return cell
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("noticias").observe(.value, with: { (snapshot) in
            var newItems = [noticia]()
            
            for itemSnapShot in snapshot.children {
                let item = noticia(datos: (itemSnapShot as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>,  ref: (itemSnapShot as! FIRDataSnapshot).ref )
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
           
            
        })
    }
    
        deinit {
            ref.child("noticias").removeObserver(withHandle: databaseHandle)
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noticiaInfoSegue" ,
            let nextScene = segue.destination as? NoticiaInfoViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedNoticia = items[indexPath.row]
            nextScene.noticia = selectedNoticia
        }
    }
    
    }
