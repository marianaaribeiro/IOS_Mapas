//
//  PlaceFinderViewController.swift
//  mapsView
//
//  Created by opah on 22/05/2019.
//  Copyright © 2019 Mariana Ribeiro. All rights reserved.
//

import UIKit
import MapKit

    protocol PlaceFinderDelegate: class {
        func addPlace(_ place: PalceController)
    }

class PlaceFinderViewController: UIViewController {

   
    enum PlaceFinderMessage {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    var Place: PalceController!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
        
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began{
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                self.load(show: false)
                //recuperar o local de acordo do valor digitado pelo usuario
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.menssage(type: .error("Nāo foi encontrado nenhum local com esse nome."))
                    }
                } else {
                    self.menssage(type: .error("Erro desconhecido."))
                }
            }
        }
    }

    @IBAction func findCity(_ sender: UIButton) {
        //teclado sendo fechado
        tfCity.resignFirstResponder()
        
        //recuperando o valor do campo de texto
        let address = tfCity.text!
        
        //chamando o loading
        load(show: true)
        
        //transformar o endereco em coordenadas
        let geoCoder = CLGeocoder()
        //cria uma array onde vai constar o endereco
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            //depois de pesquisado e conferido o endereco, eh hora de mostrar e parar o loading
            self.load(show: false)
            //recuperar o local de acordo do valor digitado pelo usuario
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                   self.menssage(type: .error("Nāo foi encontrado nenhum local com esse nome."))
                }
            } else {
                self.menssage(type: .error("Erro desconhecido."))
            }
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        //criando a variavel e gerar as coordenadas apartir do placemark
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else{
            return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = String(describing: Place)
        Place = PalceController( name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        //exibindo no mapa
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        mapView.setRegion(region, animated: true)
        self.menssage(type: .confirmation(Place.name))
        return true
    }
    
    func menssage(type: PlaceFinderMessage){
        let title: String, message: String
        var hasConfirmation : Bool = false
        
        switch type {
        case .confirmation(let name):
            title = "Local encontrado com sucesso"
            message = "Deseja Procurar no mapa o local: \(name)"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Atenção"
            message = errorMessage
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAlert)
        
        if hasConfirmation {
            let confirmAlert = UIAlertAction(title: "OK", style: .default, handler: {(action) in
                self.delegate?.addPlace(self.Place)
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(confirmAlert)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func load(show: Bool){
        //se nao for para exibir, entao nao exiba
        viLoading.isHidden = !show
        //se eh para mostrar entao inicie animando
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
