SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CfgCajaCrea]
@RucE		nvarchar (22),
@Cd_Caja	nvarchar (20),
@Itm_CC		int output,
@Cd_MIS		char (3),
@Cd_CC		nvarchar (16),
@Cd_SC		nvarchar (16),
@Cd_SS		nvarchar (16),
@Cd_Alm		varchar (20),
@msj		varchar(100) output
as
if exists (select * from CfgCaja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	set @msj = 'Configuracion Caja ya existe'
else
begin
	set @Itm_CC = dbo.Itm_CC(@RucE, @Cd_Caja)
	insert into CfgCaja(RucE,Cd_Caja,Itm_CC,Cd_MIS,Cd_CC,Cd_SC,Cd_SS,Cd_Alm)
		  values(@RucE,@Cd_Caja,@Itm_CC,@Cd_MIS,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Alm)
	
	if @@rowcount <= 0
		set @msj = 'Configuracion Caja no pudo ser ingresado'
end
print @msj

--MP : 03/02/2012 : <Creacion del procedimiento almacenado>
GO
