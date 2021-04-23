//
//  SettingsViewModel.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation
import Combine
import UIKit

class SettingsViewModel: ObservableObject {
    
    @Published var activeAlert: ActiveAlert?
    
    public var appVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    public func twitterTapped() {
        let application = UIApplication.shared
        let appURL = URL(string: "twitter://user?screen_name=podomunro")!
        let webURL = URL(string: "https://twitter.com/podomunro")!
               
        application.canOpenURL(appURL) ? application.open(appURL) : application.open(webURL)
    }
    
    public func openUrl(_ urlString: String) {
        UIApplication.shared.open(URL(string: urlString)!)
    }
    
    public func rateUsTapped() {
        let appId = "1530697608"
        let urlStr = "https://itunes.apple.com/app/id\(appId)?action=write-review"

        guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public func tipDeveloper() {
        TNTProducts.store.requestProducts { success, products in
            guard success, let product = products?.first else {
                print("couldn't request products")
                return
            }
            
            TNTProducts.store.buyProduct(product) { success, _ in
                guard success else {
                    print("couldn't purchase product")
                    return
                }
                
                self.activeAlert = .thankYou
            }
        }
    }
    
    enum ActiveAlert { case thankYou }
}
