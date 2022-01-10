# MODULE: Azure-StorageAccount

## Description

This module creates a storage account with the specified properties as descibed below.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| storage_account_name | string | - | Name of the storage account to create |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| tags | map (string) | - | Map (hashtable) of tags |
| account_kind | string | "StorageV2" | Storage account kind. Can be one of "*StorageV2*" (general purpose v2), "*Storage*" (general purpose), "*FileStorage*", "*BlobStorage*" and "*BlockBlobStorage*".  |
| account_tier | string | "Standard" | Storage acccount tier. Can be "*Standard*" or "*Premium*". |
| account_replication_type | string | "LRS" | Storage account replication type. Can be one of "*LRS*", "*GRS*", "*RAGRS*", "*ZRS*", "*GZRS*" and "*RAGZRS*". |
| access_tier | string | "Hot" | Blob access tier. Can be "*Hot*" or "*Cool*". |
| min_tls_version | string | "TLS1_2" | Minimum TLS version allowed. Can be one of "*TLS1_0*", "*TLS1_1*" and "*TLS1_2*". |
| allow_blob_public_access | bool | false | Controls whether configuring anonymous access to blobs and containers is allowed |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| storage_account_id | string | Full resource Id of the resulting storage account |
| primary_blob_endpoint | string | URI of the blob endpoint of the storage account (i.e. an URL like https://*storage_account_name*.blob.core.windows.net/) |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
