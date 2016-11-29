namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  [IBObject]
  MoshineLabelTableViewCell = public class(MoshineBaseTableCell)
  protected
  
    method createControl:UIView; override;
    begin
      exit new UILabel;
    end;
  
    method setup; override;
    begin
      inherited setup;
      
      self.textLabel.textAlignment := NSTextAlignment.Left;
      
    end;
    
    method get_textLabel:UILabel;
    begin
      exit cellControl as UILabel;
    end;
    
  
  public
  
    [IBOutlet]property textLabel:weak UILabel read get_textLabel; override;
    
    method touchesBegan(touches: not nullable NSSet) withEvent(&event: nullable UIEvent); override;
    begin
      self.textLabel:becomeFirstResponder;
    end;
  
  end;

end.
