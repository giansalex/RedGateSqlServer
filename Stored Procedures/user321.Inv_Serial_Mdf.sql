SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [user321].[Inv_Serial_Mdf]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@Lote varchar(100),
@Cd_AlmAct varchar(20),
@FecIng datetime,
@FecSal datetime,
@msj varchar(100) output
as

update Serial 
set 
	Lote = @Lote, 
	Cd_AlmAct = @Cd_AlmAct, 
	FecIng = @FecIng,
	FecSal = @FecSal

where RucE = @RucE and Cd_Prod = @Cd_Prod and Serial = @Serial

if(@@rowcount<=0)
	set @msj = 'No se puedo modificar la serie por el producto'

GO
