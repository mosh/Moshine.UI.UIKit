namespace SimpleApp2;

uses
  UIKit;

type

  DateCollectionViewCell = public class(UICollectionViewCell)
  private
    dayLabel:UILabel;
    numberLabel:UILabel;
    darkColor:UIColor := UIColor.colorWithRed(0) green(22.0 / 255.0) blue(39.0/255.0) alpha(1);
    highlightColor:UIColor := UIColor.colorWithRed(0/255.0) green(199.0/255.0) blue(194.0/255.0) alpha(1);

  protected

  public

    constructor withFrame(frame: CGRect); override;
    begin

      dayLabel := new UILabel withFrame(CGRectMake(5,15,frame.size.width-10,20));
      dayLabel.font := UIFont.systemFontOfSize(10);
      dayLabel.textAlignment := NSTextAlignment.Center;

      numberLabel := new UILabel withFrame(CGRectMake(5, 30, frame.size.width - 10, 40));
      numberLabel.font := UIFont.systemFontOfSize(25);
      numberLabel.textAlignment := NSTextAlignment.Center;


      inherited constructor withFrame(frame);


      contentView.addSubview(dayLabel);
      contentView.addSubview(numberLabel);


      contentView.backgroundColor := UIColor.whiteColor;
      contentView.layer.cornerRadius := 3;
      contentView.layer.masksToBounds := true;
      contentView.layer.borderWidth := 1;

    end;

    property isSelected: Boolean read get_isSelected; override;

    method get_isSelected:Boolean;
    begin

      dayLabel.textColor := iif(inherited.isSelected,UIColor.whiteColor,darkColor.colorWithAlphaComponent(0.5));
      numberLabel.textColor := iif(inherited.isSelected,UIColor.whiteColor,darkColor);

      numberLabel.textColor := iif(inherited.isSelected, UIColor.whiteColor, darkColor);
      contentView.backgroundColor := iif(inherited.isSelected, highlightColor, UIColor.whiteColor);
      contentView.layer.borderWidth := iif(inherited.isSelected, 0 , 1);
      exit inherited.isSelected;
    end;

    method populateItem(date: Date; someHighlightColor: UIColor; someDarkColor: UIColor);
    begin
      self.highlightColor := someHighlightColor;
      self.darkColor := someDarkColor;

      var dateFormatter := new DateFormatter;
      dateFormatter.dateFormat := 'EEEE';

      dayLabel.text := dateFormatter.stringFromDate(date).uppercaseString;

      dayLabel.textColor := iif(self.isSelected, UIColor.whiteColor, darkColor.colorWithAlphaComponent(0.5));

      var numberFormatter := new DateFormatter();
      numberFormatter.dateFormat := 'd';

      numberLabel.text := numberFormatter.stringFromDate(date);
      numberLabel.textColor := iif(isSelected, UIColor.whiteColor, darkColor);

      contentView.layer.borderColor := darkColor.colorWithAlphaComponent(0.2).CGColor;
      contentView.backgroundColor := iif(isSelected, highlightColor, UIColor.whiteColor);
    end;



  end;

end.