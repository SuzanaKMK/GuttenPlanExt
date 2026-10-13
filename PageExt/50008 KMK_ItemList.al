pageextension 50008 KMK_ItemListExt extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {

            field(KMK_SeasonalAvailability; Rec.KMK_SeasonalAvailability)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Seasonal Availability field.', Comment = '%';
            }
            field(KMK_GrossWeight; Rec.KMK_GrossWeight)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gross Weight field.', Comment = '%';
            }
            field(KMK_PieceWeightActual; Rec.KMK_PieceWeightActual)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Piece Weight/Actual field.', Comment = '%';
            }
            field(KMK_PiecesperCase; Rec.KMK_PiecesperCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pieces per Case field.', Comment = '%';
            }
            field(KMK_ShelfLifeDays; Rec.KMK_ShelfLifeDays)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf Life (Days) field.', Comment = '%';
            }
            field(KMK_GuaranteeLifeDays; Rec.KMK_GuaranteeLifeDays)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Guarantee Life (Days) field.', Comment = '%';
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