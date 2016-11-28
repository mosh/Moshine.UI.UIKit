namespace Moshine.UI.UIKit;

uses
  Foundation, UIKit;

type

  NGMaskedTextField = public class(UITextField)
  private
    var kMaskedTextFieldDefaultCharacterMask: NSString := '?';
    var kMaskedTextFieldDefaultNumberMask: NSString := '#';
    var kMaskedTextFieldDefaultFill: NSString := '';
    
    _inputString:NSString;
    _maskString:NSString;
    
  public
    property inputString: NSString read get_inputString write set_inputString;
    property maskString: NSString read get_maskString write set_maskString;
    property defaultCharacterMask: NSString;
    property defaultNumberMask: NSString;
    property defaultFill: NSString;

    method initWithCoder(coder: NSCoder): instancetype;
    begin
      self := inherited initWithCoder(coder);
      if assigned(self) then
      begin
        self.setDefaultCharacterMask(kMaskedTextFieldDefaultCharacterMask);
        self.setDefaultNumberMask(kMaskedTextFieldDefaultNumberMask);
        self.setDefaultFill(kMaskedTextFieldDefaultFill);
        self.addTarget(self) action(selector(textFieldValueDidChange)) forControlEvents(UIControlEvents.EditingChanged);
      end;
      exit self;
    end;

    method initWithFrame(frame: CGRect): instancetype; override;
    begin
      self := inherited initWithFrame(frame);
      if assigned(self) then begin
        self.setDefaultCharacterMask(kMaskedTextFieldDefaultCharacterMask);
        self.setDefaultNumberMask(kMaskedTextFieldDefaultNumberMask);
        self.setDefaultFill(kMaskedTextFieldDefaultFill);
        self.addTarget(self) action(selector(textFieldValueDidChange)) forControlEvents(UIControlEvents.EditingChanged);
      end;
      exit self;
    end;

    method shouldChangeCharactersInRange(range: NSRange) replacementString(string: NSString): Boolean;
    begin
      if self.maskString = nil then begin
        exit true;
      end;
      if range.length > 0 then begin
        if self.inputString.length ≥ range.length then
        begin
          self.inputString := self.inputString.substringWithRange(NSMakeRange(0, self.inputString.length - range.length));
        end
        else begin
          exit false;
        end;
      end;
      if string.length > 1 then
      begin
        var multipleCharString: NSMutableArray := NSMutableArray.array();
        for i: Integer := 0 to string.length - 1 do
          multipleCharString.addObject(NSString.stringWithFormat('%c', string.characterAtIndex(i)));
        for i: Integer := 0 to multipleCharString.count - 1 do
          if self.delegate.respondsToSelector(selector(textField:shouldChangeCharactersInRange:replacementString:)) then
          begin
            self.delegate.textField(self) shouldChangeCharactersInRange(NSMakeRange(i, 0)) replacementString(multipleCharString.objectAtIndex(i));
          end;
      end
      else begin
        if string.length > 0 then begin
          if self.inputString.length + string.length ≤ self.desiredInputLength() then begin
            var chartype: NSInteger := self.desiredInputCharacterTypeForOffset(0);
            var desiredCharacterSet: NSCharacterSet := NSCharacterSet.characterSetWithCharactersInString('abc'#231'defg'#287'h'#305'ijklmno'#246'prs'#351'tu'#252'vyzqwxABC'#199'DEFG'#286'HI'#304'JKLMNO'#214'PRS'#350'TU'#220'VYZQWX0123456789');
            if chartype = 1 then begin
              desiredCharacterSet := NSCharacterSet.characterSetWithCharactersInString('abc'#231'defg'#287'h'#305'ijklmno'#246'prs'#351'tu'#252'vyzqwxABC'#199'DEFG'#286'HI'#304'JKLMNO'#214'PRS'#350'TU'#220'VYZQWX');
            end
            else begin
              if chartype = 2 then begin
                desiredCharacterSet := NSCharacterSet.characterSetWithCharactersInString('0123456789');
              end;
            end;
            if desiredCharacterSet.isSupersetOfSet(NSCharacterSet.characterSetWithCharactersInString(string.substringToIndex(1))) then begin
              self.inputString := NSString.stringWithFormat('%@%@', self.inputString, string);
            end
            else begin
              exit false;
            end;
          end
          else begin
            exit false;
          end;
        end;
      end;
      exit true;
    end;

    method textFieldValueDidChange;
    begin
      if self.maskString ≠ nil then
      begin
        self.setText(self.executeMaskOnInput());
      end;
    end;

    method get_inputString: NSString;
    begin
      if _inputString = nil then
      begin
        _inputString := '';
      end;
      exit _inputString;
    end;

    method set_inputString(value: NSString);
    begin
      _inputString := value;
      if _inputString.length = 0 then
      begin
        self.setText('');
      end;
    end;
    
    method get_maskString:NSString;
    begin
      exit _maskString;
    end;

    method set_maskString(value: NSString);
    begin
      _maskString := value;
      self.setText(self.executeMaskOnInput());
      if self.inputString.length = 0 then
      begin
        self.setText('');
      end;
    end;

    method executeMaskOnInput: NSString;
    begin
      var mutableString: NSMutableString := NSMutableString.string();
      var inputIndex: NSInteger := 0;
      for i: Integer := 0 to self.maskString.length - 1 do
        if (self.maskString.characterAtIndex(i) = self.defaultCharacterMask.characterAtIndex(0)) or (self.maskString.characterAtIndex(i) = self.defaultNumberMask.characterAtIndex(0)) then
          begin
          if inputIndex < self.inputString.length then
          begin
            mutableString.appendString(NSString.stringWithFormat('%c', self.inputString.characterAtIndex(inputIndex)));
            inc(inputIndex);
          end
          else
          begin
            mutableString.appendString(self.defaultFill);
          end;
        end
        else
        begin
          mutableString.appendString(NSString.stringWithFormat('%c', self.maskString.characterAtIndex(i)));
        end;
      exit mutableString;
    end;

    method desiredInputLength: NSInteger;
    begin
      var length: Integer := 0;
      for i: Integer := 0 to self.maskString.length - 1 do
        if (self.maskString.characterAtIndex(i) = self.defaultCharacterMask.characterAtIndex(0)) or (self.maskString.characterAtIndex(i) = self.defaultNumberMask.characterAtIndex(0)) then
        begin
          inc(length);
        end;
      exit length;
    end;

    method desiredInputCharacterTypeForOffset(offset: NSInteger): NSInteger;
    begin
      var maskString: NSMutableString := NSMutableString.stringWithString(self.maskString);
      for i: Integer := 0 to self.inputString.length - 1 do
        for j: Integer := 0 to maskString.length - 1 do
          if (maskString.characterAtIndex(j) = self.defaultCharacterMask.characterAtIndex(0)) or (maskString.characterAtIndex(j) = self.defaultNumberMask.characterAtIndex(0)) then
          begin
            maskString.replaceCharactersInRange(NSMakeRange(j, 1)) withString(self.defaultFill);
            break;
          end;
      for i: Integer := 0 to maskString.length - 1 do
        if maskString.characterAtIndex(i) = self.defaultCharacterMask.characterAtIndex(0) then
        begin
          exit 1;
        end
        else begin
          if maskString.characterAtIndex(i) = self.defaultNumberMask.characterAtIndex(0) then
          begin
            exit 2;
          end;
        end;
      exit -1;
    end;

    method caretRectForPosition(position: UITextPosition): CGRect;
    begin
      if self.maskString = nil then
      begin
        exit inherited caretRectForPosition(position);
      end
      else
      begin
        exit inherited caretRectForPosition(position);
      end;
    end;


  end;

end.
