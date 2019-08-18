//
//  SecondViewController.swift
//  CodableJSON
//
//  Created by Apple on 17/08/19.
//  Copyright © 2019 Revolut. All rights reserved.
//

import UIKit

// MARK: - Welcome
struct Welcome: Codable {
    let status: Bool
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let schools: [School]
    let team: [Team]
    let players: [Player]
    let games: [Game]
}

// MARK: - Game
struct Game: Codable {
    let id: Int
    let name: String
}

// MARK: - Player
struct Player: Codable {
    let playerid, firstname: String
}

// MARK: - School
struct School: Codable {
    let id: Int
    let schoolName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case schoolName = "school_name"
    }
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let teamName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case teamName = "team_name"
    }
}

class SeconCustomCell: UITableViewCell {
    @IBOutlet weak var myCellLabel: UILabel!
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    var dataset = [Result]()
    
    // Tableview Data Load
    var filteredData = [School]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        print("OUTPUT: \(dataset[0].id)")
        
        self.tableView.rowHeight = 66.0
        self.loadJSON()
    }
    
    // MARK: JSON Data Load
    
    func loadJSON(){
        let urlPath = "URL"
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: url! as URL) { data, response, error in
            guard data != nil && error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                let decoder = try JSONDecoder().decode(Welcome.self,  from: data!)
                let status = decoder.status
                if status == true {
                    self.filteredData = decoder.data.schools // Here how to get values for tableview array load
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    
                }
            } catch { print(error) }
        }
        task.resume()
    }
    
    // MARK: Tableview Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SeconCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SeconCustomCell
        cell.myCellLabel.text = self.filteredData[indexPath.row].schoolName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
