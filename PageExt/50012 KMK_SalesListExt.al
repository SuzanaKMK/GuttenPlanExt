pageextension 50012 KMK_SalesListExt extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {

            field(KMK_EmailSent; Rec.KMK_EmailSent)
            {
                ApplicationArea = All;

                ToolTip = 'Specifies the value if email was sent for sales order', Comment = '%';
            }
            field(KMK_DocumentSendingProfile; Rec.KMK_DocumentSendingProfile)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the KMK_DocumentSendingProfile field.', Comment = '%';
            }
            field(KMK_ZoneServiceCode; Rec.KMK_ZoneServiceCode)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the KMK_ZoneServiceCode field.', Comment = '%';
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city of the shipping address.';
            }

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
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Post &Batch")
        {
            action("KMK_PostBatch")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Batch';
                Ellipsis = true;
                Image = PostBatch;

                ToolTip = 'Post several documents at once. A report request window opens where you can specify which documents to post.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    SalesHeader.SetFilter("No.", SelectionFilterManagement.GetSelectionFilterForSalesHeader(SalesHeader));
                    REPORT.RunModal(REPORT::KMK_BatchPostSOExt, true, true, SalesHeader);
                    CurrPage.Update(false);
                end;
            }

        }
        modify("Post &Batch")
        {
            Visible = false;
        }

        addlast(Category_Category7)
        {


            actionref(KMK_PostBatch_Promoted; KMK_PostBatch)
            {
            }

        }
    }

    var
        myInt: Integer;
}