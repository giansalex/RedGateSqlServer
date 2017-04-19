SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvConsxSrv]
@RucE nvarchar(11),
@Cd_Srv char(7),
@TipCons int,
@msj varchar(100) output
as
if (@TipCons=0)
		select 
			pr.ID_PrSv,pr.Descrip,mo.Simbolo,pr.PVta,pr.ValVta,pr.IB_IncIGV,pr.IB_Exrdo, 
			convert(varchar,isnull(pr.Dscto,'.00'))+(case pr.IC_Tipdscto when 'P' then  '%' else '' end) as Dscto,
			convert(varchar, MrgSup)+(case pr.IC_TipVP when 'P' then  '%' else '' end) as MrgSup, 
			convert(varchar, MrgInf)+(case pr.IC_TipVP when 'P' then  '%' else '' end) as MrgInf
		from 	
			PrecioSrv as pr
			left join Moneda as mo on mo.Cd_Mda=pr.Cd_Mda
			left join Servicio2 as srv on srv.RucE=pr.RucE and srv.Cd_Srv=pr.Cd_Srv and srv.Estado=1
		
		Where 
			pr.RucE=@RucE and pr.Cd_Srv=@Cd_Srv and pr.Estado=1

print @msj
-- Leyenda --
-- J : 2010-03-19 : <Creacion del procedimiento almacenado>
GO
