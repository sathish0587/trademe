//
//  ListingDetailsViewController.swift
//  Trademe
//
//  Created by Sathish Kumar on 11/03/20.
//  Copyright © 2020 Sathish Kumar. All rights reserved.
//

import UIKit

class ListingDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listingIDLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    var listingID: String = ""
    var listingDetailsModel = ListingDetailsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Details"
        self.callGetListingDetailsAPI()
        // Do any additional setup after loading the view.
    }
    func callGetListingDetailsAPI() {
        self.showActivityIndicator()
        APIManager.sharedInstance.getListingDetails(listingID: listingID, onSuccess: { [weak self] ListingDetailsModel in
            self?.listingDetailsModel = ListingDetailsModel
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
                self?.updateUI()
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
    func updateUI() {
        self.titleLabel.text = String(format:"Product Name: %@", self.listingDetailsModel.title ?? "")
        self.listingIDLabel.text = String(format:"Product ID: %@",self.listingDetailsModel.listingId ?? "")
        self.categoryLabel.text = String(format:"Product Category: %@",self.listingDetailsModel.categoryName ?? "")
        self.regionLabel.text = String(format:"Product Region: %@",self.listingDetailsModel.region ?? "")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
