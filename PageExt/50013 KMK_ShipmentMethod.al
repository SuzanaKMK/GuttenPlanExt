pageextension 50013 KMK_ShipmentMethodExt extends "Shipment Methods"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {

            field(KMKType; Rec.KMKType)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Backhaul Type field.', Comment = '%';
            }
            field(KMK_BHNo; Rec.KMK_BHNo)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Backhaul No. field.', Comment = '%';
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