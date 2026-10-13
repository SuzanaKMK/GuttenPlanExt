pageextension 50041 KMK_SalesInvList extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {


            field(KMK_TotalCaseQuantityItem; Rec.KMK_TotalCaseQuantityItem)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Case Quantity field.', Comment = '%';
            }
            field(KMK_TotalCaseNetWeight; Rec.KMK_TotalCaseNetWeight)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Net Weight field.', Comment = '%';
            }
            field(KMK_TotalCaseGrossWeight; Rec.KMK_TotalCaseGrossWeight)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Gross Weight field.', Comment = '%';
            }
            field(KMK_DocumentSendingProfile; Rec.KMK_DocumentSendingProfile)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Sending Profile field.', Comment = '%';
            }
            field(KMK_ZoneServiceCode; Rec.KMK_ZoneServiceCode)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Zone Service Code field.', Comment = '%';
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