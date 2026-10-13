tableextension 50009 KMK_SalesPriceExt extends "Sales Price"
{
    fields
    {
        // Add changes to table fields here
        field(50000; KMK_ItemDescription; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }

        field(50100; KMK_ItemCost; Decimal)
        {
            Caption = 'Item Cost';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("Item No.")));
            Editable = false;

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