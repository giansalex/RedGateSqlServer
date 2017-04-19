SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_GeneralRMCrea]
@RucE nvarchar(11),
--@NroReg int,
@Cd_Tab nvarchar(3),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Descrip1 varchar(50),
@Descrip2 varchar(50),
@Usu nvarchar(10),
@FecMov datetime,
@Cd_Est nvarchar(2),
@msj varchar(100) output
as
begin
	Declare @NroReg int
	set @NroReg = dbo.NroReg_GenRM(@RucE)
	insert into GeneralRM(RucE,NroReg,Cd_Tab,Cd_Area,Cd_MR,Descrip1,Descrip2,Usu,FecMov,Cd_Est)
	              values(@RucE,@NroReg,@Cd_Tab,@Cd_Area,@Cd_MR,@Descrip1,@Descrip2,@Usu,@FecMov,@Cd_Est)
	
	if @@rowcount <= 0
		set @msj = 'No se pudo registrar general RM'
end
print @msj
GO
