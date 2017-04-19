SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaRMCrea]
--@NroReg int,
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@FecMov datetime,
@Cd_Area nvarchar(8),
@Cd_MR nvarchar(2),
@Usu nvarchar(10),
@Cd_TM nvarchar(2),
@msj varchar(100) output
as
begin
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,FecMov,Cd_Area,Cd_MR,Usu,Cd_TM)
		     values(user123.Nro_RegVtaRM(@RucE),@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@FecMov,@Cd_Area,@Cd_MR,@Usu,@Cd_TM)
	if @@rowcount <= 0
	   set @msj = 'Error al ingresar VentaRM'
end
print @msj
GO
