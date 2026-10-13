tableextension 50006 KMK_SalesLineExt extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50050; KMK_NetWeightCase; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Net Weight (Case)';
            Description = '001';

            trigger OnValidate()
            var
            begin
                rec.KMK_TotalNetWeightCase := Rec.Quantity * rec.KMK_NetWeightCase;

            end;

        }
        field(50051; KMK_GrossWeightCase; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Gross Weight (Case)';
            Description = '001';

            trigger OnValidate()
            var
            begin

                Rec.KMK_TotalGrossWeightCase := Rec.Quantity * rec.KMK_GrossWeightCase;

            end;
        }

        field(50052; KMK_TotalNetWeightCase; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Net Weight (Case)';
            Description = '001';
        }
        field(50053; KMK_TotalGrossWeightCase; Decimal)
        {
            Caption = 'Total Gross Weight (Case)';
            DataClassification = ToBeClassified;
            Description = '001';
        }
        field(50054; KMK_TotalItemCaseQty; Decimal)
        {

            Caption = 'Total Item Case Qty.';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = FIELD("Document Type"),
                                                                                                "Document No." = FIELD("Document No."),
                                                                                                Type = CONST(Item)));

            Description = '002';
            Editable = false;
        }

        field(50060; KMK_AmountperCaseDiscount; Decimal)
        {
            Caption = '$ per Case Discount';
            DataClassification = ToBeClassified;
            Description = '003';
        }
        field(50070; KMK_PackSize; Decimal)
        {
            Caption = 'Pack Size';

            FieldClass = FlowField;
            CalcFormula = Lookup(Item.KMK_PiecesperCase WHERE("No." = FIELD("No.")));

            Description = 'Pieces per case for TrueCommerce';
            Editable = false;
        }
        field(50100; KMK_GUIDescription; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = '004';
            Caption = 'GUI Description';
        }
        field(50105; "GUI User ID"; Text[50]) { DataClassification = ToBeClassified; }

        field(50114; "GUI Type"; Text[50]) { DataClassification = ToBeClassified; }
        field(50115; "GUI Time of Action"; DateTime) { DataClassification = ToBeClassified; }
        field(50120; "GUI Pallet"; Text[10]) { DataClassification = ToBeClassified; }
        field(50125; "GUI-to-BC Entry No"; Integer) { DataClassification = ToBeClassified; }
        field(50130; "KMK_PriceDiscrepancyExists"; Boolean)
        {
            Caption = 'Price Discrepancy Exists';
            DataClassification = ToBeClassified;
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

    procedure GetStatusStyleText_KMK() StatusStyleText: Text
    var
        recSR: Record "Sales & Receivables Setup";
        recSalesHdr: Record "Sales Header";
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