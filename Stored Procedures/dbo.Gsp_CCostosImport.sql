SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Gsp_CCostosImport '11111111111','OFI','OFICINA','OFI',0,null
CREATE procedure [dbo].[Gsp_CCostosImport]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(10),
@IB_Psp bit,
@msj varchar(100) output
as





if exists (select top 1 * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC)
begin
	
	--set @msj = 'Ya existe Centro de Costos'
	--return
	update CCostos set Descrip=@Descrip , NCorto=@NCorto , IB_Psp=@IB_Psp
	where RucE=@RucE and Cd_CC=@Cd_CC
	
	if @@rowcount <= 0
	   set @msj = 'Centro de Costos no pudo ser ingresado'
end


else
begin
	insert into CCostos(RucE,Cd_CC,Descrip,NCorto,IB_Psp)
		     values(@RucE,@Cd_CC,@Descrip,@NCorto,@IB_Psp)

	if @@rowcount <= 0
	   set @msj = 'Centro de Costos no pudo ser ingresado'
	else
	begin
		insert into CCSub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp) values(@RucE,@Cd_CC,'01010101','GENERAL','GN',0)
		insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp) values(@RucE,@Cd_CC,'01010101','01010101','GENERAL','GN',0)
	end
end
print @msj

--02/01/2013 NCorto modificado de 6 a 10 caracteres
GO
