namespace Moshine.UI.UIKit;

uses
  UIKit;

type

  StepCollectionViewFlowLayout = public class(UICollectionViewFlowLayout)
  private
  protected
  public

    method snapStep:CGFloat;
    begin
      exit self.itemSize.width + self.minimumLineSpacing;
    end;

    method isValidOffset(offset: CGFloat):Boolean;
    begin
      exit ((offset >= CGFloat(self.minContentOffset())) and (offset <= CGFloat(self.maxContentOffset())));
    end;

    method minContentOffset: CGFloat;
    begin
      exit -CGFloat(self.collectionView.contentInset.left);
    end;

    method maxContentOffset:CGFloat;
    begin
      exit CGFloat(self.minContentOffset() + self.collectionView.contentSize.width - self.itemSize.width);
    end;


    method targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) withScrollingVelocity(velocity: CGPoint): CGPoint; override;
    begin

      {$IFDEF TOFFEE}

      var _proposedContentOffset := CGPointMake(proposedContentOffset.x, proposedContentOffset.y);

      var offSetAdjustment: CGFloat := CGFLOAT_MAX; //  CGFloat.greatestFiniteMagnitude;

      var horizontalCenter:CGFloat := proposedContentOffset.x + (self.collectionView.bounds.size.width / 2.0);

      var targetRect := CGRectMake(proposedContentOffset.x,0.0,self.collectionView.bounds.size.width,self.collectionView.bounds.size.height);

      //var attrArray:UICollectionViewLayoutAttributes :=

      var attrArray :=self.layoutAttributesForElementsInRect(targetRect);

      for each layoutAttributes:UICollectionViewLayoutAttributes in attrArray do
      begin
        if layoutAttributes.representedElementCategory = UICollectionElementCategory.Cell then
        begin
          var itemHorizontalCenter:CGFloat := layoutAttributes.center.x;

          if abs(itemHorizontalCenter - horizontalCenter) < abs(offSetAdjustment) then
          begin
            offSetAdjustment := itemHorizontalCenter - horizontalCenter;
          end;

        end;
      end;

      var nextOffset: CGFloat := proposedContentOffset.x + offSetAdjustment;

      repeat
      begin
        _proposedContentOffset.x := nextOffset;
        var deltaX := proposedContentOffset.x - self.collectionView.contentOffset.x;
        var velX := velocity.x;

        if (deltaX = 0.0) or (velX = 0) or ((velX > 0.0) and (deltaX > 0.0)) or ((velX < 0.0) and (deltaX < 0.0)) then
        begin
          break;
        end;

        if velocity.x > 0.0 then
        begin
          nextOffset := nextOffset + self.snapStep();
        end
        else if velocity.x < 0.0 then
        begin
          nextOffset := nextOffset - self.snapStep();
        end;

      end
      until (not self.isValidOffset(nextOffset));

      _proposedContentOffset.y := 0.0;

      exit _proposedContentOffset;

      {$ENDIF}

    end;

  end;

end.