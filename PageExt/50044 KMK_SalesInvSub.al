pageextension 50044 KMK_SalesInvSubExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here

        addlast(Control1)
        {

            field("GUI Type"; Rec."GUI Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GUI Type field.', Comment = '%';
            }
            field("GUI Pallet"; Rec."GUI Pallet")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GUI Pallet field.', Comment = '%';
            }
            field("GUI User ID"; Rec."GUI User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GUI User ID field.', Comment = '%';
            }
            field("GUI Time of Action"; Rec."GUI Time of Action")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GUI Time of Action field.', Comment = '%';
            }
            field(KMK_GUIDescription; Rec.KMK_GUIDescription)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GUI Description field.', Comment = '%';
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