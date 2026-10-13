codeunit 50050 KMK_GuttenPlan
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::Item, OnAfterValidateEvent, KMK_ShelfLifeDays, false, false)]
    local procedure CalcGuaranteeLife(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
    begin
        if xRec.KMK_ShelfLifeDays <> Rec.KMK_ShelfLifeDays then
            rec.KMK_GuaranteeLifeDays := round(Rec.KMK_ShelfLifeDays * 0.75, 1, '>');
    end;


    [EventSubscriber(ObjectType::Table, Database::Item, OnAfterValidateEvent, KMK_PiecesperCase, false, false)]
    local procedure InsertUpdateItemUOM(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var

    begin
        if xRec.KMK_PiecesperCase <> Rec.KMK_PiecesperCase then
            InsertItemUOM(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, OnAfterValidateEvent, KMK_PiecesperCase, false, false)]
    local procedure CalcNWCase(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        InvSetup: Record "Inventory Setup";
    begin

        InvSetup.Reset();
        InvSetup.Get();
        if xRec.KMK_PiecesperCase <> Rec.KMK_PiecesperCase then begin
            rec.KMK_NetWeightCase := rec.KMK_PiecesperCase * rec.KMK_MoldedPieceWeightOz / 16;
            rec.KMK_GrossWeight := (rec.KMK_NetWeightCase * InvSetup.KMK_SafetyFactor) + InvSetup.KMK_LinerCaseWeight + InvSetup.KMK_SafetyFactor;
        end;

    end;


    procedure InsertItemUOM(var Item: Record Item)
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        // does ItemUOM for EA exist?
        ItemUOM.Reset();
        ItemUOM.SetRange("Item No.", Item."No.");
        ItemUOM.SetFilter(Code, '%1', 'EA');
        if ItemUOM.FindFirst() then begin
            ItemUOM."Qty. per Unit of Measure" := Item.KMK_PiecesperCase;
            ItemUOM.KMK_QtyperBaseCase := 1 / Item.KMK_PiecesperCase;
            ItemUOM.Modify();
        end
        else begin
            ItemUOM.Init();
            ItemUOm."Item No." := Item."No.";
            ItemUOM.Code := 'EA';
            ItemUOM.Insert();
            ItemUOM."Qty. per Unit of Measure" := Item.KMK_PiecesperCase;
            ItemUOM.KMK_QtyperBaseCase := 1 / Item.KMK_PiecesperCase;
            ItemUOM.Modify();
        end;
    end;

    var
        myInt: Integer;



    procedure RunPostingBatch(var SalesHeader: Record "Sales Header"; ReplacePostingDate: Boolean; ReplacewithShipDate: Boolean; PostingDate: Date; ReplaceDocumentDate: Boolean; CalcInvoiceDiscount: Boolean; Ship: Boolean; Invoice: Boolean)
    var
        TempErrorMessage: Record "Error Message" temporary;
        SalesBatchPostMgt: Codeunit "Sales Batch Post Mgt.";
        ErrorMessages: Page "Error Messages";
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        PostingCodeunitId: Integer;
        PostingDateIsNotSetErr: Label 'Enter the posting date.';
        BatchPostingMsg: Label 'Batch posting of sales documents.';
        ApprovalPendingErr: Label 'Cannot post sales document no. %1 of type %2 because it is pending approval.', Comment = '%1 = Document No.; %2 = Document Type';
        ApprovalWorkflowErr: Label 'Cannot post sales document no. %1 of type %2 due to the approval workflow.', Comment = '%1 = Document No.; %2 = Document Type';
        InterCompanyZipFileNamePatternTok: Label 'Sales IC Batch - %1.zip', Comment = '%1 - today date, Sample: Sales IC Batch - 23-01-2024.zip';
        ProcessBarMsg: Label 'Processing: @1@@@@@@@', Comment = '1 - overall progress';

    begin


        if ReplacePostingDate and (PostingDate = 0D) then
            Error(PostingDateIsNotSetErr);

        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::Invoice, Invoice);
        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::Ship, Ship);
        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::"Calculate Invoice Discount", CalcInvoiceDiscount);
        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::"Posting Date", PostingDate);
        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::"Replace Posting Date", ReplacePostingDate);
        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::KMK_ReplacePostwithShipDate, ReplacewithShipDate);
        BatchProcessingMgt.SetParameter(Enum::"Batch Posting Parameter Type"::"Replace Document Date", ReplaceDocumentDate);


        SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
        Commit();
        if SalesBatchPostMgt.Run(SalesHeader) then;
        BatchProcessingMgt.ResetBatchID();
        if GuiAllowed then begin
            BatchProcessingMgt.GetErrorMessages(TempErrorMessage);

            if TempErrorMessage.FindFirst() then begin
                ErrorMessages.SetRecords(TempErrorMessage);
                ErrorMessages.Run();
            end;
        end;
    end;
}