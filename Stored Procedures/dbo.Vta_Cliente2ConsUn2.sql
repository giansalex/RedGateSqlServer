SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2ConsUn2]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
if not exists (select * from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt and Cd_Vdr is not null)
	begin
		if not exists (select * from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
			begin
				set @msj = 'Cliente no existe'
			end
			else
			begin 
				select a.*,'' as Cd_VdrTD,'' as NroVdr,'' as NomVdr from Cliente2 a where a.RucE=@RucE and a.Cd_Clt=@Cd_Clt
			end
	end	--set @msj = 'Cliente no existe'
else	--select a.* from Cliente2 a where a.RucE=@RucE and a.Cd_Clt=@Cd_Clt
--select v.Cd_TDI as Cd_VdrTDI,v.NDoc as NroVdr,isnull(v.RSocial,isnull(v.Nom+' ','')+isnull(v.ApPat+' ','')+isnull(v.ApMat+' ','')) as NomVdr from vendedor2 v
	begin
		select 
		a.*,v.Cd_TDI as Cd_VdrTD,
		v.NDoc as NroVdr,
		isnull(v.RSocial,isnull(v.Nom+' ','')+isnull(v.ApPat+' ','')+isnull(v.ApMat+' ','')) as NomVdr
		 from Cliente2 a inner join Vendedor2 v on a.RucE=v.RucE and a.Cd_Vdr = v.Cd_Vdr
		 where a.RucE=@RucE and a.Cd_Clt=@Cd_Clt		 
	end
 print @msj
 
 --exec Vta_Cliente2ConsUn2 '11111111111','CLT0000007',null
GO
