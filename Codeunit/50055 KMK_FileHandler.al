codeunit 50055 KMK_FileHandler
{
    procedure UploadFilesToSharePoint(var KMK_ImagesAtt: Record KMK_ImagesAttachment; FileName: Text[250]; MimeType: Text; FileContent: InStream)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        SharePointFileUrl: Text;
        ResponseText: Text;
        FileMgt: Codeunit "File Management";
        JsonToken: JsonToken;
        KMK_ImagesAtt2: Record KMK_ImagesAttachment;
        FileURLName: Text;
        ContainsSameFile: Label 'The file %1 already exists in the customer.';
        SRSetup: Record "Sales & Receivables Setup";
    begin
        // Check if there is a file with the same name in the customer, if it exists, an error message will be displayed
        SRSetup.Reset();
        SRSetup.Get();
        If SRSetup.KMK_ShareDriveLink = '' then Error('You need to set Link');


        KMK_ImagesAtt2.Reset();
        KMK_ImagesAtt2.SetRange("Table ID", KMK_ImagesAtt."Table ID");
        KMK_ImagesAtt2.SetRange("No.", KMK_ImagesAtt."No.");
        KMK_ImagesAtt2.SetRange("File Name", FileName);
        /*  if KMK_ImagesAtt."Folder Name" <> '' then
             KMK_ImagesAtt2.SetRange("Folder Name", KMK_ImagesAtt."Folder Name"); */

        if KMK_ImagesAtt2.FindFirst() then
            Error(ContainsSameFile, FileName);

        SharePointFileUrl := SRSetup.KMK_ShareDriveLink + FileName + ':/content';
        //if KMK_ImagesAtt."Folder Name" = '' then
        FileURLName := SRSetup.KMK_ShareDriveLink + FileName;
        // else
        //  FileURLName := SRSetup.CSD_ShareDriveLink + KMK_ImagesAtt."Folder Name" + '/' + FileName;
        KMK_ImagesAtt."Web Url" := FileURLName;
        KMK_ImagesAtt."File Name" := SRSetup.KMK_ShareDriveLink + FileName;
        KMK_ImagesAtt."File Extension" := FileMgt.GetExtension(FileName);
        KMK_ImagesAtt."Mime Type" := MimeType;
        KMK_ImagesAtt.ID := KMK_ImagesAtt.GetLastID() + 1;
        KMK_ImagesAtt.Insert(true);

    end;

    procedure UpdateFileInSharePoint(var KMK_ImagesAtt: Record KMK_ImagesAttachment)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        SharePointFileUrl: Text;
        ResponseText: Text;
        JsonRaw: JsonObject;
        JsonRawText: Text;
        KMK_ImagesAtt2: Record KMK_ImagesAttachment;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        SRSetup: Record "Sales & Receivables Setup";
    begin

        //Add the fields and values ​​you need to modify 
        SRSetup.Reset();
        SRSetup.Get();
        If SRSetup.KMK_ShareDriveLink = '' then Error('Link needs to be entered');
        JsonRaw.Add('name', KMK_ImagesAtt."File Name");
        JsonRaw.WriteTo(JsonRawText);

        // Define the SharePoint folder URL

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        SharePointFileUrl := SRSetup.KMK_ShareDriveLink + KMK_ImagesAtt."SharePoint File ID";
        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.GetHeaders(Headers);
        //SC  Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));
        RequestContent.GetHeaders(ContentHeader);
        RequestContent.WriteFrom(JsonRawText);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content(RequestContent);

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                //Update Web URL
                JsonResponse.ReadFrom(ResponseText);
                JsonResponse.Get('webUrl', JsonToken);
                KMK_ImagesAtt."Web Url" := JsonToken.AsValue().AsText();
                KMK_ImagesAtt.Modify(true);

                // Check if the file exists in other items, if it exists, modify all records in the BC side.
                KMK_ImagesAtt2.Reset();
                KMK_ImagesAtt2.SetFilter(ID, '<>%1', KMK_ImagesAtt.ID);
                KMK_ImagesAtt2.SetRange("SharePoint File ID", KMK_ImagesAtt."SharePoint File ID");
                if KMK_ImagesAtt2.FindSet() then begin
                    KMK_ImagesAtt2.ModifyAll("File Name", KMK_ImagesAtt."File Name");
                    KMK_ImagesAtt2.ModifyAll("Web Url", KMK_ImagesAtt."Web Url");
                end;
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to update file in SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
    end;

    procedure DeleteFileInSharePoint(var KMK_ImagesAtt: Record KMK_ImagesAttachment)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        //SC  AuthToken: SecretText;
        SharePointFileUrl: Text;
        ResponseText: Text;
        KMK_ImagesAtt2: Record KMK_ImagesAttachment;
    begin
        // Check if the file exists in other customers, if it exists, just delete it in the BC side.
        KMK_ImagesAtt2.Reset();
        KMK_ImagesAtt2.SetFilter(ID, '<>%1', KMK_ImagesAtt.ID);
        KMK_ImagesAtt2.SetRange("SharePoint File ID", KMK_ImagesAtt."SharePoint File ID");
        if not KMK_ImagesAtt2.IsEmpty then begin
            KMK_ImagesAtt.Delete();
            exit;
        end;


    end;

    procedure CheckFileInSharePoint(var KMK_ImagesAtt: Record KMK_ImagesAttachment)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        //SC  AuthToken: SecretText;
        SharePointFileUrl: Text;
        ResponseText: Text;
        LinkedToSharePointMsg: Label 'The file %1 is linked to SharePoint.';
        SRSetup: Record "Sales & Receivables Setup";
        ProposeToDeleteMsg: Label 'The file %1 does not exist in SharePoint. Do you want to delete it from Business Central?\\%2 %3';
    begin
        // Check if the file exists in SharePoint, if not exists, propose to delete from BC side.
        if KMK_ImagesAtt."SharePoint File ID" = '' then
            if Confirm(StrSubstNo(ProposeToDeleteMsg, KMK_ImagesAtt."File Name")) then begin
                KMK_ImagesAtt.Delete();
                exit;
            end;


        // Define the SharePoint folder URL

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        SRSetup.Reset();
        SRSetup.Get();
        SharePointFileUrl := SRSetup.KMK_ShareDriveLink + KMK_ImagesAtt."SharePoint File ID";
        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.GetHeaders(Headers);
        //SC  Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                //JsonResponse.ReadFrom(ResponseText);
                Message(LinkedToSharePointMsg, KMK_ImagesAtt."File Name");
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                if Confirm(StrSubstNo(ProposeToDeleteMsg, KMK_ImagesAtt."File Name", HttpResponseMessage.HttpStatusCode(), ResponseText)) then begin
                    KMK_ImagesAtt.Delete();
                end;
                //Error('Failed to Delete files in SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
    end;



}