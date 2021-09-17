//
//  ViewController.swift
//  section20
//
//  Created by alican on 16.09.2021.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var table: UITableView!
    
    var fileUrl : URL!
    
    var brands : [String] = []
    var _counter : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Data source verinin kaynağı ile ilgili fonksiyonları barındırıyor.
        table.dataSource = self
        
        // delegate de ise tableView ile ilgili etkileşimler ile ilgili fonksiyonları barındırıyor.
        table.delegate = self
        
        //self.title = "super brands"
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        // Add butonunu kod ile de ekledik (soldaki buton)
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        addButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = addButton
        
        
        //Edit Button
        let editButton = editButtonItem
        editButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItems?.append(editButton)
        
        
        let baseUrl = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        fileUrl = baseUrl.appendingPathComponent("brands.txt") // FileUrl i alıp Finder aç Command Shift G ile path finder açılacak path i ver txt nin kaydedildiği yeri görürsün
        
        
        //loadedData
        loadData()
    }
    
    
    @IBAction func btnAddClicked(_ sender: UIBarButtonItem) {
        
        if table.isEditing == true{
            return
        }
        
        let alert = UIAlertController(title: "Add Brand", message: "Please enter your brand.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { txtBrandName in
            txtBrandName.placeholder = "Brand Name"
        })
                
        let actionAdd = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { action in
            let firstTextField = alert.textFields![0] as UITextField
            self.addBrand(brandName: firstTextField.text!)
        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // verileri görüntülememizi sağlar.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    // herbir hücre olusturuldugunda satır olusturuldugunda bu fonksiyon çalıştırılacaktır.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell : UITableViewCell = UITableViewCell()
        let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = brands[indexPath.row]
        return cell
    }
    
    func addBrand(brandName : String) {
        //let brandName : String = "\(_counter). new brand "
        //_counter = _counter + 1
        
        /*  -- Markaları alta ekler biz aşağıda üste eklesin diye kodda değişiklik yaptık.
        brands.append(brandName)
        let indexPath : IndexPath = IndexPath(row: brands.count-1, section: 0)
        */
        
        brands.insert(brandName, at: 0)
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        // Tabloya Ekleme
        table.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
        saveData()
    }
    
    @objc func addButtonClicked(){
        
        if table.isEditing == true{
            return
        }
        
        let alert = UIAlertController(title: "Add Brand", message: "Please enter your brand.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { txtBrandName in
            txtBrandName.placeholder = "Brand Name"
        })
                
        let actionAdd = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { action in
            let firstTextField = alert.textFields![0] as UITextField
            self.addBrand(brandName: firstTextField.text!)
        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            brands.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            saveData()
        }
    }
    
    // for saving data to UserDefaults
    /*
    func saveData()  {
        UserDefaults.standard.setValue(brands , forKey: "brands")
    }
  
    func loadData()  {
        if let loadedData : [String] = UserDefaults.standard.value(forKey: "brands") as? [String]{
            brands = loadedData
            table.reloadData()
        }
    }*/
    
    // for saving data to txtFile
    func saveData()  {
        let _data = NSArray(array: brands)
        
        do {
            try _data.write(to: fileUrl)
        } catch {
            print("OPPS! Got an error while writing data to txt file.")
        }
    }
  
    func loadData()  {
        if let loadedData : [String] = NSArray(contentsOf: fileUrl) as? [String]{
            brands = loadedData
            table.reloadData()
        }
        
    }
}

