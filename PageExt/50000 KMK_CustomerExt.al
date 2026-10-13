pageextension 50000 KMK_CustomerExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {


              field(KMK_OnHold; Rec.KMK_OnHold)
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the value of the On Hold field.', Comment = '%';
                 Visible = false;
             }
             field(KMK_OnHoldDate; Rec.KMK_OnHoldDate)
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the value of the On Hold Date field.', Comment = '%';
                 Editable = Rec.KMK_OnHold = true;
                 Visible = false;
             } 
            field(KMK_ExtDocDupAllowed; Rec.KMK_ExtDocDupAllowed)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ext. Doc. Duplicate Allowed field.', Comment = '%';
            }
        }
        addlast(Payments)
        {

            field(KMK_SalesServiceAllowancePer; Rec.KMK_SalesServiceAllowancePer)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Service Allowance (%) field.', Comment = '%';
            }
        }

        addafter("Location Code")
        {

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

        addafter("Base Calendar Code")
        {

            field(KMK_EDIASNRequired; Rec.KMK_EDIASNRequired)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EDI ASN Required field.', Comment = '%';
            }
            /* field(KMK_SlipSheet; Rec.KMK_SlipSheet)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Slip Sheet field.', Comment = '%';
            }
            field(KMK_TempTale; Rec.KMK_TempTale)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the TempTale required on orders field.', Comment = '%';
            } */
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}