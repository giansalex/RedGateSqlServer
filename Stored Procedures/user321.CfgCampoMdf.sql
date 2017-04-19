SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoMdf]
@RucE nvarchar(11),
@Id_CTb int,
@Id_TDt int,@Nom varchar(100),
@ValorDef varchar(100),
@MaxCarac int,@IB_Oblig bit,@IB_Hab bit,
@MinDate datetime,
@MaxDate datetime,
@ValList varchar(8000),
@Fmla varchar(300),
@msj varchar(100) output
as

if not exists (select top 1 * from CfgCampos where RucE=@RucE and Id_CTb=@Id_CTb)
	set @msj = 'ConfiguraciÃ³n del campo no existe'
update CfgCampos set Id_TDt=@Id_TDt, Nom=@Nom, ValorDef=@ValorDef, MaxCarac=@MaxCarac, 
			IB_Oblig=@IB_Oblig, IB_Hab=@IB_Hab, MinDate=@MinDate, MaxDate=@MaxDate,
			ValList=@ValList, Fmla=@Fmla
		where 	RucE=@RucE and Id_CTb=@Id_CTb
-- Leyenda --
-- MP : 2010-12-17 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-18 : <Modificacion del procedimiento almacenado>
GO
