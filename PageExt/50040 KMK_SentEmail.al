page 50040 "Sent Emails for Document"
{
    Caption = 'Sent Emails for Document';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sent Email";
    SourceTableTemporary = true;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    CardPageId = "Email Viewer";
    layout
    {
        area(Content)
        {
            field("Mail Id"; 'Sent: ' + Format(Rec.SystemModifiedAt))
            {
                Caption = 'Mail';
                ApplicationArea = All;
            }
        }
    }
    procedure AddBuffer(var SentEmailTemp: Record "Sent Email" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Rec.Copy(SentEmailTemp, true);
        CurrPage.Update();
    end;
}