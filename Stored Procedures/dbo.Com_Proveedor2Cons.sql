SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
if(@TipCons=0)
	select *from Proveedor2 where RucE=@RucE
else if(@TipCons=1) 
	select case(isnull(len(RSocial),0))
	                     when 0 then Cd_Prv+'  |  '+ApPat+ ' ' + ApMat+ ' ' +Nom
		       else Cd_Prv+'  |  '+RSocial end as CodNom, Cd_Prv,  case(isnull(len(RSocial),0))
	                     when 0 then ApPat+ ' ' + ApMat+ ' ' +Nom
		       else RSocial end  as Nombre, NDoc, TDI.NCorto as descrip from Proveedor2 p
		       left Join TipDocIdn TDI on p.Cd_TDI = TDI.Cd_TDI
		       where RucE=@RucE
			
else if(@TipCons=2)
	select *,TDI.NCorto from Proveedor2 p
	left Join TipDocIdn TDI on p.Cd_TDI = TDI.Cd_TDI 
	where RucE=@RucE and p.Estado = 1
else if(@TipCons=3)
	select case(isnull(len(RSocial),0))
	                     when 0 then Cd_Prv+'  |  '+ApPat+ ' ' + ApMat+ ' ' +Nom
		       else Cd_Prv+'  |  '+RSocial end as  Nombre   from Proveedor2 p
			left Join TipDocIdn TDI on p.Cd_TDI = TDI.Cd_TDI
			where RucE=@RucE and p.Estado = 1
print @msj

-- Leyenda --
-- PP : 2010-02-18 : <Creacion del procedimiento almacenado>
-- MP : 2011-02-10 : <Modificacion del procedimiento almacenado>

--DEMO
--EXEC Com_Proveedor2Cons '11111111111', 1, null




GO
