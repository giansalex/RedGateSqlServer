SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_Serial_Crea2]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@Lote varchar(100),
@Cd_AlmAct varchar(20),
@FecIng datetime,
@FecSal datetime,
@Cd_Inv char(12),
@Cd_Com char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as

if not exists (select * from Serial where RucE = @RucE and Cd_Prod = @Cd_Prod and Serial = @Serial)
begin
	insert into Serial values (@RucE, @Cd_Prod, @Serial, @Lote, @Cd_AlmAct, @FecIng, @FecSal)
	if(@@rowcount<=0) set @msj = 'No se pudo ingresar la serie por el producto'
end
else
begin
	update Serial set FecSal=@FecSal where RucE = @RucE and Cd_Prod = @Cd_Prod and Serial = @Serial
end
--INSERTAR MOVIMIENTO--
insert into serialmov (RucE, Cd_Prod, Serial, Cd_Inv, Cd_Com, Cd_Vta) values (@RucE, @Cd_Prod, @Serial, @Cd_Inv, @Cd_Com, @Cd_Vta)
if(@@rowcount<=0) set @msj = 'No se pudo insertar el movimento de serial'

GO
