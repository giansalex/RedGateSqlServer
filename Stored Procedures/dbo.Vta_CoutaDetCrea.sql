SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Vta_CoutaDetCrea]
@RucE nvarchar(11),
@Cd_EC int,
@Cd_Cuo	int,
@Item int,
@Cd_Srv	char(7),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as

if exists (select *from CoutaDet where RucE=@RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo and Item=@Item)
	set @msj='Ya existe numero de detalle en cuota'
else
begin
	set @Item = dbo.ItemCuoD(@RucE,@Cd_EC,@Cd_Cuo)
	insert into CuotaDet(RucE,Cd_EC,Cd_Cuo,Item,Cd_Srv,CA01,CA02,CA03,CA04,CA05)
		Values(@RucE,@Cd_EC,@Cd_Cuo,@Item,@Cd_Srv,@CA01,@CA02,@CA03,@CA04,@CA05)

if @@rowcount <=0
	set @msj='Error al registrar detalle de cuota'
end	
GO
