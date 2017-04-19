SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServCrea3]
--//SERVICIO
@RucE nvarchar(11),
@Cd_Srv nvarchar(7),
@Cd_GS nvarchar(6),
@CodCo varchar(30),
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
--If exists (select * from Producto where RucE=@RucE and CodCo=@CodCo)
	--set @msj = 'Ya existe ese Código Comercial'
/*select * from producto where rucE='11111111111'
select * from servicio where rucE='11111111111'*/
/*if exists (select a.* ,b.* from Servicio a,Producto b 
where 
a.RucE=b.RucE and 
a.RucE=@RucE and 
a.Cd_Srv=b.Cd_Pro and 
a.Cd_Srv=@Cd_Srv and 
b.CodCo=@CodCo)
set @msj = 'Ya existe Servicio'*/
/*select serv.RucE,serv.Cd_Srv,serv.Cd_GS,prod.Cd_Pro,prod.CodCo,prod.Nombre,prod.Descrip from Servicio serv, Producto prod
where
serv.RucE=prod.RucE and
serv.Cd_Srv = prod.Cd_Pro and
serv.Cd_Srv = '144' and
prod.CodCo='LAE-T05'*/
else
begin
begin transaction
	--set @Cd_Srv = (select user123.Cod_Srv(@RucE))
	insert into Producto(RucE,Cd_Pro,CodCo,Nombre,Descrip,Cta1,Cta2,PrecioVta,IB_IncIGV,IB_Exrdo,ValorVta,IC_TipDcto,Dcto,Cd_Mda,Cd_CC,Cd_SC,Cd_SS,Estado)
		      values(@RucE,@Cd_Srv,@CodCo,@Nombre,@Descrip,@Cta1,@Cta2,@PrecioVta,@IB_IncIGV,@IB_Exrdo,@ValorVta,@IC_TipDcto,@Dcto,@Cd_Mda,@Cd_CC,@Cd_SC,@Cd_SS,1)

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
