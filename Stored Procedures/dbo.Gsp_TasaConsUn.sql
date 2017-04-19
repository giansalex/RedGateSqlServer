SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaConsUn]
@Cd_Ts nvarchar(3),
@msj varchar(100) output
as
if not exists (select * from Tasas where Cd_Ts=@Cd_Ts)
	set @msj = 'Tasa no existe'
else	select * from Tasas where Cd_Ts=@Cd_Ts
print @msj
GO
