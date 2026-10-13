pageextension 50003 KMK_ShiptoAddressExt extends "Ship-to Address"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {

            field(KMK_ShippingTime; Rec.KMK_ShippingTime)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Time field.', Comment = '%';
            }
            field(KMK_MinOrderQtycases; Rec.KMK_MinOrderQtycases)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Min. Order Qty. (cases) field.', Comment = '%';
            }
            /*  field(KMK_DrivingMiles; Rec.KMK_DrivingMiles)
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the value of the Driving Miles field.', Comment = '%';
             } */
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}