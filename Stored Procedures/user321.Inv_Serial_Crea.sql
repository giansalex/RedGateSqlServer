SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_Serial_Crea]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@Lote varchar(100),
@Cd_AlmAct varchar(20),
@FecIng datetime,
@FecSal datetime,
@msj varchar(100) output
as

if exists (select * from Serial where RucE = @RucE and Cd_Prod = @Cd_Prod and Serial = @Serial)
begin
	set @msj = 'El producto '+@Cd_Prod+' ya contiene el serial = '+@Serial
	return
end
insert into Serial values (@RucE, @Cd_Prod, @Serial, @Lote, @Cd_AlmAct, @FecIng, @FecSal)
if(@@rowcount<=0)
	set @msj = 'No se pudo ingresar la serie por el producto'



GO
