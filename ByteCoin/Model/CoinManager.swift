//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoin(coin: CoinModel)
    func didFailedWithError(error:Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "619A50A9-7CE5-48C7-B841-C76031F28596"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        fetchCoinRate(coin: currency)
    }
    
    func fetchCoinRate(coin: String) {
        let urlString = "\(baseURL)BTC/\(coin)?apiKey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailedWithError(error: error as! Error)
                    return
                }
                
                if let safeData = data{
                    if let coin = self.parseJson(data!){
                        self.delegate?.didUpdateCoin(coin: coin)
                    }
                    
                }
            }
            
            //            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            task.resume()
        }
    }
    
    func parseJson(_ coinData: Data)-> CoinModel?{
        let decoder = JSONDecoder()
        
//        lo de abajo: .decode(type: tipo decodeable, y from: data a decodear)
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: coinData)
            
            let rate = decodedData.rate
            let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            
            let coin = CoinModel(rate: rate, asset_id_base: asset_id_base, asset_id_quote: asset_id_quote)
            return coin
        } catch {
            delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
}
