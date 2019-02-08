﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

pageextension 13678 "OIOUBL-Service Credit Memo" extends "Service Credit Memo"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = Service;
                ToolTip = 'Specifies the customer''s reference.';
            }
        }

        addafter("Contact Name")
        {
            field("OIOUBL-Contact Role"; "OIOUBL-Contact Role")
            {
                ApplicationArea = Service;
                ToolTip = 'Specifies the role of the contact person at the customer.';
            }
        }

        addafter("Bill-to Contact")
        {
            field("OIOUBL-GLN"; "OIOUBL-GLN")
            {
                Tooltip = 'Specifies the GLN location number for the customer.';
                ApplicationArea = Service;
            }
            field("OIOUBL-Account Code"; "OIOUBL-Account Code")
            {
                Tooltip = 'Specifies the account code of the customer.';
                ApplicationArea = Service;

                trigger OnValidate();
                begin
                    CurrPage.ServLines.PAGE.UpdateForm(TRUE);
                end;
            }
            field("OIOUBL-Profile Code"; "OIOUBL-Profile Code")
            {
                Tooltip = 'Specifies the profile that the customer requires for electronic documents.';
                ApplicationArea = Service;
            }
        }
    }
}