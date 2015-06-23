//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Eugene Yurtaev on 22/06/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift
import ConvenienceKit

class NoteDisplayViewController: UIViewController {
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    @IBOutlet weak var noteContentTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    var edit = true

    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if edit {
            self.navigationItem.title = "Edit Note"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !edit {
            deleteButton.enabled = false
        }
        
        displayNote(note)
        
        noteTitleTextField.returnKeyType = .Next //1
        noteTitleTextField.delegate = self
        noteContentTextView.delegate = self
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3){
                self.toolbarBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3) {
                self.toolbarBottomSpace.constant = height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func displayNote(note: Note?) {
        if let note = note, titleTextField = noteTitleTextField, contentTextView = noteContentTextView  {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if count(note.title)==0 && count(note.content)==0 { //1
                titleTextField.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    func saveNote() {
        if let note = note {
            let realm = Realm()
            
            realm.write {
                if (note.title != self.noteTitleTextField.text || note.content != self.noteContentTextView.text) {
                    note.title = self.noteTitleTextField.text
                    note.content = self.noteContentTextView.text
                    note.modificationDate = NSDate()
                }
            }
        }
    }

    @IBAction func scrollViewTapped(sender: UITapGestureRecognizer) {
        noteContentTextView.becomeFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoteDisplayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == noteTitleTextField) {  //1
            noteContentTextView.becomeFirstResponder()
            noteContentTextView.returnKeyType = .Done
        }
        
        return false
    }
}

extension NoteDisplayViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            noteContentTextView.scrollRangeToVisible(range)
            var textViewRect = noteContentTextView.frame
            textViewRect.origin = CGPoint(x: 0, y: toolbarBottomSpace.constant)
            scrollView.scrollRectToVisible(textViewRect, animated: true)
        }
        return true
    }
    
}
