pageextension 50010 KMK_SalesOrder extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addlast("Shipping and Billing")
        {




        }

        addfirst(factboxes)
        {
            part(SentEmails; "Sent Emails for Document")
            {
                ApplicationArea = All;
            }
        }



    }





    actions
    {
        // Add changes to page actions here

        modify(Release)
        {
            trigger OnAfterAction()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader := Rec;

                // Your custom logic: insert/update lines and recalc their amounts here

                // Call standard release
                // Codeunit.Run(Codeunit::"Release Sales Document", SalesHeader);

                // Refresh header + subform after release

                CurrPage.SalesLines.Page.ForceTotalsCalculation();

                CurrPage.SalesLines.PAGE.UpdateForm(true);
                CurrPage.Update();
            end;
        }


    }


    trigger OnAfterGetRecord()
    var
        SentEmailTemp: Record "Sent Email" temporary;
        Email: Codeunit Email;
    begin
        StyleExprTxt := Rec.GetStatusStyleText_KMK();
        // SentEmailTemp :=
        Email.GetSentEmailsForRecord(Database::"Sales Header", Rec.SystemId, SentEmailTemp);
        CurrPage.SentEmails.Page.AddBuffer(SentEmailTemp);
    end;


    var
        myInt: Integer;
        StyleExprTxt: Text;
        SalesRec: Record "Sales & Receivables Setup";

}