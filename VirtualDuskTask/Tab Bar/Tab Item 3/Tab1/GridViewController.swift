//
//  GridViewController.swift
//  VirtualDuskTask
//
//  Created by Pavankumar G on 13/02/18.
//  Copyright © 2018 Pavankumar G. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var tempImagesArray : NSMutableArray = []
    var tempImage : UIImage?
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - View Life cycle method

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Using singleton we can access the TXT file data in different view controllers

        //let shhh =  AccountManager.sharedInstance.userInfo
       // print(shhh)
        
        let fileURLProject = Bundle.main.path(forResource: "CollectionJSON", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        var tempDict : NSDictionary = [:]
        
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            
            
            
        } catch let error as NSError {
            print("Failed reading from URL:, Error: " + error.localizedDescription)
        }
        
        let jsonData = readStringProject.data(using: .utf8)
        
        if let urlCont = jsonData {
            
            do {
                
                let jsonResult  = try JSONSerialization.jsonObject(with: urlCont, options:
                    JSONSerialization.ReadingOptions.mutableContainers)
                
                tempDict = jsonResult as! NSDictionary
            }catch {
                
                print("JSON Processing Failed")
            }
        }
        
        
        
        
        
        let tempItems : NSMutableArray = tempDict.value(forKey: "items") as! NSMutableArray
        
         for i in 0..<tempItems.count
                {
                    // We can use keypath also for getting the perticular image url value
                    
                    let tempDict : NSDictionary = tempItems[i] as! NSDictionary
                    let tempImageUrlDic: NSDictionary = tempDict.value(forKey: "media") as! NSDictionary
                    tempImagesArray.add(tempImageUrlDic.value(forKey: "m")!)
                    
                }
        
        // Do any additional setup after loading the view.
    }

    //MARK: - Memory Warning method

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UICollectionViewDelegate & UICollectionViewDatatSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return tempImagesArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageObj.contentMode = .scaleAspectFill
        cell.imageObj.backgroundColor = UIColor.lightGray
        let imageURL = tempImagesArray[indexPath.row]
        let requestURL = NSURL(string: imageURL as! String)! as URL

        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil {
                    if let imageData = data {
                        cell.imageObj.image = UIImage(data: imageData)
                    } else {
                        //Default Image if server response nil
                      cell.imageObj.image = UIImage.init(named: "degaultImage")
                    }
                } else {
                    //Default Image

                     cell.imageObj.image = UIImage.init(named: "degaultImage")
                }
            }
            }.resume()
        
        
       
        return cell
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemsPerRow:CGFloat = 3
        let heightt = self.view.frame.size.height

        if heightt == 1024 {
            itemsPerRow = 4
        }
        
        
        let hardCodedPadding:CGFloat = 1
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = itemWidth - 4
//        print(itemWidth)
//        print(itemHeight)

        
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    
    func load_image(link:String, imageview:UIImageView)
    {
        
        let urll:NSURL = NSURL(string: link)!
        let session = URLSession.shared

        let request = NSMutableURLRequest(url: urll as URL)
        request.timeoutInterval = 10
        
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
           
            
            
            self.tempImage = UIImage(data: data!)
            
            if (self.tempImage != nil)
            {
                
                
                print(self.tempImage!)
                
                
                
                
            }
            
        }
        
        task.resume()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
