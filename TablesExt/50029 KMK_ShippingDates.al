table 50029 KMK_ShippingDates
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50000; KMK_Shipping_Time; DateFormula)
        {
            Caption = 'Shipping Time';
        }
        field(50100; KMK_Base_Calendar_Code; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";

        }
    }

    keys
    {
        key(Key1; KMK_Shipping_Time)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}