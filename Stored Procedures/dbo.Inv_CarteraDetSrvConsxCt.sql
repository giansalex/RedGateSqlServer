SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetSrvConsxCt]
@RucE nvarchar(11),
@Cd_Ct char(3),
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select ctDet.RucE as Ruc,ctDet.Cd_Ct as CodCt,ctDet.Cd_Srv as Codigo,srv.Nombre as Nombre,ctDet.Estado
		from CarteraProdDet_S ctDet
		Left Join CarteraProd ct on ct.RucE=ctDet.RucE and ct.Cd_Ct=ctDet.Cd_Ct
		Left Join Servicio2 srv on  srv.RucE=ctDet.RucE and srv.Cd_Srv=ctDet.Cd_Srv
		Where ctDet.RucE=@RucE and ctDet.Cd_Ct=@Cd_Ct  --and srv.Estado=1 and ct.Estado=1-- and ctDet.Estado=1
	end
end
print @msj
--------
--J : 29-03-2010 -> <Creado>
--exec dbo.Inv_CarteraDetProdConsxCt '11111111111','001',0,null
GO
