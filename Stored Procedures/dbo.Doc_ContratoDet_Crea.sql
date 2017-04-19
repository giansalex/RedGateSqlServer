SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Doc_ContratoDet_Crea]

@RucE nvarchar(11),
@Cd_Ctt int,
@IC_TipDet char(1),
@FecDef smalldatetime,
@ValorDef numeric(13,3),
@IC_TipVal char(1),
@ValorAgr numeric(13,3),
@TotalDef numeric(13,3),
@msj varchar(100) output

AS

Declare @Item int
Set @Item = (Select isnull(max(Item),0)+1 from ContratoDet where RucE=@RucE and Cd_Ctt=@Cd_Ctt)

Insert into ContratoDet(RucE,Cd_Ctt,Item,IC_TipDet,FecDef,ValorDef,IC_TipVal,ValorAgr,TotalDef)
values(@RucE,@Cd_Ctt,@Item,@IC_TipDet,@FecDef,@ValorDef,@IC_TipVal,@ValorAgr,@TotalDef)

if @@rowcount <= 0
begin
	Set @msj = 'No se pudo ingresar alerta del contrato'
end

GO
