SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServMdf]
--//SERVICIO
@RucE nvarchar(11),
@Cd_Srv nvarchar(7),
@Cd_GS nvarchar(6),

--//PRODUCTO
--@Cd_Pro nvarchar(10),
@Nombre varchar(100),
@Descrip varchar(200),
@Cta1 nvarchar(10),
@Cta2 nvarchar(10),
@PrecioVta numeric(13,3),
@IB_IncIGV bit,
@IB_Exrdo bit,
@ValorVta numeric(13,3),
@IC_TipDcto varchar(1),
@Dcto numeric(13,3),
@Cd_Mda nvarchar(2),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),

--@UsuCrea nvarchar(10),
@UsuMdf nvarchar(10),
--@FecReg datetime,
--@FecMdf datetime,
@Estado bit,

@msj varchar(100) output
as
if not exists (select * from Servicio where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'Servicio no existe'
else
begin
begin transaction
	update Producto set Nombre=@Nombre, Descrip=@Descrip,Cta1=@Cta1, Cta2=@Cta2, 
                            PrecioVta=@PrecioVta, IB_IncIGV=@IB_IncIGV, IB_Exrdo=@IB_Exrdo, ValorVta=@ValorVta, 
			    IC_TipDcto=@IC_TipDcto, Dcto=@Dcto, Cd_Mda=@Cd_Mda,
			    Cd_CC=@Cd_CC, Cd_SC=@Cd_SC, Cd_SS=@Cd_SS, Estado=@Estado
	where RucE=@RucE and Cd_Pro=@Cd_Srv

	if @@rowcount <= 0
	   set @msj = 'Producto no pudo ser modificado'

	update Servicio set Cd_GS=@Cd_GS, UsuMdf=@UsuMdf, FecMdf=GetDate(), Estado=@Estado
	where RucE=@RucE and Cd_Srv=@Cd_Srv 
	
	if @@rowcount <= 0
	begin
		set @msj = 'Servicio no pudo ser modificado'
	rollback transaction
	end
commit transaction
end
print @msj
GO
