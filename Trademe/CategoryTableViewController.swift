//
//  CategoryTableViewController.swift
//  Trademe
//
//  Created by Sathish Kumar on 8/03/20.
//  Copyright © 2020 Sathish Kumar. All rights reserved.
//

import UIKit

class CustomCategoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
}
class CategoryTableViewController: UITableViewController {
 
    var categoryNumber : String?
    var categoryTitle : String?

    var listingDataModel : [DataModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryTitle
        self.callSearchAPI()
    }
    
    func callSearchAPI() {
        self.showActivityIndicator()
        APIManager.sharedInstance.searchAPI(categoryID: categoryNumber ?? "", onSuccess: { [weak self] UserDataModel in
            self?.listingDataModel = UserDataModel
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
    
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        let imgURL: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: imgURL as URL)
        URLSession.shared.dataTask(with: request) {data, response, error in
            if (error == nil) {
                if let data = data {
                    DispatchQueue.main.async {
                        imageview.image = UIImage(data: data)
                    }
                }
            } else {
                print("Error");
            }
            }.resume();
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listingDataModel?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryList") as! CustomCategoryCell
        tableView.layer.cornerRadius = 10
        guard (self.listingDataModel?[indexPath.row]) != nil else{
            return cell
        }
        cell.titleLabel?.text = self.listingDataModel?[indexPath.row].title
        cell.idLabel?.text = self.listingDataModel?[indexPath.row].id
        if (self.listingDataModel?[indexPath.row].thumbnailUrl) != nil{
            self.load_image(urlString: self.listingDataModel?[indexPath.row].thumbnailUrl ?? "", imageview: cell.thumbnailImgView!, index: indexPath.row)
        }
        else{
            cell.thumbnailImgView.image = nil
        }

        return cell
    }
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alert = UIAlertController(title: "Thanks", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)    }

}
