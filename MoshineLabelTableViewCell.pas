﻿namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  [IBObject]
  MoshineLabelTableViewCell = public class(MoshineBaseTableViewCell)
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



  public

    [IBOutlet]property textLabel:UILabel read begin
      exit cellControl as UILabel;
    end; override;

    property Text: nullable String read
      begin
        exit textLabel.text;
      end
      write
      begin
        textLabel.text := value;
      end; override;

  end;

end.