page 50050 KMK_ShipDates
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = KMK_ShippingDates;
    Caption = 'Shipping Dates';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(KMK_Shipping_Time; Rec.KMK_Shipping_Time)
                {
                    ToolTip = 'Specifies the value of the Shipping Time field.', Comment = '%';
                }
                field(KMK_Base_Calendar_Code; Rec.KMK_Base_Calendar_Code)
                {
                    ToolTip = 'Specifies the value of the Base Calendar Code field.', Comment = '%';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}