SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoCrea]
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


if exists (select * from CfgCampos where RucE= @RucE and Id_CTb=@Id_CTb)
	set @msj = 'Ya existe la configuraciÃ³n del campo'
else 
begin
insert 	into 	CfgCampos(RucE,Id_CTb,Id_TDt,Nom,ValorDef,MaxCarac,IB_Oblig,IB_Hab,MinDate,MaxDate,ValList,Fmla)
	values	(@RucE,@Id_CTb,@Id_TDt,@Nom,@ValorDef,@MaxCarac,@IB_Oblig,@IB_Hab,@MinDate,@MaxDate,@ValList,@Fmla)
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-17 : <Modificacion del procedimiento almacenado>
GO
