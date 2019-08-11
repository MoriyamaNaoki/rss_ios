import UIKit
import Foundation

class ViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var check_title = [String]()
    var news_title = [String]()
    var link = [String]()
    var enclosure = [String]()
    var check_element = String()
    
    var select_link = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news_title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "tableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = news_title[indexPath.row]

        return cell
        
    }

    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        select_link = link[indexPath.row]
        performSegue(withIdentifier: "web", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "web" {
            let next = segue.destination as! webViewController
            next.targetURL = select_link
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: URL = URL(string:"https://news.yahoo.co.jp/pickup/rss.xml")!
        /*
        do {
            //取得_HTMLソース
            let source: String = try String(contentsOf: url as URL, encoding: String.Encoding.utf8);
            print(source);
        } catch {
            //何かしらのエラーが発生した。
            print("エラーが発生しました。");
        }
        */
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            let parser: XMLParser? = XMLParser(data: data!)
            parser!.delegate = self
            parser!.parse()
            
        })
        //タスク開始
        task.resume()
    }
    


    //解析_開始時
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    //解析_要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "enclosure" {
            print(attributeDict["url"]!)
            enclosure.append(attributeDict["url"]!)
        }
        check_element = elementName

    }
    
    //解析_要素内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string != "\n" {
            if check_element == "title" {
                check_title.append(string)
                print("開始要素:" + string)
            }

            if check_element == "link" {
                link.append(string)
                print("開始要素:" + string)
            }
        }
    }
    
    //解析_要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if check_element == "title" {
            var title = check_title[0]
            for i in 1..<check_title.count {
                title = title + check_title[i]
            }
            check_title = [String]()
            news_title.append(title)
        }
    }
    
    //解析_終了時
    func parserDidEndDocument(_ parser: XMLParser) {

    }
    
    //解析_エラー発生時
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
}



