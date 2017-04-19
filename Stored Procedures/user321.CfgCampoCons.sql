SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select top 1 *from CfgCampos where RucE=@RucE)
	set @msj='No se encontro configuraciones del campo'
else
begin
	select 	con.RucE,con.Id_CTb,con.Id_TDt,con.Nom,con.ValorDef,con.MaxCarac,con.IB_Oblig,IB_Hab,MinDate,MaxDate,
		ValList,Fmla
	from 	CfgCampos con 
	where 	con.RucE=@RucE
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-18 : <Modificacion del procedimiento almacenado>



GO
