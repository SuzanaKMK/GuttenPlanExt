pageextension 50004 KMK_InventorySetupetx extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here

        addlast(content)
        {
            group(GuttenPlan)
            {
                Caption = 'GuttenPlan';



                field(KMK_SafetyFactor; Rec.KMK_SafetyFactor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Safety Factor field.', Comment = '%';
                }
                field(KMK_PalletFactor; Rec.KMK_PalletFactor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pallet Factor field.', Comment = '%';
                }
                field(KMK_LinerCaseWeight; Rec.KMK_LinerCaseWeight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Liner + Case Weight field.', Comment = '%';
                }
                field(KMK_DefDryWhsLocation; Rec.KMK_DefDryWhsLocation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Dry Whs. Location field.', Comment = '%';
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