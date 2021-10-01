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
    
    var todos : [String] = []
    var todosExplanation : [String] = []
    var _counter : Int = 0
    var selectedRow : Int = -1
    var todoExp : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Data source verinin kaynağı ile ilgili fonksiyonları barındırıyor.
        table.dataSource = self
        
        // delegate de ise tableView ile ilgili etkileşimler ile ilgili fonksiyonları barındırıyor.
        table.delegate = self
        
        //self.title = "super todos"
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.largeTitleDisplayMode = .never
        // Add butonunu kod ile de ekledik (soldaki buton)
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        addButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = addButton
        
        
        //Edit Button
        let editButton = editButtonItem
        editButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItems?.append(editButton)
        
        // Verileri dosyaya kaydetmek için kullanacagımız yere file olusturmak için kullandıgımız kodlar.
        let baseUrl = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        fileUrl = baseUrl.appendingPathComponent("todos.txt") // FileUrl i alıp Finder aç Command Shift G ile path finder açılacak path i ver txt nin kaydedildiği yeri görürsün
        
        // Bu kod aracılıgıyla UI dan uğrasmadan UserDefaults ' daki tüm verileri silebiliriz.
        //UserDefaults.standard.removeObject(forKey: "todos")
        
        //loadedData
        loadData()
    }
    
    // viewDidLoad --> bir kere calısırken , viewWillAppear --> her ekran önümüze geldiğinde çalışır.
    // yani bizim bu ekranımız her görüntülendiğinde (Bu ekran) çalışacaktır.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        if todoExp == "" {
            todosExplanation.remove(at: selectedRow)
            todos.remove(at: selectedRow)
        }else if todoExp == todosExplanation[selectedRow]{
            return
        }else{
            todosExplanation[selectedRow] = todoExp
        }
        saveData()
        table.reloadData()
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
        return todos.count
    }
    
    // herbir hücre olusturuldugunda satır olusturuldugunda bu fonksiyon çalıştırılacaktır.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell : UITableViewCell = UITableViewCell()
        let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = todos[indexPath.row]
        return cell
    }
    
    func addBrand(brandName : String) {
        //let brandName : String = "\(_counter). new brand "
        //_counter = _counter + 1
        
        /*  -- Markaları alta ekler biz aşağıda üste eklesin diye kodda değişiklik yaptık.
        todos.append(brandName)
        let indexPath : IndexPath = IndexPath(row: todos.count-1, section: 0)
        */
        
        todos.insert(brandName, at: 0)
        todosExplanation.insert("Not inserted any value", at: 0)
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        // Tabloya Ekleme
        table.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
        saveData()
        
        // Bir marka eklediğimizde o markanın seçili olması gerekiyor ki explanation sayfasına gittiğimizde secili hale gelmesi gerekiyor cunku biz selectedRow üzerinden işlem yapacağız
        // Satırı aşağıda sayfaya gitmeden segue den önce secili hale getirelim.
        // İlgili indexPath i bulunan şeyi seçili hale getirdik.
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        
        // Ekleme yapıldıktan sonra direkt explanation sayfasına gidilmesini sağlar.
        performSegue(withIdentifier: "goExplanation", sender: self)
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
    
    // Silme İşlemi
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            todosExplanation.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            saveData()
        }
    }
    
    // for saving data to UserDefaults
    func saveData()  {
        UserDefaults.standard.setValue(todos , forKey: "todos")
        UserDefaults.standard.setValue(todosExplanation, forKey: "explanations")
    }
  
    func loadData()  {
        if let loadedData : [String] = UserDefaults.standard.value(forKey: "todos") as? [String]{
            todos = loadedData
        }
        
        if let explanation : [String] = UserDefaults.standard.value(forKey: "explanations") as? [String]{
            todosExplanation = explanation
        }
        
        // tüm tabloyu baştan render eder , yükler.
        table.reloadData()
    }
    
    // for saving data to txtFile
    /*
    func saveData()  {
        let _data = NSArray(array: todos)
        
        do {
            try _data.write(to: fileUrl)
        } catch {
            print("OPPS! Got an error while writing data to txt file.")
        }
    }
  
    func loadData()  {
        if let loadedData : [String] = NSArray(contentsOf: fileUrl) as? [String]{
            todos = loadedData
            table.reloadData()
        }
        
    }*/
    
    
    
    // TableView de bir satırı sectiğimizde bunu nasıl ele alabiliriz bunu bu method ile yapacağız. 1. sırada bu calısır
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("selected brand : \(todos[indexPath.row])")
        performSegue(withIdentifier: "goExplanation", sender: self)
        
    }
    
    // Bir Segue den önce (diğer sayfaya geçişten önce) bir işlem yapmak istiyorsak bunu burada yapıyoruz. 2. sırada bu calısır
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let explanationView : ExplanationViewController = segue.destination as! ExplanationViewController
        
        // tabloda hangi satırın seçili oldugunu buluyoruz.
        selectedRow = table.indexPathForSelectedRow!.row
        // Açıklamaları ekliyoruz.
        explanationView.setExplanation(exp: todosExplanation[selectedRow])
        explanationView.masterView = self
       
    }
}

