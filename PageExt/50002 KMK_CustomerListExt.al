pageextension 50002 KMK_CustomerListExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shipping Agent Code")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
            }


            field(KMK_BHAllowancePerCase; Rec.KMK_BHAllowancePerCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BH Allowance $/case field.', Comment = '%';
            }
            field(KMK_MinOrderQtycases; Rec.KMK_MinOrderQtycases)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Min. Order Qty. (cases) field.', Comment = '%';
            }

        }

        addafter("Payment Terms Code")
        {

            field(KMK_SalesServiceAllowancePer; Rec.KMK_SalesServiceAllowancePer)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Service Allowance (%) field.', Comment = '%';
            }
        }

        addafter("Last Date Modified")
        {

            field("Document Sending Profile"; Rec."Document Sending Profile")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the preferred method of sending documents to this customer, so that you do not have to select a sending option every time that you post and send a document to the customer. Sales documents to this customer will be sent using the specified sending profile and will override the default document sending profile.';
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