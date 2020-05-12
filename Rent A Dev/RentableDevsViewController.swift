//
//  RentableDevsViewController.swift
//  Rent A Dev
//
//  Created by Dharmendra Valiya on 05/12/20.
//  Copyright © 2020 Dharmendra Valiya All rights reserved.
//

import UIKit

enum DeveloperDisplay : Int
{
    case allDevelopers
    case favoriteDevelopers
}

class RentableDevsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesToggle: UISegmentedControl!
    let developers : [Developer] = DevDataManager.loadDevelopers()
    fileprivate var favoriteDevelopers : [Developer] {
        return developers.filter { $0.isFavorite == true }
    }
    fileprivate let CELL_ID = "Cell"
    fileprivate var showAllDevelopers = true
    
    //MARK: View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.rowHeight = 120
        beginFakeDataLoad {
            self.tableView.isHidden = false
        }
//        beginFakeDataLoad {
//            self.tableView.alpha = 0
//            self.tableView.isHidden = false
//            UIView.animate(withDuration:1, animations: { void in
//                self.tableView.alpha = 1.0
//            })
//        }
        
        self.registerController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        super.traitCollectionDidChange(previousTraitCollection)
        self.registerController()
    }
    
    //MARK: Registering
    private func registerController()
    {
        // Check for force touch feature, and add force touch/previewing capability.
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    //MARK: Tableview Datasource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.showAllDevelopers ? developers.count : favoriteDevelopers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        if let devCell = cell as? DeveloperTableViewCell
        {
            let currentDeveoper = self.showAllDevelopers ? developers[(indexPath as NSIndexPath).row] : favoriteDevelopers[(indexPath as NSIndexPath).row]
            devCell.bindData(with: currentDeveoper)
        }
        
        return cell
    }
    
    //MARK: Segment Toggle
    @IBAction func segmentChanged(_ sender: UISegmentedControl)
    {
        showAllDevelopers = favoritesToggle.selectedSegmentIndex == DeveloperDisplay.allDevelopers.rawValue
        tableView.reloadData()
    }
    
    func showFavoriteDevelopers()
    {
        favoritesToggle.selectedSegmentIndex = DeveloperDisplay.favoriteDevelopers.rawValue
        showAllDevelopers = false
        tableView.reloadData()
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let devDetailViewController = segue.destination as? DeveloperDetailViewController, let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            devDetailViewController.developer = developers[(selectedIndexPath as NSIndexPath).row]
            tableView.cellForRow(at: selectedIndexPath)?.setSelected(false, animated: true)
        }
    }
}

