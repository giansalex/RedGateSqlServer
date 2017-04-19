SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_SerialMov_ConsxMov]
@RucE nvarchar(11),
@Cd_Inv char(12),
@Cd_Com char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
--with encryption
as
if(@Cd_Inv != '' or @Cd_Inv is not null)
begin
	select * from SerialMov where RucE=@RucE and Cd_Inv=@Cd_Inv
end
else if(@Cd_Com != '' or @Cd_Com is not null)
begin
	select * from SerialMov where RucE=@RucE and Cd_Com=@Cd_Com
end
else if(@Cd_Vta != '' or @Cd_Vta is not null)
begin
	select * from SerialMov where RucE=@RucE and Cd_Vta=@Cd_Vta
end


-- LEYENDA
-- CAM 24/09/2012 <Creacion del SPs>
GO
