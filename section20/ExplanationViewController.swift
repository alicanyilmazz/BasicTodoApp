//
//  ExplanationViewController.swift
//  section20
//
//  Created by alican on 17.09.2021.
//

import UIKit

class ExplanationViewController: UIViewController {

    
    @IBOutlet weak var lblBrandExplanation: UITextView!
    var _explanation : String = ""
    
    var masterView : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .never
        lblBrandExplanation.text = _explanation
    }
    
    func setExplanation(exp : String) {
        _explanation = exp
        if isViewLoaded {
            lblBrandExplanation.text = _explanation
        }
    }
    
    // Bu Ekran gözümüzden kaynoldugunda veya bu ekrandan baska ekrana gecis yaptıgımızda bu fonksiyon calısır.
    override func viewWillDisappear(_ animated: Bool) {
        masterView?.todoExp = lblBrandExplanation.text
        lblBrandExplanation.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblBrandExplanation.becomeFirstResponder()
        
    }
}
