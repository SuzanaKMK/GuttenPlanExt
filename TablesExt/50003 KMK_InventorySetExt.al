tableextension 50003 KMK_InventorySetupExt extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50050; KMK_SafetyFactor; Decimal)
        {
            Caption = 'Safety Factor';

            DecimalPlaces = 2 : 3;
            BlankZero = true;

        }

        field(50052; KMK_LinerCaseWeight; Decimal)
        {
            Caption = 'Liner + Case Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;
        }
        field(50053; KMK_PalletFactor; Decimal)
        {
            Caption = 'Pallet Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;
        }
        field(50054; KMK_DefDryWhsLocation; Code[10])
        {
            Caption = 'Default Dry Whs. Location';
            DataClassification = ToBeClassified;
            TableRelation = Location;
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