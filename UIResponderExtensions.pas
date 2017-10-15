namespace Moshine.UI.UIKit;

uses
  UIKit;

type

  UIResponderExtensions = public extension class(UIResponder)
  public
    method DelayCallback(someMethod:block) forMilliseconds(m:Int64);
    begin

      var value:Int64 := m * NSEC_PER_MSEC;

      var popTime: dispatch_time_t := dispatch_time(DISPATCH_TIME_NOW, value);

      dispatch_after(popTime, dispatch_get_main_queue(), () -> begin

        someMethod();

      end);


    end;

  end;


end.