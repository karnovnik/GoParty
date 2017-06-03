//
//  SongCellView.swift
//  KaraokeCatalog
//
//  Created by Karnovskiy on 2/19/17.
//  Copyright © 2017 Karnovskiy. All rights reserved.
//

import UIKit

class SongCellView: UITableViewCell {
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var isKaraokeImg: UIImageView!
    @IBOutlet weak var isClipImg: UIImageView!
    @IBOutlet weak var nationImg: UIImageView!
    @IBOutlet weak var favoriteImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData( song: Song) {
        ID.text = String( song.ID )
        name.text = song.name
        singer.text = song.singer
        
        nationImg.image = UIImage(named: ENations.getFlagNameByValue(song.nation));
        
        if song.isFavorite {
            favoriteImg.image = UIImage(named: "favorite")
        } else {
            favoriteImg.image = nil;
        }
        
        if song.isClip {
            isClipImg.image = UIImage(named: "clip")
        } else {
            isClipImg.image = nil;
        }
        
        if song.typeKaraoke == "Karaoke" {
            isKaraokeImg.image = UIImage(named: "karaoke")
        } else {
            isKaraokeImg.image = UIImage(named: "pro")
        }
    }

}
