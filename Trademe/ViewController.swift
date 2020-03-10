//
//  ViewController.swift
//  Trademe
//
//  Created by Sathish Kumar on 7/03/20.
//  Copyright © 2020 Sathish Kumar. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

}
extension UIViewController {
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        
        activityIndicator.tag = 100
        
        for subview in view.subviews {
            if subview.tag == 100 {
                print("already added")
                return
            }
        }
        view.addSubview(activityIndicator)
    }
    func hideActivityIndicator() {
        let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var categoryDataModel : [DataModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "trademe Categories"
        showActivityIndicator()
        
        APIManager.sharedInstance.getCategoryList(onSuccess: { [weak self] UserDataModel in
            self?.categoryDataModel = UserDataModel
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
                self?.tableView.reloadData()
            }
            }, onFailure: { error in
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
        
    }
    //MARK: Assign data
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "CategoryListViewSegue") {
            if let indexPath = tableView.indexPathForSelectedRow{
            let viewController:CategoryTableViewController = segue.destination as! CategoryTableViewController
                viewController.categoryNumber = self.categoryDataModel?[indexPath.row].id ?? ""
                viewController.categoryTitle = self.categoryDataModel?[indexPath.row].title ?? ""
            }
        }
    }
    //MARK: Tableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellData") as! CustomTableViewCell
        tableView.layer.cornerRadius = 10
        guard (self.categoryDataModel?[indexPath.row]) != nil else{
            return cell
        }
        cell.nameLabel?.text = self.categoryDataModel?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CategoryListViewSegue", sender: self)
    }


}

