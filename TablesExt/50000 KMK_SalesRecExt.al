tableextension 50000 KMK_SalesRecExt extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; KMK_PickupBackhaulResource; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Pickup Backhaul Resource';
            TableRelation = Resource;
            Description = '001';
        }
        field(50001; KMK_SalesOrderWeightLimit; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Order Weight Limit';
            Description = '002';
        }
        field(50002; KMK_BOLReportNo; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = CONST(Report));
            Caption = 'BOL Report No.';
            Description = '002';
        }
        field(50003; KMK_BOLReportCaption; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field(KMK_BOLReportNo)));
            Caption = 'BOL Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; KMK_BOLReportFolder; Text[250])
        {

            Caption = 'BOL Report Folder';
            Editable = true;

        }
        field(50005; KMK_SaveTemp; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; KMK_ShareDriveLink; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50031; KMK_GUIUserID; Text[50])
        {
            Caption = 'GUI User ID';
            DataClassification = ToBeClassified;

        }
        field(50032; KMK_UseOnHold; Boolean)
        {
            Caption = 'Use On Hold';
            DataClassification = ToBeClassified;
        }
        field(50101; "KMK_APIUserID"; Guid)
        {
            Caption = 'GUI API User ID';
        }
        field(50110; "KMK_EDIUserID"; Guid)
        {
            Caption = 'EDI User ID';
        }


    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}