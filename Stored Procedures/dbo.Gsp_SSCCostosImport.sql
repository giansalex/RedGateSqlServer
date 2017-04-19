SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosImport]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(10),
@IB_Psp bit,
@msj varchar(100) output
as

/******************** Start Validaciones **************************************/
if not exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'No existe Centro de Costos : '+ @Cd_CC + ' y Sub Centro de Costos : '+ @Cd_SC


/******************** end Validacion *************************************/

else if exists (select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
begin	
	--set @msj = 'Ya existe Sub Sub Centro de Costos'
	update CCSubSub set @Descrip=Descrip , @NCorto=NCorto , @IB_Psp=IB_Psp
	where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Centro de Costos no pudo ser ingresado'
	
end
else
begin
	insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp)
	              values(@RucE,@Cd_CC,@Cd_SC,@Cd_SS,@Descrip,@NCorto,@IB_Psp)
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Centro de Costos no pudo ser ingresado'
end
print @msj
--AC : 02/01/2013 : <NCorto modificado de 6 a 10 caracteres>
GO
