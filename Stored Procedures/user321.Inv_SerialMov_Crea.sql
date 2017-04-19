SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_SerialMov_Crea]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@Cd_Inv char(12),
@Cd_Com char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as

insert into serialmov (RucE, Cd_Prod, Serial, Cd_Inv, Cd_Com, Cd_Vta) values (@RucE, @Cd_Prod, @Serial, @Cd_Inv, @Cd_Com, @Cd_Vta)
if(@@rowcount<=0) set @msj = 'No se pudo insertar el movimento de serial'

GO
