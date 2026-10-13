codeunit 50051 KMK_GuttenPlan_Sale
{
    trigger OnRun()
    begin

    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Sell-to Customer No.', false, false)]
    local procedure UpdateShippingTime(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
        ShipToCode: Record "Ship-to Address";
    begin
        if rec."Ship-to Code" <> xRec."Ship-to Code" then
        // is there shipping time on ship-to code
        begin
            ShipToCode.Reset();
            ShipToCode.setrange("Customer No.", rec."Sell-to Customer No.");
            ShipToCode.SetRange(code, rec."Ship-to Code");
            if ShipToCode.FindFirst() then begin
                if format(ShipToCode.KMK_ShippingTime) <> '' then
                    rec.Validate("Shipping Time", ShipToCode.KMK_ShippingTime);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'External Document No.', false, false)]
    local procedure UpdateShipDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
    begin
        //>>     ClearShipDate(Rec);
    end;

    //OnBeforeMessageIfSalesLinesExist

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeMessageIfSalesLinesExist, '', false, false)]
    local procedure ShipAgentChangeNoUpdateLines(var SalesHeader: Record "Sales Header"; ChangedFieldCaption: Text; var IsHandled: Boolean)
    var
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (ChangedFieldCaption = SalesHeader.FieldCaption("Shipping Agent Code")) then
            IsHandled := true;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict, '', false, false)]
    local procedure ShouldConfimDate(var SalesHeader: Record "Sales Header"; ChangedFieldNo: Integer; var ShouldConfirmReservationDateConflict: Boolean)
    var
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (ChangedFieldNo = SalesHeader.FieldNo("Shipment Date")) then
            ShouldConfirmReservationDateConflict := true;
    end;

    /*   [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Shipping Agent Code', false, false)]
      local procedure RolleBackShippingTime(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
      var
      begin
          if Rec."Shipping Time" <> xRec."Shipping Time" then
             Rec."Shipping Time":= xRec."Shipping Time";
      end; */

    //OnBeforeGetShippingTime

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeGetShippingTime, '', false, false)]
    local procedure OnBeforeGetShippingTime(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var CalledByFieldNo: Integer; var IsHandled: Boolean; CurrentFieldNo: Integer)
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (CalledByFieldNo = SalesHeader.FieldNo("Shipping Agent Code")) then
            IsHandled := true;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Ship-to Code', false, false)]
    local procedure UpdateShipTime(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
        ShipToCode: Record "Ship-to Address";
    begin
        if rec."Ship-to Code" <> xRec."Ship-to Code" then
        // is there shipping time on ship-to code
        begin
            ShipToCode.Reset();
            ShipToCode.setrange("Customer No.", rec."Sell-to Customer No.");
            ShipToCode.SetRange(code, rec."Ship-to Code");
            if ShipToCode.FindFirst() then begin
                if format(ShipToCode.KMK_ShippingTime) <> '' then
                    rec.Validate("Shipping Time", ShipToCode.KMK_ShippingTime);
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
    local procedure UpdateCaseWeight(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recItem: Record Item;
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            recItem.Reset();
            if not recItem.Get(Rec."No.") then
                recItem.Init()
            else begin
                rec.validate(KMK_NetWeightCase, recItem.KMK_NetWeightCase);
                Rec.validate(KMK_GrossWeightCase, recItem.KMK_GrossWeight);

            end;

        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Price", OnAfterValidateEvent, 'Item No.', false, false)]
    local procedure UpdateDesc(var Rec: Record "Sales Price"; var xRec: Record "Sales Price"; CurrFieldNo: Integer)
    var
        recItem: Record Item;
    begin

        recItem.Reset();
        if not recItem.Get(Rec."Item No.") then
            recItem.Init()
        else begin
            rec.KMK_ItemDescription := recItem.Description;

        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'KMK_AmountperCaseDiscount', false, false)]
    local procedure UpdateLineDiscAmt(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var

    begin
        if xRec.KMK_AmountperCaseDiscount <> rec.KMK_AmountperCaseDiscount then begin
            rec.GetSalesHeader();
            rec.TestStatusOpen();
            rec.validate(rec."Line Discount Amount", (rec.Quantity * rec.KMK_AmountperCaseDiscount));

        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Quantity', false, false)]
    local procedure UpdateLineDiscAmtQty(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
    begin
        if xRec.Quantity <> rec.Quantity then begin
            rec.GetSalesHeader();
            rec.TestStatusOpen();
            rec.validate(rec."Line Discount Amount", (rec.Quantity * rec.KMK_AmountperCaseDiscount));

        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Quantity', false, false)]
    local procedure UpdateTotalCaseWeight(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recItem: Record Item;
        Shdr: Record "Sales Header";
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            recItem.Reset();
            if not recItem.Get(Rec."No.") then
                recItem.Init()
            else begin
                rec.KMK_NetWeightCase := recItem.KMK_NetWeightCase;
                Rec.KMK_GrossWeightCase := recItem.KMK_GrossWeight;
                rec.KMK_TotalNetWeightCase := Rec.Quantity * recItem.KMK_NetWeightCase;
                Rec.KMK_TotalGrossWeightCase := Rec.Quantity * recItem.KMK_GrossWeight;
            end;



        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeGetEmailSubject', '', false, false)]
    local procedure MyProcedure(var EmailSubject: Text[250]; PostedDocNo: Code[20]; ReportUsage: Integer; var IsHandled: Boolean)
    var
        ReportUsageEnum: Enum "Report Selection Usage";
        SalesHdr: Record "Sales Header";
        SalesInv: Record "Sales Invoice Header";
    begin
        // Convert ReportUsage from Integer to Enum

        // find the Ext.Doc No

        ReportUsageEnum := "Report Selection Usage".FromInteger(ReportUsage);
        // Check if ReportUsage is "S.Order"
        if ReportUsageEnum = ReportUsageEnum::"S.Order" then begin
            SalesHdr.Reset();
            if Not SalesHdr.Get(SalesHdr."Document Type"::Order, PostedDocNo) then SalesHdr.Init();

            // Customize the email subject for "S.Quote"
            EmailSubject := 'Confirmation - ' + SalesHdr."Sell-to Customer Name" + ' - ' + SalesHdr."External Document No." + ' - ' + PostedDocNo;
            IsHandled := true;
        end;

        if ReportUsageEnum = ReportUsageEnum::"S.Invoice" then begin
            SalesInv.Reset();
            if Not SalesInv.Get(PostedDocNo) then SalesInv.Init();

            // Customize the email subject for "S.Quote"
            EmailSubject := 'Invoice - ' + SalesInv."Sell-to Customer Name" + ' - ' + SalesInv."External Document No." + ' - ' + SalesInv."Order No.";
            IsHandled := true;
        end;

    end;



    //Sales Price Calc. Mgt.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", OnAfterFindSalesLineLineDisc, '', false, false)]
    local procedure OnAfterFindSalesLineLineDisc(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var SalesLineDiscount: Record "Sales Line Discount")
    var
        IsHandled_KMK: Boolean;
    begin
        IsHandled_KMK := false;

        if not IsHandled_KMK then
            if SalesLine.Type = SalesLine.Type::Item then begin
                SetUoM_KMK(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");
                SalesLineLineDiscExists_KMK(SalesHeader, SalesLine, false);
                CalcBestLineDisc_KMK(TempSalesLineDisc);
                SalesLine."Line Discount %" := TempSalesLineDisc."Line Discount %";
                SalesLine.validate(KMK_AmountperCaseDiscount, TempSalesLineDisc.KMK_DiscountPerCase);
            end;

    end;

    // MAin Released Documet
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure UpdateOnRelease(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        SRSetup: Record "Sales & Receivables Setup";
        User: Record User;
    begin
        SRSetup.Reset();
        SRSetup.Get();

        User.Reset();
        User.SetRange("User Name", UserId);
        if not User.FindFirst() then User.Init();


        if SRSetup.KMK_APIUserID <> User."User Security ID" then begin

            OnHoldOrder(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            ShipAgent(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            ShipToMinQty(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            //      ShipToMinWeight(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            ShipmnetDateBlank(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            ShipDateMismatch(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            SOWeightLimit(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            SeasonItem(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            OrderMultiple(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            ExtDocNo(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
            if SRSetup.KMK_EDIUserID <> User."User Security ID" then
                UpdateSalesPrice(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);
        end;
        AddBHLine(SalesHeader, PreviewMode, IsHandled, SkipCheckReleaseRestrictions, SkipWhseRequestOperations);

    end;

    //block for main  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure ShipToCode(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        ShipTo: Record "Ship-to Address";
        KMK_MEssage: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin

            if SalesHeader."Ship-to Code" = '' then begin

                KMK_MEssage := StrSubstNo('Please select Ship-to Code for sales order %1', SalesHeader."No.");
                error(KMK_MEssage);
            end;
        end;
    end;


    local procedure ShipAgent(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        KMK_MEssage: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin

            if SalesHeader."Shipping Agent Code" = '' then begin

                KMK_MEssage := StrSubstNo('Please select Shipping Agent for sales order %1', SalesHeader."No.");
                error(KMK_MEssage);
            end;
        end;
    end;

    local procedure OnHoldOrder(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        KMK_MEssage: Text;
        Customer: Record Customer;
        SRSetup: Record "Sales & Receivables Setup";
    begin


        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SRSetup.Reset();
            SRSetup.Get();
            If SRSetup.KMK_UseOnHold then begin
                Customer.Reset();
                if Customer.get(SalesHeader."Sell-to Customer No.") then begin
                    if (Customer.KMK_OnHold) and (Customer.KMK_OnHoldDate <> 0D) then begin
                        if SalesHeader."Order Date" >= Customer.KMK_OnHoldDate then begin

                            KMK_MEssage := StrSubstNo('Customer is On-Hold for New Orders as of %1', format(Customer.KMK_OnHoldDate));
                            error(KMK_MEssage);
                        end;
                    end;
                end;
            end;
        end;
    end;


    //block for main  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure ShipToMinQty(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        ShipTo: Record "Ship-to Address";
        KMK_MEssage: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader.CalcFields(KMK_TotalCaseQuantityItem);
            if SalesHeader."Ship-to Code" <> '' then begin
                ShipTo.Reset();
                if not ShipTo.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
                    ShipTo.Init()
                else
                    if SalesHeader.KMK_TotalCaseQuantityItem < ShipTo.KMK_MinOrderQtycases then begin
                        KMK_MEssage := StrSubstNo('Ship-to Address Minimum Order Qty %1 is not met by Current Order Total %2.Do you wish to continue?', ShipTo.KMK_MinOrderQtycases, SalesHeader.KMK_TotalCaseQuantityItem);
                        if not Confirm(KMK_MEssage, true) then IsHandled := true;
                    end;
            end;


        end;
    end;

    //block for main   [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure ShipToMinWeight(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        ShipTo: Record "Ship-to Address";
        KMK_MEssage: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader.CalcFields(KMK_TotalCaseQuantityItem);
            if SalesHeader."Ship-to Code" <> '' then begin
                ShipTo.Reset();
                if not ShipTo.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
                    ShipTo.Init()
                else
                    if SalesHeader.KMK_TotalCaseQuantityItem < ShipTo.KMK_MinOrderQtycases then begin
                        KMK_MEssage := StrSubstNo('Ship-to Address Minimum Order Qty %1 is not met by Current Order Total %2.Do you wish to continue?', ShipTo.KMK_MinOrderQtycases, SalesHeader.KMK_TotalCaseQuantityItem);
                        if not Confirm(KMK_MEssage, true) then IsHandled := true;
                    end;
            end;
        end;
    end;


    //block for Main  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure ShipmnetDateBlank(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        KMK_MEssage: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin

            if SalesHeader."Shipment Date" = 0D then
                Error('Shipment Date can not be blank for sales Order %1', SalesHeader."No.");

        end;
    end;

    local procedure ShipDateMismatch(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        KMK_MEssage: Text;
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin

            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindSet() then begin
                if SalesLine."Shipment Date" <> SalesHeader."Shipment Date" then
                    Error('Shipment Date on one or more lines is different from sales Order Shipment Date %1', SalesHeader."Shipment Date");
            end;

        end;
    end;

    //block for Main   [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure SOWeightLimit(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        recSalesRec: Record "Sales & Receivables Setup";
        KMK_Message: Text;
    begin
        recSalesRec.Reset();
        recSalesRec.Get();
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader.CalcFields(KMK_TotalCaseGrossWeight);


            if SalesHeader.KMK_TotalCaseGrossWeight > recSalesRec.KMK_SalesOrderWeightLimit then begin
                KMK_MEssage := StrSubstNo('Total Gross Weight per SO  %1 is Over the Limit.', SalesHeader."No.");
                if not Confirm(KMK_MEssage, true) then IsHandled := true;
            end;
        end;
    end;


    //block for Main    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure SeasonItem(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        Item: Record Item;
        KMK_Messages: List of [Text];
        KMK_Message: Text;
        SLine: Record "Sales Line";
        TypeHelper: Codeunit "Type Helper";
        MessageTxt: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SLine.Reset();
            SLine.SetRange("Document No.", SalesHeader."No.");
            SLine.SetRange("Document Type", SalesHeader."Document Type");
            SLine.SetRange(Type, SLine.Type::Item);
            SLine.SetFilter(Quantity, '<>%1', 0);
            if SLine.FindSet() then
                repeat
                    Item.Reset();
                    If Item.Get(SLine."No.") then begin
                        if Item.KMK_SeasonalAvailability and ((SLine."Shipment Date" < Item.KMK_StartDate) or (SLine."Shipment Date" > Item.KMK_EndDate)) then begin
                            if KMK_Message = '' then
                                KMK_Message := StrSubstNo('Item No. %1 is a Seasonal Product available from %2 to %3', Item."No.", FORMAT(Item.KMK_StartDate), Format(Item.KMK_EndDate))
                            else
                                KMK_Message := KMK_Message + '\' + StrSubstNo('Item No. %1 is a Seasonal Product available from %2 to %3', Item."No.", FORMAT(Item.KMK_StartDate), Format(Item.KMK_EndDate));
                        end;

                    end;
                until SLine.Next() = 0;
            if KMK_Message <> '' then begin
                KMK_Messages := KMK_Message.Split(TypeHelper.LFSeparator());
                foreach KMK_Message in KMK_Messages do MessageTxt := '\' + KMK_Message;
                if MessageTxt <> '' then begin
                    IsHandled := true;
                    Message(MessageTxt);
                end;
            end;
        end;
    end;

    //block for Main [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure OrderMultiple(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        Item: Record Item;
        KMK_Messages: List of [Text];
        KMK_Message: Text;
        SLine: Record "Sales Line";
        TypeHelper: Codeunit "Type Helper";
        MessageTxt: Text;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SLine.Reset();
            SLine.SetRange("Document No.", SalesHeader."No.");
            SLine.SetRange("Document Type", SalesHeader."Document Type");
            SLine.SetRange(Type, SLine.Type::Item);
            SLine.SetFilter(Quantity, '<>%1', 0);
            if SLine.FindSet() then
                repeat
                    Item.Reset();
                    Item.SetRange("No.", SLine."No.");
                    Item.SetFilter(KMK_OrderMultipleQty, '<>%1', 0);
                    If Item.FindFirst() then begin
                        if SLine.Quantity Mod Item.KMK_OrderMultipleQty <> 0 then begin
                            if KMK_Message = '' then
                                KMK_Message := StrSubstNo('Item No. %1 - Order Multiple %2 is not met by Qty = (%3)', Item."No.", FORMAT(Item.KMK_OrderMultipleQty), Format(Sline.Quantity))
                            else
                                KMK_Message := KMK_Message + '\' + StrSubstNo('Item No. %1 - Order Multiple %2 is not met by Qty = (%3)', Item."No.", FORMAT(Item.KMK_OrderMultipleQty), Format(Sline.Quantity));
                        end;

                    end;
                until SLine.Next() = 0;
            if KMK_Message <> '' then begin
                KMK_Message := KMK_Message + '\' + 'Do you wish to continue?';
                KMK_Messages := KMK_Message.Split(TypeHelper.LFSeparator());
                foreach KMK_Message in KMK_Messages do MessageTxt := '\' + KMK_Message;
                if not Confirm(MessageTxt, true) then
                    IsHandled := true;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterValidateEvent, "Shipment Method Code", false, false)]
    local procedure CheckBHAllowance(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recShipmentMethod: Record "Shipment Method";
    begin
        if xRec."Shipment Method Code" <> Rec."Shipment Method Code" then begin
            recShipmentMethod.Reset();
            if recShipmentMethod.get(rec."Shipment Method Code") then begin
                if recShipmentMethod.KMK_BHNo <> '' then
                    rec.TestField(KMK_BHAllowancePerCase);
            end;
        end;

    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "Unit Price", false, false)]
    local procedure CheckSalesPrice(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        PriceAmount: Decimal;
        SalesHeader: Record "Sales Header";
        PriceType: Enum "Price Type";
        AmountType: Enum "Price Amount Type";
    begin
        /* SalesHeader.Get(Rec."Document Type", Rec."Document No.");

        PriceAmount := KMK_FindSalesLinePrice(SalesHeader, Rec, CurrFieldNo);

        // Compare with current Unit Price on the sales line
        if (Rec."Unit Price" <> PriceAmount) then
            Rec.KMK_PriceDiscrepancyExists := true;
        Rec.Modify(); */
        UpdatePriceIsDifferent(Rec);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure OnAfterValidateUnitPrice(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        UpdatePriceIsDifferent(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        UpdatePriceIsDifferent(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        UpdatePriceIsDifferent(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Variant Code', false, false)]
    local procedure OnAfterValidateVariant(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        UpdatePriceIsDifferent(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit of Measure Code', false, false)]
    local procedure OnAfterValidateUoM(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        UpdatePriceIsDifferent(Rec);
    end;


    //block for Main [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure AddBHLine(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        recShipmentMethod: Record "Shipment Method";
        SLine: Record "Sales Line";
        BHSalesLine: Record "Sales Line";
        NextLineNo: Integer;
        Customer: Record Customer;
        SHdr: Record "Sales Header";
        DocumentTotals: Codeunit "Document Totals";
        SalesLine: Record "Sales Line";
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
    begin

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            //check shipment method
            SalesHeader.CalcFields(KMK_TotalCaseQuantityItem);
            recShipmentMethod.Reset();
            if recShipmentMethod.get(SalesHeader."Shipment Method Code") then begin
                if recShipmentMethod.KMK_BHNo <> '' then begin
                    Customer.Reset();
                    If not Customer.Get(SalesHeader."Sell-to Customer No.") then Customer.Init();
                    //does Sline for BH exist
                    SLine.Reset();
                    SLine.SetRange("Document No.", SalesHeader."No.");
                    SLine.SetRange("Document Type", SalesHeader."Document Type");
                    SLine.SetRange(Type, recShipmentMethod.KMKType);
                    SLine.SetRange("No.", recShipmentMethod.KMK_BHNo);
                    if not SLine.FindFirst() then begin
                        SLine.Reset();
                        SLine.SetRange("Document No.", SalesHeader."No.");
                        SLine.SetRange("Document Type", SalesHeader."Document Type");
                        if Sline.FindLast() then
                            NextLineNo := SLine."Line No." + 10000
                        else
                            NextLineNo := 10000;
                        BHSalesLine.Init();
                        BHSalesLine."Document Type" := SalesHeader."Document Type";
                        BHSalesLine."Document No." := SalesHeader."No.";
                        BHSalesLine."Line No." := NextLineNo;
                        BHSalesLine.Insert(true);
                        BHSalesLine.Validate(Type, recShipmentMethod.KMKType);
                        BHSalesLine.Validate("No.", recShipmentMethod.KMK_BHNo);
                        BHSalesLine.Validate(Quantity, -1);
                        BHSalesLine.Validate("Unit Price", SalesHeader.KMK_TotalCaseQuantityItem * Customer.KMK_BHAllowancePerCase);
                        BHSalesLine.Modify(true);

                    end else begin

                        Sline.Validate(Quantity, -1);


                        Sline.Validate("Unit Price", SalesHeader.KMK_TotalCaseQuantityItem * Customer.KMK_BHAllowancePerCase);

                        Sline.Modify(true);

                    end;

                end
            end;
        end;
        // Prepare totals records
        TotalSalesHeader := SalesHeader;
        TotalSalesLine.Reset();
        TotalSalesLine.Copy(BHSalesLine);

        // Recalculate totals (similar to RecalculateTotals on the subpage)
        DocumentTotals.CalculateSalesSubPageTotals(
            TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);


    end;

    //   OnAfterCalculateSalesSubPageTotals(
    //     TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct, TotalSalesLine2);


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnAfterValidateEvent, Status, false, false)]
    local procedure CalculateSalesSubPageTotals(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        DocumentTotals: Codeunit "Document Totals";
        SalesLine: Record "Sales Line";
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
    begin
        TotalSalesHeader := Rec;
        TotalSalesLine.Reset();
        TotalSalesLine.SetRange("Document No.", Rec."No.");
        TotalSalesLine.SetRange("Document Type", Rec."Document Type");
        if not TotalSalesLine.FindSet() then exit;


        // Recalculate totals (similar to RecalculateTotals on the subpage)
        DocumentTotals.CalculateSalesSubPageTotals(
            TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", OnAfterCalculateSalesSubPageTotals, '', false, false)]
    local procedure OnAfterCalculateSalesSubPageTotals(var TotalSalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var VATAmount: Decimal; var InvoiceDiscountAmount: Decimal; var InvoiceDiscountPct: Decimal; var TotalSalesLine2: Record "Sales Line")
    begin
        TotalSalesHeader.CalcFields(KMK_TotalCaseGrossWeight, KMK_TotalCaseNetWeight, KMK_TotalCaseQuantityItem, Amount, "Amount Including VAT");


    end;

    //block for main [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure ExtDocNo(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        Customer: Record Customer;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if Customer.get(SalesHeader."Sell-to Customer No.") then begin
                if not Customer.KMK_ExtDocDupAllowed then begin
                    SalesHeader.TestField("External Document No.");
                    SearchForExternalDocNo(SalesHeader);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'External Document No.', false, false)]
    local procedure ExtDocNoField(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Customer: Record Customer;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if Customer.get(Rec."Sell-to Customer No.") then begin
                if not Customer.KMK_ExtDocDupAllowed then begin
                    Rec.TestField("External Document No.");
                    SearchForExternalDocNo(Rec);
                end;
            end;
        end;
    end;

    procedure CalcBestLineDisc_KMK(var SalesLineDisc: Record "Sales Line Discount")
    var
        BestSalesLineDisc: Record "Sales Line Discount";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if SalesLineDisc.FindSet() then
            repeat
                if IsInMinQty_KMK(SalesLineDisc."Unit of Measure Code", SalesLineDisc."Minimum Quantity") then
                    case true of
                        ((BestSalesLineDisc."Currency Code" = '') and (SalesLineDisc."Currency Code" <> '')) or
                      ((BestSalesLineDisc."Variant Code" = '') and (SalesLineDisc."Variant Code" <> '')):
                            BestSalesLineDisc := SalesLineDisc;
                        ((BestSalesLineDisc."Currency Code" = '') or (SalesLineDisc."Currency Code" <> '')) and
                      ((BestSalesLineDisc."Variant Code" = '') or (SalesLineDisc."Variant Code" <> '')):
                            if BestSalesLineDisc."Line Discount %" <= SalesLineDisc."Line Discount %" then
                                BestSalesLineDisc := SalesLineDisc;
                    end;
            until SalesLineDisc.Next() = 0;

        SalesLineDisc := BestSalesLineDisc;
    end;


    procedure SalesLineLineDiscExists_KMK(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    var
        IsHandled_KMK: Boolean;
    begin
        if (SalesLine.Type = SalesLine.Type::Item) and Item.Get(SalesLine."No.") then begin
            IsHandled_KMK := false;

            if not IsHandled_KMK then begin
                FindSalesLineDisc_KMK(
                  TempSalesLineDisc, GetCustNoForSalesHeader_KMK(SalesHeader), SalesHeader."Bill-to Contact No.",
                  SalesLine."Customer Disc. Group", '', SalesLine."No.", Item."Item Disc. Group", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
                  SalesHeader."Currency Code", SalesHeader."Order Date", ShowAll);

            end;
            exit(TempSalesLineDisc.FindFirst())
        end;
        exit(false);
    end;

    procedure FindSalesLineDisc_KMK(var ToSalesLineDisc: Record "Sales Line Discount"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin


        FromSalesLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromSalesLineDisc.SetFilter("Variant Code", '%1|%2', VariantCode, '');

        if not ShowAll then begin
            FromSalesLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromSalesLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            if UOM <> '' then
                FromSalesLineDisc.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
        end;

        ToSalesLineDisc.Reset();
        ToSalesLineDisc.DeleteAll();
        for FromSalesLineDisc."Sales Type" := FromSalesLineDisc."Sales Type"::Customer to FromSalesLineDisc."Sales Type"::Campaign do
            if (FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"All Customers") or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Customer) and (CustNo <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Campaign) and
                not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
            then begin
                InclCampaigns := false;

                FromSalesLineDisc.SetRange("Sales Type", FromSalesLineDisc."Sales Type");
                case FromSalesLineDisc."Sales Type" of
                    FromSalesLineDisc."Sales Type"::"All Customers":
                        FromSalesLineDisc.SetRange("Sales Code");
                    FromSalesLineDisc."Sales Type"::Customer:
                        FromSalesLineDisc.SetRange("Sales Code", CustNo);
                    FromSalesLineDisc."Sales Type"::"Customer Disc. Group":
                        FromSalesLineDisc.SetRange("Sales Code", CustDiscGrCode);
                    FromSalesLineDisc."Sales Type"::Campaign:
                        begin
                            InclCampaigns := ActivatedCampaignExists_KMK(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                end;

                repeat
                    FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::Item);
                    FromSalesLineDisc.SetRange(Code, ItemNo);
                    CopySalesDiscToSalesDisc_KMK(FromSalesLineDisc, ToSalesLineDisc);

                    if ItemDiscGrCode <> '' then begin
                        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::"Item Disc. Group");
                        FromSalesLineDisc.SetRange(Code, ItemDiscGrCode);
                        CopySalesDiscToSalesDisc_KMK(FromSalesLineDisc, ToSalesLineDisc);
                    end;

                    if InclCampaigns then begin
                        InclCampaigns := TempCampaignTargetGr.Next() <> 0;
                        FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                    end;
                until not InclCampaigns;
            end;


    end;

    local procedure CopySalesDiscToSalesDisc_KMK(var FromSalesLineDisc: Record "Sales Line Discount"; var ToSalesLineDisc: Record "Sales Line Discount")
    begin
        if FromSalesLineDisc.FindSet() then
            repeat
                ToSalesLineDisc := FromSalesLineDisc;
                ToSalesLineDisc.Insert();
            until FromSalesLineDisc.Next() = 0;
    end;

    procedure ActivatedCampaignExists_KMK(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
        IsHandled: Boolean;
    begin
        if not ToCampaignTargetGr.IsTemporary then
            Error(TempTableErr);

        IsHandled := false;

        if IsHandled then
            exit;

        ToCampaignTargetGr.Reset();
        ToCampaignTargetGr.DeleteAll();

        if CampaignNo <> '' then begin
            ToCampaignTargetGr."Campaign No." := CampaignNo;
            ToCampaignTargetGr.Insert();
        end else begin
            FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Customer);
            FromCampaignTargetGr.SetRange("No.", CustNo);
            if FromCampaignTargetGr.FindSet() then
                repeat
                    ToCampaignTargetGr := FromCampaignTargetGr;
                    ToCampaignTargetGr.Insert();
                until FromCampaignTargetGr.Next() = 0
            else
                if Cont.Get(ContNo) then begin
                    FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Contact);
                    FromCampaignTargetGr.SetRange("No.", Cont."Company No.");
                    if FromCampaignTargetGr.FindSet() then
                        repeat
                            ToCampaignTargetGr := FromCampaignTargetGr;
                            ToCampaignTargetGr.Insert();
                        until FromCampaignTargetGr.Next() = 0;
                end;
        end;
        exit(ToCampaignTargetGr.FindFirst())
    end;

    local procedure IsInMinQty_KMK(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    local procedure GetCustNoForSalesHeader_KMK(SalesHeader: Record "Sales Header"): Code[20]
    var
        CustNo: Code[20];
    begin
        CustNo := SalesHeader."Bill-to Customer No.";

        exit(CustNo);
    end;

    procedure SetUoM_KMK(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    LOCAL PROCEDURE ClearShipDate(VAR SalesHeaderRec: Record "Sales Header");
    VAR
        ShipToAddr: Record "Ship-to Address";
        Cust: Record Customer;
        DocSendProfile: Code[20];
        ShipMetCode: code[20];

    begin


        Cust.GET(SalesHeaderRec."Sell-to Customer No.");
        DocSendProfile := Cust."Document Sending Profile";

        ShipMetCode := SalesHeaderRec."Shipment Method Code";
        IF ((DocSendProfile = 'EDI') AND (ShipMetCode = 'PICKUP') AND (SalesHeaderRec."Shipment Date" = TODAY)) THEN begin
            SalesHeaderRec."Shipment Date" := 0D;
        end;

        // IF (ShipMetCode = 'DELIVERY') THEN begin
        SalesHeaderRec."Shipment Date" := 0D;
        // end;

        IF (DocSendProfile <> 'EDI') THEN BEGIN
            IF SalesHeaderRec."Sell-to Customer No." <> '' THEN BEGIN
                ShipToAddr.SETFILTER("Customer No.", SalesHeaderRec."Sell-to Customer No.");
                IF ShipToAddr.FINDFIRST THEN
                    SalesHeaderRec.VALIDATE("Ship-to Code", ShipToAddr.Code);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeValidateEvent, 'Order Date', false, false)]
    LOCAL PROCEDURE SalesHeaderOnBeforeValidateOrderDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        Rec.SetHideValidationDialog(TRUE);  //030
    END;




    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Planned Delivery Date', false, false)]

    LOCAL PROCEDURE SalesHeaderOnAfterValidateOrderDate(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer);
    BEGIN
        // rec."Shipment Date" := GetShipDateFromShipDate(Rec."Planned Delivery Date", Rec."Shipping Time");

    END;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeCalcPlannedShptDate, '', false, false)]

    local procedure OnBeforeCalcPlannedShptDate(var SalesLine: Record "Sales Line"; var PlannedShipmentDate: Date; CallingFieldNo: Integer; var IsHandled: Boolean)
    begin
        SalesLine."Planned Shipment Date" := GetShipDateFromShipDate(SalesLine."Planned Delivery Date", SalesLine."Shipping Time");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Requested Delivery Date', false, false)]
    LOCAL PROCEDURE SalesHeaderOnAfterValidateReqDeliveryDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    var
        SRSetup: Record "Sales & Receivables Setup";
        User: Record User;
    begin
        SRSetup.Reset();
        SRSetup.Get();

        User.Reset();
        User.SetRange("User Name", UserId);
        if not User.FindFirst() then User.Init();


        if SRSetup.KMK_EDIUserID <> User."User Security ID" then begin

            rec."Shipment Date" := GetShipDateFromShipDate(Rec."Requested Delivery Date", Rec."Shipping Time");
            UpdateSalesLines(Rec, Rec.FIELDNO("Requested Delivery Date"));  //035
        end;
    END;




    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
    LOCAL PROCEDURE SalesLineOnAfterValidateNo(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN

        UpdateShipmentDate(Rec);
    END;


    LOCAL PROCEDURE UpdateShipmentDate(VAR SalesLineRec: Record 37);
    VAR
        SalesHeader: Record 36;
    BEGIN
        //013 Start
        IF SalesHeader.GET(SalesLineRec."Document Type", SalesLineRec."Document No.") THEN BEGIN
            GetShipToAddrShippingTime(SalesHeader, SalesHeader, SalesHeader.FIELDNO("Shipping Time"));
            SalesLineRec.VALIDATE("Shipping Time", SalesHeader."Shipping Time");
            //016 SalesHeader."Shipment Date" := SalesLineRec."Shipment Date";
            //016 SalesHeader.MODIFY;
            IF SalesHeader."Shipment Date" <> 0D THEN                       //036
                SalesLineRec."Shipment Date" := SalesHeader."Shipment Date";  //036
        END;
        //013 End
    END;

    LOCAL PROCEDURE UpdateSalesLines(VAR SalesRec: Record 36; CurrFieldNo: Integer);
    VAR
        SalesLine: Record 37;
        NewSalesLine: Record 37;
        UpdatedQty: Decimal;
    BEGIN
        //015 Start
        SalesLine.LOCKTABLE;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesRec."Document Type");
        SalesLine.SETRANGE("Document No.", SalesRec."No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                IF SalesLine."No." <> '' THEN BEGIN
                    //029 Start
                    IF CurrFieldNo = SalesRec.FIELDNO("Order Date") THEN BEGIN
                        NewSalesLine := SalesLine;
                        NewSalesLine."Line No." += 1;
                        NewSalesLine.VALIDATE(Quantity, 0);
                        NewSalesLine.INSERT;
                    END ELSE

                        IF ((CurrFieldNo = SalesRec.FIELDNO("Requested Delivery Date")) AND (SalesRec."Shipment Date" = 0D)) THEN BEGIN //035
                            SalesLine.VALIDATE("Requested Delivery Date", SalesRec."Requested Delivery Date");
                            //>> SalesLine.VALIDATE("Planned Shipment Date", CALCDATE('-' + FORMAT(SalesRec."Shipping Time"), SalesRec."Requested Delivery Date"));
                        END ELSE
                            IF SalesRec."Shipment Date" <> 0D THEN
                                SalesLine.VALIDATE("Shipment Date", SalesRec."Shipment Date")
                            ELSE
                                SalesLine.VALIDATE("Shipping Time", SalesRec."Shipping Time");
                    SalesLine.MODIFY(TRUE);
                END;
            UNTIL SalesLine.NEXT = 0;

    END;


    LOCAL PROCEDURE UpdateSalesLines1(VAR SalesRec: Record 36; CurrFieldNo: Integer);
    VAR
        SalesLine: Record 37;
        NewSalesLine: Record 37;
        UpdatedQty: Decimal;
    BEGIN
        //015 Start
        SalesLine.LOCKTABLE;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesRec."Document Type");
        SalesLine.SETRANGE("Document No.", SalesRec."No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                IF SalesLine."No." <> '' THEN BEGIN
                    //029 Start
                    IF CurrFieldNo = SalesRec.FIELDNO("Order Date") THEN BEGIN
                        NewSalesLine := SalesLine;
                        NewSalesLine."Line No." += 1;
                        NewSalesLine.VALIDATE(Quantity, 0);
                        NewSalesLine.INSERT;
                    END ELSE
                        //029 End
                        //035 IF CurrFieldNo = SalesRec.FIELDNO("Requested Delivery Date") THEN BEGIN
                        IF ((CurrFieldNo = SalesRec.FIELDNO("Requested Delivery Date")) AND (SalesRec."Shipment Date" = 0D)) THEN BEGIN //035
                            SalesLine.VALIDATE("Requested Delivery Date", SalesRec."Requested Delivery Date");
                            //>>        SalesLine.VALIDATE("Planned Shipment Date", CALCDATE('-' + FORMAT(SalesRec."Shipping Time"), SalesRec."Requested Delivery Date"));
                        END ELSE
                            //035 Start
                            IF SalesRec."Shipment Date" <> 0D THEN
                                SalesLine.VALIDATE("Shipment Date", SalesRec."Shipment Date")
                            ELSE
                                //035 End
                                SalesLine.VALIDATE("Shipping Time", SalesRec."Shipping Time");
                    SalesLine.MODIFY(TRUE);
                END;
            UNTIL SalesLine.NEXT = 0;
        //016 SalesRec."Shipment Date" := SalesLine."Shipment Date";
        //015 End
    END;


    LOCAL PROCEDURE GetShipToAddrShippingTime(VAR Rec: Record 36; xRec: Record 36; CurrFieldNo: Integer);
    VAR
        ShippingAgentServices: Record 5790;
        ShipToAddress: Record 222;
    BEGIN
        //001 Start
        WITH Rec DO BEGIN
            IF "Ship-to Code" = '' THEN
                EXIT;
            IF ShippingAgentServices.GET("Shipping Agent Code", "Shipping Agent Service Code") THEN
                EXIT;

            IF ShipToAddress.GET("Sell-to Customer No.", "Ship-to Code") THEN
                IF ((FORMAT(ShipToAddress.KMK_ShippingTime) <> '') AND
                   (FORMAT(ShipToAddress.KMK_ShippingTime) <> FORMAT("Shipping Time"))) OR ("Shipment Date" = 0D)
                THEN BEGIN
                    "Shipping Time" := ShipToAddress.KMK_ShippingTime;
                    IF NOT (CurrFieldNo IN [FIELDNO("Shipping Agent Service Code")]) THEN
                        UpdateSalesLines1(Rec, CurrFieldNo);  //015
                END;
        END;
        //001 End
    END;



    var
        myInt: Integer;
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        SalesPriceMgmt: Codeunit "Sales Price Calc. Mgt.";
        QtyPerUOM: Decimal;
        Qty: Decimal;
        Item: Record Item;
        TempTableErr: Label 'The table passed as a parameter must be temporary.';

    procedure SearchForExternalDocNo(var OriginalSalesHeader: Record "Sales Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesAlreadyExistsTxt: Label 'PO Order %1 already exists for this customer. See SO No %2';
        SalesInvAlreadyExistsTxt: Label 'PO Order %1 already exists for this customer. See Posted Sales Invoice %2';
        SalesCrAlreadyExistsTxt: Label 'PO Order %1 already exists for this customer. See Posted Sales Cr. %2';
        ExtDocFound: Boolean;
    begin
        ExtDocFound := false;
        // SalesHeader.SetLoadFields("Document Type", "No.", "Sell-to Customer No.", "External Document No.");
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", OriginalSalesHeader."Document Type");
        SalesHeader.SetFilter("No.", '<>%1', OriginalSalesHeader."No.");
        SalesHeader.SetRange("Sell-to Customer No.", OriginalSalesHeader."Sell-to Customer No.");
        SalesHeader.SetRange("External Document No.", OriginalSalesHeader."External Document No.");
        if SalesHeader.FindFirst() then begin
            Message(SalesAlreadyExistsTxt, SalesHeader."External Document No.", SalesHeader."No.");
            ExtDocFound := true;
        end;


        // SalesInvoiceHeader.SetLoadFields("Sell-to Customer No.", "External Document No.");
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", OriginalSalesHeader."Sell-to Customer No.");
        SalesInvoiceHeader.SetRange("External Document No.", OriginalSalesHeader."External Document No.");
        if SalesInvoiceHeader.FindFirst() then begin
            Message(SalesInvAlreadyExistsTxt, SalesInvoiceHeader."External Document No.", SalesInvoiceHeader."No.");
            ExtDocFound := true;
        end;

        // SalesCrMemoHeader.SetLoadFields("Sell-to Customer No.", "External Document No.");
        SalesInvoiceHeader.Reset();
        SalesCrMemoHeader.SetRange("Sell-to Customer No.", OriginalSalesHeader."Sell-to Customer No.");
        SalesCrMemoHeader.SetRange("External Document No.", OriginalSalesHeader."External Document No.");
        if SalesCrMemoHeader.FindFirst() then begin
            Message(SalesCrAlreadyExistsTxt, SalesCrMemoHeader."External Document No.", SalesCrMemoHeader."No.");
            ExtDocFound := true;
        end;
        exit(ExtDocFound);
    end;


    // calculate shipping date


    procedure GetShipDateFromShipDate(StartDate: Date; DateFormula: DateFormula): Date
    var
        CustomizedCalendarChange: array[2] of Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        ShippingDate: Record KMK_ShippingDates;
    begin
        ShippingDate.Reset();
        if not ShippingDate.Get(DateFormula) then
            exit(0D)
        else begin
            CustomizedCalendarChange[1].SetSource(
                Enum::"Calendar Source Type"::KMK_ShippingDate
                ,
                format(ShippingDate.KMK_Shipping_Time),        // Source Code, e.g. key from your own table
                '',              // Additional Source Code if needed
                ShippingDate.KMK_Base_Calendar_Code);   // Base Calendar Code

            exit(
                CalendarManagement.CalcDateBOC(
                    '-' + Format(DateFormula),
                    StartDate,
                    CustomizedCalendarChange,
                    false));
        end;
    end;


    procedure KMK_FindSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer): Decimal;
    var
        TempSalesPrice: Record "Sales Price" temporary;
        SalesPriceMgmt: Codeunit "Sales Price Calc. Mgt.";
        FoundSalesPrice: Boolean;



    begin

        case SalesLine.Type of
            SalesLine.Type::Item:
                begin

                    Item.Get(SalesLine."No.");
                    SalesPriceMgmt.SalesLinePriceExists(SalesHeader, SalesLine, false);

                    SalesPriceMgmt.CalcBestUnitPrice(TempSalesPrice);


                    Exit(TempSalesPrice."Unit Price");

                end;

        end;



    end;

    local procedure UpdateSalesPrice(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        SalesLine: Record "Sales Line";
        KMK_MEssage: Text;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            //>>  SalesLine.SetRange(KMK_PriceDiscrepancyExists, true);
            if SalesLine.FindSet() then begin
                KMK_MEssage := StrSubstNo('Do you want to continue and update the Unit Price to match BC?');
                if Confirm(KMK_MEssage, true) then begin
                    repeat
                        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, SalesLine.FieldNo("Quantity"));
                        SalesLine.KMK_PriceDiscrepancyExists := false;
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;

                end
                else
                    IsHandled := true;
            end;
        end;


    end;


    procedure UpdatePriceIsDifferent(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        TempSalesLine: Record "Sales Line" temporary;
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";
        StandardPrice: Decimal;
        LineVariant: Variant;
    begin
        if SalesLine.Type <> SalesLine.Type::Item then begin
            SalesLine.KMK_PriceDiscrepancyExists := false;
            exit;
        end;

        if SalesLine."No." = '' then
            exit;

        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;

        TempSalesLine.Init();
        TempSalesLine.TransferFields(SalesLine, true);
        TempSalesLine.Insert();

        TempSalesLine.GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
        PriceCalculation.ApplyPrice(0);

        LineVariant := TempSalesLine;
        PriceCalculation.GetLine(LineVariant);
        TempSalesLine := LineVariant;

        StandardPrice := TempSalesLine."Unit Price";

        SalesLine.KMK_PriceDiscrepancyExists := SalesLine."Unit Price" <> StandardPrice
    end;

}