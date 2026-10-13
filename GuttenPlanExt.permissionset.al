permissionset 50001 GuttenPlanExt
{
    Assignable = true;
    Permissions = tabledata KMK_ShippingDates = RIMD,
        table KMK_ShippingDates = X,
        report KMK_BatchPostSOExt = X,
        report KMK_Check10411 = X,
        codeunit KMK_GuttenPlan = X,
        codeunit KMK_GuttenPlan_Sale = X,
        codeunit KMK_SalesBatchPostMgt = X,
        page KMK_ShipDates = X,
        page "Pan Layout Picture" = X,
        page "Sent Emails for Document" = X,
        tabledata KMK_ImagesAttachment = RIMD,
        table KMK_ImagesAttachment = X,
        codeunit KMK_FileHandler = X,
        page KMKAttachmentListFactbox = X,
        page KMK_ImageDetails = X;
}