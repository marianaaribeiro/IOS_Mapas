//
//  PlacesTableViewController.swift
//  mapsView
//
//  Created by opah on 22/05/2019.
//  Copyright © 2019 Mariana Ribeiro. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    var Place: [PalceController] = []
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadPlace()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! != "mapSegue"{
            let vc = segue.destination as! PlaceFinderViewController
            vc.delegate = self
        }
    }

    func loadPlace(){
        if let placesData = ud.data(forKey: "placesKey"){
            do{
                let decoderPlace = JSONDecoder()
                Place = try JSONDecoder().decode([PalceController].self, from: placesData)
                
                tableView.reloadData()
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    func savePlace(){
     let json = try? JSONEncoder().encode(Place)
     ud.set(json, forKey: "placesKey")
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Place.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let place = Place[indexPath.row]
        cell.textLabel?.text = place.name

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PlacesTableViewController: PlaceFinderDelegate{
    func addPlace(_ place: PalceController) {
        if !Place.contains(place){
         Place.append(place)
            savePlace()
         tableView.reloadData()
        }
    }
}

