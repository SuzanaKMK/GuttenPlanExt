tableextension 50007 KMK_SalesHeaderExt extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50055; KMK_TotalWeightLimit; Text[20])
        {
            Caption = 'Total Weight Limit';
            DataClassification = ToBeClassified;
            Description = '002';
        }
        field(50056; KMK_ShipperSignature; Text[50])
        {
            Caption = 'Shipper Signature ';
            DataClassification = ToBeClassified;
            Description = '003';
        }

        field(50050; KMK_TotalCaseGrossWeight; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".KMK_TotalGrossWeightCase WHERE("Document Type" = FIELD("Document Type"),
                                            "Document No." = FIELD("No.")));
            Caption = 'Total Gross Weight';

            DecimalPlaces = 0 : 5;
            Description = '002,005';
            Editable = False;
        }
        field(50051; KMK_TotalCaseNetWeight; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".KMK_TotalNetWeightCase WHERE("Document Type" = FIELD("Document Type"),
                                                                        "Document No." = FIELD("No.")));
            Caption = 'Total Net Weight';

            DecimalPlaces = 0 : 5;
            Description = '002,005';
            Editable = False;
        }



        field(50054; KMK_TotalCaseQuantityItem; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = FIELD("Document Type"),
                                                                                                "Document No." = FIELD("No."),
                                                                                                Type = CONST(Item),
                                                                                                "No." = FILTER(<> '')));
            Caption = 'Total Case Quantity';
            DecimalPlaces = 0 : 5;
            Description = '005';
            Editable = false;
        }
        field(50060; KMK_BOLPrinted; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'BOL Printed';
            Description = '004';
        }
        field(50061; KMK_ZoneServiceCode; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address"."Service Zone Code" where("Customer No." = field("Bill-to Customer No."),
                                Code = field("Ship-to Code")));
            Caption = 'Zone Service Code';
        }
        field(50062; KMK_DocumentSendingProfile; Text[20])
        {
            FieldClass = FlowField;
            Caption = 'Document Sending Profile';
            CalcFormula = Lookup(Customer."Document Sending Profile" WHERE("No." = field("Sell-to Customer No.")));
        }
        field(50063; KMK_EmailSent; Boolean)
        {
            Caption = 'Confirmation Email';

            FieldClass = FlowField;
            CalcFormula = exist("Email Related Record" where("Table Id" = const(Database::"Sales Header"),
                                                                           "System Id" = field(SystemId)));
        }

        modify("Shipment Date")
        {
            trigger OnBeforeValidate()
            var
            begin
                HideValidationDialog := true;
            end;
        }

        modify("Shipping Agent Code")
        {
            trigger OnBeforeValidate()
            var
            begin
                HideValidationDialog := true;
            end;
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

    procedure GetStatusStyleText_KMK() StatusStyleText: Text
    var
        recSR: Record "Sales & Receivables Setup";
    begin
        recSR.Reset();
        recSR.Get();
        rec.CalcFields(KMK_TotalCaseGrossWeight);
        if rec.KMK_TotalCaseGrossWeight <= recSR.KMK_SalesOrderWeightLimit then begin
            rec.KMK_TotalWeightLimit := '0K';
            StatusStyleText := 'Favorable';
        end
        else begin
            rec.KMK_TotalWeightLimit := 'Over the limit';
            StatusStyleText := 'Unfavorable';
        end;
    end;

    var
        myInt: Integer;
}