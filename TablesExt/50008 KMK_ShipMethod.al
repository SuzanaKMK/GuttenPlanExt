tableextension 50008 KMK_ShipMethod extends "Shipment Method"
{
    fields
    {
        // Add changes to table fields here
        field(50005; KMKType; Enum "Sales Line Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Backhaul Type';


        }
        field(50001; KMK_BHNo; Code[20])
        {

            DataClassification = ToBeClassified;
            Caption = 'Backhaul No.';
            TableRelation = if (KMKType = const(" ")) "Standard Text"
            else
            if (KMKType = const("G/L Account")) "G/L Account"
            else
            if (KMKType = const(Resource)) Resource
            else
            if (KMKType = const("Fixed Asset")) "Fixed Asset"
            else
            if (KMKType = const("Charge (Item)")) "Item Charge";

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