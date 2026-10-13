pageextension 50011 KMK_SalesOrderSubExt extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {

            field(KMK_PriceDiscrepancyExists; Rec.KMK_PriceDiscrepancyExists)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Discrepancy Exists field.', Comment = '%';
                Editable = false;
                Visible = false;
            }
        }
        addbefore(Quantity)
        {

            field(KMK_GUIDescription; Rec.KMK_GUIDescription)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GUI Description field.', Comment = '%';
            }

            field(KMK_NetWeightCase; Rec.KMK_NetWeightCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Weight (Case) field.', Comment = '%';
                Visible = false;
                trigger OnValidate()
                var
                begin
                    DeltaUpdateTotals();
                end;



            }
            field(KMK_GrossWeightCase; Rec.KMK_GrossWeightCase)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gross Weight (Case) field.', Comment = '%';
                Visible = false;
                trigger OnValidate()
                var
                begin
                    DeltaUpdateTotals();
                end;

            }

        }

        addafter("Amount Including VAT")
        {

            field(KMK_AmountperCaseDiscount; Rec.KMK_AmountperCaseDiscount)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the $ per Case Discount field.', Comment = '%';
            }
        }



        addlast(Control28)
        {
            field(KMK_TotalCaseGrossWeight; recSalesHdr.KMK_TotalCaseGrossWeight)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Gross Weight field.', Comment = '%';
                Editable = false;
                Caption = 'Total Gross Weight';


            }
            field(KMK_TotalCaseQuantityItem; recSalesHdr.KMK_TotalCaseQuantityItem)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Case Quantity field.', Comment = '%';
                Editable = false;
                Caption = 'Total Case Quantity';
            }

            field(KMK_TotalWeightLimit; recSalesHdr.KMK_TotalWeightLimit)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Weight Limit field.', Comment = '%';
                StyleExpr = StyleExprTxt;
                Editable = false;
                Caption = 'Total Weight Limit';

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetCurrRecord()
    begin
        StyleExprTxt := GetStatusStyleText();
    end;

    trigger OnAfterGetRecord()

    begin
        StyleExprTxt := GetStatusStyleText();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StyleExprTxt := GetStatusStyleText();
    end;

    trigger OnDeleteRecord(): Boolean
    begin

    end;

    trigger OnModifyRecord(): Boolean
    var
    begin
        StyleExprTxt := GetStatusStyleText();
    end;





    var
        myInt: Integer;
        StyleExprTxt: Text;
        recSalesHdr: Record "Sales Header";


    procedure GetStatusStyleText() StatusStyleText: Text
    var
        recSR: Record "Sales & Receivables Setup";
    begin
        recSR.Reset();
        recSR.Get();
        if not recSalesHdr.get(rec."Document Type", Rec."Document No.") then
            recSalesHdr.Init()
        else begin
            recSalesHdr.CalcFields(KMK_TotalCaseGrossWeight, KMK_TotalCaseQuantityItem);
            if recSalesHdr.KMK_TotalCaseGrossWeight <= recSR.KMK_SalesOrderWeightLimit then begin
                recSalesHdr.KMK_TotalWeightLimit := '0K';
                StatusStyleText := 'Favorable';
            end
            else begin
                recSalesHdr.KMK_TotalWeightLimit := 'Over the limit';
                StatusStyleText := 'Unfavorable';
            end;
        end;
    end;
}