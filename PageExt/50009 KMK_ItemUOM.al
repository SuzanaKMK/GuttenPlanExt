pageextension 50009 KMK_ItemUOM extends "Item Units of Measure"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. per Unit of Measure")
        {

            field(KMK_QtyperBaseCase; Rec.KMK_QtyperBaseCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. per Base UOM/Pieces Per Case field.', Comment = '%';
                DecimalPlaces = 0 : 5;
            }
        }
        modify("Qty. per Unit of Measure")
        {
            Caption = 'Qty of Base Unit of Measure per Unit';
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}