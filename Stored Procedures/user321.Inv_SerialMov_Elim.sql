SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_SerialMov_Elim]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@Cd_Inv char(12),
@Cd_Com char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as

declare @Cadena nvarchar(500)
set @Cadena = 'delete from SerialMov where RucE = '''+@RucE+''' and Cd_Prod = '''+@Cd_Prod+''' and Serial = '''+@Serial+''''
if (len(@Cd_Inv)>0)
	set @Cadena = @Cadena + ' and Cd_Inv = '''+@Cd_Inv+''''
if (len(@Cd_Com)>0)
	set @Cadena = @Cadena + ' and Cd_Com = '''+@Cd_Com+''''
if (len(@Cd_Vta)>0)
	set @Cadena = @Cadena + ' and Cd_Vta = '''+@Cd_Vta+''''
exec (@Cadena)
GO
