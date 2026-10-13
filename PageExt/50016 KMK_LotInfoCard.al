pageextension 50016 KMk_LotInfoCard extends "Lot No. Information Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(Inventory)
        {

            field(KMK_ManufactureDate; Rec.KMK_ManufactureDate)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Manufacturing Date field.', Comment = '%';
            }
            field(KMK_DaysRemaining; Rec.KMK_DaysRemaining)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Days Remaining field.', Comment = '%';
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