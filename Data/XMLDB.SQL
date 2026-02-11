/* Microsoft SQL Server - Scripting			*/
/* Server: THOR					*/
/* Database: XMLApp					*/
/* Creation Date 4/29/98 8:36:37 AM 			*/

/****** Object:  Stored Procedure dbo.dt_adduserobject    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_adduserobject') and sysstat & 0xf = 4)
	drop procedure dbo.dt_adduserobject
GO

/****** Object:  Stored Procedure dbo.dt_droppropertiesbyid    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_droppropertiesbyid') and sysstat & 0xf = 4)
	drop procedure dbo.dt_droppropertiesbyid
GO

/****** Object:  Stored Procedure dbo.dt_dropuserobjectbyid    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_dropuserobjectbyid') and sysstat & 0xf = 4)
	drop procedure dbo.dt_dropuserobjectbyid
GO

/****** Object:  Stored Procedure dbo.dt_getobjwithprop    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_getobjwithprop') and sysstat & 0xf = 4)
	drop procedure dbo.dt_getobjwithprop
GO

/****** Object:  Stored Procedure dbo.dt_getpropertiesbyid    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_getpropertiesbyid') and sysstat & 0xf = 4)
	drop procedure dbo.dt_getpropertiesbyid
GO

/****** Object:  Stored Procedure dbo.dt_setpropertybyid    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_setpropertybyid') and sysstat & 0xf = 4)
	drop procedure dbo.dt_setpropertybyid
GO

/****** Object:  Stored Procedure dbo.GetProductList    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.GetProductList') and sysstat & 0xf = 4)
	drop procedure dbo.GetProductList
GO

/****** Object:  Stored Procedure dbo.dt_verstamp003    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dt_verstamp003') and sysstat & 0xf = 4)
	drop procedure dbo.dt_verstamp003
GO

/****** Object:  Table dbo.dtproperties    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.dtproperties') and sysstat & 0xf = 3)
	drop table dbo.dtproperties
GO

/****** Object:  Table dbo.Products    Script Date: 4/29/98 8:36:39 AM ******/
if exists (select * from sysobjects where id = object_id('dbo.Products') and sysstat & 0xf = 3)
	drop table dbo.Products
GO

/****** Object:  Table dbo.dtproperties    Script Date: 4/29/98 8:36:39 AM ******/
CREATE TABLE dbo.dtproperties (
	id int IDENTITY (1, 1) NOT NULL ,
	objectid int NULL ,
	property varchar (64) NOT NULL ,
	value varchar (255) NULL ,
	lvalue image NULL ,
	version int NOT NULL CONSTRAINT DF__dtpropert__versi__02DC7882 DEFAULT (0),
	CONSTRAINT pk_dtproperties PRIMARY KEY  CLUSTERED 
	(
		id,
		property
	)
)
GO

/****** Object:  Table dbo.Products    Script Date: 4/29/98 8:36:40 AM ******/
CREATE TABLE dbo.Products (
	ProdID int NOT NULL ,
	Name char (40) NOT NULL ,
	Price money NOT NULL ,
	QtyOnHand int NOT NULL ,
	Color char (10) NOT NULL ,
	ShipOpts tinyint NOT NULL 
)
GO

/****** Object:  Stored Procedure dbo.dt_verstamp003    Script Date: 4/29/98 8:36:40 AM ******/
/*
**	This proc exists only to version distribution of data package storage format
*/
create procedure dt_verstamp003
as
	return (0)

GO

/****** Object:  Stored Procedure dbo.dt_adduserobject    Script Date: 4/29/98 8:36:40 AM ******/
/*
**	Add an object to the dtproperties table
*/
create procedure dt_adduserobject
as
	/*
	** Create the user object if it does not exist already
	*/
	begin transaction
		insert dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity

GO

/****** Object:  Stored Procedure dbo.dt_droppropertiesbyid    Script Date: 4/29/98 8:36:40 AM ******/
/* 
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
create procedure dt_droppropertiesbyid	
	@id int,
	@property varchar(64)
as

	if (@property is null) or (@property = '')
		delete from dtproperties where objectid=@id
	else
		delete from dtproperties 
			where objectid=@id and property=@property

	raiserror (' %d row(s) affected', -1, -1, @@rowcount)

GO

/****** Object:  Stored Procedure dbo.dt_dropuserobjectbyid    Script Date: 4/29/98 8:36:40 AM ******/
/*	
**	Drop an object from the dtproperties table
*/
create procedure dt_dropuserobjectbyid
	@id int
as
	delete from dtproperties where objectid=@id

GO

/****** Object:  Stored Procedure dbo.dt_getobjwithprop    Script Date: 4/29/98 8:36:40 AM ******/
/*
**	Retrieve the owner object(s) of a given property
*/
create procedure dt_getobjwithprop
	@property varchar(30),
	@value varchar(255)
as

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dtproperties
			where property=@property

	else
		select objectid id from dtproperties
			where property=@property and value=@value

GO

/****** Object:  Stored Procedure dbo.dt_getpropertiesbyid    Script Date: 4/29/98 8:36:40 AM ******/
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
**
*/
create procedure dt_getpropertiesbyid
	@id int,
	@property varchar(64)
as

	if (@property is null) or (@property = '')
		select property, version, value, lvalue
			from dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dtproperties
			where  @id=objectid and @property=property

GO

/****** Object:  Stored Procedure dbo.dt_setpropertybyid    Script Date: 4/29/98 8:36:40 AM ******/
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
create procedure dt_setpropertybyid
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	if exists (select * from dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dtproperties set value=@value, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dtproperties (property, objectid, value, lvalue)
			values (@property, @id, @value, @lvalue)
	end

	raiserror (' %d row(s) affected', -1, -1, @@rowcount)

GO

/****** Object:  Stored Procedure dbo.GetProductList    Script Date: 4/29/98 8:36:40 AM ******/
Create Procedure GetProductList
As
	SELECT * FROM Products ORDER BY Name, Price

	return (0)
GO

