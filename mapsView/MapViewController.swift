//
//  mapViewController.swift
//  mapsView
//
//  Created by opah on 22/05/2019.
//  Copyright © 2019 Mariana Ribeiro. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var SeachBas: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var uiInfo: UIView!
    @IBOutlet weak var ibNome: UILabel!
    @IBOutlet weak var ibAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showRoute(_ sender: UIButton) {
    }
    

    @IBAction func showSeach(_ sender: UIBarButtonItem) {
    }
}
