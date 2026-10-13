tableextension 50010 KMK_SalesDiscountExt extends "Sales Line Discount"
{
    fields
    {
        // Add changes to table fields here
        field(50000; KMK_DiscountPerCase; Decimal)
        {
            Caption = ' $ per Case Discount';
            AutoFormatType = 2;
            MinValue = 0;
        }


    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}