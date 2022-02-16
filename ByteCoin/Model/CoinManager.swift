//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "BB70DA75-0879-4E04-8BC1-A5810054CDE5"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performTask(with: urlString)
        
    }
    func performTask(with urlString:String){
        if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: .default)
            let  task = urlSession.dataTask(with: url, completionHandler: { data, response, error in
                if error != nil{
                    print("error")
                }
                if let safeData = data {
                    if let coindata = parseJSON(data: safeData){
                        delegate?.didUpdateRate(self, coinData: coindata)}
                }
            })
            task.resume()
        }
    }
    func parseJSON(data: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do{ let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            let coinData = CoinData(rate: rate)
            return coinData
        }
        catch{
            delegate?.didHandleErrors(error)
            return nil
        }
    }
}
protocol CoinManagerDelegate {
    func didHandleErrors(_ error: Error)
    func didUpdateRate(_ coinmanager: CoinManager,coinData: CoinData)
}
