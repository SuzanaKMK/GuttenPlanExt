table 50030 KMK_ImagesAttachment
{
    Caption = 'GuttenPlan Item Attachment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(4; "Attached Date"; DateTime)
        {
            Caption = 'Attached Date';
        }
        field(5; "File Name"; Text[250])
        {
            Caption = 'Attachment';
            NotBlank = true;
        }
        field(6; "File Extension"; Text[250])
        {
            Caption = 'File Extension';
        }
        field(7; "Mime Type"; Text[100])
        {
            Caption = 'Mime Type';
        }
        field(8; "SharePoint File ID"; Text[100])
        {
            Caption = 'SharePoint File ID';
        }
        field(9; "Web Url"; Text[1024])
        {
            Caption = 'Web URL';
            ExtendedDatatype = URL;
        }
        field(10; "Attached By"; Guid)
        {
            Caption = 'Attached By';
            Editable = false;
            TableRelation = User."User Security ID" where("License Type" = const("Full User"));
        }
        field(11; User; Code[50])
        {
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("Attached By"),
                                                         "License Type" = const("Full User")));
            Caption = 'User';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Table ID", "No.", ID)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Validate("Attached Date", CurrentDateTime);
        if IsNullGuid("Attached By") then
            "Attached By" := UserSecurityId();
    end;

    procedure GetLastID(): Integer;
    var
        ZYSharePointAttachment: Record KMK_ImagesAttachment;
    begin
        ZYSharePointAttachment.SetCurrentKey(ID);
        ZYSharePointAttachment.Ascending();
        if ZYSharePointAttachment.FindLast() then
            exit(ZYSharePointAttachment.ID)
        else
            exit(0);
    end;
}