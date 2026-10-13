pageextension 50007 KMK_ItemCardExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. on Sales Order")
        {

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
            field(KMK_MoldedPieceWeightOz; Rec.KMK_MoldedPieceWeightOz)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Molded/Piece Weight (Oz.) field.', Comment = '%';
            }
            field(KMK_NetWeightCase; Rec.KMK_NetWeightCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Weight (Case) field.', Comment = '%';
            }
            field(KMK_GrossWeight; Rec.KMK_GrossWeight)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gross Weight field.', Comment = '%';
            }
            field(KMK_OrderMultipleQty; Rec.KMK_OrderMultipleQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Multiple Qty, field.', Comment = '%';
            }
        }

        addbefore("Allow Invoice Disc.")
        {

            field(KMK_SeasonalAvailability; Rec.KMK_SeasonalAvailability)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Seasonal Availability field.', Comment = '%';
            }
            field(KMK_StartDate; Rec.KMK_StartDate)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
            }
            field(KMK_EndDate; Rec.KMK_EndDate)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
            }
        }

        addafter(ItemPicture)
        {
            part(ItemPanLayout; "Pan Layout Picture")
            {
                ApplicationArea = All;
                Caption = 'Pan Layout';
                SubPageLink = "No." = field("No.");
                Visible = false;
            }


            part(ItemPanLayouts; KMKAttachmentListFactbox)
            {
                ApplicationArea = All;
                Caption = 'Pan Layout Pictures';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Item),
                              "No." = field("No.");

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