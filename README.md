# kubernetes cluster Installation tips

## Required apps:
- OCI CLI --> https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm
- Terraform --> https://www.terraform.io/downloads
- Ansible --> apt, yum, pip...
- (Algo mas relacionado con ansible pero no me acuerdo. Mañana lo pongo)

## Requiered moves:
- Create Oracle Cloud (Free Tier) account
- Create Terraform Cloud account: organization and workspace.
- In provider.tf replace values for "organization" and "name" fields by yours organization and workspace names have created.
- In vars.tf replace values of the variables with yours according the region you have an account:
  - "tenancy_ocid" and "compartment_ocid" (have the same value)
  - "region"
  - "instance-AMD_source_image_id" and "instance-ARM_source_image_id" (Canonical-Ubuntu-18.04 https://docs.oracle.com/en-us/iaas/images/image/d81a7730-37d9-486c-9b25-02088aaf98e4/)
- $oci session authenticate<br />
Enter the name of the profile you would like to create: DEFAULT
- $terraform login

## Installation:
- make && make clean && make install
