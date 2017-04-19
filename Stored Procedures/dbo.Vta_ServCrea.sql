SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServCrea]
--//SERVICIO
@RucE nvarchar(11),
@Cd_Srv nvarchar(7),
@Cd_GS nvarchar(6),

--//PRODUCTO
--@Cd_Pro nvarchar(10),
@Nombre varchar(150),
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

@UsuCrea nvarchar(10),
--@UsuMdf nvarchar(10),
--@FecReg datetime,
--@FecMdf datetime,
--@Estado bit,

@msj varchar(100) output
as

--Declare @Cd_Srv nvarchar(7)

if exists (select * from Servicio where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'Ya existe Servicio'
else
begin
begin transaction
	--set @Cd_Srv = (select user123.Cod_Srv(@RucE))
	insert into Producto(RucE,Cd_Pro,Nombre,Descrip,Cta1,Cta2,PrecioVta,IB_IncIGV,IB_Exrdo,ValorVta,IC_TipDcto,Dcto,Cd_Mda,Cd_CC,Cd_SC,Cd_SS,Estado)
		      values(@RucE,@Cd_Srv,@Nombre,@Descrip,@Cta1,@Cta2,@PrecioVta,@IB_IncIGV,@IB_Exrdo,@ValorVta,@IC_TipDcto,@Dcto,@Cd_Mda,@Cd_CC,@Cd_SC,@Cd_SS,1)

	if @@rowcount <= 0
	   set @msj = 'Producto no pudo ser registrado'	

	insert into Servicio(RucE,Cd_Srv,Cd_GS,UsuCrea,UsuMdf,FecReg,FecMdf,Estado)
		values(@RucE,@Cd_Srv,@Cd_GS,@UsuCrea,@UsuCrea,getdate(),getdate(),1)
	
	if @@rowcount <= 0
	begin
		set @msj = 'Servicio no pudo ser registrado'
	rollback transaction
	end
commit transaction
end
print @msj
GO
