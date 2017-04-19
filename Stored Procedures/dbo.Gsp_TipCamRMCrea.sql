SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gsp_TipCamRMCrea]
@FecTC varchar(10),
@Cd_Mda nvarchar(2),
@TCCom numeric(13,3),
@TCVta numeric(13,3),
@TCPro numeric(13,3),
@Usu varchar(20),
@FecMov datetime,
@Cd_Est nvarchar(2),
@msj varchar(100) output
as
begin
	insert into TipCamRM(NroReg,FecTC,Cd_Mda,TCCom,TCVta,TCPro,Usu,FecMov,Cd_Est)
	       values(user123.NroReg_TipCamRM(),@FecTC,@Cd_Mda,@TCCom,@TCVta,@TCPro,@Usu,@FecMov,@Cd_Est)
	if @@rowcount <= 0
	   set @msj = 'Error al ingresar TipCamRM'
end
print @msj
GO
