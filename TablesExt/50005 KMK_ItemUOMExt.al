tableextension 50005 KMK_ItemUOMExt extends "Item Unit of Measure"
{
    fields
    {
        // Add changes to table fields here
        field(50000; KMK_QtyperBaseCase; Decimal)
        {
            Caption = 'Qty. per Base UOM/Pieces Per Case';
            DataClassification = ToBeClassified;
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