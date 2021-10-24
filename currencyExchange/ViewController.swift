//
//  ViewController.swift
//  currencyExchange
//
//  Created by Phoebe Hu on 10/23/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   


    @IBOutlet weak var inputNum: UITextField!
    
    @IBOutlet weak var fromPickerView: UIPickerView!
    
    @IBOutlet weak var toPickerView: UIPickerView!
    
    @IBOutlet weak var resNum: UILabel!
    
    var currencyCode: [String] = [];
    var values: [Double] = []
    var activeCurrency = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fromPickerView.delegate = self;
        fromPickerView.dataSource = self;
        
        toPickerView.delegate = self;
        toPickerView.dataSource = self;
        fetchJson()
        inputNum.addTarget(self, action: #selector(updateViews), for: .editingChanged)
    }
    
    @objc func updateViews(input: Double){
        guard let amountText = inputNum.text, let theAmountText = Double(amountText) else {return}
        if inputNum.text != "" {
            let total = theAmountText * activeCurrency;
            resNum.text = String(format: "%.2f", total);
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
    }
    
    
    func fetchJson(){
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else {return}
        URLSession.shared.dataTask(with: url) {
            (data, responds, error) in
            
            //handle error if any
            if error != nil {
                print(error!)
                return
            }
            guard let safeData = data else {return}
            
            //decode
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                print(results.rates)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
            } catch{
                print(error)
            }
        }.resume()
    }



}

