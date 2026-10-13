tableextension 50013 KMK_PurchLine extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; KMK_GUIDescription; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = '004';
            Caption = 'GUI Description';
        }
        field(50105; "GUI User ID"; Text[50]) { DataClassification = ToBeClassified; }
        field(50114; "GUI Type"; Text[50]) { DataClassification = ToBeClassified; }
        field(50115; "GUI Time of Action"; DateTime) { DataClassification = ToBeClassified; }
        field(50120; "GUI Pallet"; Text[10]) { DataClassification = ToBeClassified; }
        field(50125; "GUI-to-BC Entry No"; Integer) { DataClassification = ToBeClassified; }
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