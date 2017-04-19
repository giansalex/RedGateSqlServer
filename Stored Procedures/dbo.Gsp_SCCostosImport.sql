SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosImport]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(10),
@IB_Psp bit,
@msj varchar(100) output
as
if not exists (select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC)
	set @msj = 'No existe Centro de Costos : '+@Cd_CC
else
begin
	if exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	begin
		--set @msj = 'Ya existe Sub Centro de Costos'
		update CCSub set Descrip=@Descrip , NCorto=@NCorto , IB_Psp=@IB_Psp
		where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC

		if @@rowcount <= 0
			set @msj = 'Sub Centro de Costos no pudo ser ingresado'	
	end
		else
		begin
			insert into CCSub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp)
			   values(@RucE,@Cd_CC,@Cd_SC,@Descrip,@NCorto,@IB_Psp)
		if @@rowcount <= 0
		    set @msj = 'Sub Centro de Costos no pudo ser ingresado'
		else
		begin
			insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp) values(@RucE,@Cd_CC,@Cd_SC,'01010101','GENERAL','GN',0)
		end
	end
end
print @msj

--AC : 02/01/2013 : <NCorto modificado de 6 a 10 caracteres>
GO
