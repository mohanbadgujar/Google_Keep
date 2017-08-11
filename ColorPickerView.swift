
import UIKit

class ColorPickerView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var collectionview: UICollectionView!
    let colors = ["0xffffff","0xf55131","0x59cc50","0x49c7f3","0xefe357","0xf085e1","0x85b2f0","0xf5a02d","0xb8b6b3","F5DEB3"]

       override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.dataSource = self
        collectionview.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "colorcell", for: indexPath) as! ColorPickerViewCell
        
        let color = colors[indexPath.row]
        cell.contentView.backgroundColor = UIColor(hex : color)
        cell.contentView.layer.cornerRadius = cell.contentView.frame.size.width/2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionview.cellForItem(at: indexPath) as! ColorPickerViewCell
        cell.image.image = UIImage(named: "right_icon")
        
        NotificationCenter.default.post(name: NSNotification.Name("selectedCell"), object: nil,userInfo:["color":colors[indexPath.row]])
       
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.3), execute: {
           self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
