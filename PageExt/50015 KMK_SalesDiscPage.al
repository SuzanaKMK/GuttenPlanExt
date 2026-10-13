pageextension 50015 KMK_SalesDiscExt extends "Sales Line Discounts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Discount %")
        {

            field(KMK_DiscountPerCase; Rec.KMK_DiscountPerCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the $ per Case Discount field.', Comment = '%';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
