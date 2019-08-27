//
//  PlaceController.swift
//  mapsView
//
//  Created by opah on 05/06/2019.
//  Copyright © 2019 Mariana Ribeiro. All rights reserved.
//

import Foundation
import MapKit

struct PalceController: Codable {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //esse metodo vai devolver uma string que eh o endereco formatado
    static func getFormatted(with placemark: CLPlacemark) -> String {
        var address = ""
        //recuperando o nome da rua caso tenha atravez do placemark
        if let street = placemark.thoroughfare {
            address += street //colocando a rua
        }
        if let number = placemark.subThoroughfare{
            address += " \(number)" //colocando o numero
        }
        if let subLocality = placemark.subLocality{
            address += ", \(subLocality)" //colocando o bairro
        }
        if let city = placemark.locality {
            address += "\n\(city)" //cidade
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)" //estado
        }
        if let postalCode = placemark.postalCode{
            address += "\nCEP: \(postalCode)" //cep
        }
        if let country = placemark.country{
            address += "\n\(country)" //pais
        }
        return address
    }
}

extension PalceController: Equatable{
    static func ==(lhs: PalceController, rhs: PalceController) -> Bool{
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }    
}
