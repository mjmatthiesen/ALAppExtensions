﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

report 13634 "OIOUBL-Create Elec. Srv. Inv."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Invoice Header"; "Service Invoice Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.", "Customer No.", "Bill-to Customer No.", "OIOUBL-GLN", "OIOUBL-Electronic Invoice Created";

            trigger OnAfterGetRecord();
            begin
                CODEUNIT.RUN(CODEUNIT::"OIOUBL-Export Service Invoice", "Service Invoice Header");
                COMMIT();
                Counter := Counter + 1;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE(SuccessMsg, Counter);
            end;

            trigger OnPreDataItem();
            var
                ServInvHeader: Record 5992;
            begin
                Counter := 0;

                // Any electronic service invoices?
                ServInvHeader.COPY("Service Invoice Header");
                ServInvHeader.FILTERGROUP(8);
                ServInvHeader.SETFILTER("OIOUBL-GLN", '<>%1', '');
                if NOT ServInvHeader.FINDFIRST() then
                    ERROR(NothingToCreateErr);

                // All electronic service invoices?
                ServInvHeader.SETRANGE("OIOUBL-GLN", '');
                if ServInvHeader.FINDFIRST() then
                    if NOT CONFIRM(InvoicesWillBeSkippedQst, TRUE) then
                        CurrReport.QUIT();
                ServInvHeader.SETRANGE("OIOUBL-GLN");

                // Some already sent?
                ServInvHeader.SETRANGE("OIOUBL-Electronic Invoice Created", TRUE);
                if ServInvHeader.FINDFIRST() then
                    if NOT CONFIRM(InvoicesAlreadyCreatedQst) then
                        CurrReport.QUIT();

                SETFILTER("OIOUBL-GLN", '<>%1', '');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Counter: Integer;
        InvoicesWillBeSkippedQst: Label 'One or more invoices that match your filter criteria are not electronic invoices and will be skipped.\\Do you want to continue?';
        InvoicesAlreadyCreatedQst: Label 'One or more invoices that match your filter criteria have been created before.\\Do you want to continue?';
        SuccessMsg: Label 'Successfully created %1 electronic invoice(s).', Comment = '%1 = amount of electronic invoices created';
        NothingToCreateErr: Label 'There is nothing to create.';
}

