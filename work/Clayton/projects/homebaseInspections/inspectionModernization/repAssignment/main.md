# Clayton Home Inspections Legacy Rep Editor

## Abstract
A tool that allows users to decide who the inspections go to based on state and county logic.

MySql:

Rep assinged to a Field Chase/ Hom Inspection is identified by **CLAYTON.FPMFCRQ.FCREP#** which maps to **CATS.dbo.Sys
User.LoginId** LoginId can be retrieved from sSusUSer usingLink username, Ad username, employee number, email address
and a few other data points. Sys use is the source for [[clayton-link]] user info.

Rep assignments are stored in Remarketing.dbo.IdCounty

Querying by fcID (which is also FCREP# and SysUser.LoginID) gets all states and counties assigned to a Rep.

Field Chases/Home Inspections are assigned based on the location of the asset, either STate and County, or by STate.



## Directory

## Useful Links

## Tags
