SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvMdf]
@ID_PrSv int,
@RucE nvarchar(11),
@Cd_Srv char(7),
@Descrip varchar(100),
@PVta numeric(13,4),
@IB_IncIGV bit,
@IB_Exrdo bit,
@ValVta numeric(13,4),
@IC_TipDscto varchar(1),
@Dscto numeric(13,4),
@IC_TipVP varchar(1),
@MrgInf numeric(13,4),
@MrgSup numeric(13,4),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from PrecioSrv where RucE=@RucE and ID_PrSv=@ID_PrSv)
	set @msj = 'Precio no existe'
else
begin
begin transaction
	update 
		PrecioSrv 
	set 	
		Descrip=@Descrip,PVta=@PVta,IB_IncIGV=@IB_IncIGV,IB_Exrdo=@IB_Exrdo,ValVta=@ValVta,
		IC_TipDscto=@IC_TipDscto,Dscto=@Dscto,IC_TipVP=@IC_TipVP,MrgInf=@MrgInf,MrgSup=@MrgSup,
		Estado=@Estado
	where 
		RucE=@RucE and ID_PrSv=@ID_PrSv

	if @@rowcount <= 0
	begin
	   set @msj = 'Precio del Servicio no pudo ser modificado'	
		rollback transaction
	end
commit transaction
print @msj
end
-- Leyenda --
-- J : 2010-03-19 : <Creacion del procedimiento almacenado>
-- CE: 2012-09-17 : <Modificado para agregar 4 decimales>
GO
