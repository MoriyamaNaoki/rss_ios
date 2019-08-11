import UIKit

class webViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var targetURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let targetURL = adress
        let requestURL = NSURL(string: targetURL)
        let req = NSURLRequest(url: requestURL! as URL)
        webView.loadRequest(req as URLRequest)
    }
    

}
