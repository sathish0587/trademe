//
//  APIManager.swift
//  Trademe
//
//  Created by Sathish Kumar on 7/03/20.
//  Copyright © 2020 Sathish Kumar. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    var dataModelArray = [DataModel]()
    
    func getCategoryList(onSuccess: @escaping([DataModel]) -> Void, onFailure: @escaping(Error) -> Void){
        let baseURL = "https://api.tmsandbox.co.nz/v1/Categories/0.json"
        guard let url = URL(string:baseURL) else { return }
        let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in
            
            if error != nil {
                print("Client error!")
                onFailure(error!)
            }
            else{
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    let serviceError: NSError = NSError(domain: "", code: 400, userInfo: nil)
                    onFailure(serviceError)
                    print("Server error!")
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
//                    print(json as Any)
                    if let jsonDictionary = json as [String : Any]? {
                        if let results = jsonDictionary["Subcategories"] as? NSArray {
                            for dict in results {
                                let dataModel =  DataModel()
                                if let resultDict = dict as? NSDictionary {
                                    if let title = resultDict["Name"] as? String{
                                        dataModel.title = title
                                    }
                                    if let number = resultDict["Number"] as? String{
                                        dataModel.id = number
                                    }
                                }
                                self?.dataModelArray.append(dataModel)
                            }
                        }
                    }
                    onSuccess(self?.dataModelArray ?? [] )
                    
                } catch {
                    print("JSONSerialization error:", error)
                }
            }
        }
        task.resume()
    }
    
    func searchAPI(categoryID: String, onSuccess: @escaping([DataModel]) -> Void, onFailure: @escaping(Error) -> Void){
        let queryItems = [URLQueryItem(name: "category", value: categoryID)]
        let urlComps = NSURLComponents(string:"https://api.tmsandbox.co.nz/v1/Search/General.json")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        var request = URLRequest(url: url)
        request.setValue("OAuth oauth_consumer_key=\"BD3ADC476CA0B2A24874709ACEE004D2\",oauth_signature_method=\"PLAINTEXT\", oauth_signature=\"9E56645B4CE86664E762A1AA8136AD15&\"", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.dataModelArray.removeAll()

        let task = URLSession.shared.dataTask(with: request) {[weak self](data, response, error) in
            
            if error != nil {
                print("Client error!")
                onFailure(error!)
            }
            else{
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    let serviceError: NSError = NSError(domain: "", code: 400, userInfo: nil)
                    onFailure(serviceError)
                    print("Server error!")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
//                    print(json as Any)
                    if let jsonDictionary = json as [String : Any]? {
                        if let results = jsonDictionary["List"] as? NSArray {
                            var loopCount = 0
                            for dict in results {
                                loopCount += 1
                                if loopCount <= 20{
                                    let dataModel =  DataModel()
                                    if let resultDict = dict as? NSDictionary {
                                        if let title = resultDict["Title"] as? String{
                                            dataModel.title = title
                                        }
                                        if let number = resultDict["ListingId"] as? Int{
                                            dataModel.id = String(number)
                                        }
                                        if let thumbnail = resultDict["PictureHref"] as? String{
                                            dataModel.thumbnailUrl = thumbnail
                                        }
                                    }
                                    self?.dataModelArray.append(dataModel)
                                }
                            }
                        }
                    }
                    onSuccess(self?.dataModelArray ?? [] )
                    
                } catch {
                    print("JSONSerialization error:", error)
                }
            }
        }
        task.resume()
    }
}
