tableextension 50011 KMK_LotInfoExt extends "Lot No. Information"
{
    fields
    {
        // Add changes to table fields here
        field(50000; KMK_ManufactureDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manufacturing Date';
        }
        field(50001; KMK_DaysRemaining; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Days Remaining';
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