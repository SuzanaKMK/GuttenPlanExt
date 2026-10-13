page 50051 KMKAttachmentListFactbox
{
    Caption = 'Gutten Plan Images';
    PageType = ListPart;
    DeleteAllowed = false;
    DelayedInsert = true;
    InsertAllowed = false;
    SourceTable = KMK_ImagesAttachment;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec."File Name")
                {
                    Caption = 'Name';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the attached file.';
                    Width = 30;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(Rec."Web Url");
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenInDetail)
            {
                ApplicationArea = Basic, Suite;
                Image = ViewDetails;
                Caption = 'Show details';
                ToolTip = 'Open the document in detail.';

                trigger OnAction()
                var
                    KMK_ImagesAttachment: Record KMK_ImagesAttachment;
                begin
                    KMK_ImagesAttachment.Reset();
                    KMK_ImagesAttachment.SetRange("Table ID", Rec."Table ID");
                    KMK_ImagesAttachment.SetRange("No.", Rec."No.");
                    Page.Run(Page::KMK_ImageDetails, KMK_ImagesAttachment);
                end;
            }
            action(Upload)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Upload';
                ToolTip = 'Upload a document to SharePoint.';
                trigger OnAction()
                var
                    InS: InStream;
                    FileMgt: Codeunit "File Management";
                    FileName: Text[250];
                    UploadFileMsg: Label 'Please select the file to upload';
                    SharePointHandler: Codeunit KMK_FileHandler;
                begin
                    if UploadIntoStream(UploadFileMsg, '', '', FileName, InS) then
                        SharePointHandler.UploadFilesToSharePoint(Rec, FileName, FileMgt.GetFileNameMimeType(FileName), InS);
                end;
            }

            action(Delete)
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Delete';
                ToolTip = 'Delete a document in SharePoint.';
                trigger OnAction()
                var
                    SharePointHandler: Codeunit KMK_FileHandler;
                begin
                    SharePointHandler.DeleteFileInSharePoint(Rec);
                end;
            }
        }
    }
}