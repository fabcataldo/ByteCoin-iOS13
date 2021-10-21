//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Fabio on 21/10/2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation
struct CoinModel: Decodable{
    let rate: Double
    let asset_id_base: String
    let asset_id_quote: String
    
    var rateString: String{
        return String(format: "%.1f", rate)
    }
    
}
