SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[setValorImpreso]
@RucE nvarchar(11),
@eje nvarchar(4),
@cd_Vta nvarchar(10),
@msj  varchar(100) output
as
if not exists(select * from venta where RucE=@RucE and cd_vta=@cd_Vta and eje=@eje)
 set @msj= 'No existe venta'
 else
 begin
   update venta set IB_Impreso=1 where RucE=@Ruce and cd_vta=@cd_Vta and eje=@eje
 end
 
 -- Leyenda
 -- Analy 15/06/2012 <creacion>
 --exec setValorImpreso '11111111111','2012','VT00001055',null
GO
