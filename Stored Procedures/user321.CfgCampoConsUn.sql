SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoConsUn]
@RucE nvarchar(11),
@Id_CTb int,
@msj varchar(100) output
as

if not exists (select top 1 *from CfgCampos where RucE=@RucE and Id_CTb=@Id_CTb)
	set @msj='No se encontro Cliente'
else 
Begin
	select  con.RucE,con.Id_CTb,con.Id_TDt,con.Nom,con.ValorDef,con.MaxCarac,con.IB_Oblig,IB_Hab,con.MinDate,
		con.MaxDate,con.ValList,con.Fmla
	from 	CfgCampos con 
	where 	con.RucE=@RucE and con.Id_CTb=@Id_CTb
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-18 : <Modificacion del procedimiento almacenado>

--CAM: XD

GO
