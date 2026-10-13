tableextension 50032 KMK_SalesShipHdr extends "Sales Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(50050; KMK_TotalCaseGrossWeight; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line".KMK_TotalGrossWeightCase WHERE("Document No." = FIELD("No.")));
            Caption = 'Total Gross Weight';

            DecimalPlaces = 0 : 5;
            Description = '002,005';
            Editable = False;
        }
        field(50051; KMK_TotalCaseNetWeight; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line".KMK_TotalNetWeightCase WHERE("Document No." = FIELD("No.")));
            Caption = 'Total Net Weight';

            DecimalPlaces = 0 : 5;
            Description = '002,005';
            Editable = False;
        }
        field(50054; KMK_TotalCaseQuantityItem; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line".Quantity WHERE("Document No." = FIELD("No."),
                                                                                                Type = CONST(Item),
                                                                                                "No." = FILTER(<> '')));
            Caption = 'Total Case Quantity';
            DecimalPlaces = 0 : 5;
            Description = '005';
            Editable = false;
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