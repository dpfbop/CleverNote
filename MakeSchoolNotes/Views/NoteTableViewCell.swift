//
//  NoteTableViewCell.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    
    @IBOutlet weak var noteDateLabel: UILabel!
    
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        }()
    
    var note: Note? {
        didSet {
            if let note = note, titleLabel = noteTitleLabel, dateLabel = noteDateLabel {
                self.noteTitleLabel.text = note.title
                self.noteDateLabel.text = NoteTableViewCell.dateFormatter.stringFromDate(note.modificationDate)
            }
        }
    }
}
