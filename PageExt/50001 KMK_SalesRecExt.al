pageextension 50001 KMK_SaLesRecExt extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(content)
        {
            group(GuttenPlan)
            {
                Caption = 'GuttenPlan';

                field(KMK_UseOnHold; Rec.KMK_UseOnHold)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Use On Hold field.', Comment = '%';
                }

                field(KMK_GUIUserID; Rec.KMK_GUIUserID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GUI User ID field.', Comment = '%';
                    Visible = false;
                }
                field(KMK_APIUserID; Rec.KMK_APIUserID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GUI API User ID field.', Comment = '%';
                }
                field(KMK_EDIUserID; Rec.KMK_EDIUserID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI User ID field.', Comment = '%';
                }



                field(KMK_PickupBackhaulResource; Rec.KMK_PickupBackhaulResource)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pickup Backhaul Resource field.', Comment = '%';
                }

                field(KMK_SalesOrderWeightLimit; Rec.KMK_SalesOrderWeightLimit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Weight Limit field.', Comment = '%';
                }
                field(KMK_BOLReportNo; Rec.KMK_BOLReportNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOL Report No. field.', Comment = '%';
                }
                field(KMK_BOLReportCaption; Rec.KMK_BOLReportCaption)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOL Report Caption field.', Comment = '%';
                }
                field(KMK_BOLReportFolder; Rec.KMK_BOLReportFolder)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOL Report Folder field.', Comment = '%';

                }
                field(KMK_SaveTemp; Rec.KMK_SaveTemp)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the KMK_SaveTemp field.', Comment = '%';
                }

                field(KMK_ShareDriveLink; Rec.KMK_ShareDriveLink)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the web folder field.', Comment = '%';
                }


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