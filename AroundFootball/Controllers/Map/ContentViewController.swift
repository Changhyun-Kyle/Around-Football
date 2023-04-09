//
//  ContentViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/04/18.
//

import UIKit

var nameLabel: [String] = []
var addressLabel: [String] = []

class ContentViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let contentNibName = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(contentNibName, forCellReuseIdentifier: "ContentTableViewCell")
        
        let headerNibName = UINib(nibName: "ContentHeaderCell", bundle: nil)
        tableView.register(headerNibName, forHeaderFooterViewReuseIdentifier: "ContentHeaderCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
        cell.timeLabel.text = "13:00 - 15:00"
        cell.typeLabel.text = "용병 3명"
        cell.timeLabel.textColor = .black
        cell.typeLabel.textColor = .black
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let nameLabel = UILabel()
        let addressLabel = UILabel()
        
        
        nameLabel.frame = CGRect.init(x: 30, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        nameLabel.text = "고려대학교 녹지운동장"
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .black
        
        addressLabel.frame = CGRect.init(x: 30, y: 30, width: headerView.frame.width-10, height: headerView.frame.height-10)
        addressLabel.text = "서울특별시 성북구 돈암동 173-7"
        addressLabel.font = .boldSystemFont(ofSize: 15)
        addressLabel.textColor = .black
        
        headerView.backgroundColor = .white
        headerView.addSubview(nameLabel)
        headerView.addSubview(addressLabel)

        let underLine = UIView()
        underLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha:1)
        headerView.addSubview(underLine)
        underLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underLine.heightAnchor.constraint(equalToConstant: 1),
            underLine.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            underLine.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            underLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
