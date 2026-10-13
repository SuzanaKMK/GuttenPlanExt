pageextension 50014 KMK_SalesPriceExt extends "Sales Prices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item No.")
        {

            field(KMK_ItemDescription; Rec.KMK_ItemDescription)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
            }
            field(KMK_ItemCost; Rec.KMK_ItemCost)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Item Cost field.', Comment = '%';
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