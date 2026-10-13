tableextension 50004 KMK_ItemExt extends Item
{
    fields
    {
        // Add changes to table fields here


        field(50052; KMK_Pan_Layout; MediaSet)
        {
            DataClassification = ToBeClassified;
            Caption = 'Pan Layout';

            Description = '002';
        }
        field(50053; KMK_OrderMultipleQty; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '003';
            Caption = 'Order Multiple Qty,';
        }
        field(50060; KMK_SeasonalAvailability; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '004';
            Caption = 'Seasonal Availability ';
        }
        field(50061; KMK_StartDate; Date)
        {
            DataClassification = ToBeClassified;
            Description = '004';
            Caption = ' Start Date';
        }
        field(50062; KMK_EndDate; Date)
        {
            DataClassification = ToBeClassified;
            Description = '004';
            Caption = 'End Date';
        }

        field(50071; KMK_ShelfLifeDays; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '005';
            Caption = 'Shelf Life (Days) ';
        }
        field(50072; KMK_GuaranteeLifeDays; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '005';
            Caption = 'Guarantee Life (Days)';
            editable = false;
        }
        field(50073; KMK_PiecesperCase; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '005';
            Caption = 'Pieces per Case';
        }
        field(50074; KMK_MoldedPieceWeightOz; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Captioned Moulded Weight';
            Caption = 'Molded/Piece Weight (Oz.) ';
        }
        field(50075; KMK_NetWeightCase; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '005';
            Caption = 'Net Weight (Case)';
            trigger OnValidate()
            var
            begin
                if rec.KMK_NetWeightCase <> xRec.KMK_NetWeightCase then
                    rec.validate("Net Weight", Round(rec.KMK_NetWeightCase, 0.01, '='));
            end;

        }

        field(50077; KMK_GrossWeight; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Captioned Gross Weight';
            Caption = 'Gross Weight (Case)';

            trigger OnValidate()
            var
            begin
                if rec.KMK_GrossWeight <> xRec.KMK_GrossWeight then
                    rec.validate("Gross Weight", Round(rec.KMK_GrossWeight, 0.01, '='));
            end;

        }
        field(50078; KMK_PieceWeightActual; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Actual piece weight in Oz.';
            Caption = 'Piece Weight/Actual';
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