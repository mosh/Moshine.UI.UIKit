namespace Moshine.UI.UIKit;

uses
  Foundation,
  PureLayout,
  UIKit;

type

  [IBObject]
  MoshineBaseTableViewCell = public abstract class(UITableViewCell)
  private
  protected

    property cellControl:UIView read private write;

    method createControl:UIView; abstract;

    method setup; virtual;
    begin
      self.detailTextLabel:hidden := true;
      self.cellControl := createControl;
      self.contentView.viewWithTag(3):removeFromSuperview();
      self.cellControl.tag := 3;
      self.cellControl.translatesAutoresizingMaskIntoConstraints := false;
      self.contentView.addSubview(self.cellControl);

      var insets := new UIEdgeInsets;
      insets.top := 8.0;
      insets.left := 16.0;
      insets.bottom := 8.0;
      insets.right := 16.0;

      self.cellControl.autoPinEdgesToSuperviewEdgesWithInsets(insets);


    end;

  public

    method awakeFromNib; override;
    begin
      inherited awakeFromNib;
      setup;
    end;

    constructor WithStyle(style: UITableViewCellStyle) reuseIdentifier(reuseIdentifier: NSString);
    begin
      inherited constructor WithStyle(style) reuseIdentifier(reuseIdentifier);
      setup;
    end;

    constructor WithCoder(aDecoder: NSCoder);
    begin
      inherited constructor WithCoder(aDecoder);
      setup;
    end;

  end;

end.