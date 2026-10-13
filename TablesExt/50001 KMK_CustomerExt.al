tableextension 50001 KMK_CustomerExt extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50050; KMK_BHAllowancePerCase; Decimal)
        {
            Caption = 'BH Allowance $/case';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 3;
            BlankZero = true;
            Description = '001';
        }

        field(50052; KMK_SalesServiceAllowancePer; Decimal)
        {
            Caption = 'Sales Service Allowance (%)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;
        }

        field(50053; KMK_EDIASNRequired; Boolean)
        {
            Caption = 'EDI ASN Required';
            DataClassification = ToBeClassified;

            InitValue = false;
        }
        field(50051; KMK_MinOrderQtycases; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Min. Order Qty. (cases)';
            Description = '001';
        }
        field(50055; KMK_ExtDocDupAllowed; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ext. Doc. Duplicate Allowed';

        }
        field(50056; KMK_OnHold; Boolean)
        {
            Caption = 'On Hold';
            DataClassification = ToBeClassified;

        }
        field(50057; KMK_OnHoldDate; Date)
        {
            Caption = 'On Hold Date';
            DataClassification = ToBeClassified;

        }
        /* field(50054; KMK_SlipSheet; Boolean)
        {
            Caption = 'Slip Sheet';
            DataClassification = ToBeClassified;
            Description = 'Slip sheet required on mixed pallets';
        }
        field(50055; KMK_TempTale; Enum Customer_TempTale)
        {
            Caption = 'TempTale required on orders';
            DataClassification = ToBeClassified;
            Description = 'TempTale required on orders';
        } */


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