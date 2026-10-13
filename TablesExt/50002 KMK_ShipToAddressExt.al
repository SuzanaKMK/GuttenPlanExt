tableextension 50002 KMK_ShiptoAddress extends "Ship-to Address"
{
    fields
    {
        // Add changes to table fields here
        field(50050; KMK_ShippingTime; DateFormula)
        {
            DataClassification = ToBeClassified;
            Caption = 'Shipping Time';
            Description = '001';
        }

        field(50051; KMK_MinOrderQtycases; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Min. Order Qty. (cases)';
            Description = '001';
        }

        /* field(50052; KMK_DrivingMiles; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Driving Miles';
        } */

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