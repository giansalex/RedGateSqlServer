SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvCrea_Import]
@RucE nvarchar(11),
@Cd_Srv char(7),
@Descrip varchar(100),
@Cd_Mda nvarchar(2),
@PVta numeric(13,4),
@IB_IncIGV bit,
@IB_Exrdo bit,
@ValVta numeric(13,4),
@IC_TipDscto char(1),
@Dscto numeric(12,4),
@IC_TipVP varchar(1),
@MrgInf numeric(13,4),
@MrgSup numeric(13,4),
@msj varchar(100) output
as

/************* start Validaciones ******************/
If not exists(select * from Servicio2 Where RucE =@RucE and  Cd_Srv=@Cd_Srv) and (isnull(@Cd_Srv,'')<>'')
begin
	set @msj = 'No existe servicio '+ @Cd_Srv
	return 	
end

If not exists(select * from Moneda Where  Cd_Mda=@Cd_Mda) and (isnull(@Cd_Mda,'')<>'')
begin
	set @msj = 'No existe codigo de moneda '+@Cd_Mda
	return 	
end
/************* end Validaciones ******************/


If exists(select * from PrecioSrv Where RucE =@RucE and  Cd_Srv=@Cd_Srv and Cd_Mda=@Cd_Mda and descrip=@Descrip) and (isnull(@Cd_Mda,'')<>'') and (isnull(@Cd_Srv,'')<>'') and (isnull(@Descrip,'')<>'')
	set @msj = 'Ya existe el precio para el servicio'
else
begin


begin transaction
	insert into PrecioSrv(ID_PrSv,RucE,Cd_Srv,Descrip,Cd_Mda,PVta,IB_IncIGV,IB_Exrdo,ValVta,IC_TipDscto,Dscto,IC_TipVP,MrgInf,MrgSup,Estado)
	            values(dbo.Id_PrecioSrv(@RucE),@RucE,@Cd_Srv,@Descrip,@Cd_Mda,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@IC_TipVP,@MrgInf,@MrgSup,1)

	if @@rowcount <= 0
	begin
	   set @msj = 'Precio no pudo ser registrado'	
		rollback transaction
	end
commit transaction
print @msj
end

--LEYENDA

--CE : 2012-09-17 <Modificacion>, <se agrego para 4 decimales>

GO
